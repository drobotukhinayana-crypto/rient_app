import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/home/data/models/statistics/statistics.dart';
import 'package:rient_app/features/home/service/statistics_service.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';

final statisticsProvider = FutureProvider<Statistics>((ref) async {
  final service = ref.watch(statisticsServiceProvider);

  // Добавляем зависимость от выбранного филиала, чтобы статистика обновлялась при его изменении
  ref.watch(selectedBranchProvider);

  // Получаем текущую дату
  final now = DateTime.now();

  // Первый день текущего месяца
  final startDate = DateTime(now.year, now.month, 1);

  // Последний день текущего месяца
  final endDate = DateTime(now.year, now.month + 1, 0);

  return service.getStatistics(
    startDate: startDate,
    endDate: endDate,
  );
});