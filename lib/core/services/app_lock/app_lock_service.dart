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
      final supported = await _localAuth.isDeviceSupported();
      if (!supported) return false;
      return await _localAuth.canCheckBiometrics ||
          await _localAuth.isDeviceSupported();
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
        return 'Отпечаток пальца';
      }
      if (types.contains(BiometricType.strong) ||
          types.contains(BiometricType.weak)) {
        return 'Биометрия';
      }
    } catch (_) {}
    return 'Биометрия';
  }

  Future<void> enableBiometric() async {
    final ok = await authenticateWithBiometrics(
      reason: 'Подтвердите включение блокировки приложения',
    );
    if (!ok) {
      throw AppLockSetupException('Не удалось подтвердить биометрию');
    }
    await _secureStorage.delete(key: _appLockPinSecureKey);
    await _storage.saveString(appLockModeStorageKey, AppLockMode.biometric.storageValue);
  }

  Future<void> enablePin(String pin) async {
    final normalized = pin.trim();
    if (normalized.length < 4) {
      throw AppLockSetupException('PIN должен содержать минимум 4 цифры');
    }
    await _secureStorage.write(key: _appLockPinSecureKey, value: normalized);
    await _storage.saveString(appLockModeStorageKey, AppLockMode.pin.storageValue);
  }

  Future<bool> verifyPin(String pin) async {
    final saved = await _secureStorage.read(key: _appLockPinSecureKey);
    if (saved == null || saved.isEmpty) return false;
    return saved == pin.trim();
  }

  Future<bool> authenticateWithBiometrics({required String reason}) async {
    if (kIsWeb) return false;
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } on LocalAuthException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
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
