/// Уведомление на вкладке «Сообщения».
class MessageNotificationItem {
  const MessageNotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.isUnread,
    this.showAccent = false,
    this.accentIsWarning = false,
    this.appointmentId,
    this.type,
    this.isLicenseNotification = false,
    this.licenseAction,
    this.licensePaymentUrl,
  });

  final int id;
  final String title;
  final String description;
  final String timestamp;
  final bool isUnread;

  /// Синяя полоска слева (например, «Новая запись»).
  final bool showAccent;

  /// Жёлтая полоска для уведомлений о лицензии.
  final bool accentIsWarning;

  final int? appointmentId;
  final String? type;
  final bool isLicenseNotification;
  final String? licenseAction;
  final String? licensePaymentUrl;

  MessageNotificationItem copyWith({
    bool? isUnread,
    bool? showAccent,
    bool? accentIsWarning,
  }) {
    return MessageNotificationItem(
      id: id,
      title: title,
      description: description,
      timestamp: timestamp,
      isUnread: isUnread ?? this.isUnread,
      showAccent: showAccent ?? this.showAccent,
      accentIsWarning: accentIsWarning ?? this.accentIsWarning,
      appointmentId: appointmentId,
      type: type,
      isLicenseNotification: isLicenseNotification,
      licenseAction: licenseAction,
      licensePaymentUrl: licensePaymentUrl,
    );
  }
}
