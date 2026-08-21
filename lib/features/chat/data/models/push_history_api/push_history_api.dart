import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_history_api.freezed.dart';
part 'push_history_api.g.dart';

@freezed
sealed class PushHistoryApiResponse with _$PushHistoryApiResponse {
  const factory PushHistoryApiResponse({
    required int count,
    required String? next,
    required String? previous,
    required List<PushHistoryItemApi> results,
  }) = _PushHistoryApiResponse;

  factory PushHistoryApiResponse.fromJson(Map<String, dynamic> json) =>
      _$PushHistoryApiResponseFromJson(json);
}

@freezed
sealed class PushHistoryItemApi with _$PushHistoryItemApi {
  const factory PushHistoryItemApi({
    required int id,
    required String? type,
    required String? title,
    required String? body,
    required Map<String, dynamic>? payload,
    required String? status,
    required String? error,
    required int? appointment,
    required int? branch,
    @JsonKey(name: 'is_read') required bool isRead,
    @JsonKey(name: 'read_at') required String? readAt,
    @JsonKey(name: 'sent_at') required String? sentAt,
    @JsonKey(name: 'report_date') required String? reportDate,
    @JsonKey(name: 'delivered_devices_count') required int? deliveredDevicesCount,
    @JsonKey(name: 'failed_devices_count') required int? failedDevicesCount,
    required String? created,
  }) = _PushHistoryItemApi;

  const PushHistoryItemApi._();

  factory PushHistoryItemApi.fromJson(Map<String, dynamic> json) =>
      _$PushHistoryItemApiFromJson(json);

  int? get appointmentId {
    if (appointment != null && appointment! > 0) return appointment;
    final raw = payload?['appointment_id'];
    if (raw is int) return raw;
    if (raw is num) return raw.toInt();
    if (raw is String) return int.tryParse(raw);
    return null;
  }

  /// Тип из payload (например `payment_expires_today`) или верхнеуровневый `type`.
  String? get effectiveType {
    final payloadType = payload?['type'];
    if (payloadType is String && payloadType.trim().isNotEmpty) {
      return payloadType.trim();
    }
    final topLevel = type?.trim();
    if (topLevel != null && topLevel.isNotEmpty) return topLevel;
    return null;
  }

  bool get isLicenseNotification {
    final value = effectiveType ?? '';
    return value.startsWith('payment_') || value.startsWith('license_');
  }

  bool get isAppointmentNotification =>
      effectiveType == 'appointment_created' || appointmentId != null;

  String? get licenseAction {
    final action = payload?['action'];
    if (action is String && action.trim().isNotEmpty) return action.trim();
    return null;
  }

  String? get licensePaymentUrl {
    for (final key in const ['payment_url', 'url', 'link']) {
      final raw = payload?[key];
      if (raw is String && raw.trim().isNotEmpty) return raw.trim();
    }
    return null;
  }
}
