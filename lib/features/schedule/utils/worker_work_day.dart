import 'package:rient_app/features/schedule/data/models/schedules_api/schedules_api.dart';
import 'package:rient_app/features/schedule/service/schedules_service.dart';
import 'package:rient_app/features/schedule/utils/worker_schedule_config_map.dart';
import 'package:rient_app/features/schedule/view/components/work_schedule_mapper.dart';

DateTime dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

bool isSameCalendarDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// При дублях на дату — как в [work_schedule_mapper]: ручной день важнее auto.
ScheduleItemApi? pickPreferredDailySchedule(
  Iterable<ScheduleItemApi> items,
  DateTime date,
) {
  final key = SchedulesService.dateToApi(date);
  ScheduleItemApi? best;
  for (final item in items) {
    if (item.canonicalDate != key) continue;
    if (best == null || preferDailyScheduleItem(item, best)) {
      best = item;
    }
  }
  return best;
}

Map<String, ScheduleItemApi> indexDailySchedulesByDate(
  Iterable<ScheduleItemApi> items,
) {
  final map = <String, ScheduleItemApi>{};
  for (final item in items) {
    final key = item.canonicalDate;
    final existing = map[key];
    if (existing == null || preferDailyScheduleItem(item, existing)) {
      map[key] = item;
    }
  }
  return map;
}

/// Рабочий ли день сотрудника с учётом ручных правок в `workers/.../schedules/`.
bool isWorkerWorkingOnDate({
  required DateTime date,
  required Set<int> workingWeekdays,
  ScheduleItemApi? daily,
  Map<String, dynamic>? shiftConfig,
}) {
  final day = dateOnly(date);

  if (daily != null) {
    final parsed = daily.dateParsed;
    if (parsed != null && isSameCalendarDay(parsed, day)) {
      if (!daily.active) return false;
      if (!daily.auto) {
        final start = daily.timeStartShort;
        final end = daily.timeEndShort;
        return start != null &&
            end != null &&
            start.isNotEmpty &&
            end.isNotEmpty;
      }
    }
  }

  if (isShiftWorkerScheduleConfig(shiftConfig)) {
    return isShiftWorkerWorkDay(day, shiftConfig);
  }

  return workingWeekdays.contains(day.weekday);
}

bool isWorkerNonWorkingOnDate({
  required DateTime date,
  required Set<int> workingWeekdays,
  ScheduleItemApi? daily,
  Map<String, dynamic>? shiftConfig,
}) {
  return !isWorkerWorkingOnDate(
    date: date,
    workingWeekdays: workingWeekdays,
    daily: daily,
    shiftConfig: shiftConfig,
  );
}

double? _hourFromShortTime(String? value) {
  if (value == null || value.isEmpty) return null;
  final parts = value.split(':');
  if (parts.length < 2) return null;
  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null || minute == null) return null;
  return hour + (minute / 60);
}

/// Часы смены мастера в день (null = выходной / нет окна в календаре).
({double? start, double? end}) workerShiftHoursForDate({
  required DateTime date,
  required Set<int> workingWeekdays,
  ScheduleItemApi? daily,
  Map<String, dynamic>? shiftConfig,
  required double branchStartHour,
  required double branchEndHour,
}) {
  if (!isWorkerWorkingOnDate(
    date: date,
    workingWeekdays: workingWeekdays,
    daily: daily,
    shiftConfig: shiftConfig,
  )) {
    return (start: null, end: null);
  }

  if (daily != null && !daily.auto && daily.active) {
    final start = _hourFromShortTime(daily.timeStartShort);
    final end = _hourFromShortTime(daily.timeEndShort);
    if (start != null && end != null && end > start) {
      return (start: start, end: end);
    }
  }

  if (isShiftWorkerScheduleConfig(shiftConfig)) {
    final start = _hourFromShortTime(
      shiftConfig?['time_start']?.toString(),
    );
    final end = _hourFromShortTime(shiftConfig?['time_end']?.toString());
    if (start != null && end != null && end > start) {
      return (start: start, end: end);
    }
  }

  if (workingWeekdays.contains(date.weekday)) {
    return (start: branchStartHour, end: branchEndHour);
  }

  return (start: null, end: null);
}
