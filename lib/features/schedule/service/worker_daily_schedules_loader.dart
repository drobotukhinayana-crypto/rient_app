import 'package:rient_app/features/schedule/data/models/schedules_api/schedules_api.dart';
import 'package:rient_app/features/schedule/service/schedules_service.dart';
import 'package:rient_app/features/schedule/utils/worker_schedule_config_map.dart';
import 'package:rient_app/features/schedule/utils/worker_work_day.dart';
import 'package:rient_app/features/schedule/view/components/work_schedule_mapper.dart';

/// Дневные записи графика сотрудника за период — тот же источник, что на сайте:
/// `schedules/?key__in=worker/{id}` (+ fallback workers/.../schedules/).
Future<List<ScheduleItemApi>> fetchMergedWorkerDailySchedules({
  required SchedulesService schedulesService,
  required int workerId,
  required int branchId,
  required DateTime rangeStart,
  required DateTime rangeEnd,
  Map<String, dynamic>? workerRow,
  bool bustCache = false,
}) async {
  if (workerId <= 0 || branchId <= 0) return const [];

  final start = dateOnly(rangeStart);
  final end = dateOnly(rangeEnd);
  final shiftConfig = workerScheduleConfigForBranch(workerRow, branchId);
  final keyId = shiftConfig?['id']?.toString();
  final daysInRange = end.difference(start).inDays.abs() + 1;
  final pageSize = (daysInRange * 4).clamp(31, 500);
  final keyIn = 'worker/$workerId';

  Future<List<ScheduleItemApi>> fetchMergedFallback() async {
    final responses = await Future.wait([
      schedulesService.getWorkerSchedules(
        workerId: workerId,
        dateGte: start,
        dateLte: end,
        pageSize: pageSize,
        bustCache: bustCache,
      ),
      schedulesService.getSchedules(
        branchId: branchId,
        dateGte: start,
        dateLte: end,
        pageSize: pageSize,
        bustCache: bustCache,
      ),
    ]);
    return mergeWorkerScheduleSources(
      fromWorkerEndpoint: responses[0].results,
      fromBranchEndpoint: responses[1].results,
      workerId: workerId,
      branchId: branchId,
    );
  }

  if (keyId != null && keyId.isNotEmpty) {
    var response = await schedulesService.getSchedules(
      branchId: branchId,
      dateGte: start,
      dateLte: end,
      pageSize: pageSize,
      keyIn: keyIn,
      keyId: keyId,
      ordering: 'date',
      bustCache: bustCache,
    );
    if (response.results.isEmpty) {
      response = await schedulesService.getSchedules(
        branchId: branchId,
        dateGte: start,
        dateLte: end,
        pageSize: pageSize,
        keyIn: keyIn,
        ordering: 'date',
        bustCache: bustCache,
      );
    }
    if (response.results.isNotEmpty) {
      return response.results;
    }
  }

  return fetchMergedFallback();
}
