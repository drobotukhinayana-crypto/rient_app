import 'package:flutter/foundation.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';
import 'package:screen_protector/screen_protector.dart';

/// Блокировка скриншотов и записи экрана (FLAG_SECURE на Android).
class ScreenshotProtectionService {
  static Future<void> applyForRole(int roleId) async {
    if (roleId == UserRole.owner.value) {
      await disable();
    } else {
      await enable();
    }
  }

  static Future<void> enable() async {
    if (kIsWeb) return;
    try {
      await ScreenProtector.preventScreenshotOn();
      if (defaultTargetPlatform == TargetPlatform.android) {
        await ScreenProtector.protectDataLeakageOn();
      }
    } catch (_) {
      // Плагин недоступен на этой платформе.
    }
  }

  static Future<void> disable() async {
    if (kIsWeb) return;
    try {
      await ScreenProtector.preventScreenshotOff();
      if (defaultTargetPlatform == TargetPlatform.android) {
        await ScreenProtector.protectDataLeakageOff();
      }
    } catch (_) {
      // Плагин недоступен на этой платформе.
    }
  }
}
