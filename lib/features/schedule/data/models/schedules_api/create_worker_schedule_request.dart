/// Тело POST/PATCH /organizations/{id}/workers/{worker_id}/schedules/
class CreateWorkerScheduleRequest {
  const CreateWorkerScheduleRequest({
    required this.date,
    required this.key,
    required this.timeStart,
    required this.timeEnd,
    required this.active,
    required this.subject,
    required this.subjectPk,
    required this.branch,
    this.breakStart,
    this.breakEnd,
    this.auto = false,
    this.captcha,
  });

  final String date;

  /// Ключ субъекта, например `worker/3`.
  final String key;
  final String timeStart;
  final String timeEnd;
  final bool active;
  final String subject;
  final int subjectPk;
  final int branch;
  final String? breakStart;
  final String? breakEnd;
  final bool auto;
  final String? captcha;

  /// [timeStart], [timeEnd], перерывы — `HH:mm` или `HH:mm:ss`.
  factory CreateWorkerScheduleRequest.forWorker({
    required DateTime date,
    required String timeStart,
    required String timeEnd,
    required bool active,
    required int workerId,
    required int branchId,
    String? breakStart,
    String? breakEnd,
    bool auto = false,
    String captcha = 'dummy',
  }) {
    return CreateWorkerScheduleRequest(
      date: dateToApi(date),
      key: workerScheduleKey(workerId),
      timeStart: timeToApi(timeStart),
      timeEnd: timeToApi(timeEnd),
      active: active,
      subject: 'worker',
      subjectPk: workerId,
      branch: branchId,
      breakStart: breakStart == null ? null : timeToApi(breakStart),
      breakEnd: breakEnd == null ? null : timeToApi(breakEnd),
      auto: auto,
      captcha: captcha,
    );
  }

  static String workerScheduleKey(int workerId) => 'worker/$workerId';

  static String dateToApi(DateTime date) {
    final y = date.year;
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  static String timeToApi(String time) {
    final trimmed = time.trim();
    if (trimmed.length == 5 && trimmed.contains(':')) {
      return '$trimmed:00';
    }
    return trimmed;
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'key': key,
      'time_start': timeStart,
      'time_end': timeEnd,
      'active': active,
      'subject': subject,
      'subject_pk': subjectPk,
      'branch': branch,
      'auto': auto,
      if (breakStart != null) 'break_start': breakStart,
      if (breakEnd != null) 'break_end': breakEnd,
      'captcha': captcha ?? 'dummy',
    };
  }
}
