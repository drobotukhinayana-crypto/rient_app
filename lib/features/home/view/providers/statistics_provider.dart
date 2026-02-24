import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/home/data/models/statistics/statistics.dart';
import 'package:rient_app/features/home/service/statistics_service.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/home/view/providers/selected_date_provider.dart';

final statisticsProvider = FutureProvider<Statistics>((ref) async {
  final service = ref.watch(statisticsServiceProvider);

  // Ждем загрузки списка филиалов
  final branchesResponse = await ref.watch(branchesProvider.future);

  // Проверяем, что есть хотя бы один филиал с валидным ID
  if (branchesResponse.results.isEmpty || branchesResponse.results.first.id == null) {
    throw Exception('No valid branch found');
  }

  // Получаем выбранную дату
  final selectedDate = ref.watch(selectedDateProvider);

  // Используем выбранную дату как startDate и endDate (данные за один день)
  return service.getStatistics(
    startDate: selectedDate,
    endDate: selectedDate,
  );
});