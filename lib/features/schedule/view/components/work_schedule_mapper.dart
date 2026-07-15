import 'package:rient_app/features/schedule/data/models/schedule_patterns_api/schedule_patterns_api.dart';
import 'package:rient_app/features/schedule/data/models/schedule_patterns_branch_api/schedule_patterns_branch_api.dart';
import 'package:rient_app/features/home/data/models/branches_api/branches_api.dart';
import 'package:rient_app/features/schedule/data/models/schedules_api/schedules_api.dart';
import 'package:rient_app/features/schedule/data/models/workers_api/workers_api.dart';
import 'package:rient_app/features/schedule/service/schedules_service.dart';
import 'package:rient_app/features/schedule/utils/schedule_branch_bounds.dart';
import 'package:rient_app/features/schedule/utils/schedule_day_key.dart';
import 'package:rient_app/features/schedule/utils/worker_schedule_config_map.dart';
import 'package:rient_app/features/schedule/utils/worker_work_day.dart';
import 'package:rient_app/features/schedule/view/components/work_schedule_mock_data.dart';

/// При дублях `wed`/`wen` или branch/worker — активный шаблон и больший id.
/// При дублях на одну дату: ручная запись (`auto: false`), затем рабочий день, затем больший `id`.
bool preferDailyScheduleItem(
  ScheduleItemApi candidate,
  ScheduleItemApi current,
) {
  if (candidate.auto != current.auto) return !candidate.auto;
  if (candidate.active != current.active) return candidate.active;
  return candidate.id > current.id;
}

/// Слияние `workers/{id}/schedules/` и `schedules/?branch=` (правки с веба).
///
/// Записи `workers/{id}/schedules/` имеют приоритет на дату — там правки с сайта/мобилки.
/// Записи филиала без `worker/N` в key — только часы филиала, в график сотрудника не попадают.
List<ScheduleItemApi> mergeWorkerScheduleSources({
  required List<ScheduleItemApi> fromWorkerEndpoint,
  required List<ScheduleItemApi> fromBranchEndpoint,
  required int workerId,
  required int branchId,
}) {
  final byDate = <String, ScheduleItemApi>{};

  for (final item in fromBranchEndpoint) {
    if (item.branch != branchId) continue;
    final itemWorkerId = item.workerId;
    if (itemWorkerId == null || itemWorkerId != workerId) continue;
    final dateKey = item.canonicalDate;
    byDate.putIfAbsent(dateKey, () => item);
  }

  for (final item in fromWorkerEndpoint) {
    if (item.branch != branchId) continue;
    final itemWorkerId = item.workerId;
    if (itemWorkerId != null && itemWorkerId != workerId) continue;
    final dateKey = item.canonicalDate;
    final existing = byDate[dateKey];
    if (existing == null || preferDailyScheduleItem(item, existing)) {
      byDate[dateKey] = item;
    }
  }

  return byDate.values.toList();
}

bool preferSchedulePattern(
  SchedulePatternItemApi candidate,
  SchedulePatternItemApi current,
) {
  // Новее по id важнее: иначе stale active:true из workerRow
  // перекрывает свежий active:false из API (и наоборот).
  if (candidate.id != current.id) return candidate.id > current.id;
  return candidate.active && !current.active;
}

List<SchedulePatternItemApi> dedupeSchedulePatternsByDay(
  Iterable<SchedulePatternItemApi> patterns,
) {
  final byDay = <String, SchedulePatternItemApi>{};
  for (final pattern in patterns) {
    final key = canonicalScheduleDayKey(pattern.day);
    final existing = byDay[key];
    if (existing == null || preferSchedulePattern(pattern, existing)) {
      byDay[key] = pattern;
    }
  }
  return byDay.values.toList();
}

