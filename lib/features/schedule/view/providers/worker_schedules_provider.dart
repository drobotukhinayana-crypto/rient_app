import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/schedule/data/models/schedules_api/create_worker_schedule_request.dart';
import 'package:rient_app/features/schedule/data/models/schedules_api/schedules_api.dart';
import 'package:rient_app/features/schedule/service/schedules_service.dart';

/// Параметры запроса графика сотрудника за период.
class WorkerSchedulesQuery {
  const WorkerSchedulesQuery({
    required this.workerId,
    required this.dateGte,
    required this.dateLte,
  });

  final int workerId;
  final DateTime dateGte;
  final DateTime dateLte;

  @override
  bool operator ==(Object other) {
    return other is WorkerSchedulesQuery &&
        other.workerId == workerId &&
        other.dateGte.year == dateGte.year &&
        other.dateGte.month == dateGte.month &&
        other.dateGte.day == dateGte.day &&
        other.dateLte.year == dateLte.year &&
        other.dateLte.month == dateLte.month &&
        other.dateLte.day == dateLte.day;
  }

  @override
  int get hashCode => Object.hash(
        workerId,
        dateGte.year,
        dateGte.month,
        dateGte.day,
        dateLte.year,
        dateLte.month,
        dateLte.day,
      );
}

/// Запрос графика сотрудника за календарный месяц.
WorkerSchedulesQuery workerSchedulesQueryForMonth(
  int workerId,
  DateTime month,
) {
  final monthStart = DateTime(month.year, month.month, 1);
  final monthEnd = DateTime(month.year, month.month + 1, 0);
  return WorkerSchedulesQuery(
    workerId: workerId,
    dateGte: monthStart,
    dateLte: monthEnd,
  );
}

/// GET /organizations/{id}/workers/{worker_id}/schedules/
final workerSchedulesProvider =
    FutureProvider.family<SchedulesApiResponse, WorkerSchedulesQuery>((
  ref,
  query,
) async {
  if (query.workerId <= 0) {
    throw Exception('Invalid worker id: ${query.workerId}');
  }
  final service = ref.watch(schedulesServiceProvider);
  return service.getWorkerSchedules(
    workerId: query.workerId,
    dateGte: query.dateGte,
    dateLte: query.dateLte,
  );
});

/// Записи графика сотрудника, сгруппированные по дате (YYYY-MM-DD).
Map<String, List<ScheduleItemApi>> schedulesByDate(
  SchedulesApiResponse response,
) {
  final map = <String, List<ScheduleItemApi>>{};
  for (final item in response.results) {
    map.putIfAbsent(item.date, () => []).add(item);
  }
  return map;
}

/// POST дневной записи графика. После успеха инвалидируйте [workerSchedulesProvider].
Future<ScheduleItemApi> createWorkerScheduleDay(
  Ref ref, {
  required int workerId,
  required CreateWorkerScheduleRequest body,
}) {
  return ref.read(schedulesServiceProvider).createWorkerSchedule(
        workerId: workerId,
        body: body,
      );
}

/// PATCH дневной записи графика. После успеха инвалидируйте [workerSchedulesProvider].
Future<ScheduleItemApi> updateWorkerScheduleDay(
  Ref ref, {
  required int workerId,
  required int scheduleId,
  required CreateWorkerScheduleRequest body,
}) {
  return ref.read(schedulesServiceProvider).updateWorkerSchedule(
        workerId: workerId,
        scheduleId: scheduleId,
        body: body,
      );
}
