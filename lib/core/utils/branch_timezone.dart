import 'package:timezone/timezone.dart' as tz;

/// Таймзона филиала по умолчанию, если API не вернул [BranchApi.timezone].
const defaultBranchTimezoneId = 'Europe/Moscow';

/// Работа с календарём и API-датами в таймзоне филиала (IANA, напр. Europe/Moscow).
class BranchTimezone {
  BranchTimezone(String? timezoneId) : _location = _resolveLocation(timezoneId);

  final tz.Location _location;

  tz.Location get location => _location;

  static tz.Location _resolveLocation(String? timezoneId) {
    final id = (timezoneId ?? '').trim();
    if (id.isEmpty) {
      return tz.getLocation(defaultBranchTimezoneId);
    }
    try {
      return tz.getLocation(id);
    } catch (_) {
      return tz.getLocation(defaultBranchTimezoneId);
    }
  }

  /// Текущие дата и время в таймзоне филиала.
  tz.TZDateTime now() => tz.TZDateTime.now(_location);

  /// Сегодня (полночь→полночь) в таймзоне филиала как «наивная» дата.
  DateTime todayDateOnly() {
    final current = now();
    return DateTime(current.year, current.month, current.day);
  }

  /// ISO из API → wall-clock время филиала (для сетки расписания).
  DateTime? parseApiDateTime(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final trimmed = raw.trim();
    final parsed = DateTime.tryParse(trimmed);
    if (parsed == null) return null;

    final hasExplicitOffset = trimmed.endsWith('Z') ||
        RegExp(r'[+-]\d{2}:?\d{2}$').hasMatch(trimmed);

    if (hasExplicitOffset || parsed.isUtc) {
      final inBranch = tz.TZDateTime.from(parsed, _location);
      return DateTime(
        inBranch.year,
        inBranch.month,
        inBranch.day,
        inBranch.hour,
        inBranch.minute,
        inBranch.second,
        inBranch.millisecond,
      );
    }

    return DateTime(
      parsed.year,
      parsed.month,
      parsed.day,
      parsed.hour,
      parsed.minute,
      parsed.second,
      parsed.millisecond,
    );
  }

  /// Начало календарного дня для API: `YYYY-MM-DDT00:00:00±HH:MM`.
  String formatApiDayStart(DateTime date) =>
      _formatApiDateTime(date, time: '00:00:00');

  /// Конец календарного дня для API: `YYYY-MM-DDT23:59:00±HH:MM`.
  String formatApiDayEnd(DateTime date) =>
      _formatApiDateTime(date, time: '23:59:00');

  /// Конец дня с секундами (аналитика): `YYYY-MM-DDT23:59:59±HH:MM`.
  String formatApiDayEndWithSeconds(DateTime date) =>
      _formatApiDateTime(date, time: '23:59:59');

  String _formatApiDateTime(DateTime date, {required String time}) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final second = parts.length > 2 ? int.parse(parts[2]) : 0;
    final local = tz.TZDateTime(
      _location,
      date.year,
      date.month,
      date.day,
      hour,
      minute,
      second,
    );
    return _formatWithOffset(local, time);
  }

  static String _formatWithOffset(tz.TZDateTime dateTime, String time) {
    final offset = dateTime.timeZoneOffset;
    final totalMinutes = offset.inMinutes;
    final sign = totalMinutes >= 0 ? '+' : '-';
    final absMinutes = totalMinutes.abs();
    final hours = (absMinutes ~/ 60).toString().padLeft(2, '0');
    final minutes = (absMinutes % 60).toString().padLeft(2, '0');
    final y = dateTime.year;
    final m = dateTime.month.toString().padLeft(2, '0');
    final d = dateTime.day.toString().padLeft(2, '0');
    return '$y-$m-${d}T$time$sign$hours:$minutes';
  }
}
