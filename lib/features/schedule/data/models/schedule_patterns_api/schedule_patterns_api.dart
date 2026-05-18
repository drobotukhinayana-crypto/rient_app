// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_patterns_api.freezed.dart';
part 'schedule_patterns_api.g.dart';

@freezed
sealed class SchedulePatternsApiResponse with _$SchedulePatternsApiResponse {
  const factory SchedulePatternsApiResponse({
    required int count,
    required String? next,
    required String? previous,
    required List<SchedulePatternItemApi> results,
  }) = _SchedulePatternsApiResponse;

  factory SchedulePatternsApiResponse.fromJson(Map<String, dynamic> json) =>
      _$SchedulePatternsApiResponseFromJson(json);
}

@freezed
sealed class SchedulePatternItemApi with _$SchedulePatternItemApi {
  const factory SchedulePatternItemApi({
    required int id,
    required String day,
    @JsonKey(name: 'time_start') required String? timeStart,
    @JsonKey(name: 'time_end') required String? timeEnd,
    required bool active,
    required int worker,
    @JsonKey(name: 'break_start') required String? breakStart,
    @JsonKey(name: 'break_end') required String? breakEnd,
  }) = _SchedulePatternItemApi;

  factory SchedulePatternItemApi.fromJson(Map<String, dynamic> json) =>
      _$SchedulePatternItemApiFromJson(json);
}

extension SchedulePatternItemApiX on SchedulePatternItemApi {
  String? get timeStartShort => _shortTime(timeStart);

  String? get timeEndShort => _shortTime(timeEnd);

  String? get breakStartShort => _shortTime(breakStart);

  String? get breakEndShort => _shortTime(breakEnd);

  static String? _shortTime(String? value) {
    if (value == null || value.isEmpty) return null;
    return value.length >= 5 ? value.substring(0, 5) : value;
  }

  /// 1 = Monday … 7 = Sunday (DateTime.weekday).
  int? get weekdayNumber {
    switch (day.toLowerCase()) {
      case 'mon':
        return DateTime.monday;
      case 'tue':
        return DateTime.tuesday;
      case 'wed':
      case 'wen':
        return DateTime.wednesday;
      case 'thu':
        return DateTime.thursday;
      case 'fri':
        return DateTime.friday;
      case 'sat':
        return DateTime.saturday;
      case 'sun':
        return DateTime.sunday;
      default:
        return null;
    }
  }

  String get dayLabelRu {
    switch (day.toLowerCase()) {
      case 'mon':
        return 'ПН';
      case 'tue':
        return 'ВТ';
      case 'wed':
      case 'wen':
        return 'СР';
      case 'thu':
        return 'ЧТ';
      case 'fri':
        return 'ПТ';
      case 'sat':
        return 'СБ';
      case 'sun':
        return 'ВС';
      default:
        return day.toUpperCase();
    }
  }
}
