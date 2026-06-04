import 'package:rient_app/features/chat/data/models/push_history_api/push_history_api.dart';
import 'package:rient_app/features/chat/view/components/message_notification_item.dart';

MessageNotificationItem messageNotificationItemFromPush(
  PushHistoryItemApi item,
) {
  final created = item.created ?? item.sentAt;
  return MessageNotificationItem(
    id: item.id,
    title: item.title?.trim().isNotEmpty == true
        ? item.title!.trim()
        : 'Уведомление',
    description: item.body?.trim().isNotEmpty == true
        ? item.body!.trim()
        : '',
    timestamp: formatPushNotificationDate(created),
    isUnread: !item.isRead,
    showAccent: !item.isRead && item.type == 'appointment_created',
    appointmentId: item.appointmentId,
    type: item.type,
  );
}

/// Смещение Москвы (API отдаёт UTC).
const _moscowOffset = Duration(hours: 3);

final _isoTimezoneSuffix = RegExp(r'[Zz]$|[+-]\d{2}:?\d{2}$');

/// Парсит дату push-истории из API (UTC) в локальное время для отображения (UTC+3).
DateTime? parsePushHistoryDateTime(String? iso) {
  if (iso == null || iso.isEmpty) return null;
  final trimmed = iso.trim();
  final parsed = DateTime.tryParse(trimmed);
  if (parsed == null) return null;

  final DateTime utc;
  if (_isoTimezoneSuffix.hasMatch(trimmed)) {
    utc = parsed.toUtc();
  } else {
    utc = DateTime.utc(
      parsed.year,
      parsed.month,
      parsed.day,
      parsed.hour,
      parsed.minute,
      parsed.second,
      parsed.millisecond,
      parsed.microsecond,
    );
  }
  return utc.add(_moscowOffset);
}

String formatPushNotificationDate(String? iso) {
  final dt = parsePushHistoryDateTime(iso);
  if (dt == null) return iso ?? '';
  final h = dt.hour.toString().padLeft(2, '0');
  final m = dt.minute.toString().padLeft(2, '0');
  final d = dt.day.toString().padLeft(2, '0');
  final mo = dt.month.toString().padLeft(2, '0');
  return '$h:$m, $d.$mo.${dt.year}';
}
