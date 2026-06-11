import 'package:rient_app/features/schedule/service/schedules_service.dart';

/// Единый ключ даты YYYY-MM-DD для записей `schedules` (API может отдать DD.MM.YYYY).
String canonicalScheduleDateKey(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return trimmed;

  final iso = DateTime.tryParse(trimmed);
  if (iso != null) {
    final local = iso.toLocal();
    return SchedulesService.dateToApi(
      DateTime(local.year, local.month, local.day),
    );
  }

  final dash = trimmed.split('-');
  if (dash.length == 3) {
    final y = int.tryParse(dash[0]);
    final m = int.tryParse(dash[1]);
    final d = int.tryParse(dash[2]);
    if (y != null && m != null && d != null) {
      return SchedulesService.dateToApi(DateTime(y, m, d));
    }
  }

  final dot = trimmed.split('.');
  if (dot.length == 3) {
    final d = int.tryParse(dot[0]);
    final m = int.tryParse(dot[1]);
    final y = int.tryParse(dot[2]);
    if (d != null && m != null && y != null) {
      return SchedulesService.dateToApi(DateTime(y, m, d));
    }
  }

  return trimmed;
}

DateTime? parseScheduleApiDate(String raw) {
  final key = canonicalScheduleDateKey(raw);
  final parts = key.split('-');
  if (parts.length != 3) return null;
  final year = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  final day = int.tryParse(parts[2]);
  if (year == null || month == null || day == null) return null;
  return DateTime(year, month, day);
}

bool isSameScheduleApiDate(String raw, DateTime date) {
  final parsed = parseScheduleApiDate(raw);
  if (parsed == null) return false;
  return parsed.year == date.year &&
      parsed.month == date.month &&
      parsed.day == date.day;
}
