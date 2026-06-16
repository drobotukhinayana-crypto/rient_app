import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum AppNotificationPermissionStatus {
  granted,
  denied,
  notDetermined,
}

class NotificationPermissionService {
  NotificationPermissionService._();

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static Future<AppNotificationPermissionStatus> getStatus() async {
    if (kIsWeb) return AppNotificationPermissionStatus.granted;

    if (Platform.isIOS) {
      final settings = await FirebaseMessaging.instance.getNotificationSettings();
      return _statusFromAuthorization(settings.authorizationStatus);
    }

    if (Platform.isAndroid) {
      final androidPlugin =
          _localNotifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      final enabled = await androidPlugin?.areNotificationsEnabled();
      if (enabled == true) {
        return AppNotificationPermissionStatus.granted;
      }
      if (enabled == false) {
        return AppNotificationPermissionStatus.denied;
      }
      return AppNotificationPermissionStatus.notDetermined;
    }

    return AppNotificationPermissionStatus.granted;
  }

  static AppNotificationPermissionStatus _statusFromAuthorization(
    AuthorizationStatus status,
  ) {
    switch (status) {
      case AuthorizationStatus.authorized:
      case AuthorizationStatus.provisional:
        return AppNotificationPermissionStatus.granted;
      case AuthorizationStatus.denied:
        return AppNotificationPermissionStatus.denied;
      case AuthorizationStatus.notDetermined:
        return AppNotificationPermissionStatus.notDetermined;
    }
  }

  static Future<AppNotificationPermissionStatus> request() async {
    if (kIsWeb) return AppNotificationPermissionStatus.granted;

    if (Platform.isIOS) {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isAndroid) {
      final androidPlugin =
          _localNotifications.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.requestNotificationsPermission();
    }

    return getStatus();
  }

  static Future<void> openSystemNotificationSettings() async {
    if (kIsWeb) return;
    try {
      await AppSettings.openAppSettings(type: AppSettingsType.notification);
    } catch (e) {
      debugPrint('NotificationPermissionService: open settings failed: $e');
      await AppSettings.openAppSettings();
    }
  }

  static Future<bool> hasGrantedPermission() async {
    final status = await getStatus();
    return status == AppNotificationPermissionStatus.granted;
  }
}

const notificationExplainPromptDeclinedKey =
    'notification_explain_prompt_declined';
