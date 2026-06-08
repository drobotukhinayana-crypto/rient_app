import 'package:flutter/scheduler.dart';
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

/// Инвалидация на следующий кадр — не ломает провайдеры в том же build.
void invalidateScheduleNetworkProvidersDeferred(dynamic ref) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    if (!ref.mounted) return;
    invalidateScheduleNetworkProviders(ref);
  });
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
        invalidateScheduleNetworkProvidersDeferred(ref);
      }
    }
  });

  ref.listen<bool>(scheduleServerReachableProvider, (previous, next) {
    if (previous != false && next == false) {
      invalidateScheduleNetworkProvidersDeferred(ref);
      if (ref.read(appHasNetworkProvider)) {
        Future<void>.delayed(const Duration(seconds: 2), () {
          if (!ref.mounted) return;
          if (!ref.read(appHasNetworkProvider)) return;
          if (ref.read(scheduleServerReachableProvider)) return;
          markScheduleServerReachable(ref);
          invalidateScheduleNetworkProvidersDeferred(ref);
        });
      }
    }
  });

  ref.listen<bool>(appHasNetworkProvider, (previous, next) {
    if (!next) return;
    if (!ref.read(scheduleServerReachableProvider)) {
      resetScheduleNetworkStateForSession(ref);
      invalidateScheduleNetworkProvidersDeferred(ref);
    }
  });
});
