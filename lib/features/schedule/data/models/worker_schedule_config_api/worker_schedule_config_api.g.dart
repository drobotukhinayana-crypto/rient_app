// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_schedule_config_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkerScheduleConfigApi _$WorkerScheduleConfigApiFromJson(
  Map<String, dynamic> json,
) => _WorkerScheduleConfigApi(
  id: json['id'] as String,
  worker: (json['worker'] as num).toInt(),
  branch: (json['branch'] as num).toInt(),
  scheduleType: (json['schedule_type'] as num).toInt(),
  scheduleShiftPattern: json['schedule_shift_pattern'] as String?,
  scheduleShiftStartDate: json['schedule_shift_start_date'] as String?,
  timeStart: json['time_start'] as String?,
  timeEnd: json['time_end'] as String?,
  active: json['active'] as bool,
);

Map<String, dynamic> _$WorkerScheduleConfigApiToJson(
  _WorkerScheduleConfigApi instance,
) => <String, dynamic>{
  'id': instance.id,
  'worker': instance.worker,
  'branch': instance.branch,
  'schedule_type': instance.scheduleType,
  'schedule_shift_pattern': instance.scheduleShiftPattern,
  'schedule_shift_start_date': instance.scheduleShiftStartDate,
  'time_start': instance.timeStart,
  'time_end': instance.timeEnd,
  'active': instance.active,
};
