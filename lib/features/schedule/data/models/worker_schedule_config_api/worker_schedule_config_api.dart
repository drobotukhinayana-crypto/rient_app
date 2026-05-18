// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'worker_schedule_config_api.freezed.dart';
part 'worker_schedule_config_api.g.dart';

/// 0 — неделя, 1 — смена.
abstract final class WorkerScheduleConfigType {
  static const week = 0;
  static const shift = 1;
}

@freezed
sealed class WorkerScheduleConfigApi with _$WorkerScheduleConfigApi {
  const factory WorkerScheduleConfigApi({
    required String id,
    required int worker,
    required int branch,
    @JsonKey(name: 'schedule_type') required int scheduleType,
    @JsonKey(name: 'schedule_shift_pattern')
    required String? scheduleShiftPattern,
    @JsonKey(name: 'schedule_shift_start_date')
    required String? scheduleShiftStartDate,
    @JsonKey(name: 'time_start') required String? timeStart,
    @JsonKey(name: 'time_end') required String? timeEnd,
    required bool active,
  }) = _WorkerScheduleConfigApi;

  factory WorkerScheduleConfigApi.fromJson(Map<String, dynamic> json) =>
      _$WorkerScheduleConfigApiFromJson(json);
}

extension WorkerScheduleConfigApiX on WorkerScheduleConfigApi {
  bool get isWeekSchedule => scheduleType == WorkerScheduleConfigType.week;

  bool get isShiftSchedule => scheduleType == WorkerScheduleConfigType.shift;

  String? get timeStartShort => _shortTime(timeStart);

  String? get timeEndShort => _shortTime(timeEnd);

  static String? _shortTime(String? value) {
    if (value == null || value.isEmpty) return null;
    return value.length >= 5 ? value.substring(0, 5) : value;
  }
}
