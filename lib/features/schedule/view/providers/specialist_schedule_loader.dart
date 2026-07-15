import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/schedule/data/models/appointments_api/appointments_api.dart';
import 'package:rient_app/features/schedule/data/models/schedule_patterns_api/schedule_patterns_api.dart';
import 'package:rient_app/features/schedule/data/models/schedule_patterns_branch_api/schedule_patterns_branch_api.dart';
import 'package:rient_app/features/schedule/data/models/schedule_patterns_branch_api/update_branch_schedule_patterns_request.dart';
import 'package:rient_app/features/schedule/service/appointments_service.dart';
import 'package:rient_app/features/schedule/utils/schedule_day_key.dart';
import 'package:rient_app/features/schedule/utils/work_schedule_appointment_conflict.dart';
import 'package:rient_app/features/schedule/utils/worker_schedule_config_map.dart';
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
    this.branchPatternsByDay = const {},
    this.employeeName = '',
    this.employeeSpecialization,
    this.employeePictureUrl,
  });

  final String employeeName;
  final String? employeeSpecialization;
  final String? employeePictureUrl;
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
  final Map<String, SchedulePatternBranchItemApi> branchPatternsByDay;

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

  static const Object _copyWithUnset = Object();

  SpecialistDayDraft copyWith({
    bool? enabled,
    String? start,
    String? end,
    Object? breakStart = _copyWithUnset,
    Object? breakEnd = _copyWithUnset,
  }) {
    return SpecialistDayDraft(
      label: label,
      dayKey: dayKey,
      enabled: enabled ?? this.enabled,
      start: start ?? this.start,
      end: end ?? this.end,
      patternId: patternId,
      breakStart: identical(breakStart, _copyWithUnset)
          ? this.breakStart
          : breakStart as String?,
      breakEnd: identical(breakEnd, _copyWithUnset)
          ? this.breakEnd
          : breakEnd as String?,
    );
  }
}

const specialistWeekdayDayKeys = ['mon', 'tue', 'wed', 'thu', 'fri'];
const specialistWeekendDayKeys = ['sat', 'sun'];
const _weekdayKeys = specialistWeekdayDayKeys;
const _weekendKeys = specialistWeekendDayKeys;
const _weekdayLabels = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ'];
const _weekendLabels = ['СБ', 'ВС'];

String specialistEmployeeNameFromWorkerRow(Map<String, dynamic>? workerRow) {
  if (workerRow == null) return '';
  final first = workerRow['first_name']?.toString().trim() ?? '';
  final last = workerRow['last_name']?.toString().trim() ?? '';
  return [first, last].where((part) => part.isNotEmpty).join(' ');
}

String? specialistEmployeeSpecializationFromWorkerRow(
  Map<String, dynamic>? workerRow,
) {
  final value = workerRow?['specialization']?.toString().trim();
  if (value == null || value.isEmpty) return null;
  return value;
}

String? specialistEmployeePictureFromWorkerRow(Map<String, dynamic>? workerRow) {
  if (workerRow == null) return null;
  final thumbnail = workerRow['picture_thumbnail']?.toString().trim();
  if (thumbnail != null && thumbnail.isNotEmpty) return thumbnail;
  final picture = workerRow['picture']?.toString().trim();
  if (picture != null && picture.isNotEmpty) return picture;
  return null;
}

