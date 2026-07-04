import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/schedule/service/schedule_patterns_service.dart';
import 'package:rient_app/features/schedule/service/workers_service.dart';
import 'package:rient_app/features/schedule/view/providers/branch_schedule_loader.dart';
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

  var branch = ref.read(currentBranchProvider);
  if (branch == null) {
    try {
      await ref.read(branchesProvider.future);
    } catch (_) {}
    branch = ref.read(currentBranchProvider);
  }

  final patternsService = ref.read(schedulePatternsServiceProvider);
  final branchPatternsList = await (() async {
    try {
      final response =
          await patternsService.getBranchSchedulePatterns(branchId: branchId);
      return mergeBranchSchedulePatterns(
        fromApi: response.results,
        fromBranch: branch?.schedulePatterns,
        branchId: branchId,
      );
    } catch (_) {
      return mergeBranchSchedulePatterns(
        fromApi: const [],
        fromBranch: branch?.schedulePatterns,
        branchId: branchId,
      );
    }
  })();
  final branchPatternsByDay =
      branchSchedulePatternsMapFromList(branchPatternsList);

  return buildSpecialistFormFromApi(
    patterns: patternsResponse.results,
    branchId: branchId,
    workerRow: workerRow,
    loadedPatterns: patternsResponse.results,
    branchPatternsByDay: branchPatternsByDay,
  );
});
