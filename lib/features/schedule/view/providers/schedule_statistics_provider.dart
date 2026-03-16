import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/home/data/models/statistics/statistics.dart';
import 'package:rient_app/features/home/service/statistics_service.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/schedule/view/providers/workers_provider.dart';

/// Статистика (в т.ч. заполненность по дням) для недели выбранной даты на странице расписания.
final scheduleStatisticsProvider =
    FutureProvider<Statistics>((ref) async {
  final branchId = ref.watch(currentBranchIdProvider);
  if (branchId == 0) {
    throw Exception('No valid branch selected');
  }
  final selectedDate = ref.watch(selectedScheduleDateProvider);
  final weekStart = selectedDate.subtract(
    Duration(days: selectedDate.weekday - 1),
  );
  final weekEnd = weekStart.add(const Duration(days: 6));
  final service = ref.watch(statisticsServiceProvider);
  return service.getStatistics(
    startDate: weekStart,
    endDate: weekEnd,
    branchId: branchId,
  );
});
