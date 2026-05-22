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

String formatPushNotificationDate(String? iso) {
  if (iso == null || iso.isEmpty) return '';
  final dt = DateTime.tryParse(iso)?.toLocal();
  if (dt == null) return iso;
  final h = dt.hour.toString().padLeft(2, '0');
  final m = dt.minute.toString().padLeft(2, '0');
  final d = dt.day.toString().padLeft(2, '0');
  final mo = dt.month.toString().padLeft(2, '0');
  return '$h:$m, $d.$mo.${dt.year}';
}
