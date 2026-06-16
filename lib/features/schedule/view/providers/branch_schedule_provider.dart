import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/schedule/view/providers/branch_schedule_loader.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_patterns_branch_provider.dart';

final branchScheduleFormProvider =
    FutureProvider.family<BranchScheduleFormState, int>((ref, branchId) async {
  if (branchId <= 0) throw Exception('No valid branch selected');

  final patternsResponse =
      await ref.watch(branchSchedulePatternsBranchProvider(branchId).future);
  final branch = ref.watch(currentBranchProvider);
  final branchName = branch?.name?.trim() ?? 'Филиал';
  final mergedPatterns = mergeBranchSchedulePatterns(
    fromApi: patternsResponse.results,
    fromBranch: branch?.schedulePatterns,
    branchId: branchId,
  );

  return buildBranchFormFromApi(
    patterns: mergedPatterns,
    branchName: branchName,
  );
});