SpecialistScheduleFormState buildSpecialistFormFromApi({
  required List<SchedulePatternItemApi> patterns,
  required int branchId,
  Map<String, dynamic>? workerRow,
  List<SchedulePatternItemApi> loadedPatterns = const [],
  Map<String, SchedulePatternBranchItemApi> branchPatternsByDay = const {},
  int? workerId,
}) {
  final scoped = workerId == null
      ? patterns
      : patterns.where((p) => p.worker == workerId).toList();
  final byDay = <String, SchedulePatternItemApi>{};
  for (final p in scoped) {
    final key = canonicalScheduleDayKey(p.day);
    final existing = byDay[key];
    if (existing == null || p.id > existing.id) {
      byDay[key] = p;
    }
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

  final configMap = workerScheduleConfigForBranch(workerRow, branchId);
  final scheduleType = parseWorkerScheduleType(configMap?['schedule_type']);
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
    loadedPatterns: () {
      final source =
          loadedPatterns.isNotEmpty ? loadedPatterns : scoped;
      final deduped = <String, SchedulePatternItemApi>{};
      for (final p in source) {
        final key = canonicalScheduleDayKey(p.day);
        final existing = deduped[key];
        if (existing == null || p.id > existing.id) {
          deduped[key] = p;
        }
      }
      // Дни из byDay (свитчи формы) имеют приоритет по active/часам.
      for (final entry in byDay.entries) {
        deduped[entry.key] = entry.value;
      }
      return deduped.values.toList();
    }(),
    branchPatternsByDay: branchPatternsByDay,
    employeeName: () {
      final fromRow = specialistEmployeeNameFromWorkerRow(workerRow);
      return fromRow.isNotEmpty ? fromRow : 'Сотрудник';
    }(),
    employeeSpecialization:
        specialistEmployeeSpecializationFromWorkerRow(workerRow),
    employeePictureUrl: specialistEmployeePictureFromWorkerRow(workerRow),
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

int _timeToMinutes(String time) {
  final parts = time.split(':');
  final h = int.tryParse(parts.first) ?? 0;
  final m = int.tryParse(parts.length > 1 ? parts[1] : '0') ?? 0;
  return h * 60 + m;
}

SchedulePatternBranchItemApi? specialistBranchPatternForDayKey(
  String dayKey,
  Map<String, SchedulePatternBranchItemApi> patternsByDay,
) {
  return patternsByDay[canonicalScheduleDayKey(dayKey)];
}

/// Для группы дней: самое позднее открытие и самое раннее закрытие филиала.
({String? minStart, String? maxEnd}) specialistGroupBranchBounds(
  List<String> dayKeys,
  Map<String, SchedulePatternBranchItemApi> patternsByDay,
) {
  String? minStart;
  String? maxEnd;

  for (final dayKey in dayKeys) {
    final pattern = specialistBranchPatternForDayKey(dayKey, patternsByDay);
    if (pattern == null || !pattern.active) continue;
    final start = pattern.timeStartShort;
    final end = pattern.timeEndShort;
    if (start == null || end == null || start.isEmpty || end.isEmpty) {
      continue;
    }
    if (minStart == null ||
        _timeToMinutes(start) > _timeToMinutes(minStart)) {
      minStart = start;
    }
    if (maxEnd == null || _timeToMinutes(end) < _timeToMinutes(maxEnd)) {
      maxEnd = end;
    }
  }

  return (minStart: minStart, maxEnd: maxEnd);
}

String? validateSpecialistDayAgainstBranch(
  SpecialistDayDraft day,
  Map<String, SchedulePatternBranchItemApi> patternsByDay,
) {
  if (!day.enabled) return null;

  final pattern = specialistBranchPatternForDayKey(day.dayKey, patternsByDay);
  if (pattern == null || !pattern.active) {
    return 'филиал не работает в этот день';
  }

  final branchStart = pattern.timeStartShort;
  final branchEnd = pattern.timeEndShort;
  if (branchStart == null ||
      branchEnd == null ||
      branchStart.isEmpty ||
      branchEnd.isEmpty) {
    return null;
  }

  if (_timeToMinutes(day.start) < _timeToMinutes(branchStart)) {
    return 'начало смены не раньше $branchStart (открытие филиала)';
  }
  if (_timeToMinutes(day.end) > _timeToMinutes(branchEnd)) {
    return 'окончание смены не позже $branchEnd (закрытие филиала)';
  }
  return null;
}

String? validateSpecialistShiftTimesAgainstBranch({
  required String workStart,
  required String workEnd,
  required Map<String, SchedulePatternBranchItemApi> patternsByDay,
}) {
  final bounds = specialistGroupBranchBounds(
    [..._weekdayKeys, ..._weekendKeys],
    patternsByDay,
  );
  final branchStart = bounds.minStart;
  final branchEnd = bounds.maxEnd;
  if (branchStart == null || branchEnd == null) return null;

  if (_timeToMinutes(workStart) < _timeToMinutes(branchStart)) {
    return 'Начало смены не раньше $branchStart (открытие филиала)';
  }
  if (_timeToMinutes(workEnd) > _timeToMinutes(branchEnd)) {
    return 'Окончание смены не позже $branchEnd (закрытие филиала)';
  }
  return null;
}

/// Сообщение об ошибке валидации или null, если всё ок.
String? validateSpecialistWeekScheduleDays(
  List<SpecialistDayDraft> days, {
  Map<String, SchedulePatternBranchItemApi> branchPatternsByDay = const {},
}) {
  for (final day in days) {
    if (!day.enabled) continue;
    if (day.start.trim().isEmpty || day.end.trim().isEmpty) {
      return '«${day.label}»: укажите время работы';
    }
    if (_timeToMinutes(day.start) >= _timeToMinutes(day.end)) {
      return '«${day.label}»: время окончания должно быть позже начала';
    }
    final breakStart = day.breakStart?.trim() ?? '';
    final breakEnd = day.breakEnd?.trim() ?? '';
    if (breakStart.isEmpty != breakEnd.isEmpty) {
      return '«${day.label}»: укажите начало и конец перерыва';
    }
    if (breakStart.isNotEmpty &&
        breakEnd.isNotEmpty &&
        _timeToMinutes(breakStart) >= _timeToMinutes(breakEnd)) {
      return '«${day.label}»: некорректное время перерыва';
    }
    if (branchPatternsByDay.isNotEmpty) {
      final branchError =
          validateSpecialistDayAgainstBranch(day, branchPatternsByDay);
      if (branchError != null) {
        return '«${day.label}»: $branchError';
      }
    }
  }
  return null;
}

UpdateBranchSchedulePatternsRequest buildWorkerPatternsBatchRequest({
  required int branchId,
  required int workerId,
  required List<SchedulePatternItemApi> originalPatterns,
  required List<SpecialistDayDraft> allDays,
}) {
  final originalByDay = <String, SchedulePatternItemApi>{};
  for (final pattern in originalPatterns) {
    if (pattern.worker != workerId) continue;
    final dayKey = canonicalScheduleDayKey(pattern.day);
    originalByDay.putIfAbsent(dayKey, () => pattern);
  }

  final items = <UpdateBranchSchedulePatternItem>[];
  final seenBranchDay = <String>{};

  for (final day in allDays) {
    final dayKey = canonicalScheduleDayKey(day.dayKey);
    final branchDayKey = '$branchId|$dayKey';
    if (!seenBranchDay.add(branchDayKey)) continue;

    final original = originalByDay[dayKey];
    if (original == null) continue;

    items.add(
      UpdateBranchSchedulePatternItem.fromWorkerPattern(
        original,
        branchId: branchId,
        timeStart: day.start,
        timeEnd: day.end,
        active: day.enabled,
        breakStart: day.breakStart,
        breakEnd: day.breakEnd,
      ),
    );
  }
  return UpdateBranchSchedulePatternsRequest(patterns: items);
}

bool specialistDayDraftScheduleChanged(
  SpecialistDayDraft previous,
  SpecialistDayDraft next,
) {
  if (previous.enabled != next.enabled) return true;
  if (!next.enabled) return false;
  if (previous.start != next.start || previous.end != next.end) return true;
  final prevBreakStart = (previous.breakStart ?? '').trim();
  final prevBreakEnd = (previous.breakEnd ?? '').trim();
  final nextBreakStart = (next.breakStart ?? '').trim();
  final nextBreakEnd = (next.breakEnd ?? '').trim();
  return prevBreakStart != nextBreakStart || prevBreakEnd != nextBreakEnd;
}

WorkScheduleDayBounds _boundsFromSpecialistDayDraft(SpecialistDayDraft day) {
  return WorkScheduleDayBounds(
    isWorkingDay: day.enabled,
    workStart: day.start,
    workEnd: day.end,
    breakStart: day.breakStart,
    breakEnd: day.breakEnd,
  );
}

const _patternValidationHorizonDays = 365;
const _patternValidationMaxPages = 20;

Future<List<AppointmentApi>> _fetchActiveAppointmentsInRange({
  required WidgetRef ref,
  required int branchId,
  required int workerId,
  required DateTime from,
  required DateTime to,
}) async {
  final service = ref.read(appointmentsServiceProvider);
  final results = <AppointmentApi>[];
  var more = false;
  for (var page = 0; page < _patternValidationMaxPages; page++) {
    final response = await service.getAppointments(
      branchId: branchId,
      workerId: workerId,
      dateTimeGte: from,
      dateTimeLte: to,
      more: more,
    );
    results.addAll(response.results.where((a) => a.isActive));
    final nextUrl = response.next?.trim();
    if (nextUrl == null || nextUrl.isEmpty) break;
    more = true;
  }
  return results;
}

/// Проверка шаблона недели перед сохранением (как для одного дня в сетке графика).
Future<String?> validateSpecialistWeekPatternAgainstAppointments({
  required WidgetRef ref,
  required int branchId,
  required int workerId,
  required List<SpecialistDayDraft> previousDays,
  required List<SpecialistDayDraft> newDays,
}) async {
  if (branchId <= 0 || workerId <= 0) return null;

  final previousByKey = {
    for (final day in previousDays)
      canonicalScheduleDayKey(day.dayKey): day,
  };

  final boundsByWeekday = <int, WorkScheduleDayBounds>{};
  for (final day in newDays) {
    final key = canonicalScheduleDayKey(day.dayKey);
    final previous = previousByKey[key];
    if (previous != null &&
        !specialistDayDraftScheduleChanged(previous, day)) {
      continue;
    }
    final weekday = scheduleDayKeyToWeekday(day.dayKey);
    if (weekday == null) continue;
    boundsByWeekday[weekday] = _boundsFromSpecialistDayDraft(day);
  }

  if (boundsByWeekday.isEmpty) return null;

  final now = DateTime.now();
  final rangeStart = DateTime(now.year, now.month, now.day);
  final rangeEnd = rangeStart.add(
    const Duration(days: _patternValidationHorizonDays),
  ).subtract(const Duration(milliseconds: 1));

  final appointments = await _fetchActiveAppointmentsInRange(
    ref: ref,
    branchId: branchId,
    workerId: workerId,
    from: rangeStart,
    to: rangeEnd,
  );

  for (final appointment in appointments) {
    final range = appointmentTimeRange(appointment, rangeStart);
    final appointmentDay = DateTime(
      range.start.year,
      range.start.month,
      range.start.day,
    );
    if (appointmentDay.isBefore(rangeStart)) continue;

    final proposed = boundsByWeekday[range.start.weekday];
    if (proposed == null) continue;

    if (appointmentConflictsWithWorkScheduleChange(
      day: appointmentDay,
      appointmentStart: range.start,
      appointmentEnd: range.end,
      proposed: proposed,
    )) {
      return workScheduleAppointmentsConflictMessage;
    }
  }

  return null;
}
