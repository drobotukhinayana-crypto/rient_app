import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/home/data/models/statistics/statistics.dart';
import 'package:rient_app/features/home/service/statistics_service.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/home/view/providers/current_worker_id_provider.dart';
import 'package:rient_app/features/home/view/providers/selected_date_provider.dart';

final statisticsProvider = FutureProvider<Statistics>((ref) async {
  final service = ref.watch(statisticsServiceProvider);

  // Получаем текущий branchId (учитывает выбранный филиал)
  final branchId = ref.watch(currentBranchIdProvider);

  // Проверяем, что branchId валидный
  if (branchId == 0) {
    throw Exception('No valid branch found');
  }

  final roleId = ref.watch(roleProvider);
  final workerId = roleId == UserRole.worker.value
      ? await ref.watch(currentWorkerIdProvider.future)
      : null;
  if (roleId == UserRole.worker.value && (workerId == null || workerId <= 0)) {
    throw Exception('Не найден worker.id в accounts');
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
    workerId: workerId,
  );
});
