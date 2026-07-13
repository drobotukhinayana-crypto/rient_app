import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/schedule/data/models/appointments_api/appointments_api.dart';
import 'package:rient_app/features/schedule/service/appointments_service.dart';
import 'package:rient_app/features/schedule/service/schedule_offline_sync_service.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_offline_provider.dart';
import 'package:rient_app/core/network/network_failure.dart';

class AppointmentsQuery {
  const AppointmentsQuery({
    required this.workerId,
    required this.dateTimeGte,
    required this.dateTimeLte,
  });

  final int? workerId;
  final DateTime dateTimeGte;
  final DateTime dateTimeLte;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AppointmentsQuery &&
            other.workerId == workerId &&
            other.dateTimeGte == dateTimeGte &&
            other.dateTimeLte == dateTimeLte);
  }

  @override
  int get hashCode => Object.hash(workerId, dateTimeGte, dateTimeLte);
}

final scheduleAppointmentsProvider =
    FutureProvider.family<List<AppointmentApi>, AppointmentsQuery>((ref, query) async {
      var branchId = ref.watch(currentBranchIdProvider);
      if (branchId == 0) {
        final restored = await ensureSelectedBranchRestored(ref);
        branchId = restored?.id ?? 0;
      }
      if (branchId == 0 || query.workerId == null) {
        return const <AppointmentApi>[];
      }

      final cache = ref.read(scheduleAppointmentsCacheProvider);
      final snapshot = await cache.read();
      final isOffline = ref.watch(scheduleOfflineModeProvider);
      final workerId = query.workerId!;

      List<AppointmentApi> fromCache() {
        if (snapshot == null) return const [];
        final effectiveBranchId =
            branchId > 0 ? branchId : snapshot.branchId;
        if (effectiveBranchId <= 0) return const [];
        // В оффлайне отдаём всё, что есть в кэше для воркера в видимом диапазоне,
        // даже если границы snapshot чуть уже/шире запроса.
        return cache.appointmentsForQuery(
          snapshot: snapshot,
          branchId: effectiveBranchId,
          workerId: workerId,
          dateTimeGte: query.dateTimeGte,
          dateTimeLte: query.dateTimeLte,
        );
      }

      if (isOffline) {
        return fromCache();
      }

      if (ref.read(appNoConnectionProvider)) {
        return fromCache();
      }

      final service = ref.watch(appointmentsServiceProvider);
      final fetchRange = expandAppointmentsFetchRange(
        query.dateTimeGte,
        query.dateTimeLte,
      );
      try {
        final response = await service.getAppointments(
          branchId: branchId,
          workerId: workerId,
          dateTimeGte: fetchRange.gte,
          dateTimeLte: fetchRange.lte,
        );
        if (!ref.mounted) return fromCache();
        ref.read(scheduleServerReachableProvider.notifier).state = true;
        final active = response.results.where((a) => a.isActive).toList();
        unawaited(
          cache.mergeWorkerAppointments(
            branchId: branchId,
            workerId: workerId,
            appointments: active,
            rangeFrom: fetchRange.gte,
            rangeTo: fetchRange.lte,
          ),
        );
        return filterActiveAppointmentsForVisibleRange(
          response.results,
          query.dateTimeGte,
          query.dateTimeLte,
        );
      } catch (e) {
        if (!ref.mounted) return fromCache();
        if (isPermissionDenied(e)) {
          return const <AppointmentApi>[];
        }
        if (isNetworkFailure(e) && !isClientHttpError(e)) {
          onScheduleNetworkFailure(ref, e);
        }
        final cached = fromCache();
        if (cached.isNotEmpty) {
          return cached;
        }
        return const <AppointmentApi>[];
      }
    });
