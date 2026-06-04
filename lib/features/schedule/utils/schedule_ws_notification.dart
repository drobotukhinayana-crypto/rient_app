import 'dart:convert';

/// События WS/push, после которых нужно обновить экран расписания.
const _appointmentEventValues = <String>{
  'appointment',
  'appointments',
  'appointment_created',
  'appointment_updated',
  'appointment_deleted',
  'appointment_changed',
  'booking',
  'booking_created',
};

const _topicKeys = {
  'topic',
  'theme',
  'type',
  'channel',
  'event',
  'action',
  'model',
  'entity',
  'command',
  'name',
};

bool _matchesAppointmentEvent(String? raw) {
  if (raw == null || raw.isEmpty) return false;
  final value = raw.toLowerCase().trim();
  if (_appointmentEventValues.contains(value)) return true;
  return value.contains('appointment') || value.contains('booking');
}

/// Распознаёт WS-сообщение о записи (в т.ч. вложенный JSON с веба).
bool isScheduleAppointmentWsMessage(dynamic raw, {int depth = 0}) {
  if (depth > 12) return false;

  dynamic payload = raw;
  if (raw is String) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return false;
    try {
      payload = jsonDecode(trimmed);
      return isScheduleAppointmentWsMessage(payload, depth: depth + 1);
    } catch (_) {
      return _matchesAppointmentEvent(trimmed);
    }
  }

  if (payload is Map) {
    for (final entry in payload.entries) {
      final key = entry.key.toString().toLowerCase();
      final value = entry.value;

      if (key == 'appointment' ||
          key == 'appointment_id' ||
          key == 'appointments') {
        return true;
      }

      if (_topicKeys.contains(key) && _matchesAppointmentEvent(value?.toString())) {
        return true;
      }

      if (isScheduleAppointmentWsMessage(value, depth: depth + 1)) {
        return true;
      }
    }
    return false;
  }

  if (payload is List) {
    for (final item in payload) {
      if (isScheduleAppointmentWsMessage(item, depth: depth + 1)) {
        return true;
      }
    }
  }

  return false;
}
