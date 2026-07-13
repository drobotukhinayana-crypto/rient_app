import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/local_storage.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/schedule/data/models/appointments_api/appointments_api.dart';
import 'package:rient_app/features/schedule/data/schedule_appointments_cache.dart';
import 'package:rient_app/features/schedule/data/schedule_workers_cache.dart';
import 'package:rient_app/features/schedule/service/appointments_service.dart';
import 'package:rient_app/core/network/network_failure.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_offline_provider.dart';
import 'package:rient_app/features/schedule/view/providers/workers_provider.dart';

final scheduleAppointmentsCacheProvider = Provider<ScheduleAppointmentsCache>(
  (ref) => ScheduleAppointmentsCache(ref.watch(localStorageProvider)),
);

final scheduleWorkersCacheProvider = Provider<ScheduleWorkersCache>(
  (ref) => ScheduleWorkersCache(ref.watch(localStorageProvider)),
);

final scheduleOfflineSyncServiceProvider = Provider<ScheduleOfflineSyncService>(
  (ref) => ScheduleOfflineSyncService(ref),
);

class ScheduleOfflineSyncService {
  ScheduleOfflineSyncService(this.ref);

  final Ref ref;

  Future<void> syncIfOnline() async {
    try {
      if (ref.read(scheduleOfflineModeProvider)) return;
    } catch (_) {
      // Провайдер может быть mid-rebuild при выходе из оффлайна.
      return;
    }

    var branchId = ref.read(currentBranchIdProvider);
    if (branchId <= 0) {
      final restored = await ensureSelectedBranchRestored(ref);
      branchId = restored?.id ?? 0;
    }
    if (branchId <= 0) return;

    final workersResponse = await ref.read(scheduleWorkersProvider.future);
    final workers = workersResponse.results;
    if (workers.isNotEmpty) {
      await ref.read(scheduleWorkersCacheProvider).saveForBranch(
            branchId: branchId,
            workers: workers,
          );
    }
    final workerIds = workers.map((w) => w.id).where((id) => id > 0).toList();
    if (workerIds.isEmpty) return;

    final anchor = DateTime.now();
    final offlineFrom = ScheduleAppointmentsCache.offlineRangeStart(anchor);
    final offlineTo = ScheduleAppointmentsCache.offlineRangeEnd(anchor);
    final fetchRange = expandAppointmentsFetchRange(offlineFrom, offlineTo);
    final rangeFrom = fetchRange.gte;
    final rangeTo = fetchRange.lte;
    final service = ref.read(appointmentsServiceProvider);
    final cache = ref.read(scheduleAppointmentsCacheProvider);

    try {
      final byWorker = <int, List<AppointmentApi>>{};
      for (final workerId in workerIds) {
        final response = await service.getAppointments(
          branchId: branchId,
          workerId: workerId,
          dateTimeGte: rangeFrom,
          dateTimeLte: rangeTo,
        );
        byWorker[workerId] =
            response.results.where((a) => a.isActive).toList();
      }
      // Полный снимок на ±2 недели — чтобы холодный старт оффлайн показывал записи.
      await cache.save(
        ScheduleAppointmentsCacheSnapshot(
          branchId: branchId,
          rangeFrom: offlineFrom,
          rangeTo: offlineTo,
          cachedAt: DateTime.now(),
          byWorker: byWorker,
        ),
      );
      ref.read(scheduleServerReachableProvider.notifier).state = true;
    } catch (e) {
      if (isClientHttpError(e)) return;
      if (isNetworkFailure(e)) {
        onScheduleNetworkFailure(ref, e);
      }
    }
  }
}