List<SchedulePatternItemApi> schedulePatternsFromWorkerRow(
  Map<String, dynamic>? workerRow,
) {
  if (workerRow == null) return const [];
  final raw = workerRow['schedule_patterns'];
  if (raw is! List) return const [];
  final patterns = <SchedulePatternItemApi>[];
  for (final item in raw) {
    if (item is! Map) continue;
    try {
      patterns.add(
        SchedulePatternItemApi.fromJson(
          item.map((k, v) => MapEntry(k.toString(), v)),
        ),
      );
    } catch (_) {
      // пропускаем битые записи
    }
  }
  return patterns;
}

List<SchedulePatternItemApi> mergeSchedulePatternsForWorker({
  required List<SchedulePatternItemApi> fromBranchApi,
  Map<String, dynamic>? workerRow,
}) {
  // API — источник правды; workerRow только закрывает дни, которых нет в API.
  final fromApi = dedupeSchedulePatternsByDay(fromBranchApi);
  final fromRow = dedupeSchedulePatternsByDay(
    schedulePatternsFromWorkerRow(workerRow),
  );
  final byDay = <String, SchedulePatternItemApi>{
    for (final pattern in fromRow)
      canonicalScheduleDayKey(pattern.day): pattern,
  };
  for (final pattern in fromApi) {
    byDay[canonicalScheduleDayKey(pattern.day)] = pattern;
  }
  return byDay.values.toList();
}

Map<int, List<SchedulePatternItemApi>> groupSchedulePatternsByWorker(
  List<SchedulePatternItemApi> patterns,
) {
  final map = <int, List<SchedulePatternItemApi>>{};
  for (final pattern in patterns) {
    map.putIfAbsent(pattern.worker, () => []).add(pattern);
  }
  return {
    for (final entry in map.entries)
      entry.key: dedupeSchedulePatternsByDay(entry.value),
  };
}

/// Фиолетовый — только ручная правка дня в сетке (`auto: false`).
/// Смена шаблона через «…» оставляет `auto: true` → обычный цвет.
bool isManualWorkScheduleDaily(ScheduleItemApi daily) => !daily.auto;

WorkScheduleShiftTone _toneForShiftHours(String start, String end) {
  final startH = int.tryParse(start.split(':').first) ?? 0;
  final endH = int.tryParse(end.split(':').first) ?? 0;
  final hours = (endH - startH).clamp(0, 24).toDouble();
  return hours >= 10 ? WorkScheduleShiftTone.full : WorkScheduleShiftTone.short;
}

WorkScheduleDayCell clampWorkScheduleCellToBranchPattern(
  WorkScheduleDayCell cell,
  SchedulePatternBranchItemApi? branchPattern,
) =>
    _clampCellToBranchPattern(cell, branchPattern);

WorkScheduleDayCell _clampCellToBranchPattern(
  WorkScheduleDayCell cell,
  SchedulePatternBranchItemApi? branchPattern,
) {
  if (cell.kind != WorkScheduleCellKind.shift || branchPattern == null) {
    return cell;
  }
  if (!branchPattern.active) return cell;

  final branchStart = branchPattern.timeStartShort;
  final branchEnd = branchPattern.timeEndShort;
  final workerStart = cell.timeStart;
  final workerEnd = cell.timeEnd;
  if (branchStart == null ||
      branchEnd == null ||
      workerStart == null ||
      workerEnd == null ||
      branchStart.isEmpty ||
      branchEnd.isEmpty) {
    return cell;
  }

  final intersect = intersectWorkerShiftWithBranch(
    workerStart: workerStart,
    workerEnd: workerEnd,
    branchStart: branchStart,
    branchEnd: branchEnd,
  );
  if (intersect == null) {
    // Ручной рабочий день не схлопываем в выходной, если часы не попали в смену филиала.
    if (cell.isManuallyEdited) return cell;
    return WorkScheduleDayCell.dayOff(
      isManuallyEdited: false,
      scheduleId: cell.scheduleId,
      breakStart: cell.breakStart,
      breakEnd: cell.breakEnd,
    );
  }

  if (intersect.start == workerStart && intersect.end == workerEnd) {
    return cell;
  }

  return WorkScheduleDayCell.shift(
    timeStart: intersect.start,
    timeEnd: intersect.end,
    tone: _toneForShiftHours(intersect.start, intersect.end),
    isSelected: cell.isSelected,
    isManuallyEdited: cell.isManuallyEdited,
    scheduleId: cell.scheduleId,
    breakStart: cell.breakStart,
    breakEnd: cell.breakEnd,
  );
}

