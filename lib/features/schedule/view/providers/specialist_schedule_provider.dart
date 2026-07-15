import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/schedule/service/schedule_patterns_service.dart';
import 'package:rient_app/features/schedule/service/workers_service.dart';
import 'package:rient_app/features/schedule/view/components/work_schedule_mapper.dart';
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

/// Последнее успешное сохранение формы «…» — чтобы повторное открытие
/// не показывало устаревшие свитчи, пока GET ещё отдаёт старое/кэш.
final specialistScheduleLastSavedProvider =
    StateProvider<Map<int, SpecialistScheduleFormState>>((ref) => const {});

void rememberSpecialistScheduleSave(
  WidgetRef ref, {
  required int workerId,
  required SpecialistScheduleFormState form,
}) {
  ref.read(specialistScheduleLastSavedProvider.notifier).update(
        (current) => {...current, workerId: form},
      );
}

SpecialistScheduleFormState? takeSpecialistScheduleLastSaved(
  WidgetRef ref, {
  required int workerId,
}) {
  final current = ref.read(specialistScheduleLastSavedProvider);
  final saved = current[workerId];
  if (saved == null) return null;
  ref.read(specialistScheduleLastSavedProvider.notifier).update((map) {
    final next = Map<int, SpecialistScheduleFormState>.from(map);
    next.remove(workerId);
    return next;
  });
  return saved;
}

Future<SpecialistScheduleFormState> loadSpecialistScheduleForm({
  required WidgetRef ref,
  required int workerId,
  bool preferLastSaved = true,
}) async {
  if (preferLastSaved) {
    final saved = takeSpecialistScheduleLastSaved(ref, workerId: workerId);
    if (saved != null) return saved;
  }

  final branchId = ref.read(currentBranchIdProvider);
  if (branchId == 0) throw Exception('No valid branch selected');

  // Прямой запрос к API (как на сайте), без FutureProvider-кэша сессии.
  final patternsResponse =
      await ref.read(schedulePatternsServiceProvider).getSchedulePatterns(
            branchId: branchId,
            workerId: workerId,
          );

  final workerRow = await ref.read(workersServiceProvider).getWorkerRow(
        workerId: workerId,
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

  final patterns = mergeSchedulePatternsForWorker(
    fromBranchApi: patternsResponse.results,
    workerRow: workerRow,
  );

  return buildSpecialistFormFromApi(
    patterns: patterns,
    branchId: branchId,
    workerRow: workerRow,
    loadedPatterns: patterns,
    branchPatternsByDay: branchPatternsByDay,
    workerId: workerId,
  );
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

  final patterns = mergeSchedulePatternsForWorker(
    fromBranchApi: patternsResponse.results,
    workerRow: workerRow,
  );

  return buildSpecialistFormFromApi(
    patterns: patterns,
    branchId: branchId,
    workerRow: workerRow,
    loadedPatterns: patterns,
    branchPatternsByDay: branchPatternsByDay,
    workerId: query.workerId,
  );
});
