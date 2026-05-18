import 'package:rient_app/features/schedule/data/models/schedule_patterns_api/schedule_patterns_api.dart';
import 'package:rient_app/features/schedule/data/models/schedules_api/schedules_api.dart';
import 'package:rient_app/features/schedule/data/models/workers_api/workers_api.dart';
import 'package:rient_app/features/schedule/service/schedules_service.dart';
import 'package:rient_app/features/schedule/utils/schedule_day_key.dart';
import 'package:rient_app/features/schedule/utils/worker_schedule_config_map.dart';
import 'package:rient_app/features/schedule/view/components/work_schedule_mock_data.dart';

/// При дублях `wed`/`wen` или branch/worker — активный шаблон и больший id.
bool _preferDailyScheduleItem(
  ScheduleItemApi candidate,
  ScheduleItemApi current,
) {
  if (candidate.auto != current.auto) return !candidate.auto;
  return candidate.id > current.id;
}

bool preferSchedulePattern(
  SchedulePatternItemApi candidate,
  SchedulePatternItemApi current,
) {
  if (candidate.active != current.active) return candidate.active;
  return candidate.id > current.id;
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
  return dedupeSchedulePatternsByDay([
    ...fromBranchApi,
    ...schedulePatternsFromWorkerRow(workerRow),
  ]);
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

WorkScheduleDayCell workScheduleCellFromScheduleItem(
  ScheduleItemApi? item, {
  bool selected = false,
  bool isManuallyEdited = false,
}) {
  final manual = isManuallyEdited || (item != null && !item.auto);
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

WorkScheduleDayCell workScheduleCellFromPattern(
  SchedulePatternItemApi? pattern, {
  bool selected = false,
  ScheduleItemApi? daily,
}) {
  if (pattern == null || !pattern.active) {
    return _dayOffFromDaily(daily);
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
  return WorkScheduleDayCell.shift(
    timeStart: start,
    timeEnd: end,
    tone: tone,
    isSelected: selected,
    scheduleId: daily?.id,
    breakStart: daily?.breakStartShort,
    breakEnd: daily?.breakEndShort,
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

bool _isShiftWorkDay(DateTime date, Map<String, dynamic>? configMap) {
  if (configMap == null) return false;

  final patternRaw = configMap['schedule_shift_pattern']?.toString() ?? '1/1';
  final parts = patternRaw.split('/');
  final workDays = int.tryParse(parts.isNotEmpty ? parts[0] : '') ?? 1;
  final offDays = int.tryParse(parts.length > 1 ? parts[1] : '') ?? 1;
  if (workDays <= 0 || offDays <= 0) return false;

  final startRaw = configMap['schedule_shift_start_date']?.toString();
  if (startRaw == null || startRaw.isEmpty) return false;
  final parsed = DateTime.tryParse(startRaw);
  if (parsed == null) return false;
  final shiftStart = DateTime(parsed.year, parsed.month, parsed.day);
  final target = DateTime(date.year, date.month, date.day);
  final daysSince = target.difference(shiftStart).inDays;
  if (daysSince < 0) return false;

  final cycleLength = workDays + offDays;
  final position = daysSince % cycleLength;
  return position < workDays;
}

String? _shortTimeFromDynamic(dynamic value) {
  if (value == null) return null;
  final s = value.toString();
  if (s.isEmpty) return null;
  return s.length >= 5 ? s.substring(0, 5) : s;
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
    if (!_isShiftWorkDay(date, configMap)) {
      return _dayOffFromDaily(daily);
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
  Map<String, dynamic>? workerRow,
  DateTime? highlightedCellDate,
}) {
  final configMap = workerScheduleConfigForBranch(workerRow, branchId);
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
    final itemWorkerId = item.workerId;
    if (itemWorkerId != null && itemWorkerId != worker.id) continue;
    final existing = byDate[item.date];
    if (existing == null || _preferDailyScheduleItem(item, existing)) {
      byDate[item.date] = item;
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
          // Ручные правки дня — из schedules; auto — общий шаблон, берём patterns/config.
          if (daily != null && !daily.auto) {
            if (daily.active) {
              return workScheduleCellFromScheduleItem(
                daily,
                selected: selected,
              );
            }
            // Неактивная ручная запись: если в недельном шаблоне день включён — шаблон.
            if (!_isShiftSchedule(configMap)) {
              final pattern = _patternForWeekday(
                resolvedPatterns,
                date.weekday,
              );
              if (pattern != null && pattern.active) {
                return workScheduleCellFromPattern(
                  pattern,
                  selected: selected,
                  daily: daily,
                );
              }
            }
            return workScheduleCellFromScheduleItem(
              daily,
              selected: selected,
            );
          }
          return _cellFromTemplate(
            date: date,
            patterns: resolvedPatterns,
            workerRow: workerRow,
            configMap: configMap,
            daily: daily,
            selected: selected,
          );
        }(),
    ],
  );
}
