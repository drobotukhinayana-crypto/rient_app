// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedules_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SchedulesApiResponse _$SchedulesApiResponseFromJson(
  Map<String, dynamic> json,
) => _SchedulesApiResponse(
  count: (json['count'] as num).toInt(),
  next: json['next'] as String?,
  previous: json['previous'] as String?,
  results: (json['results'] as List<dynamic>)
      .map((e) => ScheduleItemApi.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SchedulesApiResponseToJson(
  _SchedulesApiResponse instance,
) => <String, dynamic>{
  'count': instance.count,
  'next': instance.next,
  'previous': instance.previous,
  'results': instance.results,
};

_ScheduleItemApi _$ScheduleItemApiFromJson(Map<String, dynamic> json) =>
    _ScheduleItemApi(
      id: (json['id'] as num).toInt(),
      branch: (json['branch'] as num).toInt(),
      date: json['date'] as String,
      key: json['key'] as String,
      timeStart: json['time_start'] as String?,
      timeEnd: json['time_end'] as String?,
      active: json['active'] as bool,
      hours: (json['hours'] as num).toDouble(),
      breakStart: json['break_start'] as String?,
      breakEnd: json['break_end'] as String?,
      auto: json['auto'] as bool,
    );

Map<String, dynamic> _$ScheduleItemApiToJson(_ScheduleItemApi instance) =>
    <String, dynamic>{
      'id': instance.id,
      'branch': instance.branch,
      'date': instance.date,
      'key': instance.key,
      'time_start': instance.timeStart,
      'time_end': instance.timeEnd,
      'active': instance.active,
      'hours': instance.hours,
      'break_start': instance.breakStart,
      'break_end': instance.breakEnd,
      'auto': instance.auto,
    };
