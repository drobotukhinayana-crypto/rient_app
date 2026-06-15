import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:rient_app/core/services/app_lock/app_lock_mode.dart';
import 'package:rient_app/core/services/local_storage.dart';

const appLockModeStorageKey = 'app_lock_mode_v1';
const _appLockPinSecureKey = 'app_lock_pin_v1';

final appLockServiceProvider = Provider<AppLockService>(
  (ref) => AppLockService(ref.watch(localStorageProvider)),
);

class AppLockService {
  AppLockService(this._storage);

  final LocalStorage _storage;
  final LocalAuthentication _localAuth = LocalAuthentication();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<AppLockMode?> getMode() async {
    final raw = await _storage.getString(appLockModeStorageKey);
    return AppLockModeStorage.fromStorage(raw);
  }

  Future<bool> isEnabled() async => (await getMode()) != null;

  Future<bool> shouldOfferSetup() async => !(await isEnabled());

  Future<bool> canUseBiometrics() async {
    if (kIsWeb) return false;
    try {
      if (!await _localAuth.isDeviceSupported()) return false;
      final enrolled = await _localAuth.getAvailableBiometrics();
      return enrolled.isNotEmpty;
    } on LocalAuthException {
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<String> biometricLabel() async {
    if (kIsWeb) return 'Биометрия';
    try {
      final types = await _localAuth.getAvailableBiometrics();
      if (types.contains(BiometricType.face)) {
        return 'Face ID';
      }
      if (types.contains(BiometricType.fingerprint)) {
        return Platform.isIOS ? 'Touch ID' : 'Отпечаток пальца';
      }
      if (types.contains(BiometricType.strong)) {
        // Android: отпечаток / сканер радужки.
        return Platform.isIOS ? 'Биометрия' : 'Отпечаток пальца';
      }
      if (types.contains(BiometricType.weak)) {
        // Android: распознавание лица.
        return Platform.isIOS ? 'Биометрия' : 'Распознавание лица';
      }
    } catch (_) {}
    return 'Биометрия';
  }

  Future<void> enableBiometric() async {
    final ok = await authenticateWithBiometrics(
      reason: 'Подтвердите включение блокировки приложения',
    );
    if (!ok) return;

    await _secureStorage.delete(key: _appLockPinSecureKey);
    await _storage.saveString(
      appLockModeStorageKey,
      AppLockMode.biometric.storageValue,
    );
  }

  Future<void> enablePin(String pin) async {
    final normalized = pin.trim();
    if (normalized.length < 4) {
      throw AppLockSetupException('PIN должен содержать минимум 4 цифры');
    }
    await _secureStorage.write(key: _appLockPinSecureKey, value: normalized);
    await _storage.saveString(
      appLockModeStorageKey,
      AppLockMode.pin.storageValue,
    );
  }

  Future<bool> verifyPin(String pin) async {
    final saved = await _secureStorage.read(key: _appLockPinSecureKey);
    if (saved == null || saved.isEmpty) return false;
    return saved == pin.trim();
  }

  /// `true` — успех, `false` — пользователь отменил. Ошибки — [AppLockSetupException].
  Future<bool> authenticateWithBiometrics({required String reason}) async {
    if (kIsWeb) return false;
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } on LocalAuthException catch (e) {
      switch (e.code) {
        case LocalAuthExceptionCode.userCanceled:
        case LocalAuthExceptionCode.systemCanceled:
          return false;
        case LocalAuthExceptionCode.noBiometricsEnrolled:
          throw AppLockSetupException(
            'На устройстве не настроена биометрия. '
            'Добавьте отпечаток или Face ID в настройках телефона.',
          );
        case LocalAuthExceptionCode.noBiometricHardware:
        case LocalAuthExceptionCode.uiUnavailable:
          throw AppLockSetupException(
            'Биометрия недоступна на этом устройстве',
          );
        case LocalAuthExceptionCode.temporaryLockout:
        case LocalAuthExceptionCode.biometricLockout:
          throw AppLockSetupException(
            'Слишком много попыток. Попробуйте позже или установите PIN-код',
          );
        case LocalAuthExceptionCode.timeout:
          return false;
        default:
          throw AppLockSetupException(
            await _failedToConfirmBiometricMessage(),
          );
      }
    } catch (e) {
      if (e is AppLockSetupException) rethrow;
      throw AppLockSetupException(await _failedToConfirmBiometricMessage());
    }
  }

  Future<String> _failedToConfirmBiometricMessage() async {
    final label = await biometricLabel();
    return switch (label) {
      'Отпечаток пальца' => 'Не удалось подтвердить отпечаток пальца',
      'Распознавание лица' => 'Не удалось подтвердить распознавание лица',
      'Touch ID' => 'Не удалось подтвердить Touch ID',
      _ => 'Не удалось подтвердить $label',
    };
  }

  Future<void> disable() async {
    await _secureStorage.delete(key: _appLockPinSecureKey);
    await _storage.removeValue(appLockModeStorageKey);
  }

  Future<void> clearAll() async {
    await disable();
  }
}

class AppLockSetupException implements Exception {
  AppLockSetupException(this.message);

  final String message;

  @override
  String toString() => message;
}
