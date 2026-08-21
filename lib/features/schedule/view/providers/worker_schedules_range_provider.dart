import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/schedule/data/models/schedules_api/schedules_api.dart';
import 'package:rient_app/features/schedule/service/schedules_service.dart';
import 'package:rient_app/features/schedule/service/worker_daily_schedules_loader.dart';
import 'package:rient_app/features/schedule/utils/worker_schedule_config_map.dart';
import 'package:rient_app/features/schedule/utils/worker_work_day.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_offline_provider.dart';
import 'package:rient_app/features/schedule/view/providers/workers_provider.dart';
import 'package:rient_app/features/schedule/view/providers/work_schedule_provider.dart';

class WorkerSchedulesRangeQuery {
  const WorkerSchedulesRangeQuery({
    required this.workerId,
    required this.rangeStart,
    required this.rangeEnd,
  });

  final int workerId;
  final DateTime rangeStart;
  final DateTime rangeEnd;

  DateTime get _startNorm => dateOnly(rangeStart);

  DateTime get _endNorm => dateOnly(rangeEnd);

  @override
  bool operator ==(Object other) {
    return other is WorkerSchedulesRangeQuery &&
        other.workerId == workerId &&
        other._startNorm == _startNorm &&
        other._endNorm == _endNorm;
  }

  @override
  int get hashCode => Object.hash(workerId, _startNorm, _endNorm);
}

class WorkerSchedulesRangeData {
  const WorkerSchedulesRangeData({
    required this.schedulesByDate,
    this.shiftConfig,
  });

  final Map<String, ScheduleItemApi> schedulesByDate;
  final Map<String, dynamic>? shiftConfig;

  ScheduleItemApi? scheduleOn(DateTime date) =>
      schedulesByDate[SchedulesService.dateToApi(date)];
}

final workerSchedulesRangeProvider =
    FutureProvider.family<WorkerSchedulesRangeData, WorkerSchedulesRangeQuery>((
  ref,
  query,
) async {
  if (ref.watch(scheduleOfflineModeProvider)) {
    return const WorkerSchedulesRangeData(schedulesByDate: {});
  }
  ref.watch(organizationIdProvider);
  ref.watch(workScheduleReloadTokenProvider);
  final branchId = ref.watch(currentBranchIdProvider);
  if (branchId == 0 || query.workerId <= 0) {
    return const WorkerSchedulesRangeData(schedulesByDate: {});
  }

  try {
    final schedulesService = ref.read(schedulesServiceProvider);

    final rows = await ref.read(scheduleWorkerScheduleRowsProvider.future);
    final workerRow = workerScheduleRowById(rows, query.workerId);
    final shiftConfig = workerScheduleConfigForBranch(workerRow, branchId);

    final schedules = await fetchMergedWorkerDailySchedules(
      schedulesService: schedulesService,
      workerId: query.workerId,
      branchId: branchId,
      rangeStart: query._startNorm,
      rangeEnd: query._endNorm,
      workerRow: workerRow,
      bustCache: true,
    );

    return WorkerSchedulesRangeData(
      schedulesByDate: indexDailySchedulesByDate(schedules),
      shiftConfig: shiftConfig,
    );
  } catch (_) {
    return const WorkerSchedulesRangeData(schedulesByDate: {});
  }
});
