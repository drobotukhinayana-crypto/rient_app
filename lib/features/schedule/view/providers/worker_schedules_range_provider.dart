import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/schedule/data/models/schedules_api/schedules_api.dart';
import 'package:rient_app/features/schedule/service/schedules_service.dart';
import 'package:rient_app/features/schedule/service/workers_service.dart';
import 'package:rient_app/features/schedule/utils/worker_schedule_config_map.dart';
import 'package:rient_app/features/schedule/utils/worker_work_day.dart';
import 'package:rient_app/features/schedule/view/components/work_schedule_mapper.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_offline_provider.dart';
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
  ref.watch(workScheduleReloadTokenProvider);
  final branchId = ref.watch(currentBranchIdProvider);
  if (branchId == 0 || query.workerId <= 0) {
    return const WorkerSchedulesRangeData(schedulesByDate: {});
  }

  final schedulesService = ref.read(schedulesServiceProvider);
  final workersService = ref.read(workersServiceProvider);

  final workerResponse = await schedulesService.getWorkerSchedules(
    workerId: query.workerId,
    dateGte: query._startNorm,
    dateLte: query._endNorm,
    bustCache: true,
  );
  final branchResponse = await schedulesService.getSchedules(
    branchId: branchId,
    dateGte: query._startNorm,
    dateLte: query._endNorm,
    bustCache: true,
  );
  final merged = mergeWorkerScheduleSources(
    fromWorkerEndpoint: workerResponse.results,
    fromBranchEndpoint: branchResponse.results,
    workerId: query.workerId,
    branchId: branchId,
  );

  final workerRow = await workersService.getWorkerRow(
    workerId: query.workerId,
    branchId: branchId,
  );

  return WorkerSchedulesRangeData(
    schedulesByDate: indexDailySchedulesByDate(merged),
    shiftConfig: workerScheduleConfigForBranch(workerRow, branchId),
  );
});
