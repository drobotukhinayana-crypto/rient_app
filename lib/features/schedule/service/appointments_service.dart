import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/services/unauthorized_handler.dart';
import 'package:rient_app/core/network/app_dio.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/core/providers/branch_timezone_provider.dart';
import 'package:rient_app/features/schedule/data/models/appointments_api/appointments_api.dart';
import 'package:rient_app/features/schedule/utils/appointment_inventory_conflict_utils.dart';
import 'package:rient_app/features/schedule/utils/appointment_transaction_utils.dart';

final appointmentsServiceProvider = Provider<AppointmentsService>(
  (ref) => AppointmentsService(ref),
);

class AppointmentsService {
  AppointmentsService(this.ref);

  final Ref ref;

  Future<Map<String, dynamic>?> getAppointmentJson(int appointmentId) async {
    final token = ref.read(tokenProvider);
    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    final url = ApiConsts().createUrl('appointments/$appointmentId/');

    try {
      final response = await createAppDio().get<Map<String, dynamic>>(
        url,
        options: Options(headers: {'Authorization': 'JWT $token'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        return Map<String, dynamic>.from(response.data!);
      }
      return null;
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }

  Future<AppointmentApi?> getAppointmentById(int appointmentId) async {
    final token = ref.read(tokenProvider);
    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    final url = ApiConsts().createUrl('appointments/$appointmentId/');

    try {
      final response = await createAppDio().get<Map<String, dynamic>>(
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

    final branchTz = ref.read(branchTimezoneProvider);
    final url = ApiConsts().createUrl('appointments/');
    final queryParams = <String, dynamic>{
      'branch': branchId,
      'worker': workerId,
      'datetime__gte': branchTz.formatApiDayStart(dateTimeGte),
      'datetime__lte': branchTz.formatApiDayEndWithSeconds(dateTimeLte),
      'page_size': pageSize,
      'more': more,
    };

    try {
      final response = await createAppDio().get<Map<String, dynamic>>(
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
      final response = await createAppDio().delete<void>(
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
    bool createAnyway = false,
  }) async {
    final token = ref.read(tokenProvider);
    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    final url = ApiConsts().createUrl('appointments/');
    final body = withInventoryConflictOverride(
      payload,
      createAnyway: createAnyway,
    );

    try {
      final response = await createAppDio().post<dynamic>(
        url,
        data: body,
        options: Options(
          headers: {
            'Authorization': 'JWT $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      final raw = response.data;
      if (raw != null) {
        _throwIfInventoryConflictResponse(
          raw,
          createAnyway: createAnyway,
        );
      }

      if ((response.statusCode == 201 || response.statusCode == 200) &&
          raw != null) {
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
        causedError: DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: 'Failed to create appointment: ${response.statusCode}',
        ),
      );
    } catch (e) {
      if (e is AppointmentInventoryConflictException) rethrow;
      if (e is DioException) {
        await handleUnauthorizedIfNeeded(ref, e);
        _throwIfInventoryConflictResponse(
          e.response?.data,
          createAnyway: createAnyway,
        );
      }
      throw CustomException(causedError: e);
    }
  }

  Future<Map<String, dynamic>> updateAppointment({
    required int appointmentId,
    required Map<String, dynamic> payload,
    bool createAnyway = false,
  }) async {
    final token = ref.read(tokenProvider);
    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    final url = ApiConsts().createUrl('appointments/$appointmentId/');
    final body = withInventoryConflictOverride(
      payload,
      createAnyway: createAnyway,
    );

    try {
      final response = await createAppDio().patch<Map<String, dynamic>>(
        url,
        data: body,
        options: Options(
          headers: {
            'Authorization': 'JWT $token',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status != null && status < 500,
        ),
      );

      final raw = response.data;
      if (raw != null) {
        _throwIfInventoryConflictResponse(
          raw,
          createAnyway: createAnyway,
        );
      }

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          raw != null) {
        return Map<String, dynamic>.from(raw);
      }
      final apiMessage = formatApiErrorResponse(response.data) ??
          'Failed to update appointment: ${response.statusCode}';
      throw CustomException(
        message: apiMessage,
        causedError: DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          message: apiMessage,
        ),
      );
    } catch (e) {
      if (e is AppointmentInventoryConflictException) rethrow;
      if (e is CustomException) rethrow;
      if (e is DioException) {
        await handleUnauthorizedIfNeeded(ref, e);
        _throwIfInventoryConflictResponse(
          e.response?.data,
          createAnyway: createAnyway,
        );
      }
      throw CustomException(causedError: e);
    }
  }

  void _throwIfInventoryConflictResponse(
    dynamic data, {
    required bool createAnyway,
  }) {
    if (createAnyway) return;
    final conflict = appointmentInventoryConflictFromApiData(data);
    if (conflict != null) throw conflict;
  }

  /// POST /appointments/{id}/transactions/ — провести оплату (как на сайте).
  Future<Map<String, dynamic>> payAppointmentTransaction({
    required int appointmentId,
    required int price,
    String paymentMethod = 'cash',
    String captcha = AppointmentTransactionUtils.mobileCaptcha,
  }) async {
    final token = ref.read(tokenProvider);
    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    final payload = AppointmentTransactionUtils.buildMobilePayPostBody(
      price: price,
      paymentMethod: paymentMethod,
      captcha: captcha,
    );

    final url = ApiConsts().createUrl(
      'appointments/$appointmentId/transactions/',
    );

    try {
      final response = await createAppDio().post<Map<String, dynamic>>(
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
          'Failed to pay appointment: ${response.statusCode}',
        ),
      );
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }
}
