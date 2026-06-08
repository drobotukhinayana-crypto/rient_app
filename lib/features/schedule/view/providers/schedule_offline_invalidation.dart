import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/providers/worker_entity_labels_provider.dart';
import 'package:rient_app/features/schedule/view/providers/appointments_provider.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_offline_provider.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_statistics_provider.dart';
import 'package:rient_app/features/schedule/view/providers/schedules_provider.dart';
import 'package:rient_app/features/schedule/view/providers/worker_schedules_range_provider.dart';
import 'package:rient_app/features/schedule/view/providers/workers_provider.dart';

import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/features/home/view/providers/current_worker_id_provider.dart';

/// Сбрасывает зависшие онлайн-запросы расписания при входе в оффлайн.
void invalidateScheduleNetworkProviders(dynamic ref) {
  ref.invalidate(scheduleAppointmentsProvider);
  ref.invalidate(scheduleWorkersProvider);
  ref.invalidate(availableWorkersForDateProvider);
  ref.invalidate(workerWeekdaysByIdProvider);
  ref.invalidate(scheduleForDateProvider);
  ref.invalidate(workerSchedulesRangeProvider);
  ref.invalidate(scheduleStatisticsForWeekProvider);
  ref.invalidate(scheduleStatisticsForMonthProvider);
  ref.invalidate(scheduleOfflineSpecialistsProvider);
  ref.invalidate(currentWorkerIdProvider);
}

/// Глобально: нет сети / сервер недоступен → сброс зависших запросов.
final scheduleServerUnreachableListenerProvider = Provider<void>((ref) {
  ref.listen<String?>(tokenProvider, (previous, next) {
    final hadToken = previous != null && previous.isNotEmpty;
    final hasToken = next != null && next.isNotEmpty;
    if (!hadToken && hasToken) {
      resetScheduleNetworkStateForSession(ref);
      invalidateScheduleNetworkProviders(ref);
      ref.invalidate(workerEntityLabelsProvider);
    }
    if (hadToken && !hasToken) {
      resetScheduleNetworkStateForSession(ref);
    }
  });

  ref.listen<bool>(appNoConnectionProvider, (previous, next) {
    if (next) {
      final wasReachable = ref.read(scheduleServerReachableProvider);
      markScheduleServerUnreachable(ref);
      if (wasReachable) {
        invalidateScheduleNetworkProviders(ref);
      }
    }
  });

  ref.listen<bool>(scheduleServerReachableProvider, (previous, next) {
    if (previous != false && next == false) {
      invalidateScheduleNetworkProviders(ref);
      if (ref.read(appHasNetworkProvider)) {
        Future<void>.delayed(const Duration(seconds: 2), () {
          if (!ref.read(appHasNetworkProvider)) return;
          if (ref.read(scheduleServerReachableProvider)) return;
          markScheduleServerReachable(ref);
          invalidateScheduleNetworkProviders(ref);
        });
      }
    }
  });

  ref.listen<bool>(appHasNetworkProvider, (previous, next) {
    if (!next) return;
    if (!ref.read(scheduleServerReachableProvider)) {
      resetScheduleNetworkStateForSession(ref);
      invalidateScheduleNetworkProviders(ref);
    }
  });
});
