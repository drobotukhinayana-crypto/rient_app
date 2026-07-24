import 'package:dio/dio.dart';
import 'package:rient_app/core/network/app_dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/services/unauthorized_handler.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/schedule/data/models/worker_schedule_config_api/update_worker_schedule_config_request.dart';
import 'package:rient_app/features/schedule/data/models/worker_schedule_config_api/worker_schedule_config_api.dart';

final workerScheduleConfigsServiceProvider =
    Provider<WorkerScheduleConfigsService>(
  (ref) => WorkerScheduleConfigsService(ref),
);

class WorkerScheduleConfigsService {
  WorkerScheduleConfigsService(this.ref);

  final Ref ref;

  Future<WorkerScheduleConfigApi> _patchScheduleConfig({
    required String url,
    required UpdateWorkerScheduleConfigRequest body,
    required String errorLabel,
  }) async {
    final token = ref.read(tokenProvider);

    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    if (body.toJson().isEmpty) {
      throw CustomException(
        causedError: Exception('At least one field must be provided'),
      );
    }

    try {
      final response = await createAppDio().patch<Map<String, dynamic>>(
        url,
        data: body.toJson(),
        options: Options(
          headers: {
            'Authorization': 'JWT $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return WorkerScheduleConfigApi.fromJson(response.data!);
      }
      throw CustomException(
        causedError: Exception('$errorLabel: ${response.statusCode}'),
      );
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }

  /// Self-service: PATCH своего конфига в текущем филиале.
  /// PATCH /organizations/{id}/me/schedule-config/
  Future<WorkerScheduleConfigApi> updateMyScheduleConfig({
    required UpdateWorkerScheduleConfigRequest body,
  }) async {
    final organizationId = ref.read(organizationIdProvider);
    final url = ApiConsts().createUrl(
      'organizations/$organizationId/me/schedule-config/',
    );
    return _patchScheduleConfig(
      url: url,
      body: body,
      errorLabel: 'Failed to update my schedule config',
    );
  }

  /// PATCH /organizations/{id}/workers/{worker_id}/schedule_configs/{config_uuid}/
  Future<WorkerScheduleConfigApi> updateWorkerScheduleConfig({
    required int workerId,
    required String configUuid,
    required UpdateWorkerScheduleConfigRequest body,
  }) async {
    final organizationId = ref.read(organizationIdProvider);
    final url = ApiConsts().createUrl(
      'organizations/$organizationId/workers/$workerId/schedule_configs/$configUuid/',
    );
    return _patchScheduleConfig(
      url: url,
      body: body,
      errorLabel: 'Failed to update worker schedule config',
    );
  }
}
