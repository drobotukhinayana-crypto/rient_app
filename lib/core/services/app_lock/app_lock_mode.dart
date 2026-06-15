enum AppLockMode {
  pin,
  biometric,
}

extension AppLockModeStorage on AppLockMode {
  String get storageValue => name;

  static AppLockMode? fromStorage(String? raw) {
    switch (raw) {
      case 'pin':
        return AppLockMode.pin;
      case 'biometric':
        return AppLockMode.biometric;
      default:
        return null;
    }
  }
}
