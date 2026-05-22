// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_settings_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PushSettingsDeviceApi _$PushSettingsDeviceApiFromJson(
  Map<String, dynamic> json,
) => _PushSettingsDeviceApi(
  id: (json['id'] as num).toInt(),
  organization: (json['organization'] as num?)?.toInt(),
  branch: (json['branch'] as num?)?.toInt(),
  deviceId: json['device_id'] as String?,
  platform: json['platform'] as String?,
  pushEnabled: json['push_enabled'] as bool,
  isActive: json['is_active'] as bool,
  lastSeen: json['last_seen'] as String?,
  created: json['created'] as String?,
  updated: json['updated'] as String?,
);

Map<String, dynamic> _$PushSettingsDeviceApiToJson(
  _PushSettingsDeviceApi instance,
) => <String, dynamic>{
  'id': instance.id,
  'organization': instance.organization,
  'branch': instance.branch,
  'device_id': instance.deviceId,
  'platform': instance.platform,
  'push_enabled': instance.pushEnabled,
  'is_active': instance.isActive,
  'last_seen': instance.lastSeen,
  'created': instance.created,
  'updated': instance.updated,
};

_UpdatePushSettingsRequest _$UpdatePushSettingsRequestFromJson(
  Map<String, dynamic> json,
) => _UpdatePushSettingsRequest(
  organization: (json['organization'] as num).toInt(),
  pushEnabled: json['push_enabled'] as bool,
  id: (json['id'] as num?)?.toInt(),
  token: json['token'] as String?,
  deviceId: json['device_id'] as String?,
);

Map<String, dynamic> _$UpdatePushSettingsRequestToJson(
  _UpdatePushSettingsRequest instance,
) => <String, dynamic>{
  'organization': instance.organization,
  'push_enabled': instance.pushEnabled,
  'id': instance.id,
  'token': instance.token,
  'device_id': instance.deviceId,
};

_UpdatePushSettingsResponse _$UpdatePushSettingsResponseFromJson(
  Map<String, dynamic> json,
) => _UpdatePushSettingsResponse(updated: (json['updated'] as num).toInt());

Map<String, dynamic> _$UpdatePushSettingsResponseToJson(
  _UpdatePushSettingsResponse instance,
) => <String, dynamic>{'updated': instance.updated};
