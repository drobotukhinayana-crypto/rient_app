import 'package:dio/dio.dart';
import 'package:rient_app/core/network/app_dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/services/unauthorized_handler.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/chat/data/models/push_device_api/push_device_api.dart';
import 'package:rient_app/features/chat/data/models/push_history_api/push_history_api.dart';
import 'package:rient_app/features/chat/data/models/push_history_count/push_history_count.dart';
import 'package:rient_app/features/chat/data/models/push_settings_api/push_settings_api.dart';

final mobilePushServiceProvider = Provider<MobilePushService>(
  (ref) => MobilePushService(ref),
);

class MobilePushService {
  MobilePushService(this.ref);

  final Ref ref;

  int get _organizationId => ref.read(organizationIdProvider);

  Future<Map<String, String>> _authHeaders() async {
    final token = ref.read(tokenProvider);
    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }
    return {'Authorization': 'JWT $token'};
  }

  Future<PushHistoryApiResponse> getHistory({
    required bool isRead,
    int? branchId,
    DateTime? datetimeGte,
    DateTime? datetimeLte,
    int page = 1,
    int pageSize = 20,
  }) async {
    final organizationId = _organizationId;
    if (organizationId <= 0) {
      throw CustomException(
        causedError: Exception('Organization id is missing'),
      );
    }

    final query = <String, dynamic>{
      'organization': organizationId,
      'is_read': isRead,
      'page': page,
      'page_size': pageSize,
    };
    if (branchId != null && branchId > 0) {
      query['branch'] = branchId;
    }
    if (datetimeGte != null) {
      query['datetime__gte'] = datetimeGte.toUtc().toIso8601String();
    }
    if (datetimeLte != null) {
      query['datetime__lte'] = datetimeLte.toUtc().toIso8601String();
    }

    try {
      final url = ApiConsts().createUrl('mobile-push/history/');
      final response = await createAppDio().get<Map<String, dynamic>>(
        url,
        queryParameters: query,
        options: Options(headers: await _authHeaders()),
      );

      if (response.statusCode == 200 && response.data != null) {
        return PushHistoryApiResponse.fromJson(response.data!);
      }
      throw CustomException(
        causedError: Exception(
          'Failed to load push history: ${response.statusCode}',
        ),
      );
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }

  Future<PushHistoryCount> getHistoryCount({int? branchId}) async {
    final organizationId = _organizationId;
    if (organizationId <= 0) {
      throw CustomException(
        causedError: Exception('Organization id is missing'),
      );
    }

    final query = <String, dynamic>{'organization': organizationId};
    if (branchId != null && branchId > 0) {
      query['branch'] = branchId;
    }

    try {
      final url = ApiConsts().createUrl('mobile-push/history/count/');
      final response = await createAppDio().get<Map<String, dynamic>>(
        url,
        queryParameters: query,
        options: Options(headers: await _authHeaders()),
      );

      if (response.statusCode == 200 && response.data != null) {
        return PushHistoryCount.fromJson(response.data!);
      }
      throw CustomException(
        causedError: Exception(
          'Failed to load push history count: ${response.statusCode}',
        ),
      );
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }

  Future<PushHistoryItemApi> markAsRead({
    required int id,
    required bool isRead,
  }) async {
    final organizationId = _organizationId;
    if (organizationId <= 0) {
      throw CustomException(
        causedError: Exception('Organization id is missing'),
      );
    }

    try {
      final url = ApiConsts().createUrl('mobile-push/history/$id/');
      final response = await createAppDio().patch<Map<String, dynamic>>(
        url,
        queryParameters: {'organization': organizationId},
        data: {'is_read': isRead},
        options: Options(
          headers: {
            ...await _authHeaders(),
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return PushHistoryItemApi.fromJson(response.data!);
      }
      throw CustomException(
        causedError: Exception(
          'Failed to update push notification: ${response.statusCode}',
        ),
      );
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }

  Future<int> markAllAsRead({
    DateTime? datetimeGte,
    DateTime? datetimeLte,
  }) async {
    final organizationId = _organizationId;
    if (organizationId <= 0) {
      throw CustomException(
        causedError: Exception('Organization id is missing'),
      );
    }

    final body = <String, dynamic>{'organization': organizationId};
    if (datetimeGte != null) {
      body['datetime__gte'] = datetimeGte.toUtc().toIso8601String();
    }
    if (datetimeLte != null) {
      body['datetime__lte'] = datetimeLte.toUtc().toIso8601String();
    }

    try {
      final url = ApiConsts().createUrl('mobile-push/history/mark_all_read/');
      final response = await createAppDio().post<Map<String, dynamic>>(
        url,
        data: body,
        options: Options(
          headers: {
            ...await _authHeaders(),
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return (response.data!['updated'] as num?)?.toInt() ?? 0;
      }
      throw CustomException(
        causedError: Exception(
          'Failed to mark all as read: ${response.statusCode}',
        ),
      );
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }

  Future<PushDeviceApi> registerDevice(RegisterPushDeviceRequest body) async {
    try {
      final url = ApiConsts().createUrl('mobile-push/devices/');
      final response = await createAppDio().post<Map<String, dynamic>>(
        url,
        data: body.toJson(),
        options: Options(
          headers: {
            ...await _authHeaders(),
            'Content-Type': 'application/json',
          },
        ),
      );

      if ((response.statusCode == 201 || response.statusCode == 200) &&
          response.data != null) {
        return PushDeviceApi.fromJson(response.data!);
      }
      throw CustomException(
        causedError: Exception(
          'Failed to register push device: ${response.statusCode}',
        ),
      );
    } catch (e) {
      // Регистрация push — фоновая задача; 401 при смене аккаунта не должен ронять сессию.
      throw CustomException(causedError: e);
    }
  }

  /// Перепривязка существующей записи устройства к текущему пользователю.
  Future<PushDeviceApi> updateDevice({
    required int id,
    required RegisterPushDeviceRequest body,
    bool activate = true,
  }) async {
    try {
      final url = ApiConsts().createUrl('mobile-push/devices/$id/');
      final payload = body.toJson()
        ..removeWhere((_, value) => value == null)
        ..['is_active'] = activate;
      final response = await createAppDio().patch<Map<String, dynamic>>(
        url,
        data: payload,
        options: Options(
          headers: {
            ...await _authHeaders(),
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return PushDeviceApi.fromJson(response.data!);
      }
      throw CustomException(
        causedError: Exception(
          'Failed to update push device: ${response.statusCode}',
        ),
      );
    } catch (e) {
      throw CustomException(causedError: e);
    }
  }

  /// Забрать устройство по FCM-токену на текущего пользователя (смена аккаунта).
  Future<PushDeviceApi> claimDevice(RegisterPushDeviceRequest body) async {
    try {
      final url = ApiConsts().createUrl('mobile-push/devices/claim/');
      final response = await createAppDio().post<Map<String, dynamic>>(
        url,
        data: body.toJson(),
        options: Options(
          headers: {
            ...await _authHeaders(),
            'Content-Type': 'application/json',
          },
        ),
      );

      if ((response.statusCode == 201 || response.statusCode == 200) &&
          response.data != null) {
        return PushDeviceApi.fromJson(response.data!);
      }
      throw CustomException(
        causedError: Exception(
          'Failed to claim push device: ${response.statusCode}',
        ),
      );
    } catch (e) {
      throw CustomException(causedError: e);
    }
  }

  /// Реактивировать устройство по FCM-токену для текущего пользователя.
  Future<PushDeviceApi> reactivateDevice(RegisterPushDeviceRequest body) async {
    try {
      final url = ApiConsts().createUrl('mobile-push/devices/reactivate/');
      final response = await createAppDio().post<Map<String, dynamic>>(
        url,
        data: body.toJson(),
        options: Options(
          headers: {
            ...await _authHeaders(),
            'Content-Type': 'application/json',
          },
        ),
      );

      if ((response.statusCode == 201 || response.statusCode == 200) &&
          response.data != null) {
        return PushDeviceApi.fromJson(response.data!);
      }
      throw CustomException(
        causedError: Exception(
          'Failed to reactivate push device: ${response.statusCode}',
        ),
      );
    } catch (e) {
      throw CustomException(causedError: e);
    }
  }

  Future<DeactivatePushDeviceResponse> deactivateDevice({
    required int organizationId,
    int? id,
    String? token,
    String? deviceId,
  }) async {
    try {
      final url = ApiConsts().createUrl('mobile-push/devices/deactivate/');
      final response = await createAppDio().post<Map<String, dynamic>>(
        url,
        data: DeactivatePushDeviceRequest(
          organization: organizationId,
          id: id,
          token: token,
          deviceId: deviceId,
        ).toJson(),
        options: Options(
          headers: {
            ...await _authHeaders(),
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return DeactivatePushDeviceResponse.fromJson(response.data!);
      }
      throw CustomException(
        causedError: Exception(
          'Failed to deactivate push device: ${response.statusCode}',
        ),
      );
    } catch (e) {
      // Деактивация при logout часто получает 401 — это ожидаемо.
      throw CustomException(causedError: e);
    }
  }

  Future<List<PushSettingsDeviceApi>> getPushSettings() async {
    final organizationId = _organizationId;
    if (organizationId <= 0) {
      throw CustomException(
        causedError: Exception('Organization id is missing'),
      );
    }

    try {
      final url = ApiConsts().createUrl('mobile-push/settings/');
      final response = await createAppDio().get<dynamic>(
        url,
        queryParameters: {'organization': organizationId},
        options: Options(headers: await _authHeaders()),
      );

      if (response.statusCode == 200 && response.data != null) {
        final raw = response.data;
        if (raw is List) {
          return raw
              .whereType<Map>()
              .map(
                (e) => PushSettingsDeviceApi.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList();
        }
        return const [];
      }
      throw CustomException(
        causedError: Exception(
          'Failed to load push settings: ${response.statusCode}',
        ),
      );
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }

  Future<UpdatePushSettingsResponse> updatePushSettings({
    required bool pushEnabled,
    int? deviceRecordId,
    String? fcmToken,
    String? deviceId,
  }) async {
    final organizationId = _organizationId;
    if (organizationId <= 0) {
      throw CustomException(
        causedError: Exception('Organization id is missing'),
      );
    }

    try {
      final url = ApiConsts().createUrl('mobile-push/settings/');
      final payload = UpdatePushSettingsRequest(
        organization: organizationId,
        pushEnabled: pushEnabled,
        id: deviceRecordId,
        token: fcmToken,
        deviceId: deviceId,
      ).toJson()
        ..removeWhere((_, value) => value == null);
      final response = await createAppDio().patch<Map<String, dynamic>>(
        url,
        data: payload,
        options: Options(
          headers: {
            ...await _authHeaders(),
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return UpdatePushSettingsResponse.fromJson(response.data!);
      }
      throw CustomException(
        causedError: Exception(
          'Failed to update push settings: ${response.statusCode}',
        ),
      );
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }
}
