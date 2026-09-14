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

int? _parseOrganizationIdFromMap(Map<dynamic, dynamic> data) {
  final direct = _parsePushInt(data['organization']) ??
      _parsePushInt(data['organization_id']);
  if (direct != null && direct > 0) return direct;

  final payload = data['payload'];
  if (payload is Map) {
    final fromPayload = _parsePushInt(payload['organization']) ??
        _parsePushInt(payload['organization_id']);
    if (fromPayload != null && fromPayload > 0) return fromPayload;
  }
  if (payload is String && payload.isNotEmpty) {
    try {
      final decoded = jsonDecode(payload);
      if (decoded is Map) {
        return _parseOrganizationIdFromMap(decoded);
      }
    } catch (_) {}
  }
  return null;
}

/// Извлекает id филиала из data-секции FCM (поля branch / branch_id / payload).
int? parseBranchIdFromPushData(Map<String, dynamic> data) {
  return _parseBranchIdFromMap(data);
}

/// Извлекает id организации из data-секции FCM.
int? parseOrganizationIdFromPushData(Map<String, dynamic> data) {
  return _parseOrganizationIdFromMap(data);
}

int? parseBranchIdFromRemoteMessage(RemoteMessage message) {
  return parseBranchIdFromPushData(message.data);
}

int? parseOrganizationIdFromRemoteMessage(RemoteMessage message) {
  return parseOrganizationIdFromPushData(message.data);
}

class PushNavigationPayload {
  const PushNavigationPayload({this.organizationId, this.branchId});

  final int? organizationId;
  final int? branchId;

  bool get isEmpty =>
      (organizationId == null || organizationId! <= 0) &&
      (branchId == null || branchId! <= 0);
}

/// Payload для локального уведомления — чтобы при тапе переключить контекст.
String? buildPushNavigationPayload(Map<String, dynamic> data) {
  final organizationId = parseOrganizationIdFromPushData(data);
  final branchId = parseBranchIdFromPushData(data);
  if ((organizationId == null || organizationId <= 0) &&
      (branchId == null || branchId <= 0)) {
    return null;
  }

  final parts = <String>[];
  if (organizationId != null && organizationId > 0) {
    parts.add('organization_id=$organizationId');
  }
  if (branchId != null && branchId > 0) {
    parts.add('branch_id=$branchId');
  }
  return parts.join('&');
}

PushNavigationPayload parsePushNavigationPayload(String? payload) {
  if (payload == null || payload.isEmpty) {
    return const PushNavigationPayload();
  }

  int? organizationId;
  int? branchId;
  for (final part in payload.split('&')) {
    if (part.startsWith('organization_id=')) {
      organizationId = int.tryParse(part.substring('organization_id='.length));
    } else if (part.startsWith('branch_id=')) {
      branchId = int.tryParse(part.substring('branch_id='.length));
    }
  }

  return PushNavigationPayload(
    organizationId: organizationId,
    branchId: branchId,
  );
}

int? parseBranchIdFromNotificationPayload(String? payload) {
  return parsePushNavigationPayload(payload).branchId;
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
