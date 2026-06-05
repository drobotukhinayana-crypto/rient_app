import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/network/app_offline.dart';
import 'package:rient_app/core/network/ensure_network_for_request.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';
import 'package:rient_app/core/network/app_connectivity_provider.dart'
    show markScheduleServerReachable;
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/home/data/models/statistics/statistics.dart';
import 'package:rient_app/features/home/service/statistics_service.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/home/view/providers/current_worker_id_provider.dart';
import 'package:rient_app/features/home/view/providers/selected_date_provider.dart';

final statisticsProvider = FutureProvider<Statistics>((ref) async {
  try {
    await ensureNetworkForRequest(ref);

    final service = ref.watch(statisticsServiceProvider);
    final branchId = ref.watch(currentBranchIdProvider);
    if (branchId == 0) {
      throw Exception('No valid branch found');
    }

    final roleId = ref.watch(roleProvider);
    final int? workerId = roleId == UserRole.worker.value
        ? await ref.read(currentWorkerIdProvider.future)
        : null;
    if (roleId == UserRole.worker.value && (workerId == null || workerId <= 0)) {
      throw Exception('Не найден worker.id в accounts');
    }

    final selectedDate = ref.watch(selectedDateProvider);
    final selectedNorm =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final weekStart =
        selectedNorm.subtract(Duration(days: selectedDate.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    final stats = await service.getStatistics(
      startDate: weekStart,
      endDate: weekEnd,
      branchId: branchId,
      workerId: workerId,
    );
    markScheduleServerReachable(ref);
    return stats;
  } on AppOfflineException {
    rethrow;
  } catch (e) {
    final caused = e is CustomException ? e.causedError : e;
    rethrowAsOfflineIfNetworkFailure(ref, caused ?? e);
    rethrow;
  }
});
