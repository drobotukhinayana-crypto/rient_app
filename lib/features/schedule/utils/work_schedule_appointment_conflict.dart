import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/features/schedule/data/models/appointments_api/appointments_api.dart';
import 'package:rient_app/features/schedule/service/appointments_service.dart';
/// Конфликт записей с рабочим интервалом (клиент и ответ API).
const workScheduleAppointmentsConflictMessage =
    'На данное число (время) есть записи, которые не попадают в '
    'установленный интервал. Либо удалите ненужные записи, либо установите '
    'другое рабочее время';

bool isScheduleAppointmentConflictApiMessage(String? raw) {
  if (raw == null) return false;
  return raw.contains('AppointmentExistsBeyondGivenInterval');
}

bool _apiDataContainsAppointmentConflict(dynamic data) {
  if (data == null) return false;
  if (data is String) return isScheduleAppointmentConflictApiMessage(data);
  if (data is List) {
    for (final item in data) {
      if (_apiDataContainsAppointmentConflict(item)) return true;
    }
    return false;
  }
  if (data is Map) {
    for (final value in data.values) {
      if (_apiDataContainsAppointmentConflict(value)) return true;
    }
  }
  return false;
}

bool isScheduleAppointmentConflictError(Object error) {
  if (error is! CustomException) return false;
  final caused = error.causedError;
  if (caused is! DioException) return false;
  return _apiDataContainsAppointmentConflict(caused.response?.data);
}

/// Технические коды ошибок бэкенда → текст для пользователя.
String? humanizeScheduleApiError(String? raw) {
  if (raw == null) return null;
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return null;
  if (isScheduleAppointmentConflictApiMessage(trimmed)) {
    return workScheduleAppointmentsConflictMessage;
  }
  return trimmed;
}

class WorkScheduleDayBounds {
  const WorkScheduleDayBounds({
    required this.isWorkingDay,
    this.workStart,
    this.workEnd,
    this.breakStart,
    this.breakEnd,
  });

  final bool isWorkingDay;
  final String? workStart;
  final String? workEnd;
  final String? breakStart;
  final String? breakEnd;
}

int timeStringToMinutes(String time) {
  final parts = time.split(':');
  final h = int.tryParse(parts.first) ?? 0;
  final m = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;
  return h * 60 + m;
}

DateTime _parseAppointmentLocal(String? raw, DateTime fallback) {
  if (raw == null || raw.isEmpty) return fallback;
  final parsed = DateTime.tryParse(raw);
  if (parsed == null) return fallback;
  return parsed.toLocal();
}

({DateTime start, DateTime end}) appointmentTimeRange(
  AppointmentApi appointment,
  DateTime day,
) {
  final dayStart = DateTime(day.year, day.month, day.day);
  final fallbackStart = _parseAppointmentLocal(appointment.datetime, dayStart);
  var start = fallbackStart;
  var end = start.add(const Duration(minutes: 30));

  if (appointment.services.isNotEmpty) {
    final first = appointment.services.first;
    start = _parseAppointmentLocal(first.datetime, fallbackStart);
    var maxEnd = start.add(
      Duration(
        minutes: first.totalDurationMinutes <= 0
            ? 30
            : first.totalDurationMinutes,
      ),
    );
    for (final service in appointment.services) {
      final serviceStart = _parseAppointmentLocal(service.datetime, start);
      final serviceEnd = serviceStart.add(
        Duration(
          minutes: service.totalDurationMinutes <= 0
              ? 30
              : service.totalDurationMinutes,
        ),
      );
      if (serviceEnd.isAfter(maxEnd)) {
        maxEnd = serviceEnd;
      }
    }
    end = maxEnd;
  }

  return (start: start, end: end);
}

DateTime _timeOnDay(DateTime day, String time) {
  final minutes = timeStringToMinutes(time);
  return DateTime(
    day.year,
    day.month,
    day.day,
    minutes ~/ 60,
    minutes % 60,
  );
}

bool _rangesOverlap(int aStart, int aEnd, int bStart, int bEnd) {
  return aStart < bEnd && aEnd > bStart;
}

/// Запись целиком внутри смены: начало смены не позже начала записи,
/// конец смены не раньше конца записи, без попадания в перерыв.
bool _appointmentFullyInsideWork({
  required DateTime day,
  required DateTime appointmentStart,
  required DateTime appointmentEnd,
  required WorkScheduleDayBounds bounds,
}) {
  final workStart = bounds.workStart?.trim();
  final workEnd = bounds.workEnd?.trim();
  if (workStart == null ||
      workEnd == null ||
      workStart.isEmpty ||
      workEnd.isEmpty) {
    return false;
  }

  final workStartDt = _timeOnDay(day, workStart);
  final workEndDt = _timeOnDay(day, workEnd);

  if (appointmentStart.isBefore(workStartDt)) return false;
  if (appointmentEnd.isAfter(workEndDt)) return false;

  final breakStart = bounds.breakStart?.trim();
  final breakEnd = bounds.breakEnd?.trim();
  if (breakStart != null &&
      breakEnd != null &&
      breakStart.isNotEmpty &&
      breakEnd.isNotEmpty) {
    final startMin =
        appointmentStart.hour * 60 + appointmentStart.minute;
    final endMin = appointmentEnd.hour * 60 + appointmentEnd.minute;
    final bs = timeStringToMinutes(breakStart);
    final be = timeStringToMinutes(breakEnd);
    if (_rangesOverlap(startMin, endMin, bs, be)) return false;
  }

  return true;
}

/// Конфликт: выходной при любой записи; иначе запись должна целиком
/// укладываться между началом и концом смены.
bool appointmentConflictsWithWorkScheduleChange({
  required DateTime day,
  required DateTime appointmentStart,
  required DateTime appointmentEnd,
  required WorkScheduleDayBounds proposed,
}) {
  if (!proposed.isWorkingDay) return true;

  final workStart = proposed.workStart?.trim();
  final workEnd = proposed.workEnd?.trim();
  if (workStart == null ||
      workEnd == null ||
      workStart.isEmpty ||
      workEnd.isEmpty) {
    return false;
  }

  return !_appointmentFullyInsideWork(
    day: day,
    appointmentStart: appointmentStart,
    appointmentEnd: appointmentEnd,
    bounds: proposed,
  );
}

/// `null` — конфликтов нет, иначе текст ошибки.
Future<String?> validateWorkScheduleDayAgainstAppointments({
  required WidgetRef ref,
  required int branchId,
  required int workerId,
  required DateTime date,
  required WorkScheduleDayBounds proposed,
}) async {
  if (branchId <= 0 || workerId <= 0) return null;

  final normalized = DateTime(date.year, date.month, date.day);
  final dayEnd = normalized
      .add(const Duration(days: 1))
      .subtract(const Duration(milliseconds: 1));

  final response = await ref.read(appointmentsServiceProvider).getAppointments(
        branchId: branchId,
        workerId: workerId,
        dateTimeGte: normalized,
        dateTimeLte: dayEnd,
      );

  final active = response.results.where((a) => a.isActive).toList();
  if (active.isEmpty) return null;

  for (final appointment in active) {
    final range = appointmentTimeRange(appointment, normalized);
    if (appointmentConflictsWithWorkScheduleChange(
      day: normalized,
      appointmentStart: range.start,
      appointmentEnd: range.end,
      proposed: proposed,
    )) {
      return workScheduleAppointmentsConflictMessage;
    }
  }

  return null;
}
