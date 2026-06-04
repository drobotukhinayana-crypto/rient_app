import 'package:rient_app/features/analytics/data/models/analytics_summary/analytics_summary.dart';
import 'package:rient_app/features/schedule/data/models/appointments_api/appointments_api.dart';
import 'package:rient_app/features/schedule/data/models/schedules_api/schedules_api.dart';
import 'package:rient_app/features/schedule/service/schedules_service.dart';
import 'package:rient_app/features/schedule/utils/worker_work_day.dart';

/// Минуты рабочего времени за день: смена минус перерыв (обед).
int netAvailableMinutes(ScheduleItemApi? schedule) {
  if (schedule == null || !schedule.active) return 0;

  final start = _minutesFromShortTime(schedule.timeStartShort);
  final end = _minutesFromShortTime(schedule.timeEndShort);
  if (start == null || end == null || end <= start) return 0;

  var available = end - start;
  final breakStart = _minutesFromShortTime(schedule.breakStartShort);
  final breakEnd = _minutesFromShortTime(schedule.breakEndShort);
  if (breakStart != null &&
      breakEnd != null &&
      breakEnd > breakStart &&
      breakStart >= start &&
      breakEnd <= end) {
    available -= breakEnd - breakStart;
  }
  return available.clamp(0, 24 * 60);
}

int sumAppointmentMinutes(Iterable<AppointmentApi> appointments) {
  var total = 0;
  for (final appointment in appointments) {
    if (!appointment.isActive) continue;
    for (final service in appointment.services) {
      total += service.totalDurationMinutes;
    }
  }
  return total;
}

/// Загруженность дня в процентах (0–100), `null` если нет рабочей смены.
double? dayOccupancyPercent({
  required ScheduleItemApi? schedule,
  required Iterable<AppointmentApi> appointments,
}) {
  final available = netAvailableMinutes(schedule);
  if (available <= 0) return 0;
  final booked = sumAppointmentMinutes(appointments);
  if (booked <= 0) return 0;
  return (booked / available * 100).clamp(0, 100);
}

List<AnalyticsOccupancyDay> buildWorkerOccupancyByDay({
  required DateTime rangeStart,
  required DateTime rangeEnd,
  required Map<String, ScheduleItemApi> schedulesByDate,
  required List<AppointmentApi> appointments,
}) {
  final start = dateOnly(rangeStart);
  final end = dateOnly(rangeEnd);
  final byDay = <String, List<AppointmentApi>>{};

  for (final appointment in appointments) {
    final parsed = DateTime.tryParse(appointment.datetime);
    if (parsed == null) continue;
    final local = parsed.toLocal();
    final day = dateOnly(local);
    if (day.isBefore(start) || day.isAfter(end)) continue;
    final key = SchedulesService.dateToApi(day);
    byDay.putIfAbsent(key, () => []).add(appointment);
  }

  final days = <AnalyticsOccupancyDay>[];
  for (var day = start; !day.isAfter(end); day = day.add(const Duration(days: 1))) {
    final key = SchedulesService.dateToApi(day);
    final schedule = schedulesByDate[key];
    final percent = dayOccupancyPercent(
      schedule: schedule,
      appointments: byDay[key] ?? const [],
    );
    if (percent == null) continue;
    days.add(AnalyticsOccupancyDay(date: key, occupancy: percent));
  }
  return days;
}

double averageOccupancyPercent(List<AnalyticsOccupancyDay> days) {
  if (days.isEmpty) return 0;
  final sum = days.fold<double>(0, (acc, d) => acc + d.occupancy);
  return sum / days.length;
}

int? _minutesFromShortTime(String? value) {
  if (value == null || value.isEmpty) return null;
  final parts = value.split(':');
  if (parts.length < 2) return null;
  final h = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  if (h == null || m == null) return null;
  return h * 60 + m;
}
