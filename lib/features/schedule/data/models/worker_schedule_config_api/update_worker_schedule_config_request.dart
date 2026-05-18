/// Тело PATCH /organizations/{id}/workers/{worker_id}/schedule_configs/{uuid}/
class UpdateWorkerScheduleConfigRequest {
  const UpdateWorkerScheduleConfigRequest({
    this.scheduleType,
    this.scheduleShiftPattern,
    this.scheduleShiftStartDate,
    this.timeStart,
    this.timeEnd,
  });

  /// 0 — неделя, 1 — смена.
  final int? scheduleType;
  final String? scheduleShiftPattern;
  final DateTime? scheduleShiftStartDate;
  final String? timeStart;
  final String? timeEnd;

  static String dateToApi(DateTime date) {
    final y = date.year;
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  static String? timeToApi(String? time) {
    if (time == null) return null;
    final trimmed = time.trim();
    if (trimmed.isEmpty) return null;
    if (trimmed.length == 5 && trimmed.contains(':')) {
      return '$trimmed:00';
    }
    return trimmed;
  }

  Map<String, dynamic> toJson() {
    return {
      if (scheduleType != null) 'schedule_type': scheduleType,
      if (scheduleShiftPattern != null)
        'schedule_shift_pattern': scheduleShiftPattern,
      if (scheduleShiftStartDate != null)
        'schedule_shift_start_date': dateToApi(scheduleShiftStartDate!),
      if (timeStart != null) 'time_start': timeToApi(timeStart),
      if (timeEnd != null) 'time_end': timeToApi(timeEnd),
    };
  }
}
