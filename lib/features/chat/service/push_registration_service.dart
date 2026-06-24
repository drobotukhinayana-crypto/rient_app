import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rient_app/core/services/notification_permission_service.dart';
import 'package:rient_app/core/services/push_device_storage.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';
import 'package:rient_app/features/auth/view/providers/branches_id_provider.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
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
  Timer? _registerRetryTimer;
  int _registerRetryAttempt = 0;
  Future<void>? _registerInFlight;

  void dispose() {
    cancelPendingRetries();
    unawaited(_tokenRefreshSubscription?.cancel());
    _tokenRefreshSubscription = null;
  }

  /// Отменяет отложенную регистрацию (logout / смена пользователя).
  void cancelPendingRetries() {
    _registerRetryTimer?.cancel();
    _registerRetryTimer = null;
    _registerRetryAttempt = 0;
  }

  /// Сбрасывает отложенную регистрацию при logout / смене пользователя.
  void resetForNewSession() {
    cancelPendingRetries();
  }

  Future<void> registerForActiveSession() async {
    await registerCurrentDevice();
  }

  Future<void> ensureInitialized() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }
      final messaging = FirebaseMessaging.instance;
      await messaging.setAutoInitEnabled(true);
      _tokenRefreshSubscription ??= messaging.onTokenRefresh.listen((token) {
        unawaited(registerCurrentDevice(fcmToken: token));
      });
    } catch (e, st) {
      debugPrint('PushRegistrationService: Firebase init failed: $e\n$st');
    }
  }

  /// На iOS FCM token доступен только после APNS token (реальный девайс, не симулятор).
  Future<void> _waitForApnsToken(FirebaseMessaging messaging) async {
    for (var attempt = 0; attempt < 40; attempt++) {
      final apns = await messaging.getAPNSToken();
      if (apns != null && apns.isNotEmpty) return;
      await Future<void>.delayed(const Duration(milliseconds: 500));
    }
    debugPrint(
      'PushRegistrationService: APNS token not ready (simulator, no permission, or no push capability)',
    );
  }

  Future<String?> resolveFcmToken({String? override}) async {
    if (override != null && override.isNotEmpty) return override;
    try {
      if (Firebase.apps.isEmpty) return null;
      final messaging = FirebaseMessaging.instance;
      if (Platform.isIOS) {
        await _waitForApnsToken(messaging);
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

  Future<int> _resolveBranchId() async {
    var branchId = ref.read(currentBranchIdProvider);
    if (branchId > 0) return branchId;

    final authBranchId = ref.read(branchesIdProvider);
    if (authBranchId > 0) return authBranchId;

    try {
      final branches = await ref.read(branchesProvider.future);
      final selectedBranch = ref.read(selectedBranchProvider);
      if (selectedBranch != null) return selectedBranch.id;
      if (branches.results.isNotEmpty) return branches.results.first.id;
    } catch (_) {}

    return 0;
  }

  bool _isDuplicateTokenError(Object error) {
    final caused = error is CustomException ? error.causedError : error;
    if (caused is! DioException || caused.response?.statusCode != 400) {
      return false;
    }
    final data = caused.response?.data;
    final text = data?.toString().toLowerCase() ?? '';
    return text.contains('token') &&
        (text.contains('существует') ||
            text.contains('exist') ||
            text.contains('already'));
  }

  Future<PushDeviceApi> _registerOrReclaimDevice({
    required RegisterPushDeviceRequest request,
    required int? storedApiId,
  }) async {
    final pushService = ref.read(mobilePushServiceProvider);

    try {
      return await pushService.registerDevice(request);
    } catch (e) {
      if (!_isDuplicateTokenError(e)) rethrow;

      debugPrint(
        'PushRegistrationService: FCM token already registered, reclaiming',
      );

      if (storedApiId != null) {
        try {
          final device = await pushService.updateDevice(
            id: storedApiId,
            body: request,
          );
          debugPrint(
            'PushRegistrationService: reclaimed device via PATCH id=$storedApiId',
          );
          return device;
        } catch (patchError) {
          debugPrint(
            'PushRegistrationService: PATCH reclaim failed: $patchError',
          );
        }
      }

      for (final reclaim in <Future<PushDeviceApi> Function()>[
        () => pushService.claimDevice(request),
        () => pushService.reactivateDevice(request),
      ]) {
        try {
          final device = await reclaim();
          debugPrint(
            'PushRegistrationService: reclaimed device via claim/reactivate',
          );
          return device;
        } catch (reclaimError) {
          debugPrint(
            'PushRegistrationService: reclaim attempt failed: $reclaimError',
          );
        }
      }

      try {
        await pushService.deactivateDevice(
          organizationId: request.organization,
          id: storedApiId,
          token: request.token,
          deviceId: request.deviceId,
        );
        debugPrint(
          'PushRegistrationService: deactivated old binding before re-register',
        );
      } catch (deactivateError) {
        debugPrint(
          'PushRegistrationService: deactivate before re-register failed: '
          '$deactivateError',
        );
      }

      return pushService.registerDevice(request);
    }
  }

  Future<void> registerCurrentDevice({
    String? fcmToken,
    bool? pushEnabled,
    bool isRetry = false,
    bool throwOnFailure = false,
  }) async {
    if (_registerInFlight != null) {
      await _registerInFlight;
      return;
    }

    final registration = _registerCurrentDeviceImpl(
      fcmToken: fcmToken,
      pushEnabled: pushEnabled,
      isRetry: isRetry,
      throwOnFailure: throwOnFailure,
    );
    _registerInFlight = registration;
    try {
      await registration;
    } finally {
      _registerInFlight = null;
    }
  }

  Future<void> _registerCurrentDeviceImpl({
    String? fcmToken,
    bool? pushEnabled,
    bool isRetry = false,
    bool throwOnFailure = false,
  }) async {
    if (!isRetry) {
      _registerRetryTimer?.cancel();
      _registerRetryTimer = null;
      _registerRetryAttempt = 0;
    }

    final organizationId = ref.read(organizationIdProvider);
    if (organizationId <= 0) {
      debugPrint(
        'PushRegistrationService: organization id missing, retry register',
      );
      _scheduleRegisterRetry();
      return;
    }

    final jwt = ref.read(tokenProvider);
    if (jwt == null || jwt.isEmpty) {
      debugPrint('PushRegistrationService: JWT missing, retry register');
      _scheduleRegisterRetry();
      return;
    }

    try {
      await ensureInitialized();

      if (!await NotificationPermissionService.hasGrantedPermission()) {
        debugPrint(
          'PushRegistrationService: notifications permission missing, retry register',
        );
        if (throwOnFailure) {
          throw StateError('notification_permission_missing');
        }
        _scheduleRegisterRetry();
        return;
      }

      final token = await resolveFcmToken(override: fcmToken);
      if (token == null || token.isEmpty) {
        debugPrint(
          'PushRegistrationService: FCM token unavailable, retry register',
        );
        if (throwOnFailure) {
          throw StateError('fcm_token_unavailable');
        }
        _scheduleRegisterRetry();
        return;
      }
      _registerRetryAttempt = 0;
      _registerRetryTimer?.cancel();
      debugPrint('FCM token: $token');

      final deviceStorage = ref.read(pushDeviceStorageProvider);
      final deviceId = await deviceStorage.getOrCreateDeviceId();
      final storedApiId = await deviceStorage.getRegisteredDeviceApiId();
      final branchId = await _resolveBranchId();
      final roleId = ref.read(roleProvider);
      if (roleId != UserRole.owner.value && branchId <= 0) {
        debugPrint(
          'PushRegistrationService: branch id missing for role=$roleId, retry register',
        );
        if (throwOnFailure) {
          throw StateError('branch_missing');
        }
        _scheduleRegisterRetry();
        return;
      }
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

      final request = RegisterPushDeviceRequest(
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
      );

      final device = await _registerOrReclaimDevice(
        request: request,
        storedApiId: storedApiId,
      );

      await deviceStorage.saveRegisteredDeviceApiId(device.id);
      debugPrint(
        'PushRegistrationService: registered device id=${device.id} '
        'active=${device.isActive} pushEnabled=${device.pushEnabled}',
      );
    } catch (e, st) {
      final caused = e is CustomException ? e.causedError : e;
      if (caused is DioException) {
        final status = caused.response?.statusCode;
        debugPrint(
          'PushRegistrationService: register HTTP $status '
          'body=${caused.response?.data}',
        );
      }
      debugPrint('PushRegistrationService: register failed: $e\n$st');
      if (throwOnFailure) rethrow;
      _scheduleRegisterRetry();
    }
  }

  void _scheduleRegisterRetry() {
    if (_registerRetryAttempt >= 8) return;
    _registerRetryTimer?.cancel();
    final delaySeconds = 2 * (_registerRetryAttempt + 1);
    _registerRetryAttempt++;
    _registerRetryTimer = Timer(Duration(seconds: delaySeconds), () {
      unawaited(registerCurrentDevice(isRetry: true));
    });
  }

  Future<void> deactivateCurrentDevice() async {
    cancelPendingRetries();

    final organizationId = ref.read(organizationIdProvider);
    if (organizationId <= 0) return;

    final jwt = ref.read(tokenProvider);
    if (jwt == null || jwt.isEmpty) return;

    final deviceStorage = ref.read(pushDeviceStorageProvider);
    try {
      final deviceId = await deviceStorage.getOrCreateDeviceId();
      final apiId = await deviceStorage.getRegisteredDeviceApiId();
      final fcmToken = await resolveFcmToken();

      await ref.read(mobilePushServiceProvider).deactivateDevice(
            organizationId: organizationId,
            id: apiId,
            token: fcmToken,
            deviceId: deviceId,
          );
      debugPrint('PushRegistrationService: device deactivated on logout');
    } catch (e, st) {
      debugPrint('PushRegistrationService: deactivate failed: $e\n$st');
    }
    // id записи на сервере сохраняем — нужен для PATCH/claim при следующем входе.
  }
}
