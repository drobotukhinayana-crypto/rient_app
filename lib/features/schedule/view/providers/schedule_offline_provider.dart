import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:rient_app/core/network/app_connectivity_provider.dart';
import 'package:rient_app/core/network/app_offline.dart';
import 'package:rient_app/core/models/worker_entity_labels.dart';
import 'package:rient_app/core/providers/worker_entity_labels_provider.dart';
import 'package:rient_app/features/home/data/models/statistics/statistics.dart';
import 'package:rient_app/features/schedule/data/models/schedules_api/schedules_api.dart';
import 'package:rient_app/features/schedule/data/models/workers_api/workers_api.dart';
import 'package:rient_app/features/schedule/data/schedule_appointments_cache.dart';
import 'package:rient_app/features/schedule/service/schedule_offline_sync_service.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/schedule/view/components/specialist_select_dialog.dart';

export 'package:rient_app/features/schedule/view/providers/schedule_network_recovery.dart'
    show
        beginScheduleNetworkRecovery,
        confirmScheduleServerWhenBranchReady,
        refreshConnectivityAndWait,
        tryRecoverScheduleNetwork,
        tryRecoverScheduleNetworkAfterVpnOff;
export 'package:rient_app/features/schedule/view/providers/schedule_offline_invalidation.dart'
    show
        invalidateScheduleNetworkProviders,
        invalidateScheduleNetworkProvidersDeferred,
        scheduleServerUnreachableListenerProvider;
export 'package:rient_app/core/network/app_connectivity_provider.dart'
    show
        appHasNetworkProvider,
        appNoConnectionProvider,
        connectivityHasNetwork,
        connectivityCheckProvider,
        connectivityStatusProvider,
        markAppNetworkAvailable,
        markAppNetworkUnavailable,
        markScheduleServerReachable,
        markScheduleServerUnreachable,
        onScheduleNetworkFailure,
        resetScheduleNetworkStateForSession,
        scheduleNetworkRecoveryUntilProvider,
        scheduleServerReachableProvider,
        scheduleSessionBootstrapUntilProvider;

const scheduleOfflineCurrentWorkerIdKey = 'schedule_offline_current_worker_id_v1';

const scheduleOfflineEmptyWorkers = WorkersApiResponse(
  count: 0,
  next: null,
  previous: null,
  results: [],
);

const scheduleOfflineEmptySchedules = SchedulesApiResponse(
  count: 0,
  next: null,
  previous: null,
  results: [],
);

Statistics scheduleOfflineEmptyStatistics() => Statistics(
      appointments: const Appointments(total: 0, cancelled: 0, newCount: 0),
      appointmentsByDay: const [],
      incomeByDay: const [],
      services: const {},
      servicesByDay: const [],
      occupancy: 0,
      occupancyByDay: const [],
    );

/// Оффлайн-режим: нет интерфейса сети или API недоступен (TLS/таймаут), не 4xx.
final scheduleOfflineModeProvider = Provider<bool>((ref) {
  if (ref.watch(appNoConnectionProvider)) return true;
  return !ref.watch(scheduleServerReachableProvider);
});

/// Специалисты из локального кэша, если сеть недоступна.
final scheduleOfflineSpecialistsProvider =
    FutureProvider<List<SpecialistItem>>((ref) async {
  if (!ref.watch(scheduleOfflineModeProvider)) return const [];
  final labels =
      ref.watch(workerEntityLabelsProvider).value ??
      WorkerEntityLabels.defaults;
  final branchId = ref.watch(currentBranchIdProvider);
  if (branchId > 0) {
    final workersSnapshot =
        await ref.read(scheduleWorkersCacheProvider).readForBranch(branchId);
    if (workersSnapshot != null && workersSnapshot.workers.isNotEmpty) {
      return workersSnapshot.toSpecialistItems(labels);
    }
  }
  final snapshot = await ref.read(scheduleAppointmentsCacheProvider).read();
  return ScheduleAppointmentsCache.specialistsFromSnapshot(snapshot, labels);
});
