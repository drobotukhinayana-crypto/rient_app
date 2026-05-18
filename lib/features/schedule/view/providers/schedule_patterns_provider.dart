import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/schedule/data/models/schedule_patterns_api/schedule_patterns_api.dart';
import 'package:rient_app/features/schedule/data/models/schedule_patterns_branch_api/update_branch_schedule_patterns_request.dart';
import 'package:rient_app/features/schedule/service/schedule_patterns_service.dart';

class SchedulePatternsQuery {
  const SchedulePatternsQuery({
    required this.branchId,
    this.workerId,
  });

  final int branchId;
  final int? workerId;

  @override
  bool operator ==(Object other) {
    return other is SchedulePatternsQuery &&
        other.branchId == branchId &&
        other.workerId == workerId;
  }

  @override
  int get hashCode => Object.hash(branchId, workerId);
}

/// GET /organizations/{id}/schedule_patterns/
final schedulePatternsProvider =
    FutureProvider.family<SchedulePatternsApiResponse, SchedulePatternsQuery>((
  ref,
  query,
) async {
  if (query.branchId <= 0) {
    throw Exception('Invalid branch id: ${query.branchId}');
  }
  final service = ref.watch(schedulePatternsServiceProvider);
  return service.getSchedulePatterns(
    branchId: query.branchId,
    workerId: query.workerId,
  );
});

/// Шаблоны текущего филиала (опционально — одного сотрудника).
final branchSchedulePatternsProvider =
    FutureProvider.family<SchedulePatternsApiResponse, int?>((
  ref,
  workerId,
) async {
  final branchId = ref.watch(currentBranchIdProvider);
  if (branchId == 0) throw Exception('No valid branch selected');
  return ref.watch(
    schedulePatternsProvider(
      SchedulePatternsQuery(branchId: branchId, workerId: workerId),
    ).future,
  );
});

/// Шаблоны по дню недели (mon..sun).
Map<String, SchedulePatternItemApi> schedulePatternsByDay(
  SchedulePatternsApiResponse response,
) {
  final map = <String, SchedulePatternItemApi>{};
  for (final item in response.results) {
    map[item.day.toLowerCase()] = item;
  }
  return map;
}

/// POST пакетного обновления шаблонов сотрудника.
Future<void> updateWorkerSchedulePatternsBatch(
  Ref ref, {
  required int workerId,
  required UpdateBranchSchedulePatternsRequest body,
}) {
  return ref.read(schedulePatternsServiceProvider).updateWorkerSchedulePatternsBatch(
        workerId: workerId,
        body: body,
      );
}
