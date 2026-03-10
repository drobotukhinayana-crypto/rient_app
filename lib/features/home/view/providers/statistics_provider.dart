import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/home/data/models/statistics/statistics.dart';
import 'package:rient_app/features/home/service/statistics_service.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/home/view/providers/selected_date_provider.dart';

final statisticsProvider = FutureProvider<Statistics>((ref) async {
  final service = ref.watch(statisticsServiceProvider);

  // Получаем текущий branchId (учитывает выбранный филиал)
  final branchId = ref.watch(currentBranchIdProvider);

  // Проверяем, что branchId валидный
  if (branchId == 0) {
    throw Exception('No valid branch found');
  }

  // Получаем выбранную дату и границы текущей недели (пн–вс) для occupancy по дням
  final selectedDate = ref.watch(selectedDateProvider);
  final selectedNorm =
      DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
  final weekStart =
      selectedNorm.subtract(Duration(days: selectedDate.weekday - 1));
  final weekEnd = weekStart.add(const Duration(days: 6));

  return service.getStatistics(
    startDate: weekStart,
    endDate: weekEnd,
    branchId: branchId,
  );
});
