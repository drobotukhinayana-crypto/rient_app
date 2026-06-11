import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rient_app/core/services/notification_service.dart';

class PushNotificationContent {
  const PushNotificationContent({this.title, this.body});

  final String? title;
  final String? body;

  bool get isEmpty =>
      (title == null || title!.trim().isEmpty) &&
      (body == null || body!.trim().isEmpty);
}

PushNotificationContent parsePushNotificationContent(RemoteMessage message) {
  final title = message.notification?.title ??
      message.data['title']?.toString() ??
      message.data['notification_title']?.toString();
  final body = message.notification?.body ??
      message.data['body']?.toString() ??
      message.data['notification_body']?.toString();
  return PushNotificationContent(title: title, body: body);
}

final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const AndroidNotificationChannel _androidChannel = AndroidNotificationChannel(
  kHighImportanceChannelId,
  'Уведомления Rient',
  description: 'Важные уведомления приложения',
  importance: Importance.high,
);

bool _localNotificationsReady = false;

Future<void> ensurePushLocalNotificationsReady() async {
  if (_localNotificationsReady || kIsWeb) return;

  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosSettings = DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );

  await _localNotificationsPlugin.initialize(
    settings: const InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    ),
  );

  if (Platform.isAndroid) {
    final androidPlugin =
        _localNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_androidChannel);
  }

  _localNotificationsReady = true;
}

Future<void> showPushLocalNotification(RemoteMessage message) async {
  if (kIsWeb) return;

  final content = parsePushNotificationContent(message);
  if (content.isEmpty) return;

  // С notification-блоком в payload фоновую доставку показывает ОС.
  if (message.notification != null) return;

  await ensurePushLocalNotificationsReady();

  final id = message.hashCode.abs() % 2147483647;
  await _localNotificationsPlugin.show(
    id: id,
    title: content.title,
    body: content.body,
    notificationDetails: NotificationDetails(
      android: AndroidNotificationDetails(
        _androidChannel.id,
        _androidChannel.name,
        channelDescription: _androidChannel.description,
        importance: Importance.high,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    ),
  );
}