WorkScheduleDayCell workScheduleCellFromScheduleItem(
  ScheduleItemApi? item, {
  bool selected = false,
  bool isManuallyEdited = false,
}) {
  final manual = isManuallyEdited;
  if (item == null || !item.active) {
    return _dayOffFromDaily(
      item,
      isManuallyEdited: manual,
    );
  }
  final start = item.timeStartShort;
  final end = item.timeEndShort;
  if (start == null || end == null || start.isEmpty || end.isEmpty) {
    return _dayOffFromDaily(
      item,
      isManuallyEdited: manual,
    );
  }
  final tone = item.hours >= 10
      ? WorkScheduleShiftTone.full
      : WorkScheduleShiftTone.short;
  return WorkScheduleDayCell.shift(
    timeStart: start,
    timeEnd: end,
    tone: tone,
    isSelected: selected,
    isManuallyEdited: manual,
    scheduleId: item.id,
    breakStart: item.breakStartShort,
    breakEnd: item.breakEndShort,
  );
}

WorkScheduleDayCell workScheduleCellFromBranchPattern(
  SchedulePatternBranchItemApi? pattern,
) {
  if (pattern == null || !pattern.active) {
    return const WorkScheduleDayCell.dayOff();
  }
  final start = pattern.timeStartShort;
  final end = pattern.timeEndShort;
  if (start == null || end == null || start.isEmpty || end.isEmpty) {
    return const WorkScheduleDayCell.dayOff();
  }
  final startH = int.tryParse(start.split(':').first) ?? 0;
  final endH = int.tryParse(end.split(':').first) ?? 0;
  final hours = (endH - startH).clamp(0, 24).toDouble();
  final tone = hours >= 10
      ? WorkScheduleShiftTone.full
      : WorkScheduleShiftTone.short;
  return WorkScheduleDayCell.shift(
    timeStart: start,
    timeEnd: end,
    tone: tone,
  );
}

SchedulePatternBranchItemApi? _branchPatternForWeekday(
  Map<String, SchedulePatternBranchItemApi> patternsByDay,
  int weekday,
) {
  final dayKey = scheduleDayKeyForWeekday(weekday);
  if (dayKey != null) {
    final direct = patternsByDay[dayKey];
    if (direct != null) return direct;
    if (weekday == DateTime.wednesday) {
      return patternsByDay['wen'];
    }
  }
  for (final pattern in patternsByDay.values) {
    if (pattern.weekdayNumber == weekday) return pattern;
  }
  return null;
}

SchedulePatternBranchItemApi? branchSchedulePatternForDate(
  Map<String, SchedulePatternBranchItemApi> patternsByDay,
  DateTime date,
) {
  return _branchPatternForWeekday(patternsByDay, date.weekday);
}

Map<String, SchedulePatternBranchItemApi> branchSchedulePatternsByDayFromBranchApi(
  List<SchedulePattern>? patterns,
  int branchId,
) {
  final map = <String, SchedulePatternBranchItemApi>{};
  if (patterns == null) return map;
  for (final pattern in patterns) {
    final patternBranch = pattern.branch;
    if (patternBranch != null && patternBranch != branchId) continue;
    final day = pattern.day;
    if (day == null || day.isEmpty) continue;
    final key = canonicalScheduleDayKey(day);
    map[key] = SchedulePatternBranchItemApi(
      id: pattern.id ?? 0,
      branch: patternBranch ?? branchId,
      day: key,
      timeStart: pattern.timeStart,
      timeEnd: pattern.timeEnd,
      active: pattern.active ?? false,
    );
  }
  return map;
}

