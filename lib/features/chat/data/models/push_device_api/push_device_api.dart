import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_device_api.freezed.dart';
part 'push_device_api.g.dart';

@freezed
sealed class PushDeviceApi with _$PushDeviceApi {
  const factory PushDeviceApi({
    required int id,
    required int? organization,
    required int? branch,
    required String? token,
    @JsonKey(name: 'device_id') required String? deviceId,
    required String? platform,
    @JsonKey(name: 'app_version') required String? appVersion,
    @JsonKey(name: 'app_build') required String? appBuild,
    required String? locale,
    @JsonKey(name: 'timezone_name') required String? timezoneName,
    @JsonKey(name: 'push_enabled') required bool pushEnabled,
    @JsonKey(name: 'is_active') required bool isActive,
    @JsonKey(name: 'last_seen') required String? lastSeen,
    required String? created,
    required String? updated,
  }) = _PushDeviceApi;

  factory PushDeviceApi.fromJson(Map<String, dynamic> json) =>
      _$PushDeviceApiFromJson(json);
}

@freezed
sealed class RegisterPushDeviceRequest with _$RegisterPushDeviceRequest {
  const factory RegisterPushDeviceRequest({
    required int organization,
    required String token,
    required String platform,
    int? branch,
    @JsonKey(name: 'device_id') String? deviceId,
    @JsonKey(name: 'app_version') String? appVersion,
    @JsonKey(name: 'app_build') String? appBuild,
    String? locale,
    @JsonKey(name: 'timezone_name') String? timezoneName,
    @JsonKey(name: 'push_enabled') bool? pushEnabled,
  }) = _RegisterPushDeviceRequest;

  factory RegisterPushDeviceRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterPushDeviceRequestFromJson(json);
}

@freezed
sealed class DeactivatePushDeviceRequest with _$DeactivatePushDeviceRequest {
  const factory DeactivatePushDeviceRequest({
    required int organization,
    int? id,
    String? token,
    @JsonKey(name: 'device_id') String? deviceId,
  }) = _DeactivatePushDeviceRequest;

  factory DeactivatePushDeviceRequest.fromJson(Map<String, dynamic> json) =>
      _$DeactivatePushDeviceRequestFromJson(json);
}

@freezed
sealed class DeactivatePushDeviceResponse with _$DeactivatePushDeviceResponse {
  const factory DeactivatePushDeviceResponse({
    required int updated,
  }) = _DeactivatePushDeviceResponse;

  factory DeactivatePushDeviceResponse.fromJson(Map<String, dynamic> json) =>
      _$DeactivatePushDeviceResponseFromJson(json);
}
