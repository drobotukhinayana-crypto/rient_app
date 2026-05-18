import 'package:rient_app/features/schedule/data/models/schedules_api/schedules_api.dart';
import 'package:rient_app/features/schedule/data/models/workers_api/workers_api.dart';
import 'package:rient_app/features/schedule/service/schedules_service.dart';
import 'package:rient_app/features/schedule/view/components/work_schedule_mock_data.dart';

WorkScheduleDayCell workScheduleCellFromScheduleItem(
  ScheduleItemApi? item, {
  bool selected = false,
}) {
  if (item == null || !item.active) {
    return const WorkScheduleDayCell.dayOff();
  }
  final start = item.timeStartShort;
  final end = item.timeEndShort;
  if (start == null || end == null || start.isEmpty || end.isEmpty) {
    return const WorkScheduleDayCell.dayOff();
  }
  final tone = item.hours >= 10
      ? WorkScheduleShiftTone.full
      : WorkScheduleShiftTone.short;
  return WorkScheduleDayCell.shift(
    timeStart: start,
    timeEnd: end,
    tone: tone,
    isSelected: selected,
  );
}

WorkScheduleEmployeeRow workScheduleEmployeeRow({
  required WorkerApi worker,
  required DateTime monthStart,
  required List<ScheduleItemApi> schedules,
  DateTime? highlightedCellDate,
}) {
  final days = daysOfMonth(monthStart);
  final highlighted = highlightedCellDate != null
      ? DateTime(
          highlightedCellDate.year,
          highlightedCellDate.month,
          highlightedCellDate.day,
        )
      : null;

  final byDate = <String, ScheduleItemApi>{};
  for (final item in schedules) {
    byDate[item.date] = item;
  }

  final firstName = worker.firstName?.trim() ?? '';
  final lastName = worker.lastName?.trim() ?? '';
  final name = [firstName, lastName].where((p) => p.isNotEmpty).join(' ');
  final displayName = name.isNotEmpty ? name : 'Сотрудник #${worker.id}';

  return WorkScheduleEmployeeRow(
    id: worker.id.toString(),
    name: displayName,
    pictureUrl: worker.pictureThumbnail ?? worker.picture,
    monthCells: [
      for (final date in days)
        workScheduleCellFromScheduleItem(
          byDate[SchedulesService.dateToApi(date)],
          selected: highlighted != null &&
              highlighted.year == date.year &&
              highlighted.month == date.month &&
              highlighted.day == date.day,
        ),
    ],
  );
}
