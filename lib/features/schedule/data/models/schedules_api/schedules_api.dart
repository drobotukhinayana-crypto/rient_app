// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rient_app/features/schedule/utils/schedule_date_utils.dart';

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

  /// Время HH:mm из ответа API (HH:mm:ss).
  String? get timeStartShort => _shortTime(timeStart);

  String? get timeEndShort => _shortTime(timeEnd);

  String? get breakStartShort => _shortTime(breakStart);

  String? get breakEndShort => _shortTime(breakEnd);

  static String? _shortTime(String? value) {
    if (value == null || value.isEmpty) return null;
    return value.length >= 5 ? value.substring(0, 5) : value;
  }

  DateTime? get dateParsed => parseScheduleApiDate(date);

  String get canonicalDate => canonicalScheduleDateKey(date);
}
