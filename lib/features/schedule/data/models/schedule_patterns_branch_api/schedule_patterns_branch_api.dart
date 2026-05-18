// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'schedule_patterns_branch_api.freezed.dart';
part 'schedule_patterns_branch_api.g.dart';

@freezed
sealed class SchedulePatternsBranchApiResponse
    with _$SchedulePatternsBranchApiResponse {
  const factory SchedulePatternsBranchApiResponse({
    required int count,
    required String? next,
    required String? previous,
    required List<SchedulePatternBranchItemApi> results,
  }) = _SchedulePatternsBranchApiResponse;

  factory SchedulePatternsBranchApiResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$SchedulePatternsBranchApiResponseFromJson(json);
}

@freezed
sealed class SchedulePatternBranchItemApi with _$SchedulePatternBranchItemApi {
  const factory SchedulePatternBranchItemApi({
    required int id,
    required int branch,
    required String day,
    @JsonKey(name: 'time_start') required String? timeStart,
    @JsonKey(name: 'time_end') required String? timeEnd,
    required bool active,
  }) = _SchedulePatternBranchItemApi;

  factory SchedulePatternBranchItemApi.fromJson(Map<String, dynamic> json) =>
      _$SchedulePatternBranchItemApiFromJson(json);
}

extension SchedulePatternBranchItemApiX on SchedulePatternBranchItemApi {
  String? get timeStartShort => _shortTime(timeStart);

  String? get timeEndShort => _shortTime(timeEnd);

  static String? _shortTime(String? value) {
    if (value == null || value.isEmpty) return null;
    return value.length >= 5 ? value.substring(0, 5) : value;
  }

  int? get weekdayNumber {
    switch (day.toLowerCase()) {
      case 'mon':
        return DateTime.monday;
      case 'tue':
        return DateTime.tuesday;
      case 'wed':
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
