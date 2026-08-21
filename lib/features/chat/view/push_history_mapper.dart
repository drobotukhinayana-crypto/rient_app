import 'package:rient_app/features/chat/data/models/push_history_api/push_history_api.dart';
import 'package:rient_app/features/chat/view/components/message_notification_item.dart';

MessageNotificationItem messageNotificationItemFromPush(
  PushHistoryItemApi item,
) {
  final created = item.created ?? item.sentAt;
  final isUnread = !item.isRead;
  final showAccent = isUnread &&
      (item.isAppointmentNotification || item.isLicenseNotification);
  return MessageNotificationItem(
    id: item.id,
    title: item.title?.trim().isNotEmpty == true
        ? item.title!.trim()
        : _defaultTitle(item),
    description: item.body?.trim().isNotEmpty == true
        ? item.body!.trim()
        : _defaultDescription(item),
    timestamp: formatPushNotificationDate(created),
    isUnread: isUnread,
    showAccent: showAccent,
    accentIsWarning: isUnread && item.isLicenseNotification,
    appointmentId: item.appointmentId,
    type: item.effectiveType,
    isLicenseNotification: item.isLicenseNotification,
    licenseAction: item.licenseAction,
    licensePaymentUrl: item.licensePaymentUrl,
  );
}

String _defaultTitle(PushHistoryItemApi item) {
  if (item.isLicenseNotification) return 'Лицензия';
  return 'Уведомление';
}

String _defaultDescription(PushHistoryItemApi item) {
  if (!item.isLicenseNotification) return '';

  final endDate = item.payload?['tariff_end_date'];
  if (endDate is String && endDate.trim().isNotEmpty) {
    return 'Срок действия лицензии: ${endDate.trim()}';
  }
  return 'Проверьте статус лицензии организации';
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