WorkScheduleEmployeeRow workScheduleBranchRow({
  required DateTime monthStart,
  required String branchName,
  required Map<String, SchedulePatternBranchItemApi> patternsByDay,
}) {
  final days = daysOfMonth(monthStart);
  final displayName = branchName.trim().isEmpty ? 'Филиал' : branchName.trim();

  return WorkScheduleEmployeeRow(
    id: workScheduleBranchRowId,
    name: displayName,
    isBranchRow: true,
    monthCells: [
      for (final date in days)
        workScheduleCellFromBranchPattern(
          _branchPatternForWeekday(patternsByDay, date.weekday),
        ),
    ],
  );
}

WorkScheduleDayCell workScheduleCellFromPattern(
  SchedulePatternItemApi? pattern, {
  bool selected = false,
  ScheduleItemApi? daily,
}) {
  if (pattern == null || !pattern.active) {
    // Ручной рабочий день поверх шаблонного выходного.
    if (daily != null && daily.active && !daily.auto) {
      return workScheduleCellFromScheduleItem(
        daily,
        selected: selected,
        isManuallyEdited: true,
      );
    }
    return _dayOffFromDaily(
      daily,
      isManuallyEdited: daily != null && isManualWorkScheduleDaily(daily),
    );
  }
  final start = pattern.timeStartShort;
  final end = pattern.timeEndShort;
  if (start == null || end == null || start.isEmpty || end.isEmpty) {
    return const WorkScheduleDayCell.dayOff();
  }
  final startParts = start.split(':');
  final endParts = end.split(':');
  final startH = int.tryParse(startParts.first) ?? 0;
  final endH = int.tryParse(endParts.first) ?? 0;
  final hours = (endH - startH).clamp(0, 24).toDouble();
  final tone = hours >= 10
      ? WorkScheduleShiftTone.full
      : WorkScheduleShiftTone.short;
  // Ручная правка дня перекрывает часы шаблона.
  if (daily != null && !daily.auto) {
    return _workScheduleCellFromWorkerDaily(
      daily: daily,
      templateCell: WorkScheduleDayCell.shift(
        timeStart: start,
        timeEnd: end,
        tone: tone,
        isSelected: selected,
      ),
      selected: selected,
    );
  }
  final resolvedBreak = resolveWorkerBreakForDate(
    daily: daily,
    fallbackBreakStart: pattern.breakStartShort,
    fallbackBreakEnd: pattern.breakEndShort,
  );
  return WorkScheduleDayCell.shift(
    timeStart: start,
    timeEnd: end,
    tone: tone,
    isSelected: selected,
    scheduleId: daily?.id,
    breakStart: resolvedBreak.breakStart,
    breakEnd: resolvedBreak.breakEnd,
  );
}

WorkScheduleDayCell _dayOffFromDaily(
  ScheduleItemApi? daily, {
  bool isManuallyEdited = false,
}) {
  return WorkScheduleDayCell.dayOff(
    isManuallyEdited: isManuallyEdited,
    scheduleId: daily?.id,
    breakStart: daily?.breakStartShort,
    breakEnd: daily?.breakEndShort,
  );
}

SchedulePatternItemApi? _patternForWeekday(
  List<SchedulePatternItemApi> patterns,
  int weekday,
) {
  SchedulePatternItemApi? best;
  for (final pattern in patterns) {
    if (pattern.weekdayNumber != weekday) continue;
    if (best == null || preferSchedulePattern(pattern, best)) {
      best = pattern;
    }
  }
  return best;
}

bool _isShiftSchedule(Map<String, dynamic>? configMap) {
  return isShiftWorkerScheduleConfig(configMap);
}

String? _shortTimeFromDynamic(dynamic value) {
  if (value == null) return null;
  final s = value.toString();
  if (s.isEmpty) return null;
  return s.length >= 5 ? s.substring(0, 5) : s;
}

