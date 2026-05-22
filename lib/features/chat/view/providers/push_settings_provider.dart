import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  return devices.isNotEmpty ? devices.first : null;
});

Future<void> setPushEnabled(WidgetRef ref, bool enabled) async {
  final deviceStorage = ref.read(pushDeviceStorageProvider);
  final deviceId = await deviceStorage.getOrCreateDeviceId();
  final settingsDevice = await ref.read(currentPushSettingsDeviceProvider.future);
  final apiId =
      settingsDevice?.id ?? await deviceStorage.getRegisteredDeviceApiId();

  await ref.read(mobilePushServiceProvider).updatePushSettings(
        pushEnabled: enabled,
        deviceRecordId: apiId,
        deviceId: deviceId,
      );

  invalidatePushSettings(ref);

  if (enabled) {
    await ref.read(pushRegistrationServiceProvider).registerCurrentDevice(
          pushEnabled: true,
        );
  }
}

void invalidatePushSettings(WidgetRef ref) {
  ref.invalidate(pushSettingsDevicesProvider);
  ref.invalidate(currentPushSettingsDeviceProvider);
}
