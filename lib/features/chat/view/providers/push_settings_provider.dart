import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/notification_permission_service.dart';
import 'package:rient_app/core/services/push_device_storage.dart';
import 'package:rient_app/features/chat/data/models/push_settings_api/push_settings_api.dart';
import 'package:rient_app/features/chat/service/mobile_push_service.dart';
import 'package:rient_app/features/chat/service/push_registration_service.dart';

final pushSettingsDevicesProvider =
    FutureProvider<List<PushSettingsDeviceApi>>((ref) async {
  final service = ref.watch(mobilePushServiceProvider);
  return service.getPushSettings();
});

/// Текущее устройство в списке настроек (по device_id из локального хранилища).
final currentPushSettingsDeviceProvider =
    FutureProvider<PushSettingsDeviceApi?>((ref) async {
  final devices = await ref.watch(pushSettingsDevicesProvider.future);
  final deviceId = await ref.read(pushDeviceStorageProvider).getOrCreateDeviceId();
  for (final device in devices) {
    if (device.deviceId == deviceId) return device;
  }
  return null;
});

Future<int?> _resolveDeviceRecordId(WidgetRef ref, String deviceId) async {
  final deviceStorage = ref.read(pushDeviceStorageProvider);
  final settingsDevice = await ref.read(currentPushSettingsDeviceProvider.future);
  return settingsDevice?.id ?? await deviceStorage.getRegisteredDeviceApiId();
}

Future<void> syncPushSettingsWithSystemPermission(WidgetRef ref) async {
  final deviceStorage = ref.read(pushDeviceStorageProvider);
  final deviceId = await deviceStorage.getOrCreateDeviceId();
  final pushService = ref.read(mobilePushServiceProvider);
  final registration = ref.read(pushRegistrationServiceProvider);
  final granted = await NotificationPermissionService.hasGrantedPermission();

  String? fcmToken;
  if (granted) {
    await registration.registerForActiveSession();
    fcmToken = await registration.resolveFcmToken();
  } else {
    fcmToken = await registration.resolveFcmToken();
  }

  var apiId = await _resolveDeviceRecordId(ref, deviceId);
  apiId ??= await deviceStorage.getRegisteredDeviceApiId();

  if (apiId == null && fcmToken == null) {
    invalidatePushSettings(ref);
    return;
  }

  try {
    await pushService.updatePushSettings(
      pushEnabled: granted,
      deviceRecordId: apiId,
      deviceId: deviceId,
      fcmToken: fcmToken,
    );
  } catch (_) {}

  invalidatePushSettings(ref);
}

void invalidatePushSettings(WidgetRef ref) {
  ref.invalidate(pushSettingsDevicesProvider);
  ref.invalidate(currentPushSettingsDeviceProvider);
}
