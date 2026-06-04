import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/home/view/providers/current_worker_id_provider.dart';
import 'package:rient_app/features/schedule/data/models/schedule_patterns_branch_api/schedule_patterns_branch_api.dart';
import 'package:rient_app/features/schedule/data/models/workers_api/workers_api.dart';
import 'package:rient_app/features/schedule/service/schedule_patterns_service.dart';
import 'package:rient_app/features/schedule/service/schedules_service.dart';
import 'package:rient_app/features/schedule/service/workers_service.dart';
import 'package:rient_app/features/schedule/view/components/work_schedule_mapper.dart';
import 'package:rient_app/features/schedule/view/components/work_schedule_mock_data.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_patterns_branch_provider.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_patterns_provider.dart';
import 'package:rient_app/features/schedule/view/providers/schedules_provider.dart';
import 'package:rient_app/features/schedule/view/providers/worker_schedules_range_provider.dart';
import 'package:rient_app/features/schedule/view/providers/workers_provider.dart';

class WorkScheduleMonthQuery {
  const WorkScheduleMonthQuery({
    required this.monthStart,
    this.highlightedCellDate,
    this.loadEpoch = 0,
  });

  final DateTime monthStart;
  final DateTime? highlightedCellDate;
  final int loadEpoch;

  DateTime get monthEnd =>
      DateTime(monthStart.year, monthStart.month + 1, 0);

  @override
  bool operator ==(Object other) {
    return other is WorkScheduleMonthQuery &&
        other.monthStart.year == monthStart.year &&
        other.monthStart.month == monthStart.month &&
        other.highlightedCellDate?.year == highlightedCellDate?.year &&
        other.highlightedCellDate?.month == highlightedCellDate?.month &&
        other.highlightedCellDate?.day == highlightedCellDate?.day &&
        other.loadEpoch == loadEpoch;
  }

  @override
  int get hashCode => Object.hash(
        monthStart.year,
        monthStart.month,
        highlightedCellDate?.year,
        highlightedCellDate?.month,
        highlightedCellDate?.day,
        loadEpoch,
      );
}

final workScheduleReloadTokenProvider = StateProvider<int>((ref) => 0);

void bumpWorkScheduleReloadToken(WidgetRef ref) {
  ref.read(workScheduleReloadTokenProvider.notifier).update((v) => v + 1);
}

