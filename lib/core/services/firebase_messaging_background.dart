import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:rient_app/core/services/push_notification_display.dart';
import 'package:rient_app/firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final content = parsePushNotificationContent(message);
  debugPrint(
    'FCM background: ${content.title} ${content.body} '
    'notification=${message.notification != null}',
  );
  await showPushLocalNotification(message);
}
