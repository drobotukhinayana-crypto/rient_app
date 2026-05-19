import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/services/unauthorized_handler.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';

final settingsServiceProvider = Provider<SettingsService>(
  (ref) => SettingsService(ref),
);

class SettingsService {
  SettingsService(this.ref);

  final Ref ref;

  Future<void> resetWorkerAccess({required int workerId}) async {
    await _postAction(
      path: 'organizations/{orgId}/workers/$workerId/reset_access/',
      errorLabel: 'reset worker access',
    );
  }

  Future<void> resetWorkersAccess({required List<int> workerIds}) async {
    for (final id in workerIds) {
      await resetWorkerAccess(workerId: id);
    }
  }

  Future<void> prohibitOnlineBooking({required int workerId}) async {
    await _postAction(
      path: 'organizations/{orgId}/workers/$workerId/prohibit_online_booking/',
      errorLabel: 'prohibit online booking',
    );
  }

  Future<void> prohibitOnlineBookingForWorkers({
    required List<int> workerIds,
  }) async {
    for (final id in workerIds) {
      await prohibitOnlineBooking(workerId: id);
    }
  }

  Future<void> _postAction({
    required String path,
    required String errorLabel,
  }) async {
    final organizationId = ref.read(organizationIdProvider);
    final token = ref.read(tokenProvider);

    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    final resolvedPath = path.replaceFirst('{orgId}', '$organizationId');
    final url = ApiConsts().createUrl(resolvedPath);

    try {
      final response = await Dio().post<dynamic>(
        url,
        options: Options(
          headers: {
            'Authorization': 'JWT $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      final code = response.statusCode ?? 0;
      if (code == 200 || code == 201 || code == 204) {
        return;
      }
      throw CustomException(
        causedError: Exception('Failed to $errorLabel: $code'),
      );
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }
}