WorkScheduleDayCell _workScheduleCellFromWorkerDaily({
  required ScheduleItemApi daily,
  required WorkScheduleDayCell templateCell,
  bool selected = false,
}) {
  // auto: true — день из недельного шаблона («…»). Дальние даты часто
  // остаются со старой дневной записью; шаблон важнее, иначе 10 авг.
  // остаётся «рабочим», когда пн уже выходной.
  if (daily.auto) {
    if (templateCell.kind == WorkScheduleCellKind.shift) {
      final ts = templateCell.timeStart ?? '09:00';
      final te = templateCell.timeEnd ?? '20:00';
      return WorkScheduleDayCell.shift(
        timeStart: ts,
        timeEnd: te,
        tone: _toneForShiftHours(ts, te),
        isSelected: selected,
        isManuallyEdited: false,
        scheduleId: daily.id,
        breakStart: daily.breakStartShort ?? templateCell.breakStart,
        breakEnd: daily.breakEndShort ?? templateCell.breakEnd,
      );
    }
    return WorkScheduleDayCell.dayOff(
      isManuallyEdited: false,
      scheduleId: daily.id,
      breakStart: daily.breakStartShort,
      breakEnd: daily.breakEndShort,
    );
  }

  // auto: false — ручная правка по ячейке.
  if (!daily.active) {
    return _dayOffFromDaily(daily, isManuallyEdited: true);
  }

  final start = daily.timeStartShort;
  final end = daily.timeEndShort;
  if (start != null &&
      end != null &&
      start.isNotEmpty &&
      end.isNotEmpty) {
    return workScheduleCellFromScheduleItem(
      daily,
      selected: selected,
      isManuallyEdited: true,
    );
  }

  // На сайте active: true без time_start/time_end — рабочий день, часы из шаблона.
  if (templateCell.kind == WorkScheduleCellKind.shift) {
    final ts = templateCell.timeStart ?? '09:00';
    final te = templateCell.timeEnd ?? '20:00';
    return WorkScheduleDayCell.shift(
      timeStart: ts,
      timeEnd: te,
      tone: _toneForShiftHours(ts, te),
      isSelected: selected,
      isManuallyEdited: true,
      scheduleId: daily.id,
      breakStart: daily.breakStartShort ?? templateCell.breakStart,
      breakEnd: daily.breakEndShort ?? templateCell.breakEnd,
    );
  }

  return workScheduleCellFromScheduleItem(
    daily,
    selected: selected,
    isManuallyEdited: true,
  );
}

/// Ячейка дня — та же логика, что в [workScheduleEmployeeRow].
WorkScheduleDayCell resolveWorkerWorkScheduleDayCell({
  required DateTime date,
  required int workerId,
  required int branchId,
  required List<SchedulePatternItemApi> patterns,
  Map<String, dynamic>? workerRow,
  Map<String, dynamic>? configMap,
  ScheduleItemApi? daily,
  SchedulePatternBranchItemApi? branchPattern,
  bool selected = false,
}) {
  final resolvedConfig =
      configMap ?? workerScheduleConfigForBranch(workerRow, branchId);
  final resolvedPatterns = dedupeSchedulePatternsByDay(patterns);

  final templateCell = _cellFromTemplate(
    date: date,
    patterns: resolvedPatterns,
    workerRow: workerRow,
    configMap: resolvedConfig,
    daily: null,
    selected: selected,
  );

  final WorkScheduleDayCell cell;
  if (daily != null && daily.workerId == workerId) {
    cell = _workScheduleCellFromWorkerDaily(
      daily: daily,
      templateCell: templateCell,
      selected: selected,
    );
  } else {
    cell = _cellFromTemplate(
      date: date,
      patterns: resolvedPatterns,
      workerRow: workerRow,
      configMap: resolvedConfig,
      daily: daily,
      selected: selected,
    );
  }
  return _clampCellToBranchPattern(cell, branchPattern);
}

