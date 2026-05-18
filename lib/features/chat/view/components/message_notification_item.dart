/// Уведомление на вкладке «Сообщения» (мок / будущий API).
class MessageNotificationItem {
  const MessageNotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.isUnread,
    this.showAccent = false,
  });

  final String id;
  final String title;
  final String description;
  final String timestamp;
  final bool isUnread;

  /// Синяя полоска слева (например, «Новая запись»).
  final bool showAccent;
}
