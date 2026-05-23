// Пересечение смены сотрудника с рабочими часами филиала (как на вебе).

int scheduleTimeToMinutes(String time) {
  final parts = time.split(':');
  final h = int.tryParse(parts.first) ?? 0;
  final m = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;
  return h * 60 + m;
}

String scheduleMinutesToTime(int minutes) {
  final h = minutes ~/ 60;
  final m = minutes % 60;
  return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
}

/// `null`, если пересечения нет.
({String start, String end})? intersectWorkerShiftWithBranch({
  required String workerStart,
  required String workerEnd,
  required String branchStart,
  required String branchEnd,
}) {
  final ws = scheduleTimeToMinutes(workerStart);
  final we = scheduleTimeToMinutes(workerEnd);
  final bs = scheduleTimeToMinutes(branchStart);
  final be = scheduleTimeToMinutes(branchEnd);

  final start = ws > bs ? ws : bs;
  final end = we < be ? we : be;
  if (end <= start) return null;

  return (start: scheduleMinutesToTime(start), end: scheduleMinutesToTime(end));
}

/// `null`, если пересечения нет.
({double start, double end})? intersectWorkerShiftHoursWithBranch({
  required double workerStart,
  required double workerEnd,
  required double branchStart,
  required double branchEnd,
}) {
  final start = workerStart > branchStart ? workerStart : branchStart;
  final end = workerEnd < branchEnd ? workerEnd : branchEnd;
  if (end <= start) return null;
  return (start: start, end: end);
}
