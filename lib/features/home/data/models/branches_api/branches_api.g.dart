// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branches_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BranchesApiResponse _$BranchesApiResponseFromJson(Map<String, dynamic> json) =>
    _BranchesApiResponse(
      count: (json['count'] as num).toInt(),
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>)
          .map((e) => BranchApi.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BranchesApiResponseToJson(
  _BranchesApiResponse instance,
) => <String, dynamic>{
  'count': instance.count,
  'next': instance.next,
  'previous': instance.previous,
  'results': instance.results,
};

_BranchApi _$BranchApiFromJson(Map<String, dynamic> json) => _BranchApi(
  id: (json['id'] as num).toInt(),
  isMain: json['is_main'] as bool?,
  name: json['name'] as String?,
  country: json['country'] as String?,
  region: json['region'] as String?,
  city: json['city'] as String?,
  address: json['address'] as String?,
  location: json['location'] == null
      ? null
      : Location.fromJson(json['location'] as Map<String, dynamic>),
  timezone: json['timezone'] as String?,
  workspaces: (json['workspaces'] as num?)?.toInt(),
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  schedulePatterns: (json['schedule_patterns'] as List<dynamic>?)
      ?.map((e) => SchedulePattern.fromJson(e as Map<String, dynamic>))
      .toList(),
  hasChatSettings: json['has_chat_settings'] as bool?,
  isBlocked: json['is_blocked'] as bool?,
  isAvailable: json['is_available'] as bool?,
  yandexable: json['yandexable'] as bool?,
  numberOfWorkers: (json['number_of_workers'] as num?)?.toInt(),
  hasChatPushSettings: json['has_chat_push_settings'] as bool?,
);

Map<String, dynamic> _$BranchApiToJson(_BranchApi instance) =>
    <String, dynamic>{
      'id': instance.id,
      'is_main': instance.isMain,
      'name': instance.name,
      'country': instance.country,
      'region': instance.region,
      'city': instance.city,
      'address': instance.address,
      'location': instance.location,
      'timezone': instance.timezone,
      'workspaces': instance.workspaces,
      'phone': instance.phone,
      'email': instance.email,
      'schedule_patterns': instance.schedulePatterns,
      'has_chat_settings': instance.hasChatSettings,
      'is_blocked': instance.isBlocked,
      'is_available': instance.isAvailable,
      'yandexable': instance.yandexable,
      'number_of_workers': instance.numberOfWorkers,
      'has_chat_push_settings': instance.hasChatPushSettings,
    };

_Location _$LocationFromJson(Map<String, dynamic> json) => _Location(
  lat: (json['lat'] as num).toDouble(),
  lon: (json['lon'] as num).toDouble(),
);

Map<String, dynamic> _$LocationToJson(_Location instance) => <String, dynamic>{
  'lat': instance.lat,
  'lon': instance.lon,
};

_SchedulePattern _$SchedulePatternFromJson(Map<String, dynamic> json) =>
    _SchedulePattern(
      id: (json['id'] as num?)?.toInt(),
      branch: (json['branch'] as num?)?.toInt(),
      day: json['day'] as String?,
      timeStart: json['time_start'] as String?,
      timeEnd: json['time_end'] as String?,
      active: json['active'] as bool?,
    );

Map<String, dynamic> _$SchedulePatternToJson(_SchedulePattern instance) =>
    <String, dynamic>{
      'id': instance.id,
      'branch': instance.branch,
      'day': instance.day,
      'time_start': instance.timeStart,
      'time_end': instance.timeEnd,
      'active': instance.active,
    };
