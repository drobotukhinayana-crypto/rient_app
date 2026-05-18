import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/schedule/service/schedules_service.dart';
import 'package:rient_app/features/schedule/view/components/work_schedule_mapper.dart';
import 'package:rient_app/features/schedule/view/components/work_schedule_mock_data.dart';
import 'package:rient_app/features/schedule/view/providers/workers_provider.dart';

class WorkScheduleMonthQuery {
  const WorkScheduleMonthQuery({
    required this.monthStart,
    this.highlightedCellDate,
  });

  final DateTime monthStart;
  final DateTime? highlightedCellDate;

  DateTime get monthEnd =>
      DateTime(monthStart.year, monthStart.month + 1, 0);

  @override
  bool operator ==(Object other) {
    return other is WorkScheduleMonthQuery &&
        other.monthStart.year == monthStart.year &&
        other.monthStart.month == monthStart.month &&
        other.highlightedCellDate?.year == highlightedCellDate?.year &&
        other.highlightedCellDate?.month == highlightedCellDate?.month &&
        other.highlightedCellDate?.day == highlightedCellDate?.day;
  }

  @override
  int get hashCode => Object.hash(
        monthStart.year,
        monthStart.month,
        highlightedCellDate?.year,
        highlightedCellDate?.month,
        highlightedCellDate?.day,
      );
}

final workScheduleMonthProvider =
    FutureProvider.family<List<WorkScheduleEmployeeRow>, WorkScheduleMonthQuery>((
  ref,
  query,
) async {
  final branchId = ref.watch(currentBranchIdProvider);
  if (branchId == 0) throw Exception('No valid branch selected');

  final workersResponse = await ref.watch(scheduleWorkersProvider.future);
  final schedulesService = ref.read(schedulesServiceProvider);

  final rows = <WorkScheduleEmployeeRow>[];
  for (final worker in workersResponse.results) {
    final schedules = await schedulesService.getWorkerSchedules(
      workerId: worker.id,
      dateGte: query.monthStart,
      dateLte: query.monthEnd,
    );
    rows.add(
      workScheduleEmployeeRow(
        worker: worker,
        monthStart: query.monthStart,
        schedules: schedules.results,
        highlightedCellDate: query.highlightedCellDate,
      ),
    );
  }
  return rows;
});
