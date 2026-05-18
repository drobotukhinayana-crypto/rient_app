import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/schedule/service/workers_service.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_patterns_provider.dart';
import 'package:rient_app/features/schedule/view/providers/specialist_schedule_loader.dart';

class SpecialistScheduleLoadQuery {
  const SpecialistScheduleLoadQuery({required this.workerId});

  final int workerId;

  @override
  bool operator ==(Object other) =>
      other is SpecialistScheduleLoadQuery && other.workerId == workerId;

  @override
  int get hashCode => workerId.hashCode;
}

final specialistScheduleFormProvider =
    FutureProvider.family<SpecialistScheduleFormState, SpecialistScheduleLoadQuery>((
  ref,
  query,
) async {
  final branchId = ref.watch(currentBranchIdProvider);
  if (branchId == 0) throw Exception('No valid branch selected');

  final patternsResponse = await ref.watch(
    schedulePatternsProvider(
      SchedulePatternsQuery(branchId: branchId, workerId: query.workerId),
    ).future,
  );

  final workerRow = await ref.read(workersServiceProvider).getWorkerRow(
        workerId: query.workerId,
        branchId: branchId,
      );

  return buildSpecialistFormFromApi(
    patterns: patternsResponse.results,
    workerRow: workerRow,
    loadedPatterns: patternsResponse.results,
  );
});
