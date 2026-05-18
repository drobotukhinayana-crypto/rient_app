import 'package:rient_app/features/schedule/data/models/schedule_patterns_api/schedule_patterns_api.dart';
import 'package:rient_app/features/schedule/data/models/schedules_api/schedules_api.dart';
import 'package:rient_app/features/schedule/data/models/worker_schedule_config_api/worker_schedule_config_api.dart';
import 'package:rient_app/features/schedule/data/models/workers_api/workers_api.dart';
import 'package:rient_app/features/schedule/service/schedules_service.dart';
import 'package:rient_app/features/schedule/view/components/work_schedule_mock_data.dart';

Map<int, List<SchedulePatternItemApi>> groupSchedulePatternsByWorker(
  List<SchedulePatternItemApi> patterns,
) {
  final map = <int, List<SchedulePatternItemApi>>{};
  for (final pattern in patterns) {
    map.putIfAbsent(pattern.worker, () => []).add(pattern);
  }
  return map;
}

WorkScheduleDayCell workScheduleCellFromScheduleItem(
  ScheduleItemApi? item, {
  bool selected = false,
}) {
  if (item == null || !item.active) {
    return const WorkScheduleDayCell.dayOff();
  }
  final start = item.timeStartShort;
  final end = item.timeEndShort;
  if (start == null || end == null || start.isEmpty || end.isEmpty) {
    return const WorkScheduleDayCell.dayOff();
  }
  final tone = item.hours >= 10
      ? WorkScheduleShiftTone.full
      : WorkScheduleShiftTone.short;
  return WorkScheduleDayCell.shift(
    timeStart: start,
    timeEnd: end,
    tone: tone,
    isSelected: selected,
  );
}

WorkScheduleDayCell workScheduleCellFromPattern(
  SchedulePatternItemApi? pattern, {
  bool selected = false,
}) {
  if (pattern == null || !pattern.active) {
    return const WorkScheduleDayCell.dayOff();
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
  );
}

SchedulePatternItemApi? _patternForWeekday(
  List<SchedulePatternItemApi> patterns,
  int weekday,
) {
  for (final pattern in patterns) {
    if (pattern.weekdayNumber == weekday) return pattern;
  }
  return null;
}

Map<String, dynamic>? _configMap(Map<String, dynamic>? workerRow) {
  final config = workerRow?['schedule_config'];
  if (config is Map) {
    return config.map((k, v) => MapEntry(k.toString(), v));
  }
  return null;
}

bool _isShiftSchedule(Map<String, dynamic>? configMap) {
  final raw = configMap?['schedule_type'];
  final type = raw is num ? raw.toInt() : WorkerScheduleConfigType.week;
  return type == WorkerScheduleConfigType.shift;
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
  bool selected = false,
}) {
  final configMap = _configMap(workerRow);

  if (_isShiftSchedule(configMap)) {
    if (!_isShiftWorkDay(date, configMap)) {
      return const WorkScheduleDayCell.dayOff();
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
    );
  }

  return workScheduleCellFromPattern(
    _patternForWeekday(patterns, date.weekday),
    selected: selected,
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
  List<SchedulePatternItemApi> patterns = const [],
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
    final itemWorkerId = item.workerId;
    if (itemWorkerId != null && itemWorkerId != worker.id) continue;
    byDate[item.date] = item;
  }

  final firstName = worker.firstName?.trim() ?? '';
  final lastName = worker.lastName?.trim() ?? '';
  final name = [firstName, lastName].where((p) => p.isNotEmpty).join(' ');
  final displayName = name.isNotEmpty ? name : 'Сотрудник #${worker.id}';

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
            return workScheduleCellFromScheduleItem(
              daily,
              selected: selected,
            );
          }
          return _cellFromTemplate(
            date: date,
            patterns: patterns,
            workerRow: workerRow,
            selected: selected,
          );
        }(),
    ],
  );
}
