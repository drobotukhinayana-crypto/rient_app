import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/services/unauthorized_handler.dart';
import 'package:rient_app/core/network/app_dio.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/schedule/data/models/available_workers_api/available_workers_api.dart';
import 'package:rient_app/features/schedule/data/models/workers_api/workers_api.dart';

final workersServiceProvider = Provider<WorkersService>(
  (ref) => WorkersService(ref),
);

class WorkersService {
  WorkersService(this.ref);

  final Ref ref;

  /// Загружает список рабочих (специалистов) для филиала.
  Future<WorkersApiResponse> getWorkers({
    required int branchId,
    int pageSize = 500,
    int page = 1,
    int withServices = 1,
    int withSchedules = 1,
  }) async {
    final organizationId = ref.read(organizationIdProvider);
    final token = ref.read(tokenProvider);

    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    final url = ApiConsts().createUrl('organizations/$organizationId/workers/');
    final queryParams = <String, dynamic>{
      'branches__id__in': branchId,
      'page_size': pageSize,
      'page': page,
      'with_services': withServices,
      'with_schedules': withSchedules,
    };

    try {
      final response = await createAppDio().get<Map<String, dynamic>>(
        url,
        queryParameters: queryParams,
        options: Options(headers: {'Authorization': 'JWT $token'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        return WorkersApiResponse.fromJson(response.data!);
      }
      throw CustomException(
        causedError: Exception(
          'Failed to load workers: ${response.statusCode}',
        ),
      );
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }

  /// Строка сотрудника из /workers/?with_schedules=1 (schedule_config, schedule_patterns).
  Future<Map<String, dynamic>?> getWorkerRow({
    required int workerId,
    required int branchId,
  }) async {
    final organizationId = ref.read(organizationIdProvider);
    final token = ref.read(tokenProvider);
    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    final url = ApiConsts().createUrl('organizations/$organizationId/workers/');
    try {
      final response = await createAppDio().get<Map<String, dynamic>>(
        url,
        queryParameters: {
          'branches__id__in': branchId,
          'page_size': 500,
          'page': 1,
          'with_services': 1,
          'with_schedules': 1,
        },
        options: Options(headers: {'Authorization': 'JWT $token'}),
      );
      final rows = (response.data?['results'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>();
      for (final row in rows) {
        final id = (row['id'] as num?)?.toInt();
        if (id == workerId) return row;
      }
      return null;
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }

  /// Строки сотрудников из /workers/?with_schedules=1 (schedule_config, schedule_patterns).
  Future<List<Map<String, dynamic>>> getWorkerRowsWithSchedules({
    required int branchId,
  }) async {
    final organizationId = ref.read(organizationIdProvider);
    final token = ref.read(tokenProvider);
    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    final url = ApiConsts().createUrl('organizations/$organizationId/workers/');
    try {
      final response = await createAppDio().get<Map<String, dynamic>>(
        url,
        queryParameters: {
          'branches__id__in': branchId,
          'page_size': 500,
          'page': 1,
          'with_services': 1,
          'with_schedules': 1,
        },
        options: Options(headers: {'Authorization': 'JWT $token'}),
      );
      return (response.data?['results'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .toList();
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }

  /// Загружает сотрудников, доступных в конкретный день.
  Future<List<AvailableWorkerShift>> getAvailableWorkers({
    required int branchId,
    required DateTime date,
  }) async {
    final organizationId = ref.read(organizationIdProvider);
    final token = ref.read(tokenProvider);

    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    final url = ApiConsts().createUrl(
      'organizations/$organizationId/branches/$branchId/available_workers/',
    );
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final dateQuery = normalizedDate.toUtc().toIso8601String();

    try {
      final response = await createAppDio().get<List<dynamic>>(
        url,
        queryParameters: {'date': dateQuery},
        options: Options(headers: {'Authorization': 'JWT $token'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data!
            .map(
              (e) => AvailableWorkerShift.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }
      throw CustomException(
        causedError: Exception(
          'Failed to load available workers: ${response.statusCode}',
        ),
      );
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }
}
