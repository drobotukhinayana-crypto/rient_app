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