Future<List<WorkScheduleEmployeeRow>> _loadWorkScheduleMonthRows(
  ProviderContainer container,
  WorkScheduleMonthQuery query, {
  bool bustCache = false,
}) async {
  final branchId = container.read(currentBranchIdProvider);
  if (branchId == 0) throw Exception('No valid branch selected');

  // Всегда свежий список сотрудников с API (не кэш .future после invalidate).
  final workersResponse =
      await container.refresh(scheduleWorkersProvider.future);

  final schedulesService = container.read(schedulesServiceProvider);
  final workersService = container.read(workersServiceProvider);

  final workers =
      await _workersForWorkSchedule(container, workersResponse.results);
  final branch = container.read(currentBranchProvider);
  final branchName = branch?.name?.trim() ?? 'Филиал';

  final patternsService = container.read(schedulePatternsServiceProvider);
  Map<String, SchedulePatternBranchItemApi> branchPatternsByDay;
  try {
    final branchPatternsResponse =
        await patternsService.getBranchSchedulePatterns(branchId: branchId);
    branchPatternsByDay = branchSchedulePatternsByDay(branchPatternsResponse);
  } catch (_) {
    branchPatternsByDay = const {};
  }
  if (branchPatternsByDay.isEmpty) {
    branchPatternsByDay = branchSchedulePatternsByDayFromBranchApi(
      branch?.schedulePatterns,
      branchId,
    );
  }

  final patternsResponse = await container
      .read(schedulePatternsServiceProvider)
      .getSchedulePatterns(branchId: branchId);
  final patternsByWorker =
      groupSchedulePatternsByWorker(patternsResponse.results);

  final branchSchedulesResponse = await schedulesService.getSchedules(
    branchId: branchId,
    dateGte: query.monthStart,
    dateLte: query.monthEnd,
    bustCache: bustCache,
  );

  final workerRows = await Future.wait(
    workers.map(
      (worker) => workersService.getWorkerRow(
        workerId: worker.id,
        branchId: branchId,
      ),
    ),
  );

  final rows = <WorkScheduleEmployeeRow>[];
  for (var i = 0; i < workers.length; i++) {
    final worker = workers[i];
    final schedules = await schedulesService.getWorkerSchedules(
      workerId: worker.id,
      dateGte: query.monthStart,
      dateLte: query.monthEnd,
      bustCache: bustCache,
    );
    final mergedSchedules = mergeWorkerScheduleSources(
      fromWorkerEndpoint: schedules.results,
      fromBranchEndpoint: branchSchedulesResponse.results,
      workerId: worker.id,
      branchId: branchId,
    );
    rows.add(
      workScheduleEmployeeRow(
        worker: worker,
        monthStart: query.monthStart,
        branchId: branchId,
        schedules: mergedSchedules,
        patterns: mergeSchedulePatternsForWorker(
          fromBranchApi: patternsByWorker[worker.id] ?? const [],
          workerRow: workerRows[i],
        ),
        branchPatternsByDay: branchPatternsByDay,
        workerRow: workerRows[i],
        highlightedCellDate: query.highlightedCellDate,
      ),
    );
  }

  final branchRow = workScheduleBranchRow(
    monthStart: query.monthStart,
    branchName: branchName,
    patternsByDay: branchPatternsByDay,
  );
  return [branchRow, ...rows];
}

final workScheduleMonthProvider =
    FutureProvider.family<List<WorkScheduleEmployeeRow>, WorkScheduleMonthQuery>((
  ref,
  query,
) async {
  ref.watch(workScheduleReloadTokenProvider);
  ref.watch(currentBranchIdProvider);
  return _loadWorkScheduleMonthRows(ref.container, query);
});

/// Сотрудник видит только свой график; владелец/менеджер — всех в филиале.
Future<List<WorkerApi>> _workersForWorkSchedule(
  ProviderContainer container,
  List<WorkerApi> branchWorkers,
) async {
  final roleId = container.read(roleProvider);
  if (roleId != UserRole.worker.value) {
    return branchWorkers;
  }

  final selfId = await container.read(currentWorkerIdProvider.future);
  if (selfId == null || selfId <= 0) {
    throw Exception('Worker profile not found');
  }

  final own = branchWorkers.where((w) => w.id == selfId).toList();
  if (own.isEmpty) {
    throw Exception('Worker not found in branch');
  }
  return own;
}

void invalidateWorkScheduleCaches(
  WidgetRef ref, {
  int? branchId,
  int? workerId,
}) {
  ref.invalidate(schedulePatternsProvider);
  ref.invalidate(scheduleWorkersProvider);
  if (branchId != null && branchId > 0) {
    ref.invalidate(branchSchedulePatternsBranchProvider(branchId));
    ref.invalidate(
      schedulePatternsProvider(
        SchedulePatternsQuery(branchId: branchId, workerId: workerId),
      ),
    );
  }
  ref.invalidate(workScheduleMonthProvider);
  ref.invalidate(workerSchedulesRangeProvider);
  ref.invalidate(scheduleForDateProvider);
  bumpWorkScheduleReloadToken(ref);
}

Future<List<WorkScheduleEmployeeRow>> reloadWorkScheduleMonth(
  WidgetRef ref,
  WorkScheduleMonthQuery query, {
  int? branchId,
  int? workerId,
}) async {
  final container = ProviderScope.containerOf(ref.context, listen: false);
  final rows = await _loadWorkScheduleMonthRows(
    container,
    query,
    bustCache: true,
  );
  invalidateWorkScheduleCaches(ref, branchId: branchId, workerId: workerId);
  return rows;
}
