import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/analytics/data/models/analytics_summary/analytics_summary.dart';
import 'package:rient_app/features/analytics/service/analytics_service.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/home/view/providers/current_worker_id_provider.dart';

class AnalyticsQuery {
  const AnalyticsQuery({
    required this.start,
    required this.end,
    this.workerId,
    this.type = 'interval',
  });

  final DateTime start;
  final DateTime end;

  /// `null` — все специалисты филиала (только для ролей с доступом).
  final int? workerId;

  /// `interval` | `month` — тип сравнения для блока comparison.
  final String type;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnalyticsQuery &&
        other.start == start &&
        other.end == end &&
        other.workerId == workerId &&
        other.type == type;
  }

  @override
  int get hashCode => Object.hash(start, end, workerId, type);
}

final analyticsSummaryProvider =
    FutureProvider.family<AnalyticsSummary, AnalyticsQuery>((ref, query) async {
  final branchId = ref.watch(currentBranchIdProvider);
  if (branchId == 0) {
    throw Exception('No valid branch found');
  }

  final roleId = ref.watch(roleProvider);
  final int? workerId;
  if (roleId == UserRole.worker.value) {
    workerId = await ref.watch(currentWorkerIdProvider.future);
    if (workerId == null || workerId <= 0) {
      throw Exception('Не найден worker.id в accounts');
    }
  } else {
    workerId = query.workerId;
  }

  final includeBenchmarking = roleId == UserRole.owner.value ||
      roleId == UserRole.manager.value;

  return ref.read(analyticsServiceProvider).getSummary(
        startDate: query.start,
        endDate: query.end,
        branchId: branchId,
        workerId: workerId,
        type: query.type,
        includeBenchmarking: includeBenchmarking,
      );
});
