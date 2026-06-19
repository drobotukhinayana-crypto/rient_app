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

/// `true`/`false` — решение по записи `/schedules/` на дату; `null` — нет записи на дату.
bool? workingStateFromDailySchedule(DateTime date, ScheduleItemApi? daily) {
  if (daily == null) return null;
  final parsed = daily.dateParsed;
  if (parsed == null || !isSameCalendarDay(parsed, dateOnly(date))) {
    return null;
  }
  if (!daily.active) return false;
  // На сайте `active: true` — рабочий день; часы могут подставляться из шаблона.
  return true;
}

/// Рабочий ли день: запись `/schedules/` на дату, затем смена, затем шаблон недели.
bool isWorkerWorkingOnDate({
  required DateTime date,
  required Set<int> workingWeekdays,
  ScheduleItemApi? daily,
  Map<String, dynamic>? shiftConfig,
}) {
  final day = dateOnly(date);

  final fromDaily = workingStateFromDailySchedule(day, daily);
  if (fromDaily != null) return fromDaily;

  if (isShiftWorkerScheduleConfig(shiftConfig)) {
    return isShiftWorkerWorkDay(day, shiftConfig);
  }

  return workingWeekdays.contains(day.weekday);
}

bool _hasBreakRange(String? start, String? end) {
  final bs = start?.trim() ?? '';
  final be = end?.trim() ?? '';
  return bs.isNotEmpty && be.isNotEmpty;
}

/// Перерыв на дату: запись в `schedules` важнее шаблона `available_workers`.
/// Если на дату есть активный дневной график без перерыва — шаблонный не подставляем.
({String? breakStart, String? breakEnd}) resolveWorkerBreakForDate({
  required ScheduleItemApi? daily,
  String? fallbackBreakStart,
  String? fallbackBreakEnd,
}) {
  if (daily != null && daily.active) {
    final bs = daily.breakStartShort;
    final be = daily.breakEndShort;
    if (_hasBreakRange(bs, be)) {
      return (breakStart: bs, breakEnd: be);
    }
    return (breakStart: null, breakEnd: null);
  }
  return (breakStart: fallbackBreakStart, breakEnd: fallbackBreakEnd);
}

/// Границы смены (HH:mm) для слотов: дневной график, иначе смена из available_workers.
({String timeStart, String timeEnd}) resolveWorkerShiftBoundsForDate({
  required ScheduleItemApi? daily,
  required String fallbackTimeStart,
  required String fallbackTimeEnd,
}) {
  if (daily != null && daily.active) {
    final start = daily.timeStartShort;
    final end = daily.timeEndShort;
    if (start != null &&
        start.isNotEmpty &&
        end != null &&
        end.isNotEmpty) {
      return (timeStart: start, timeEnd: end);
    }
  }
  return (timeStart: fallbackTimeStart, timeEnd: fallbackTimeEnd);
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

/// Выходной для полоски дат / календаря: `active: true` — рабочий, `active: false` — выходной.
bool isWorkerNonWorkingDayForCalendar({
  required DateTime date,
  required Set<int> workingWeekdays,
  ScheduleItemApi? daily,
  Map<String, dynamic>? shiftConfig,
  bool hasSchedulesInRange = false,
}) {
  final fromDaily = workingStateFromDailySchedule(date, daily);
  if (fromDaily != null) {
    return !fromDaily;
  }
  // Неделя уже загружена из `/schedules/` — только явные `active: false`.
  if (hasSchedulesInRange) {
    return false;
  }
  if (workingWeekdays.isEmpty &&
      !isShiftWorkerScheduleConfig(shiftConfig)) {
    return false;
  }
  return isWorkerNonWorkingOnDate(
    date: date,
    workingWeekdays: workingWeekdays,
    daily: null,
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

  if (daily != null && daily.active) {
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

/// Часы работы по дням из `/schedules/` (только active с time_start/time_end).
Map<DateTime, ({double startHour, double endHour})> workerWorkHoursByDayForRange({
  required DateTime rangeStart,
  required DateTime rangeEnd,
  required Map<String, ScheduleItemApi> schedulesByDate,
}) {
  final result = <DateTime, ({double startHour, double endHour})>{};
  var date = dateOnly(rangeStart);
  final end = dateOnly(rangeEnd);
  while (!date.isAfter(end)) {
    final daily = schedulesByDate[SchedulesService.dateToApi(date)];
    if (daily != null && daily.active) {
      final start = _hourFromShortTime(daily.timeStartShort);
      final endHour = _hourFromShortTime(daily.timeEndShort);
      if (start != null && endHour != null && endHour > start) {
        result[date] = (startHour: start, endHour: endHour);
      }
    }
    date = date.add(const Duration(days: 1));
  }
  return result;
}
