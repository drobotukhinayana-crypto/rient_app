import 'package:rient_app/features/chat/view/components/message_notification_item.dart';

const mockUnreadMessages = [
  MessageNotificationItem(
    id: '1',
    title: 'Новая запись',
    description:
        'Запись Иван Иванов стрижка удлиненная на 19:00-20:00, 19 декабря',
    timestamp: '10:23, 12.12.2025',
    isUnread: true,
    showAccent: true,
  ),
  MessageNotificationItem(
    id: '2',
    title: 'Клиент отказался',
    description: 'Запись Иван Иванов стрижка удлиненная отменена',
    timestamp: '10:13, 12.12.2025',
    isUnread: true,
    showAccent: false,
  ),
  MessageNotificationItem(
    id: '3',
    title: 'Напоминание',
    description: 'Завтра у вас 5 записей в филиале Вита',
    timestamp: '09:45, 12.12.2025',
    isUnread: true,
    showAccent: false,
  ),
];

const mockReadMessages = [
  MessageNotificationItem(
    id: '4',
    title: 'Запись перенесена',
    description: 'Запись Мария Петрова маникюр перенесена на 15:00, 20 декабря',
    timestamp: '18:02, 11.12.2025',
    isUnread: false,
    showAccent: false,
  ),
  MessageNotificationItem(
    id: '5',
    title: 'Новая запись',
    description: 'Запись Алексей Смирнов бритьё на 11:00-11:30, 11 декабря',
    timestamp: '14:30, 11.12.2025',
    isUnread: false,
    showAccent: false,
  ),
];
