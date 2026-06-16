import 'package:rient_app/features/home/data/models/branches_api/branches_api.dart';
import 'package:rient_app/features/schedule/data/models/schedule_patterns_branch_api/schedule_patterns_branch_api.dart';
import 'package:rient_app/features/schedule/data/models/schedule_patterns_branch_api/update_branch_schedule_patterns_request.dart';
import 'package:rient_app/features/schedule/utils/schedule_day_key.dart';
import 'package:rient_app/features/schedule/view/providers/specialist_schedule_loader.dart';

bool preferBranchSchedulePattern(
  SchedulePatternBranchItemApi candidate,
  SchedulePatternBranchItemApi current,
) {
  if (candidate.active != current.active) return candidate.active;
  return candidate.id > current.id;
}

void putBranchSchedulePattern(
  Map<String, SchedulePatternBranchItemApi> byDay,
  SchedulePatternBranchItemApi pattern,
) {
  final key = canonicalScheduleDayKey(pattern.day);
  final existing = byDay[key];
  if (existing == null || preferBranchSchedulePattern(pattern, existing)) {
    byDay[key] = pattern;
  }
}

/// Объединяет шаблоны из API и из объекта филиала (включая неактивные дни).
List<SchedulePatternBranchItemApi> mergeBranchSchedulePatterns({
  required List<SchedulePatternBranchItemApi> fromApi,
  List<SchedulePattern>? fromBranch,
  required int branchId,
}) {
  final byDay = <String, SchedulePatternBranchItemApi>{};
  for (final pattern in fromApi) {
    putBranchSchedulePattern(byDay, pattern);
  }
  if (fromBranch == null) return byDay.values.toList();

  for (final pattern in fromBranch) {
    final day = pattern.day;
    if (day == null || day.isEmpty) continue;
    final patternBranch = pattern.branch;
    if (patternBranch != null && patternBranch != branchId) continue;
    putBranchSchedulePattern(
      byDay,
      SchedulePatternBranchItemApi(
        id: pattern.id ?? 0,
        branch: patternBranch ?? branchId,
        day: canonicalScheduleDayKey(day),
        timeStart: pattern.timeStart,
        timeEnd: pattern.timeEnd,
        active: pattern.active ?? false,
      ),
    );
  }
  return byDay.values.toList();
}

bool branchPatternScheduleChanged(
  SchedulePatternBranchItemApi? previous,
  SchedulePatternBranchItemApi next,
) {
  if (previous == null) return true;
  if (previous.active != next.active) return true;
  if (!next.active) return false;
  final prevStart = previous.timeStartShort ?? '';
  final prevEnd = previous.timeEndShort ?? '';
  final nextStart = next.timeStartShort ?? '';
  final nextEnd = next.timeEndShort ?? '';
  return prevStart != nextStart || prevEnd != nextEnd;
}

Map<String, SchedulePatternBranchItemApi> branchSchedulePatternsMapFromList(
  List<SchedulePatternBranchItemApi> patterns,
) {
  final map = <String, SchedulePatternBranchItemApi>{};
  for (final item in patterns) {
    map[canonicalScheduleDayKey(item.day)] = item;
  }
  return map;
}

/// Состояние формы «График филиала», загруженное с API.
class BranchScheduleFormState {
  const BranchScheduleFormState({
    required this.branchName,
    required this.weekdays,
    required this.weekends,
    required this.weekdayGroupStart,
    required this.weekdayGroupEnd,
    required this.weekendGroupStart,
    required this.weekendGroupEnd,
    this.loadedPatterns = const [],
  });

  final String branchName;
  final List<SpecialistDayDraft> weekdays;
  final List<SpecialistDayDraft> weekends;
  final String weekdayGroupStart;
  final String weekdayGroupEnd;
  final String weekendGroupStart;
  final String weekendGroupEnd;
  final List<SchedulePatternBranchItemApi> loadedPatterns;
}

const _weekdayKeys = ['mon', 'tue', 'wed', 'thu', 'fri'];
const _weekendKeys = ['sat', 'sun'];
const _weekdayLabels = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ'];
const _weekendLabels = ['СБ', 'ВС'];

