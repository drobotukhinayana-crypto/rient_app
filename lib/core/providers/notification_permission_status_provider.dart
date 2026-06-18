import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/notification_permission_service.dart';

final notificationPermissionStatusProvider =
    FutureProvider<AppNotificationPermissionStatus>((ref) {
  return NotificationPermissionService.getStatus();
});

void invalidateNotificationPermissionStatus(WidgetRef ref) {
  ref.invalidate(notificationPermissionStatusProvider);
}
