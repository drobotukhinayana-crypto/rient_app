/// Уведомление на вкладке «Сообщения».
class MessageNotificationItem {
  const MessageNotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.isUnread,
    this.showAccent = false,
    this.appointmentId,
    this.type,
  });

  final int id;
  final String title;
  final String description;
  final String timestamp;
  final bool isUnread;

  /// Синяя полоска слева (например, «Новая запись»).
  final bool showAccent;

  final int? appointmentId;
  final String? type;
}
