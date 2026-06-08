import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rient_app/core/services/push_notification_navigation.dart';

/// Id канала Android — должен совпадать с AndroidManifest meta-data.
const kHighImportanceChannelId = 'high_importance_channel';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  late final FlutterLocalNotificationsPlugin _localNotifications;
  late final AndroidNotificationChannel _androidChannel;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    await _initLocalNotifications();
    await _initForegroundHandlers();
  }

  Future<void> _initLocalNotifications() async {
    _localNotifications = FlutterLocalNotificationsPlugin();
    _androidChannel = const AndroidNotificationChannel(
      kHighImportanceChannelId,
      'Уведомления Rient',
      description: 'Важные уведомления приложения',
      importance: Importance.high,
    );

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _localNotifications.initialize(
      settings: const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    if (Platform.isAndroid) {
      final androidPlugin =
          _localNotifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.createNotificationChannel(_androidChannel);
      await androidPlugin?.requestNotificationsPermission();
    }

    if (Platform.isIOS) {
      await _messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  Future<void> _initForegroundHandlers() async {
    final initial = await _messaging.getInitialMessage();
    _handleOpenedMessage(initial);

    FirebaseMessaging.onMessageOpenedApp.listen(_handleOpenedMessage);
    FirebaseMessaging.onMessage.listen(_showForegroundNotification);
  }

  void _onNotificationTap(NotificationResponse response) {
    debugPrint('Notification tap: ${response.payload}');
    PushNotificationNavigation.openMessagesTab();
  }

  void _handleOpenedMessage(RemoteMessage? message) {
    if (message == null) return;
    debugPrint(
      'FCM opened: ${message.notification?.title} ${message.notification?.body}',
    );
    PushNotificationNavigation.openMessagesTab();
  }

  void _showForegroundNotification(RemoteMessage message) {
    if (kIsWeb) return;

    final title = message.notification?.title ??
        message.data['title']?.toString() ??
        message.data['notification_title']?.toString();
    final body = message.notification?.body ??
        message.data['body']?.toString() ??
        message.data['notification_body']?.toString();

    if (title == null && body == null) return;

    // iOS: баннер в foreground через setForegroundNotificationPresentationOptions,
    // если в payload есть notification. Для data-only — показываем локально.
    final hasFcmNotification = message.notification != null;
    if (Platform.isIOS && hasFcmNotification) {
      return;
    }

    final id = message.hashCode.abs() % 2147483647;

    _localNotifications.show(
      id: id,
      title: title,
      body: body,
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
}
