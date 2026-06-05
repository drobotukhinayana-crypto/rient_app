import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/core/network/network_failure.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/schedule/data/models/available_workers_api/available_workers_api.dart';
import 'package:rient_app/features/schedule/data/models/workers_api/workers_api.dart';
import 'package:rient_app/features/schedule/service/workers_service.dart';
import 'package:rient_app/core/network/app_connectivity_provider.dart'
    show onScheduleNetworkFailure;
import 'package:rient_app/features/schedule/view/providers/schedule_offline_invalidation.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_offline_provider.dart';

/// Список рабочих (специалистов) для текущего филиала на странице расписания.
final scheduleWorkersProvider = FutureProvider<WorkersApiResponse>((ref) async {
  if (ref.watch(scheduleOfflineModeProvider)) {
    return scheduleOfflineEmptyWorkers;
  }
  final branchId = ref.watch(currentBranchIdProvider);
  if (branchId == 0) {
    throw Exception('No valid branch selected');
  }
  final service = ref.watch(workersServiceProvider);
  try {
    return await service.getWorkers(branchId: branchId);
  } catch (e) {
    final caused = e is CustomException ? e.causedError : e;
    onScheduleNetworkFailure(ref, caused ?? e);
    if (ref.read(scheduleOfflineModeProvider)) {
      return scheduleOfflineEmptyWorkers;
    }
    rethrow;
  }
});

/// Доступные сотрудники в конкретный день для текущего филиала.
final availableWorkersForDateProvider =
    FutureProvider.family<List<AvailableWorkerShift>, DateTime>((ref, date) async {
      if (ref.watch(scheduleOfflineModeProvider)) {
        return const [];
      }
      final branchId = ref.watch(currentBranchIdProvider);
      if (branchId == 0) {
        throw Exception('No valid branch selected');
      }
      final service = ref.watch(workersServiceProvider);
      final normalizedDate = DateTime(date.year, date.month, date.day);
      try {
        return await service.getAvailableWorkers(
          branchId: branchId,
          date: normalizedDate,
        );
      } catch (e) {
        final caused = e is CustomException ? e.causedError : e;
        onScheduleNetworkFailure(ref, caused ?? e);
        if (ref.read(scheduleOfflineModeProvider)) {
          return const [];
        }
        rethrow;
      }
    });

/// Рабочие дни сотрудников по данным /workers/?with_schedules=1
/// workerId -> Set<weekday>, где weekday: 1..7 (Mon..Sun).
final workerWeekdaysByIdProvider = FutureProvider<Map<int, Set<int>>>((
  ref,
) async {
  if (ref.watch(scheduleOfflineModeProvider)) {
    return const <int, Set<int>>{};
  }
  final branchId = ref.watch(currentBranchIdProvider);
  if (branchId == 0) return const <int, Set<int>>{};
  final service = ref.watch(workersServiceProvider);
  return service.getWorkersWorkingWeekdays(branchId: branchId);
});

/// Ключ для сохранения id выбранного специалиста в локальное хранилище.
const selectedSpecialistIdStorageKey = 'selected_specialist_id';

/// Id выбранного специалиста на странице расписания (сохраняется между переключениями и после перезапуска приложения).
final selectedSpecialistIdProvider = StateProvider<int?>((ref) => null);

/// Флаг: восстановлен ли выбор специалиста из хранилища в этой сессии.
final restoredSpecialistSelectionProvider = StateProvider<bool>((ref) => false);

/// Выбранная дата на странице расписания (для фильтра «кто работает в этот день»). По умолчанию — сегодня.
final selectedScheduleDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

/// Открыть расписание в режиме «День» на эту дату (например, из аналитики).
final openScheduleOnDayProvider = StateProvider<DateTime?>((ref) => null);
