// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_patterns_branch_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SchedulePatternsBranchApiResponse _$SchedulePatternsBranchApiResponseFromJson(
  Map<String, dynamic> json,
) => _SchedulePatternsBranchApiResponse(
  count: (json['count'] as num).toInt(),
  next: json['next'] as String?,
  previous: json['previous'] as String?,
  results: (json['results'] as List<dynamic>)
      .map(
        (e) => SchedulePatternBranchItemApi.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
);

Map<String, dynamic> _$SchedulePatternsBranchApiResponseToJson(
  _SchedulePatternsBranchApiResponse instance,
) => <String, dynamic>{
  'count': instance.count,
  'next': instance.next,
  'previous': instance.previous,
  'results': instance.results,
};

_SchedulePatternBranchItemApi _$SchedulePatternBranchItemApiFromJson(
  Map<String, dynamic> json,
) => _SchedulePatternBranchItemApi(
  id: (json['id'] as num).toInt(),
  branch: (json['branch'] as num).toInt(),
  day: json['day'] as String,
  timeStart: json['time_start'] as String?,
  timeEnd: json['time_end'] as String?,
  active: json['active'] as bool,
);

Map<String, dynamic> _$SchedulePatternBranchItemApiToJson(
  _SchedulePatternBranchItemApi instance,
) => <String, dynamic>{
  'id': instance.id,
  'branch': instance.branch,
  'day': instance.day,
  'time_start': instance.timeStart,
  'time_end': instance.timeEnd,
  'active': instance.active,
};
