import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/services/unauthorized_handler.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/schedule/data/models/schedule_patterns_api/schedule_patterns_api.dart';
import 'package:rient_app/features/schedule/data/models/schedule_patterns_branch_api/schedule_patterns_branch_api.dart';
import 'package:rient_app/features/schedule/data/models/schedule_patterns_branch_api/update_branch_schedule_patterns_request.dart';

final schedulePatternsServiceProvider = Provider<SchedulePatternsService>(
  (ref) => SchedulePatternsService(ref),
);

class SchedulePatternsService {
  SchedulePatternsService(this.ref);

  final Ref ref;

  /// GET /organizations/{id}/schedule_patterns/
  Future<SchedulePatternsApiResponse> getSchedulePatterns({
    required int branchId,
    int? workerId,
    int pageSize = 500,
  }) async {
    final organizationId = ref.read(organizationIdProvider);
    final token = ref.read(tokenProvider);

    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    final url = ApiConsts().createUrl(
      'organizations/$organizationId/schedule_patterns/',
    );
    final queryParams = <String, dynamic>{
      'branch__id__in': branchId.toString(),
      'page_size': pageSize,
      if (workerId != null) 'worker__id': workerId,
    };

    try {
      final response = await Dio().get<Map<String, dynamic>>(
        url,
        queryParameters: queryParams,
        options: Options(headers: {'Authorization': 'JWT $token'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        return SchedulePatternsApiResponse.fromJson(response.data!);
      }
      throw CustomException(
        causedError: Exception(
          'Failed to load schedule patterns: ${response.statusCode}',
        ),
      );
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }

  /// GET /organizations/{id}/schedule_patterns_branch/
  Future<SchedulePatternsBranchApiResponse> getBranchSchedulePatterns({
    int? branchId,
    int pageSize = 500,
  }) async {
    final organizationId = ref.read(organizationIdProvider);
    final token = ref.read(tokenProvider);

    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    final url = ApiConsts().createUrl(
      'organizations/$organizationId/schedule_patterns_branch/',
    );
    final queryParams = <String, dynamic>{
      'page_size': pageSize,
      if (branchId != null) 'branch__id': branchId,
    };

    try {
      final response = await Dio().get<Map<String, dynamic>>(
        url,
        queryParameters: queryParams,
        options: Options(headers: {'Authorization': 'JWT $token'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        return SchedulePatternsBranchApiResponse.fromJson(response.data!);
      }
      throw CustomException(
        causedError: Exception(
          'Failed to load branch schedule patterns: ${response.statusCode}',
        ),
      );
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }

  /// Пакетное обновление шаблонов графика филиала.
  /// POST /organizations/{id}/branches/{branch_id}/patterns/
  Future<void> updateBranchSchedulePatternsBatch({
    required int branchId,
    required UpdateBranchSchedulePatternsRequest body,
  }) async {
    final organizationId = ref.read(organizationIdProvider);
    final token = ref.read(tokenProvider);

    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    if (body.patterns.isEmpty) {
      throw CustomException(
        causedError: Exception('patterns must not be empty'),
      );
    }

    final url = ApiConsts().createUrl(
      'organizations/$organizationId/branches/$branchId/patterns/',
    );

    try {
      final response = await Dio().post<dynamic>(
        url,
        data: body.toJson(),
        options: Options(
          headers: {
            'Authorization': 'JWT $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return;
      }
      throw CustomException(
        causedError: Exception(
          'Failed to update branch schedule patterns: ${response.statusCode}',
        ),
      );
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }

  /// Пакетное обновление шаблонов графика сотрудника.
  /// POST /organizations/{id}/workers/{worker_id}/patterns/
  Future<void> updateWorkerSchedulePatternsBatch({
    required int workerId,
    required UpdateBranchSchedulePatternsRequest body,
  }) async {
    final organizationId = ref.read(organizationIdProvider);
    final token = ref.read(tokenProvider);

    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    if (body.patterns.isEmpty) {
      throw CustomException(
        causedError: Exception('patterns must not be empty'),
      );
    }

    final url = ApiConsts().createUrl(
      'organizations/$organizationId/workers/$workerId/patterns/',
    );

    try {
      final response = await Dio().post<dynamic>(
        url,
        data: body.toJson(),
        options: Options(
          headers: {
            'Authorization': 'JWT $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        return;
      }
      throw CustomException(
        causedError: Exception(
          'Failed to update worker schedule patterns: ${response.statusCode}',
        ),
      );
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }
}
