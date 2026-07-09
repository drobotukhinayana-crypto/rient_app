import 'dart:convert';
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

int? _parsePushInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value.trim());
  return null;
}

int? _parseBranchIdFromMap(Map<dynamic, dynamic> data) {
  final direct =
      _parsePushInt(data['branch']) ?? _parsePushInt(data['branch_id']);
  if (direct != null && direct > 0) return direct;

  final payload = data['payload'];
  if (payload is Map) {
    final fromPayload = _parsePushInt(payload['branch']) ??
        _parsePushInt(payload['branch_id']);
    if (fromPayload != null && fromPayload > 0) return fromPayload;
  }
  if (payload is String && payload.isNotEmpty) {
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map) {
        return _parseBranchIdFromMap(decoded);
      }
    } catch (_) {}
  }
  return null;
}

/// Извлекает id филиала из data-секции FCM (поля branch / branch_id / payload).
int? parseBranchIdFromPushData(Map<String, dynamic> data) {
  return _parseBranchIdFromMap(data);
}

int? parseBranchIdFromRemoteMessage(RemoteMessage message) {
  return parseBranchIdFromPushData(message.data);
}

/// Payload для локального уведомления — чтобы при тапе переключить филиал.
String? buildPushNavigationPayload(Map<String, dynamic> data) {
  final branchId = parseBranchIdFromPushData(data);
  if (branchId == null) return null;
  return 'branch_id=$branchId';
}

int? parseBranchIdFromNotificationPayload(String? payload) {
  if (payload == null || payload.isEmpty) return null;
  const prefix = 'branch_id=';
  if (payload.startsWith(prefix)) {
    return int.tryParse(payload.substring(prefix.length));
  }
  return null;
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
    payload: buildPushNavigationPayload(message.data),
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
