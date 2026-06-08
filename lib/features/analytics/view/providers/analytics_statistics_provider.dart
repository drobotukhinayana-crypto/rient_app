import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/analytics/data/models/analytics_summary/analytics_summary.dart';
import 'package:rient_app/features/analytics/service/analytics_service.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/home/data/models/worker_month_statistics.dart';
import 'package:rient_app/features/home/service/statistics_service.dart';
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

  final summary = await ref.read(analyticsServiceProvider).getSummary(
        startDate: query.start,
        endDate: query.end,
        branchId: branchId,
        workerId: workerId,
        type: query.type,
      );

  if (workerId == null || workerId <= 0) return summary;

  var result = summary;

  if (query.type == 'month') {
    try {
      final monthStats = await ref.read(statisticsServiceProvider).getMonthStatistics(
            year: query.start.year,
            month: query.start.month,
            workerId: workerId,
          );
      result = _summaryWithMonthStatistics(
        summary: result,
        monthStats: monthStats,
        year: query.start.year,
        month: query.start.month,
      );
    } catch (_) {}
    return _summaryWithOccupancyByDay(
      ref,
      summary: result,
      workerId: workerId,
      start: query.start,
      end: query.end,
    );
  }

  if (roleId != UserRole.worker.value) {
    result = await _summaryWithWorkerTopServices(
      ref,
      summary: summary,
      workerId: workerId,
      start: query.start,
      end: query.end,
    );
  }

  return result;
    });

/// ТОП услуг: `global.services` в summary — по филиалу; для мастера — `statistics_one` с `worker`.
Future<AnalyticsSummary> _summaryWithWorkerTopServices(
  Ref ref, {
  required AnalyticsSummary summary,
  required int workerId,
  required DateTime start,
  required DateTime end,
}) async {
  try {
    final stats = await ref.read(statisticsServiceProvider).getStatistics(
          startDate: start,
          endDate: end,
          workerId: workerId,
        );
    if (stats.services.isEmpty) return summary;

    final services = stats.services.entries
        .map(
          (e) => AnalyticsGlobalService(
            name: e.key,
            count: e.value,
          ),
        )
        .toList();

    return summary.copyWith(
      global: summary.global.copyWith(services: services),
    );
  } catch (_) {
    return summary;
  }
}

Future<AnalyticsSummary> _summaryWithOccupancyByDay(
  Ref ref, {
  required AnalyticsSummary summary,
  required int workerId,
  required DateTime start,
  required DateTime end,
}) async {
  try {
    final stats = await ref.read(statisticsServiceProvider).getStatistics(
          startDate: start,
          endDate: end,
          workerId: workerId,
        );
    if (stats.occupancyByDay.isEmpty) return summary;

    final occupancyByDay = stats.occupancyByDay
        .map(
          (day) => AnalyticsOccupancyDay(
            date:
                '${day.date.year}-${day.date.month.toString().padLeft(2, '0')}-${day.date.day.toString().padLeft(2, '0')}',
            occupancy: day.occupancy,
          ),
        )
        .toList();

    return summary.copyWith(
      occupancy: occupancyByDay,
      summary: summary.summary.copyWith(occupancyByDay: occupancyByDay),
    );
  } catch (_) {
    return summary;
  }
}

AnalyticsSummary _summaryWithMonthStatistics({
  required AnalyticsSummary summary,
  required WorkerMonthStatistics monthStats,
  required int year,
  required int month,
}) {
  final lastDay = DateTime(year, month + 1, 0).day;
  final dateKey =
      '$year-${month.toString().padLeft(2, '0')}-${lastDay.toString().padLeft(2, '0')}';

  final incomeByDay = [
    AnalyticsIncomeByDay(
      date: dateKey,
      income: monthStats.income,
      payDue: monthStats.payDue,
    ),
  ];

  final services = monthStats.services.entries
      .map(
        (e) => AnalyticsGlobalService(
          name: e.key,
          count: e.value,
        ),
      )
      .toList();

  return summary.copyWith(
    workerId: summary.workerId,
    summary: summary.summary.copyWith(
      occupancy: monthStats.occupancy,
      incomeByDay: incomeByDay,
    ),
    comparison: summary.comparison.copyWith(
      current: summary.comparison.current.copyWith(
        totalIncome: monthStats.income,
        totalClients: monthStats.clients,
        averageTransactions: monthStats.performance,
        incomeByDay: incomeByDay,
      ),
    ),
    global: summary.global.copyWith(
      clients: summary.global.clients.copyWith(total: monthStats.clients),
      services: services.isNotEmpty ? services : summary.global.services,
    ),
    meta: summary.meta.copyWith(
      canSeePayDue: summary.meta.canSeePayDue || monthStats.payDue > 0,
    ),
  );
}
