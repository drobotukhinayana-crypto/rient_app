import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/schedule/data/models/schedule_patterns_branch_api/schedule_patterns_branch_api.dart';
import 'package:rient_app/features/schedule/data/models/schedule_patterns_branch_api/update_branch_schedule_patterns_request.dart';
import 'package:rient_app/features/schedule/service/schedule_patterns_service.dart';
import 'package:rient_app/features/schedule/utils/schedule_day_key.dart';

/// GET /organizations/{id}/schedule_patterns_branch/?branch__id={id}
final branchSchedulePatternsBranchProvider =
    FutureProvider.family<SchedulePatternsBranchApiResponse, int?>((
  ref,
  branchId,
) async {
  final service = ref.watch(schedulePatternsServiceProvider);
  return service.getBranchSchedulePatterns(branchId: branchId);
});

/// Шаблоны графика для текущего выбранного филиала.
final currentBranchSchedulePatternsBranchProvider =
    FutureProvider<SchedulePatternsBranchApiResponse>((ref) async {
  final branchId = ref.watch(currentBranchIdProvider);
  if (branchId == 0) throw Exception('No valid branch selected');
  return ref.watch(branchSchedulePatternsBranchProvider(branchId).future);
});

/// Шаблоны филиала по дню недели (mon..sun).
Map<String, SchedulePatternBranchItemApi> branchSchedulePatternsByDay(
  SchedulePatternsBranchApiResponse response,
) {
  final map = <String, SchedulePatternBranchItemApi>{};
  for (final item in response.results) {
    map[canonicalScheduleDayKey(item.day)] = item;
  }
  return map;
}

/// POST пакетного обновления шаблонов филиала.
/// После успеха инвалидируйте [branchSchedulePatternsBranchProvider].
Future<void> updateBranchSchedulePatternsBatch(
  Ref ref, {
  required int branchId,
  required UpdateBranchSchedulePatternsRequest body,
}) {
  return ref.read(schedulePatternsServiceProvider).updateBranchSchedulePatternsBatch(
        branchId: branchId,
        body: body,
      );
}
