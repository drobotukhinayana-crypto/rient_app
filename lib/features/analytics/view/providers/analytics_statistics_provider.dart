import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/home/data/models/statistics/statistics.dart';
import 'package:rient_app/features/home/service/statistics_service.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/home/view/providers/current_worker_id_provider.dart';

class AnalyticsQuery {
  const AnalyticsQuery({required this.start, required this.end});

  final DateTime start;
  final DateTime end;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnalyticsQuery &&
        other.start == start &&
        other.end == end;
  }

  @override
  int get hashCode => Object.hash(start, end);
}

final analyticsStatisticsProvider =
    FutureProvider.family<Statistics, AnalyticsQuery>((ref, query) async {
  final branchId = ref.watch(currentBranchIdProvider);
  if (branchId == 0) {
    throw Exception('No valid branch found');
  }

  final roleId = ref.watch(roleProvider);
  final workerId = roleId == UserRole.worker.value
      ? await ref.watch(currentWorkerIdProvider.future)
      : null;
  if (roleId == UserRole.worker.value && (workerId == null || workerId <= 0)) {
    throw Exception('Не найден worker.id в accounts');
  }

  return ref.read(statisticsServiceProvider).getStatistics(
        startDate: query.start,
        endDate: query.end,
        branchId: branchId,
        workerId: workerId,
      );
    });
