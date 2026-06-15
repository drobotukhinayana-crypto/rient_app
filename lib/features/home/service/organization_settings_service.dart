import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/network/app_dio.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/services/unauthorized_handler.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';

final organizationSettingsServiceProvider =
    Provider<OrganizationSettingsService>((ref) {
  return OrganizationSettingsService(ref);
});

class OrganizationSettings {
  const OrganizationSettings({
    required this.allowBackdatedAppointments,
  });

  /// `organization.settings.allow_backdated_appointments` из GET /accounts/.
  final bool allowBackdatedAppointments;

  static const defaults = OrganizationSettings(
    allowBackdatedAppointments: true,
  );
}

class OrganizationSettingsService {
  OrganizationSettingsService(this.ref);

  final Ref ref;

  /// GET /accounts/ → organization.settings.allow_backdated_appointments
  Future<OrganizationSettings> getSettings() async {
    final token = ref.read(tokenProvider);
    if (token == null || token.isEmpty) {
      return OrganizationSettings.defaults;
    }

    final url = ApiConsts().createUrl('accounts/');

    try {
      final response = await createAppDio().get<dynamic>(
        url,
        options: Options(headers: {'Authorization': 'JWT $token'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final raw = _extractAllowBackdatedAppointmentsFromAccounts(response.data);
        return OrganizationSettings(
          allowBackdatedAppointments: _boolFrom(raw, fallback: true),
        );
      }
      return OrganizationSettings.defaults;
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      return OrganizationSettings.defaults;
    }
  }
}

dynamic _extractAllowBackdatedAppointmentsFromAccounts(dynamic data) {
  if (data is! Map) return null;

  final organization = data['organization'];
  if (organization is! Map) return null;

  final settings = organization['settings'];
  if (settings is! Map) return null;

  final settingsMap = settings.map((key, value) => MapEntry(key.toString(), value));
  if (!settingsMap.containsKey('allow_backdated_appointments')) return null;
  return settingsMap['allow_backdated_appointments'];
}

bool _boolFrom(dynamic raw, {required bool fallback}) {
  if (raw is bool) return raw;
  if (raw is num) return raw != 0;
  if (raw is String) {
    final value = raw.trim().toLowerCase();
    if (value == 'true' || value == '1') return true;
    if (value == 'false' || value == '0') return false;
  }
  return fallback;
}