BranchScheduleFormState buildBranchFormFromApi({
  required List<SchedulePatternBranchItemApi> patterns,
  required String branchName,
}) {
  final byDay = <String, SchedulePatternBranchItemApi>{};
  for (final pattern in patterns) {
    byDay[canonicalScheduleDayKey(pattern.day)] = pattern;
  }

  SpecialistDayDraft draftFor(String dayKey, String label) {
    final pattern = byDay[dayKey];
    if (pattern == null) {
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
      enabled: pattern.active,
      start: pattern.timeStartShort ?? '09:00',
      end: pattern.timeEndShort ?? '20:00',
      patternId: pattern.id,
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
    final active = days.where((day) => day.enabled).toList();
    if (active.isEmpty) return '09:00';
    return active.first.start;
  }

  String groupEnd(List<SpecialistDayDraft> days) {
    final active = days.where((day) => day.enabled).toList();
    if (active.isEmpty) return '20:00';
    return active.first.end;
  }

  return BranchScheduleFormState(
    branchName: branchName.trim().isNotEmpty ? branchName.trim() : 'Филиал',
    weekdays: weekdays,
    weekends: weekends,
    weekdayGroupStart: groupStart(weekdays),
    weekdayGroupEnd: groupEnd(weekdays),
    weekendGroupStart: groupStart(weekends),
    weekendGroupEnd: groupEnd(weekends),
    loadedPatterns: patterns,
  );
}

UpdateBranchSchedulePatternsRequest buildBranchPatternsBatchRequest({
  required List<SchedulePatternBranchItemApi> originalPatterns,
  required List<SpecialistDayDraft> allDays,
  List<SchedulePattern>? fallbackBranchPatterns,
  required int branchId,
}) {
  final mergedOriginals = mergeBranchSchedulePatterns(
    fromApi: originalPatterns,
    fromBranch: fallbackBranchPatterns,
    branchId: branchId,
  );
  final originalByDay = branchSchedulePatternsMapFromList(mergedOriginals);

  final originalById = {
    for (final pattern in mergedOriginals)
      if (pattern.id > 0) pattern.id: pattern,
  };

  final items = <UpdateBranchSchedulePatternItem>[];
  for (final day in allDays) {
    final dayKey = canonicalScheduleDayKey(day.dayKey);
    var original = originalByDay[dayKey];
    final patternId = day.patternId;
    if (original == null && patternId != null && patternId > 0) {
      original = originalById[patternId];
    }
    if (original == null || original.id <= 0) continue;

    items.add(
      UpdateBranchSchedulePatternItem.fromBranchPattern(
        original,
        timeStart: day.start,
        timeEnd: day.end,
        active: day.enabled,
      ),
    );
  }

  return UpdateBranchSchedulePatternsRequest(patterns: items);
}

List<SchedulePatternBranchItemApi> buildBranchPatternsAfterSave({
  required List<SchedulePatternBranchItemApi> originalPatterns,
  required List<SpecialistDayDraft> allDays,
  List<SchedulePattern>? fallbackBranchPatterns,
  required int branchId,
}) {
  final mergedOriginals = mergeBranchSchedulePatterns(
    fromApi: originalPatterns,
    fromBranch: fallbackBranchPatterns,
    branchId: branchId,
  );
  final byDay = branchSchedulePatternsMapFromList(mergedOriginals);

  for (final day in allDays) {
    final dayKey = canonicalScheduleDayKey(day.dayKey);
    final existing = byDay[dayKey];
    final patternId = day.patternId;
    final resolvedId = existing?.id ?? patternId ?? 0;
    if (resolvedId <= 0) continue;

    byDay[dayKey] = SchedulePatternBranchItemApi(
      id: resolvedId,
      branch: existing?.branch ?? branchId,
      day: dayKey,
      timeStart: UpdateBranchSchedulePatternItem.timeToApi(
        day.enabled ? day.start : (existing?.timeStart ?? day.start),
      ),
      timeEnd: UpdateBranchSchedulePatternItem.timeToApi(
        day.enabled ? day.end : (existing?.timeEnd ?? day.end),
      ),
      active: day.enabled,
    );
  }

  return byDay.values.toList();
}
