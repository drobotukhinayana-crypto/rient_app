import 'package:flutter/foundation.dart';
import 'package:screen_protector/screen_protector.dart';

/// Блокировка скриншотов и записи экрана (FLAG_SECURE на Android).
class ScreenshotProtectionService {
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
}
