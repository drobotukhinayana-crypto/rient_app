import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/home/data/models/statistics/statistics.dart';
import 'package:rient_app/features/home/service/statistics_service.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';

/// Ключ недели: YYYY-MM-DD понедельника (для кэша по неделям).
String scheduleWeekKey(DateTime date) {
  final weekStart = date.subtract(
    Duration(days: date.weekday - 1),
  );
  final y = weekStart.year;
  final m = weekStart.month.toString().padLeft(2, '0');
  final d = weekStart.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

/// Ключ месяца: YYYY-MM (для кэша по месяцам).
String scheduleMonthKey(DateTime date) {
  final y = date.year;
  final m = date.month.toString().padLeft(2, '0');
  return '$y-$m';
}

/// Период статистики и опционально сотрудник (загруженность в расписании).
@immutable
class ScheduleStatisticsQuery {
  const ScheduleStatisticsQuery({
    required this.periodKey,
    this.workerId,
  });

  final String periodKey;
  final int? workerId;

  @override
  bool operator ==(Object other) {
    return other is ScheduleStatisticsQuery &&
        other.periodKey == periodKey &&
        other.workerId == workerId;
  }

  @override
  int get hashCode => Object.hash(periodKey, workerId);
}

/// Статистика (в т.ч. заполненность по дням) для заданного месяца.
/// Запрашиваем по неделям (те же диапазоны, что и в режиме «Неделя»), затем объединяем
/// [occupancyByDay], чтобы данные в месяце совпадали с недельным видом.
/// [query.periodKey] — ключ в формате YYYY-MM (см. [scheduleMonthKey]).
final scheduleStatisticsForMonthProvider =
    FutureProvider.family<Statistics, ScheduleStatisticsQuery>((ref, query) async {
  final branchId = ref.watch(currentBranchIdProvider);
  if (branchId == 0) {
    throw Exception('No valid branch selected');
  }
  final monthKey = query.periodKey;
  final parts = monthKey.split('-');
  if (parts.length != 2) throw Exception('Invalid month key: $monthKey');
  final y = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  if (y == null || m == null) throw Exception('Invalid month key: $monthKey');
  final monthStart = DateTime(y, m, 1);
  final monthEnd = DateTime(y, m + 1, 0);

  final service = ref.watch(statisticsServiceProvider);
  final workerId = query.workerId;
  final mergedOccupancyByDay = <DateTime, OccupancyByDay>{};
  final mergedAppointmentsByDay = <String, AppointmentByDayItem>{};
  Statistics? firstStats;

  DateTime currentWeekStart = monthStart.subtract(
    Duration(days: monthStart.weekday - 1),
  );

  while (true) {
    final weekEnd = currentWeekStart.add(const Duration(days: 6));
    if (_dateOnly(weekEnd).isBefore(monthStart)) {
      currentWeekStart = currentWeekStart.add(const Duration(days: 7));
      continue;
    }
    if (_dateOnly(currentWeekStart).isAfter(monthEnd)) break;

    final stats = await service.getStatistics(
      startDate: currentWeekStart,
      endDate: weekEnd,
      branchId: branchId,
      workerId: workerId,
    );
    firstStats ??= stats;
    for (final o in stats.occupancyByDay) {
      final key = _dateOnly(o.date);
      if (key.isBefore(monthStart) || key.isAfter(monthEnd)) continue;
      mergedOccupancyByDay[key] = o;
    }
    for (final a in stats.appointmentsByDay) {
      final parsed = DateTime.tryParse(a.date);
      if (parsed == null) continue;
      final key = _dateOnly(parsed);
      if (key.isBefore(monthStart) || key.isAfter(monthEnd)) continue;
      mergedAppointmentsByDay[a.date] = a;
    }
    currentWeekStart = currentWeekStart.add(const Duration(days: 7));
  }

  final sortedOccupancy = mergedOccupancyByDay.values.toList()
    ..sort((a, b) => a.date.compareTo(b.date));
  final sortedAppointmentsByDay = mergedAppointmentsByDay.values.toList()
    ..sort((a, b) => a.date.compareTo(b.date));

  final base = firstStats ??
      await service.getStatistics(
        startDate: monthStart,
        endDate: monthEnd,
        branchId: branchId,
        workerId: workerId,
      );
  return base.copyWith(
    occupancyByDay: sortedOccupancy,
    appointmentsByDay: sortedAppointmentsByDay,
  );
});

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Статистика (в т.ч. заполненность по дням) для заданной недели.
/// [query.periodKey] — ключ понедельника в формате YYYY-MM-DD (см. [scheduleWeekKey]).
final scheduleStatisticsForWeekProvider =
    FutureProvider.family<Statistics, ScheduleStatisticsQuery>((ref, query) async {
  final branchId = ref.watch(currentBranchIdProvider);
  if (branchId == 0) {
    throw Exception('No valid branch selected');
  }
  final weekKey = query.periodKey;
  final parts = weekKey.split('-');
  if (parts.length != 3) throw Exception('Invalid week key: $weekKey');
  final y = int.tryParse(parts[0]);
  final m = int.tryParse(parts[1]);
  final d = int.tryParse(parts[2]);
  if (y == null || m == null || d == null) {
    throw Exception('Invalid week key: $weekKey');
  }
  final weekStart = DateTime(y, m, d);
  final weekEnd = weekStart.add(const Duration(days: 6));
  final service = ref.watch(statisticsServiceProvider);
  return service.getStatistics(
    startDate: weekStart,
    endDate: weekEnd,
    branchId: branchId,
    workerId: query.workerId,
  );
});
