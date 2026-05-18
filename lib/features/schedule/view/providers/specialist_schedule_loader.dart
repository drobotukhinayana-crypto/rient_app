import 'package:rient_app/features/schedule/data/models/schedule_patterns_api/schedule_patterns_api.dart';
import 'package:rient_app/features/schedule/data/models/schedule_patterns_branch_api/update_branch_schedule_patterns_request.dart';
import 'package:rient_app/features/schedule/data/models/worker_schedule_config_api/update_worker_schedule_config_request.dart';
import 'package:rient_app/features/schedule/data/models/worker_schedule_config_api/worker_schedule_config_api.dart';

/// Состояние формы «График специалиста», загруженное с API.
class SpecialistScheduleFormState {
  const SpecialistScheduleFormState({
    required this.scheduleTypeLabel,
    required this.weekdays,
    required this.weekends,
    required this.weekdayGroupStart,
    required this.weekdayGroupEnd,
    required this.weekendGroupStart,
    required this.weekendGroupEnd,
    this.configUuid,
    this.workDays = '1',
    this.offDays = '1',
    this.shiftStartDate,
    this.shiftWorkStart = '09:00',
    this.shiftWorkEnd = '20:00',
    this.loadedPatterns = const [],
  });

  final String scheduleTypeLabel;
  final List<SpecialistDayDraft> weekdays;
  final List<SpecialistDayDraft> weekends;
  final String weekdayGroupStart;
  final String weekdayGroupEnd;
  final String weekendGroupStart;
  final String weekendGroupEnd;
  final String? configUuid;
  final String workDays;
  final String offDays;
  final DateTime? shiftStartDate;
  final String shiftWorkStart;
  final String shiftWorkEnd;
  final List<SchedulePatternItemApi> loadedPatterns;

  bool get isShift => scheduleTypeLabel == 'Смена';
}

class SpecialistDayDraft {
  const SpecialistDayDraft({
    required this.label,
    required this.dayKey,
    required this.enabled,
    required this.start,
    required this.end,
    this.patternId,
    this.breakStart,
    this.breakEnd,
  });

  final String label;
  final String dayKey;
  final bool enabled;
  final String start;
  final String end;
  final int? patternId;
  final String? breakStart;
  final String? breakEnd;

  SpecialistDayDraft copyWith({
    bool? enabled,
    String? start,
    String? end,
    String? breakStart,
    String? breakEnd,
  }) {
    return SpecialistDayDraft(
      label: label,
      dayKey: dayKey,
      enabled: enabled ?? this.enabled,
      start: start ?? this.start,
      end: end ?? this.end,
      patternId: patternId,
      breakStart: breakStart ?? this.breakStart,
      breakEnd: breakEnd ?? this.breakEnd,
    );
  }
}

const _weekdayKeys = ['mon', 'tue', 'wed', 'thu', 'fri'];
const _weekendKeys = ['sat', 'sun'];
const _weekdayLabels = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ'];
const _weekendLabels = ['СБ', 'ВС'];

