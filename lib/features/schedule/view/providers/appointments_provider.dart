import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/schedule/data/models/appointments_api/appointments_api.dart';
import 'package:rient_app/features/schedule/service/appointments_service.dart';

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

      final service = ref.watch(appointmentsServiceProvider);
      final response = await service.getAppointments(
        branchId: branchId,
        workerId: query.workerId!,
        dateTimeGte: query.dateTimeGte,
        dateTimeLte: query.dateTimeLte,
      );

      return response.results.where((a) => a.isActive).toList();
    });
