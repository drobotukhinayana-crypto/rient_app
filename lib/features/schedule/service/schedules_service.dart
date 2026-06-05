import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/services/unauthorized_handler.dart';
import 'package:rient_app/core/network/app_dio.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/schedule/data/models/schedules_api/create_worker_schedule_request.dart';
import 'package:rient_app/features/schedule/data/models/schedules_api/schedules_api.dart';

final schedulesServiceProvider = Provider<SchedulesService>(
  (ref) => SchedulesService(ref),
);

class SchedulesService {
  SchedulesService(this.ref);

  final Ref ref;

  /// API расписаний ожидает даты в формате YYYY-MM-DD.
  static String dateToApi(DateTime date) {
    final y = date.year;
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Future<SchedulesApiResponse> getSchedules({
    required int branchId,
    required DateTime dateGte,
    required DateTime dateLte,
    int pageSize = 500,
    bool bustCache = false,
  }) async {
    final organizationId = ref.read(organizationIdProvider);
    final token = ref.read(tokenProvider);

    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    final url = ApiConsts().createUrl(
      'organizations/$organizationId/schedules/',
    );
    final queryParams = <String, dynamic>{
      'date__gte': dateToApi(dateGte),
      'date__lte': dateToApi(dateLte),
      'page_size': pageSize,
      'branch': branchId,
      if (bustCache) '_': DateTime.now().millisecondsSinceEpoch,
    };

    try {
      final response = await createAppDio().get<Map<String, dynamic>>(
        url,
        queryParameters: queryParams,
        options: Options(
          headers: {
            'Authorization': 'JWT $token',
            if (bustCache) 'Cache-Control': 'no-cache',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return SchedulesApiResponse.fromJson(response.data!);
      }
      throw CustomException(
        causedError: Exception(
          'Failed to load schedules: ${response.statusCode}',
        ),
      );
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }

  /// Дневные записи графика сотрудника за период.
  /// GET /organizations/{id}/workers/{worker_id}/schedules/
  Future<SchedulesApiResponse> getWorkerSchedules({
    required int workerId,
    required DateTime dateGte,
    required DateTime dateLte,
    int pageSize = 500,
    bool bustCache = false,
  }) async {
    final organizationId = ref.read(organizationIdProvider);
    final token = ref.read(tokenProvider);

    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    final url = ApiConsts().createUrl(
      'organizations/$organizationId/workers/$workerId/schedules/',
    );
    final queryParams = <String, dynamic>{
      'date__gte': dateToApi(dateGte),
      'date__lte': dateToApi(dateLte),
      'page_size': pageSize,
      if (bustCache) '_': DateTime.now().millisecondsSinceEpoch,
    };

    try {
      final response = await createAppDio().get<Map<String, dynamic>>(
        url,
        queryParameters: queryParams,
        options: Options(
          headers: {
            'Authorization': 'JWT $token',
            if (bustCache) 'Cache-Control': 'no-cache',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return SchedulesApiResponse.fromJson(response.data!);
      }
      throw CustomException(
        causedError: Exception(
          'Failed to load worker schedules: ${response.statusCode}',
        ),
      );
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }

  /// Создать (или перезаписать) дневной график сотрудника.
  /// POST /organizations/{id}/workers/{worker_id}/schedules/
  Future<ScheduleItemApi> createWorkerSchedule({
    required int workerId,
    required CreateWorkerScheduleRequest body,
  }) async {
    final organizationId = ref.read(organizationIdProvider);
    final token = ref.read(tokenProvider);

    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    final url = ApiConsts().createUrl(
      'organizations/$organizationId/workers/$workerId/schedules/',
    );

    try {
      final response = await createAppDio().post<Map<String, dynamic>>(
        url,
        data: body.toJson(),
        options: Options(
          headers: {
            'Authorization': 'JWT $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201 && response.data != null) {
        return ScheduleItemApi.fromJson(response.data!);
      }
      throw CustomException(
        causedError: Exception(
          'Failed to create worker schedule: ${response.statusCode}',
        ),
      );
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }

  /// Обновить дневной график сотрудника.
  /// PATCH /organizations/{id}/workers/{worker_id}/schedules/{schedule_id}/
  Future<ScheduleItemApi> updateWorkerSchedule({
    required int workerId,
    required int scheduleId,
    required CreateWorkerScheduleRequest body,
  }) async {
    final organizationId = ref.read(organizationIdProvider);
    final token = ref.read(tokenProvider);

    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    final url = ApiConsts().createUrl(
      'organizations/$organizationId/workers/$workerId/schedules/$scheduleId/',
    );

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
        return ScheduleItemApi.fromJson(response.data!);
      }
      throw CustomException(
        causedError: Exception(
          'Failed to update worker schedule: ${response.statusCode}',
        ),
      );
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }
}
