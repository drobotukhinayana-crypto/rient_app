import 'package:rient_app/features/schedule/data/models/worker_schedule_config_api/worker_schedule_config_api.dart';

/// Конфиг графика сотрудника для текущего филиала из /workers/?with_schedules=1.
Map<String, dynamic>? workerScheduleConfigForBranch(
  Map<String, dynamic>? workerRow,
  int branchId,
) {
  if (workerRow == null || branchId <= 0) return null;

  final single = workerRow['schedule_config'];
  if (single is Map) {
    return _mapWithBranchCheck(single, branchId);
  }
  if (single is List) {
    return _pickConfigForBranch(single, branchId);
  }

  final plural = workerRow['schedule_configs'];
  if (plural is List) {
    return _pickConfigForBranch(plural, branchId);
  }

  return null;
}

Map<String, dynamic>? _mapWithBranchCheck(
  Map<dynamic, dynamic> source,
  int branchId,
) {
  final map = source.map((k, v) => MapEntry(k.toString(), v));
  final configBranch = _branchIdFromDynamic(map['branch']);
  if (configBranch != null && configBranch != branchId) return null;
  return map;
}

Map<String, dynamic>? _pickConfigForBranch(
  List<dynamic> configs,
  int branchId,
) {
  Map<String, dynamic>? fallback;
  for (final item in configs) {
    if (item is! Map) continue;
    final map = item.map((k, v) => MapEntry(k.toString(), v));
    final configBranch = _branchIdFromDynamic(map['branch']);
    if (configBranch == branchId) return map;
    fallback ??= map;
  }
  return fallback;
}

int? _branchIdFromDynamic(dynamic value) {
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value.trim());
  return null;
}

int parseWorkerScheduleType(dynamic raw) {
  if (raw is num) return raw.toInt();
  if (raw is String) {
    final parsed = int.tryParse(raw.trim());
    if (parsed != null) return parsed;
  }
  return WorkerScheduleConfigType.week;
}

bool isShiftWorkerScheduleConfig(Map<String, dynamic>? configMap) {
  if (configMap == null) return false;
  return parseWorkerScheduleType(configMap['schedule_type']) ==
      WorkerScheduleConfigType.shift;
}

/// Рабочий ли день по сменному графику (например 2/3: 2 дня работы, 3 выходных).
bool isShiftWorkerWorkDay(DateTime date, Map<String, dynamic>? configMap) {
  if (configMap == null) return false;

  final patternRaw = configMap['schedule_shift_pattern']?.toString() ?? '1/1';
  final parts = patternRaw.split('/');
  final workDays = int.tryParse(parts.isNotEmpty ? parts[0] : '') ?? 1;
  final offDays = int.tryParse(parts.length > 1 ? parts[1] : '') ?? 1;
  if (workDays <= 0 || offDays <= 0) return false;

  final startRaw = configMap['schedule_shift_start_date']?.toString();
  if (startRaw == null || startRaw.isEmpty) return false;
  final parsed = DateTime.tryParse(startRaw);
  if (parsed == null) return false;
  final shiftStart = DateTime(parsed.year, parsed.month, parsed.day);
  final target = DateTime(date.year, date.month, date.day);
  final daysSince = target.difference(shiftStart).inDays;
  if (daysSince < 0) return false;

  final cycleLength = workDays + offDays;
  final position = daysSince % cycleLength;
  return position < workDays;
}

/// Ближайший рабочий день начиная с [from] (включительно), не далее [maxDays] вперёд.
DateTime resolveNextWorkerWorkDate({
  required DateTime from,
  required bool Function(DateTime date) isWorkDay,
  int maxDays = 370,
}) {
  var date = DateTime(from.year, from.month, from.day);
  for (var i = 0; i < maxDays; i++) {
    if (isWorkDay(date)) return date;
    date = date.add(const Duration(days: 1));
  }
  return DateTime(from.year, from.month, from.day);
}
