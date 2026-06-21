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

Future<void> setPushEnabled(WidgetRef ref, bool enabled) async {
  final deviceStorage = ref.read(pushDeviceStorageProvider);
  final deviceId = await deviceStorage.getOrCreateDeviceId();
  final pushService = ref.read(mobilePushServiceProvider);
  final registration = ref.read(pushRegistrationServiceProvider);

  String? fcmToken;
  if (enabled) {
    if (!await NotificationPermissionService.hasGrantedPermission()) {
      throw StateError('notification_permission_missing');
    }
    fcmToken = await registration.resolveFcmToken();
    await registration.registerCurrentDevice(
      fcmToken: fcmToken,
      pushEnabled: true,
      throwOnFailure: true,
    );
  } else {
    fcmToken = await registration.resolveFcmToken();
  }

  var apiId = await _resolveDeviceRecordId(ref, deviceId);

  if (enabled) {
    apiId ??= await deviceStorage.getRegisteredDeviceApiId();
  } else {
    await registration.registerCurrentDevice(
      fcmToken: fcmToken,
      pushEnabled: false,
    );
    apiId ??= await deviceStorage.getRegisteredDeviceApiId();
  }

  await pushService.updatePushSettings(
    pushEnabled: enabled,
    deviceRecordId: apiId,
    deviceId: deviceId,
    fcmToken: fcmToken,
  );

  invalidatePushSettings(ref);
}

void invalidatePushSettings(WidgetRef ref) {
  ref.invalidate(pushSettingsDevicesProvider);
  ref.invalidate(currentPushSettingsDeviceProvider);
}
