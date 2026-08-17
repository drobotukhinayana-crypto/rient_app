import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/home/service/organization_settings_service.dart';

/// Настройки организации из GET /accounts/ → organization.settings.
final organizationSettingsProvider =
    FutureProvider<OrganizationSettings>((ref) async {
  return ref.watch(organizationSettingsServiceProvider).getSettings();
});

/// Можно ли создавать записи задним числом (`allow_backdated_appointments`).
final allowBackdatedAppointmentsProvider = Provider<bool>((ref) {
  return ref.watch(organizationSettingsProvider).maybeWhen(
        data: (settings) => settings.allowBackdatedAppointments,
        orElse: () => true,
      );
});

/// Организация заблокирована (`organization.is_blocked` из GET /accounts/).
final organizationIsBlockedProvider = Provider<bool>((ref) {
  return ref.watch(organizationSettingsProvider).maybeWhen(
        data: (settings) => settings.isBlocked,
        orElse: () => false,
      );
});
