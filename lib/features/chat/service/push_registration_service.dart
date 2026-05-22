import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rient_app/core/services/push_device_storage.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/chat/data/models/push_device_api/push_device_api.dart';
import 'package:rient_app/features/chat/service/mobile_push_service.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/firebase_options.dart';

final pushRegistrationServiceProvider = Provider<PushRegistrationService>(
  (ref) => PushRegistrationService(ref),
);

/// Инициализация Firebase и подписка на обновление FCM token.
final pushMessagingBootstrapProvider = Provider<void>((ref) {
  ref.onDispose(() {
    ref.read(pushRegistrationServiceProvider).dispose();
  });
  unawaited(ref.read(pushRegistrationServiceProvider).ensureInitialized());
});

class PushRegistrationService {
  PushRegistrationService(this.ref);

  final Ref ref;
  StreamSubscription<String>? _tokenRefreshSubscription;
  bool _initialized = false;

  void dispose() {
    unawaited(_tokenRefreshSubscription?.cancel());
    _tokenRefreshSubscription = null;
  }

  Future<void> ensureInitialized() async {
    if (_initialized) return;
    _initialized = true;

    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      final messaging = FirebaseMessaging.instance;
      await messaging.setAutoInitEnabled(true);
      if (Platform.isIOS) {
        await messaging.requestPermission(alert: true, badge: true, sound: true);
        await _waitForApnsToken(messaging);
      }
      _tokenRefreshSubscription ??= messaging.onTokenRefresh.listen((token) {
        unawaited(registerCurrentDevice(fcmToken: token));
      });
    } catch (e, st) {
      debugPrint('PushRegistrationService: Firebase init failed: $e\n$st');
    }
  }

  /// На iOS FCM token доступен только после APNS token (реальный девайс, не симулятор).
  Future<void> _waitForApnsToken(FirebaseMessaging messaging) async {
    for (var attempt = 0; attempt < 20; attempt++) {
      final apns = await messaging.getAPNSToken();
      if (apns != null && apns.isNotEmpty) return;
      await Future<void>.delayed(const Duration(milliseconds: 300));
    }
    debugPrint(
      'PushRegistrationService: APNS token not ready (simulator or no push capability)',
    );
  }

  Future<String?> _resolveFcmToken({String? override}) async {
    if (override != null && override.isNotEmpty) return override;
    try {
      if (Firebase.apps.isEmpty) return null;
      final messaging = FirebaseMessaging.instance;
      if (Platform.isIOS) {
        final apns = await messaging.getAPNSToken();
        if (apns == null || apns.isEmpty) {
          return null;
        }
      }
      return messaging.getToken();
    } catch (e) {
      debugPrint('PushRegistrationService: getToken failed: $e');
      return null;
    }
  }

  String _platformName() {
    if (Platform.isIOS) return 'ios';
    if (Platform.isAndroid) return 'android';
    return defaultTargetPlatform.name.toLowerCase();
  }

  Future<void> registerCurrentDevice({
    String? fcmToken,
    bool? pushEnabled,
  }) async {
    final organizationId = ref.read(organizationIdProvider);
    if (organizationId <= 0) return;

    final jwt = ref.read(tokenProvider);
    if (jwt == null || jwt.isEmpty) return;

    try {
      await ensureInitialized();

      final token = await _resolveFcmToken(override: fcmToken);
      if (token == null || token.isEmpty) {
        debugPrint(
          'PushRegistrationService: FCM token unavailable, skip register',
        );
        return;
      }
      // Для теста в Firebase Console → Cloud Messaging → Send test message
      debugPrint('FCM token: $token');

      final deviceStorage = ref.read(pushDeviceStorageProvider);
      final deviceId = await deviceStorage.getOrCreateDeviceId();
      final branchId = ref.read(currentBranchIdProvider);
      final packageInfo = await PackageInfo.fromPlatform();
      final locale = WidgetsBinding.instance.platformDispatcher.locale;
      final localeTag = locale.languageCode;
      String timezoneName;
      try {
        final tz = await FlutterTimezone.getLocalTimezone();
        timezoneName = tz.identifier;
      } catch (_) {
        timezoneName = DateTime.now().timeZoneName;
      }

      final device = await ref.read(mobilePushServiceProvider).registerDevice(
            RegisterPushDeviceRequest(
              organization: organizationId,
              branch: branchId > 0 ? branchId : null,
              token: token,
              deviceId: deviceId,
              platform: _platformName(),
              appVersion: packageInfo.version,
              appBuild: packageInfo.buildNumber,
              locale: localeTag,
              timezoneName: timezoneName,
              pushEnabled: pushEnabled ?? true,
            ),
          );

      await deviceStorage.saveRegisteredDeviceApiId(device.id);
    } catch (e, st) {
      debugPrint('PushRegistrationService: register failed: $e\n$st');
    }
  }

  Future<void> deactivateCurrentDevice() async {
    final organizationId = ref.read(organizationIdProvider);
    if (organizationId <= 0) return;

    final jwt = ref.read(tokenProvider);
    if (jwt == null || jwt.isEmpty) return;

    try {
      final deviceStorage = ref.read(pushDeviceStorageProvider);
      final deviceId = await deviceStorage.getOrCreateDeviceId();
      final apiId = await deviceStorage.getRegisteredDeviceApiId();
      final fcmToken = await _resolveFcmToken();

      await ref.read(mobilePushServiceProvider).deactivateDevice(
            organizationId: organizationId,
            id: apiId,
            token: fcmToken,
            deviceId: deviceId,
          );

      await deviceStorage.clearRegisteredDeviceApiId();
    } catch (e, st) {
      debugPrint('PushRegistrationService: deactivate failed: $e\n$st');
    }
  }
}
