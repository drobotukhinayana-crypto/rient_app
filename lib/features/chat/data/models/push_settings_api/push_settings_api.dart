import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_settings_api.freezed.dart';
part 'push_settings_api.g.dart';

@freezed
sealed class PushSettingsDeviceApi with _$PushSettingsDeviceApi {
  const factory PushSettingsDeviceApi({
    required int id,
    required int? organization,
    required int? branch,
    @JsonKey(name: 'device_id') required String? deviceId,
    required String? platform,
    @JsonKey(name: 'push_enabled') required bool pushEnabled,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'last_seen') required String? lastSeen,
    required String? created,
    required String? updated,
  }) = _PushSettingsDeviceApi;

  factory PushSettingsDeviceApi.fromJson(Map<String, dynamic> json) =>
      _$PushSettingsDeviceApiFromJson(json);
}

@freezed
sealed class UpdatePushSettingsRequest with _$UpdatePushSettingsRequest {
  const factory UpdatePushSettingsRequest({
    required int organization,
    @JsonKey(name: 'push_enabled') required bool pushEnabled,
    int? id,
    String? token,
    @JsonKey(name: 'device_id') String? deviceId,
  }) = _UpdatePushSettingsRequest;

  factory UpdatePushSettingsRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdatePushSettingsRequestFromJson(json);
}

@freezed
sealed class UpdatePushSettingsResponse with _$UpdatePushSettingsResponse {
  const factory UpdatePushSettingsResponse({
    required int updated,
  }) = _UpdatePushSettingsResponse;

  factory UpdatePushSettingsResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdatePushSettingsResponseFromJson(json);
}
