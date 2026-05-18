// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_patterns_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SchedulePatternsApiResponse _$SchedulePatternsApiResponseFromJson(
  Map<String, dynamic> json,
) => _SchedulePatternsApiResponse(
  count: (json['count'] as num).toInt(),
  next: json['next'] as String?,
  previous: json['previous'] as String?,
  results: (json['results'] as List<dynamic>)
      .map((e) => SchedulePatternItemApi.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$SchedulePatternsApiResponseToJson(
  _SchedulePatternsApiResponse instance,
) => <String, dynamic>{
  'count': instance.count,
  'next': instance.next,
  'previous': instance.previous,
  'results': instance.results,
};

_SchedulePatternItemApi _$SchedulePatternItemApiFromJson(
  Map<String, dynamic> json,
) => _SchedulePatternItemApi(
  id: (json['id'] as num).toInt(),
  day: json['day'] as String,
  timeStart: json['time_start'] as String?,
  timeEnd: json['time_end'] as String?,
  active: json['active'] as bool,
  worker: (json['worker'] as num).toInt(),
  breakStart: json['break_start'] as String?,
  breakEnd: json['break_end'] as String?,
);

Map<String, dynamic> _$SchedulePatternItemApiToJson(
  _SchedulePatternItemApi instance,
) => <String, dynamic>{
  'id': instance.id,
  'day': instance.day,
  'time_start': instance.timeStart,
  'time_end': instance.timeEnd,
  'active': instance.active,
  'worker': instance.worker,
  'break_start': instance.breakStart,
  'break_end': instance.breakEnd,
};