SpecialistScheduleFormState buildSpecialistFormFromApi({
  required List<SchedulePatternItemApi> patterns,
  Map<String, dynamic>? workerRow,
  List<SchedulePatternItemApi> loadedPatterns = const [],
}) {
  final byDay = <String, SchedulePatternItemApi>{};
  for (final p in patterns) {
    byDay[p.day.toLowerCase()] = p;
  }

  SpecialistDayDraft draftFor(String dayKey, String label) {
    final p = byDay[dayKey];
    if (p == null) {
      return SpecialistDayDraft(
        label: label,
        dayKey: dayKey,
        enabled: false,
        start: '09:00',
        end: '20:00',
      );
    }
    return SpecialistDayDraft(
      label: label,
      dayKey: dayKey,
      enabled: p.active,
      start: p.timeStartShort ?? '09:00',
      end: p.timeEndShort ?? '20:00',
      patternId: p.id,
      breakStart: p.breakStartShort,
      breakEnd: p.breakEndShort,
    );
  }

  final weekdays = [
    for (var i = 0; i < _weekdayKeys.length; i++)
      draftFor(_weekdayKeys[i], _weekdayLabels[i]),
  ];
  final weekends = [
    for (var i = 0; i < _weekendKeys.length; i++)
      draftFor(_weekendKeys[i], _weekendLabels[i]),
  ];

  String groupStart(List<SpecialistDayDraft> days) {
    final active = days.where((d) => d.enabled).toList();
    if (active.isEmpty) return '09:00';
    return active.first.start;
  }

  String groupEnd(List<SpecialistDayDraft> days) {
    final active = days.where((d) => d.enabled).toList();
    if (active.isEmpty) return '20:00';
    return active.first.end;
  }

  final config = workerRow?['schedule_config'];
  Map<String, dynamic>? configMap;
  if (config is Map) {
    configMap = config.map((k, v) => MapEntry(k.toString(), v));
  }

  final scheduleTypeRaw = configMap?['schedule_type'];
  final scheduleType = scheduleTypeRaw is num
      ? scheduleTypeRaw.toInt()
      : WorkerScheduleConfigType.week;
  final scheduleTypeLabel =
      scheduleType == WorkerScheduleConfigType.shift ? 'Смена' : 'Неделя';

  final shiftPattern = configMap?['schedule_shift_pattern']?.toString() ?? '1/1';
  final parts = shiftPattern.split('/');
  final workDays = parts.isNotEmpty ? parts[0] : '1';
  final offDays = parts.length > 1 ? parts[1] : '1';

  DateTime? shiftStart;
  final shiftDateRaw = configMap?['schedule_shift_start_date']?.toString();
  if (shiftDateRaw != null && shiftDateRaw.isNotEmpty) {
    final parsed = DateTime.tryParse(shiftDateRaw);
    if (parsed != null) {
      shiftStart = DateTime(parsed.year, parsed.month, parsed.day);
    }
  }

  final configStart = _shortTimeFromDynamic(configMap?['time_start']) ?? '09:00';
  final configEnd = _shortTimeFromDynamic(configMap?['time_end']) ?? '20:00';

  return SpecialistScheduleFormState(
    scheduleTypeLabel: scheduleTypeLabel,
    weekdays: weekdays,
    weekends: weekends,
    weekdayGroupStart: groupStart(weekdays),
    weekdayGroupEnd: groupEnd(weekdays),
    weekendGroupStart: groupStart(weekends),
    weekendGroupEnd: groupEnd(weekends),
    configUuid: configMap?['id']?.toString(),
    workDays: workDays,
    offDays: offDays,
    shiftStartDate: shiftStart,
    shiftWorkStart: configStart,
    shiftWorkEnd: configEnd,
    loadedPatterns: loadedPatterns.isNotEmpty ? loadedPatterns : patterns,
  );
}

String? _shortTimeFromDynamic(dynamic value) {
  if (value == null) return null;
  final s = value.toString();
  if (s.isEmpty) return null;
  return s.length >= 5 ? s.substring(0, 5) : s;
}

UpdateWorkerScheduleConfigRequest buildConfigPatchRequest({
  required String scheduleTypeLabel,
  required String weekdayGroupStart,
  required String weekdayGroupEnd,
  required String workDays,
  required String offDays,
  DateTime? shiftStartDate,
  required String shiftWorkStart,
  required String shiftWorkEnd,
}) {
  final isShift = scheduleTypeLabel == 'Смена';
  return UpdateWorkerScheduleConfigRequest(
    scheduleType: isShift
        ? WorkerScheduleConfigType.shift
        : WorkerScheduleConfigType.week,
    scheduleShiftPattern: isShift ? '$workDays/$offDays' : null,
    scheduleShiftStartDate: isShift ? shiftStartDate : null,
    timeStart: isShift ? shiftWorkStart : weekdayGroupStart,
    timeEnd: isShift ? shiftWorkEnd : weekdayGroupEnd,
  );
}

UpdateBranchSchedulePatternsRequest buildWorkerPatternsBatchRequest({
  required int branchId,
  required List<SchedulePatternItemApi> originalPatterns,
  required List<SpecialistDayDraft> allDays,
}) {
  final originalByDay = <String, SchedulePatternItemApi>{};
  for (final p in originalPatterns) {
    originalByDay[p.day.toLowerCase()] = p;
  }

  final items = <UpdateBranchSchedulePatternItem>[];
  for (final day in allDays) {
    final original = originalByDay[day.dayKey];
    if (original == null || day.patternId == null) continue;
    items.add(
      UpdateBranchSchedulePatternItem.fromWorkerPattern(
        original,
        branchId: branchId,
        timeStart: day.start,
        timeEnd: day.end,
        active: day.enabled,
      ),
    );
  }
  return UpdateBranchSchedulePatternsRequest(patterns: items);
}
