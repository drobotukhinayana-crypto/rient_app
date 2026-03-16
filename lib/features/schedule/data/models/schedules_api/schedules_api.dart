// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedules_api.freezed.dart';
part 'schedules_api.g.dart';

@freezed
sealed class SchedulesApiResponse with _$SchedulesApiResponse {
  const factory SchedulesApiResponse({
    required int count,
    required String? next,
    required String? previous,
    required List<ScheduleItemApi> results,
  }) = _SchedulesApiResponse;

  factory SchedulesApiResponse.fromJson(Map<String, dynamic> json) =>
      _$SchedulesApiResponseFromJson(json);
}

@freezed
sealed class ScheduleItemApi with _$ScheduleItemApi {
  const factory ScheduleItemApi({
    required int id,
    required int branch,
    required String date,
    required String key,
    @JsonKey(name: 'time_start') required String? timeStart,
    @JsonKey(name: 'time_end') required String? timeEnd,
    required bool active,
    required double hours,
    @JsonKey(name: 'break_start') required String? breakStart,
    @JsonKey(name: 'break_end') required String? breakEnd,
    required bool auto,
  }) = _ScheduleItemApi;

  factory ScheduleItemApi.fromJson(Map<String, dynamic> json) =>
      _$ScheduleItemApiFromJson(json);
}

extension ScheduleItemApiX on ScheduleItemApi {
  /// Id сотрудника из ключа вида "worker/2".
  int? get workerId {
    if (!key.startsWith('worker/')) return null;
    return int.tryParse(key.substring(7));
  }
}
