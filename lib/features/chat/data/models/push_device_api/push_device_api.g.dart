// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_device_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PushDeviceApi _$PushDeviceApiFromJson(Map<String, dynamic> json) =>
    _PushDeviceApi(
      id: (json['id'] as num).toInt(),
      organization: (json['organization'] as num?)?.toInt(),
      branch: (json['branch'] as num?)?.toInt(),
      token: json['token'] as String?,
      deviceId: json['device_id'] as String?,
      platform: json['platform'] as String?,
      appVersion: json['app_version'] as String?,
      appBuild: json['app_build'] as String?,
      locale: json['locale'] as String?,
      timezoneName: json['timezone_name'] as String?,
      pushEnabled: json['push_enabled'] as bool,
      isActive: json['is_active'] as bool,
      lastSeen: json['last_seen'] as String?,
      created: json['created'] as String?,
      updated: json['updated'] as String?,
    );

Map<String, dynamic> _$PushDeviceApiToJson(_PushDeviceApi instance) =>
    <String, dynamic>{
      'id': instance.id,
      'organization': instance.organization,
      'branch': instance.branch,
      'token': instance.token,
      'device_id': instance.deviceId,
      'platform': instance.platform,
      'app_version': instance.appVersion,
      'app_build': instance.appBuild,
      'locale': instance.locale,
      'timezone_name': instance.timezoneName,
      'push_enabled': instance.pushEnabled,
      'is_active': instance.isActive,
      'last_seen': instance.lastSeen,
      'created': instance.created,
      'updated': instance.updated,
    };

_RegisterPushDeviceRequest _$RegisterPushDeviceRequestFromJson(
  Map<String, dynamic> json,
) => _RegisterPushDeviceRequest(
  organization: (json['organization'] as num).toInt(),
  token: json['token'] as String,
  platform: json['platform'] as String,
  branch: (json['branch'] as num?)?.toInt(),
  deviceId: json['device_id'] as String?,
  appVersion: json['app_version'] as String?,
  appBuild: json['app_build'] as String?,
  locale: json['locale'] as String?,
  timezoneName: json['timezone_name'] as String?,
  pushEnabled: json['push_enabled'] as bool?,
);

Map<String, dynamic> _$RegisterPushDeviceRequestToJson(
  _RegisterPushDeviceRequest instance,
) => <String, dynamic>{
  'organization': instance.organization,
  'token': instance.token,
  'platform': instance.platform,
  'branch': instance.branch,
  'device_id': instance.deviceId,
  'app_version': instance.appVersion,
  'app_build': instance.appBuild,
  'locale': instance.locale,
  'timezone_name': instance.timezoneName,
  'push_enabled': instance.pushEnabled,
};

_DeactivatePushDeviceRequest _$DeactivatePushDeviceRequestFromJson(
  Map<String, dynamic> json,
) => _DeactivatePushDeviceRequest(
  organization: (json['organization'] as num).toInt(),
  id: (json['id'] as num?)?.toInt(),
  token: json['token'] as String?,
  deviceId: json['device_id'] as String?,
);

Map<String, dynamic> _$DeactivatePushDeviceRequestToJson(
  _DeactivatePushDeviceRequest instance,
) => <String, dynamic>{
  'organization': instance.organization,
  'id': instance.id,
  'token': instance.token,
  'device_id': instance.deviceId,
};

_DeactivatePushDeviceResponse _$DeactivatePushDeviceResponseFromJson(
  Map<String, dynamic> json,
) => _DeactivatePushDeviceResponse(updated: (json['updated'] as num).toInt());

Map<String, dynamic> _$DeactivatePushDeviceResponseToJson(
  _DeactivatePushDeviceResponse instance,
) => <String, dynamic>{'updated': instance.updated};
