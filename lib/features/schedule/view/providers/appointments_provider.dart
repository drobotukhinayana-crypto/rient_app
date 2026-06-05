import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/schedule/data/models/appointments_api/appointments_api.dart';
import 'package:rient_app/features/schedule/data/schedule_appointments_cache.dart';
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
      final branchId = ref.watch(currentBranchIdProvider);
      if (branchId == 0 || query.workerId == null) {
        return const <AppointmentApi>[];
      }

      final cache = ref.read(scheduleAppointmentsCacheProvider);
      final snapshot = await cache.read();
      final isOffline = ref.watch(scheduleOfflineModeProvider);
      final workerId = query.workerId!;

      List<AppointmentApi> fromCache() {
        if (snapshot == null) return const [];
        final anchor = DateTime.now();
        final inRange = ScheduleAppointmentsCache.isDateInOfflineRange(
              query.dateTimeGte,
              anchor,
            ) ||
            ScheduleAppointmentsCache.isDateInOfflineRange(
              query.dateTimeLte,
              anchor,
            );
        if (!inRange) return const [];
        return cache.appointmentsForQuery(
          snapshot: snapshot,
          branchId: branchId,
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
      try {
        final response = await service.getAppointments(
          branchId: branchId,
          workerId: workerId,
          dateTimeGte: query.dateTimeGte,
          dateTimeLte: query.dateTimeLte,
        );
        ref.read(scheduleServerReachableProvider.notifier).state = true;
        return response.results.where((a) => a.isActive).toList();
      } catch (e) {
        if (isNetworkFailure(e)) {
          onScheduleNetworkFailure(ref, e);
        }
        final cached = fromCache();
        if (cached.isNotEmpty) {
          return cached;
        }
        throw CustomException(causedError: e);
      }
    });