WorkScheduleDayCell _cellFromTemplate({
  required DateTime date,
  required List<SchedulePatternItemApi> patterns,
  Map<String, dynamic>? workerRow,
  Map<String, dynamic>? configMap,
  ScheduleItemApi? daily,
  bool selected = false,
}) {
  if (_isShiftSchedule(configMap)) {
    if (!isShiftWorkerWorkDay(date, configMap)) {
      if (daily != null && daily.active) {
        return workScheduleCellFromScheduleItem(
          daily,
          selected: selected,
          isManuallyEdited: isManualWorkScheduleDaily(daily),
        );
      }
      return _dayOffFromDaily(
        daily,
        isManuallyEdited:
            daily != null ? isManualWorkScheduleDaily(daily) : false,
      );
    }
    final start = _shortTimeFromDynamic(configMap?['time_start']) ?? '09:00';
    final end = _shortTimeFromDynamic(configMap?['time_end']) ?? '20:00';
    final startH = int.tryParse(start.split(':').first) ?? 9;
    final endH = int.tryParse(end.split(':').first) ?? 20;
    final hours = (endH - startH).clamp(0, 24).toDouble();
    return WorkScheduleDayCell.shift(
      timeStart: start,
      timeEnd: end,
      tone: hours >= 10
          ? WorkScheduleShiftTone.full
          : WorkScheduleShiftTone.short,
      isSelected: selected,
      scheduleId: daily?.id,
      breakStart: daily?.breakStartShort,
      breakEnd: daily?.breakEndShort,
    );
  }

  return workScheduleCellFromPattern(
    _patternForWeekday(patterns, date.weekday),
    selected: selected,
    daily: daily,
  );
}

ScheduleItemApi? _dailyScheduleForWorker({
  required Map<String, ScheduleItemApi> byDate,
  required int workerId,
  required String dateKey,
}) {
  final item = byDate[dateKey];
  if (item == null) return null;
  final itemWorkerId = item.workerId;
  if (itemWorkerId != null && itemWorkerId != workerId) return null;
  return item;
}

WorkScheduleEmployeeRow workScheduleEmployeeRow({
  required WorkerApi worker,
  required DateTime monthStart,
  required List<ScheduleItemApi> schedules,
  required int branchId,
  List<SchedulePatternItemApi> patterns = const [],
  Map<String, SchedulePatternBranchItemApi> branchPatternsByDay = const {},
  Map<String, dynamic>? workerRow,
  DateTime? highlightedCellDate,
}) {
  final days = daysOfMonth(monthStart);
  final highlighted = highlightedCellDate != null
      ? DateTime(
          highlightedCellDate.year,
          highlightedCellDate.month,
          highlightedCellDate.day,
        )
      : null;

  final byDate = <String, ScheduleItemApi>{};
  for (final item in schedules) {
    if (item.branch != branchId) continue;
    final itemWorkerId = item.workerId;
    if (itemWorkerId != null && itemWorkerId != worker.id) continue;
    final dateKey = item.canonicalDate;
    final existing = byDate[dateKey];
    if (existing == null || preferDailyScheduleItem(item, existing)) {
      byDate[dateKey] = item;
    }
  }

  final firstName = worker.firstName?.trim() ?? '';
  final lastName = worker.lastName?.trim() ?? '';
  final name = [firstName, lastName].where((p) => p.isNotEmpty).join(' ');
  final displayName = name.isNotEmpty ? name : 'Сотрудник #${worker.id}';
  final resolvedPatterns = dedupeSchedulePatternsByDay(patterns);

  return WorkScheduleEmployeeRow(
    id: worker.id.toString(),
    name: displayName,
    pictureUrl: worker.pictureThumbnail ?? worker.picture,
    monthCells: [
      for (final date in days)
        () {
          final selected = highlighted != null &&
              highlighted.year == date.year &&
              highlighted.month == date.month &&
              highlighted.day == date.day;
          final dateKey = SchedulesService.dateToApi(date);
          final daily = _dailyScheduleForWorker(
            byDate: byDate,
            workerId: worker.id,
            dateKey: dateKey,
          );
          return resolveWorkerWorkScheduleDayCell(
            date: date,
            workerId: worker.id,
            branchId: branchId,
            patterns: resolvedPatterns,
            workerRow: workerRow,
            daily: daily,
            branchPattern: _branchPatternForWeekday(
              branchPatternsByDay,
              date.weekday,
            ),
            selected: selected,
          );
        }(),
    ],
  );
}
