import 'package:rient_app/features/schedule/data/models/schedule_patterns_api/schedule_patterns_api.dart';
import 'package:rient_app/features/schedule/data/models/schedule_patterns_branch_api/schedule_patterns_branch_api.dart';

/// Элемент массива patterns для POST .../branches/{id}/patterns/
class UpdateBranchSchedulePatternItem {
  const UpdateBranchSchedulePatternItem({
    required this.id,
    required this.branch,
    required this.day,
    required this.timeStart,
    required this.timeEnd,
    required this.active,
  });

  final int id;
  final int branch;
  final String day;
  final String timeStart;
  final String timeEnd;
  final bool active;

  factory UpdateBranchSchedulePatternItem.fromBranchPattern(
    SchedulePatternBranchItemApi pattern, {
    String? timeStart,
    String? timeEnd,
    bool? active,
  }) {
    return UpdateBranchSchedulePatternItem(
      id: pattern.id,
      branch: pattern.branch,
      day: pattern.day.toLowerCase(),
      timeStart: timeToApi(timeStart ?? pattern.timeStart ?? '09:00:00'),
      timeEnd: timeToApi(timeEnd ?? pattern.timeEnd ?? '20:00:00'),
      active: active ?? pattern.active,
    );
  }

  factory UpdateBranchSchedulePatternItem.fromWorkerPattern(
    SchedulePatternItemApi pattern, {
    required int branchId,
    String? timeStart,
    String? timeEnd,
    bool? active,
  }) {
    return UpdateBranchSchedulePatternItem(
      id: pattern.id,
      branch: branchId,
      day: pattern.day.toLowerCase(),
      timeStart: timeToApi(timeStart ?? pattern.timeStart ?? '09:00:00'),
      timeEnd: timeToApi(timeEnd ?? pattern.timeEnd ?? '20:00:00'),
      active: active ?? pattern.active,
    );
  }

  static String timeToApi(String time) {
    final trimmed = time.trim();
    if (trimmed.length == 5 && trimmed.contains(':')) {
      return '$trimmed:00';
    }
    return trimmed;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'branch': branch,
        'day': day,
        'time_start': timeStart,
        'time_end': timeEnd,
        'active': active,
      };
}

/// Тело POST /organizations/{id}/branches/{branch_id}/patterns/
class UpdateBranchSchedulePatternsRequest {
  const UpdateBranchSchedulePatternsRequest({required this.patterns});

  final List<UpdateBranchSchedulePatternItem> patterns;

  Map<String, dynamic> toJson() => {
        'patterns': patterns.map((e) => e.toJson()).toList(),
      };
}
