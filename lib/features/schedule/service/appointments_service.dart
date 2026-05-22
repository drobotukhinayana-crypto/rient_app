import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/services/unauthorized_handler.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/features/schedule/data/models/appointments_api/appointments_api.dart';

final appointmentsServiceProvider = Provider<AppointmentsService>(
  (ref) => AppointmentsService(ref),
);

class AppointmentsService {
  AppointmentsService(this.ref);

  final Ref ref;

  Future<AppointmentApi?> getAppointmentById(int appointmentId) async {
    final token = ref.read(tokenProvider);
    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    final url = ApiConsts().createUrl('appointments/$appointmentId/');

    try {
      final response = await Dio().get<Map<String, dynamic>>(
        url,
        options: Options(headers: {'Authorization': 'JWT $token'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        return AppointmentApi.fromJson(response.data!);
      }
      return null;
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }

  Future<AppointmentsApiResponse> getAppointments({
    required int branchId,
    required int workerId,
    required DateTime dateTimeGte,
    required DateTime dateTimeLte,
    int pageSize = 312,
    bool more = false,
  }) async {
    final token = ref.read(tokenProvider);
    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    final url = ApiConsts().createUrl('appointments/');
    final queryParams = <String, dynamic>{
      'branch': branchId,
      'worker': workerId,
      'datetime__gte': dateTimeGte.toUtc().toIso8601String(),
      'datetime__lte': dateTimeLte.toUtc().toIso8601String(),
      'page_size': pageSize,
      'more': more,
    };

    try {
      final response = await Dio().get<Map<String, dynamic>>(
        url,
        queryParameters: queryParams,
        options: Options(headers: {'Authorization': 'JWT $token'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        return AppointmentsApiResponse.fromJson(response.data!);
      }
      throw CustomException(
        causedError: Exception(
          'Failed to load appointments: ${response.statusCode}',
        ),
      );
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }

  Future<void> deleteAppointment({
    required int appointmentId,
    String captcha = 'dummy',
  }) async {
    final token = ref.read(tokenProvider);
    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    final url = ApiConsts().createUrl('appointments/$appointmentId/');

    try {
      final response = await Dio().delete<void>(
        url,
        queryParameters: {'captcha': captcha},
        options: Options(headers: {'Authorization': 'JWT $token'}),
      );
      if (response.statusCode == 204 || response.statusCode == 200) {
        return;
      }
      throw CustomException(
        causedError: Exception(
          'Failed to delete appointment: ${response.statusCode}',
        ),
      );
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }

  Future<List<Map<String, dynamic>>> createAppointment({
    required Map<String, dynamic> payload,
  }) async {
    final token = ref.read(tokenProvider);
    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    final url = ApiConsts().createUrl('appointments/');

    try {
      final response = await Dio().post<dynamic>(
        url,
        data: payload,
        options: Options(
          headers: {
            'Authorization': 'JWT $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if ((response.statusCode == 201 || response.statusCode == 200) &&
          response.data != null) {
        final raw = response.data;
        if (raw is List<dynamic>) {
          return raw
              .whereType<Map<String, dynamic>>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
        }
        if (raw is Map<String, dynamic>) {
          return [Map<String, dynamic>.from(raw)];
        }
      }
      throw CustomException(
        causedError: Exception(
          'Failed to create appointment: ${response.statusCode}',
        ),
      );
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }

  Future<Map<String, dynamic>> updateAppointment({
    required int appointmentId,
    required Map<String, dynamic> payload,
  }) async {
    final token = ref.read(tokenProvider);
    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    final url = ApiConsts().createUrl('appointments/$appointmentId/');

    try {
      final response = await Dio().patch<Map<String, dynamic>>(
        url,
        data: payload,
        options: Options(
          headers: {
            'Authorization': 'JWT $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        return Map<String, dynamic>.from(response.data!);
      }
      throw CustomException(
        causedError: Exception(
          'Failed to update appointment: ${response.statusCode}',
        ),
      );
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }
}
