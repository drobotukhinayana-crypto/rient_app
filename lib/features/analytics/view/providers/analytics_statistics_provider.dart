import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/analytics/data/models/analytics_summary/analytics_summary.dart';
import 'package:rient_app/features/analytics/service/analytics_service.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/home/data/models/branch_statistics_comparison.dart';
import 'package:rient_app/features/home/data/models/statistics/statistics.dart';
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

  var result = summary;

  if (query.type == 'month') {
    try {
      final branchStats =
          await ref.read(statisticsServiceProvider).getBranchStatisticsComparison(
                startDate: query.start,
                endDate: query.end,
                type: 'month',
                workerId: workerId,
              );
      result = _summaryWithBranchStatistics(
        summary: result,
        period: branchStats.current,
      );
    } catch (_) {}

    if (workerId != null && workerId > 0) {
      try {
        final monthStats =
            await ref.read(statisticsServiceProvider).getMonthStatistics(
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

    return result;
  }

  try {
    final branchStats =
        await ref.read(statisticsServiceProvider).getBranchStatisticsComparison(
              startDate: query.start,
              endDate: query.end,
              type: 'interval',
              workerId: workerId,
            );
    result = _summaryWithBranchStatistics(
      summary: result,
      period: branchStats.current,
    );
  } catch (_) {}

  try {
    final stats = await ref.read(statisticsServiceProvider).getStatistics(
          startDate: query.start,
          endDate: query.end,
          workerId: workerId,
        );
    result = _summaryWithStatisticsOccupancy(summary: result, stats: stats);
  } catch (_) {}

  return result;
});

String _analyticsDateKey(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

/// Подмешиваем только дневную загруженность из `statistics_one` для полоски периода.
AnalyticsSummary _summaryWithStatisticsOccupancy({
  required AnalyticsSummary summary,
  required Statistics stats,
}) {
  final occupancyByDay = [
    for (final day in stats.occupancyByDay)
      AnalyticsOccupancyDay(
        date: _analyticsDateKey(day.date),
        occupancy: day.occupancy,
      ),
  ];
  if (occupancyByDay.isEmpty) return summary;

  return summary.copyWith(
    occupancy: occupancyByDay,
    summary: summary.summary.copyWith(
      occupancyByDay: occupancyByDay,
    ),
  );
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

AnalyticsSummary _summaryWithBranchStatistics({
  required AnalyticsSummary summary,
  required BranchStatisticsPeriod period,
}) {
  final incomeByDay = [
    for (final item in period.incomeByDay)
      AnalyticsIncomeByDay(
        date: item.date,
        income: item.income,
        payDue: item.payDue,
      ),
  ];

  final totalAppointments = period.totalAppointments ?? 0;
  final canceled = period.canceledAppointments ?? 0;

  return summary.copyWith(
    summary: summary.summary.copyWith(
      occupancy: period.occupancy ?? summary.summary.occupancy,
      incomeByDay: incomeByDay.isNotEmpty
          ? incomeByDay
          : summary.summary.incomeByDay,
      appointments: AnalyticsAppointments(
        total: totalAppointments,
        cancelled: canceled,
        newCount: period.newClients ?? 0,
      ),
    ),
    comparison: summary.comparison.copyWith(
      current: summary.comparison.current.copyWith(
        totalIncome: period.totalIncome,
        totalClients: period.totalClients,
        averageTransactions: period.averageTransactions,
        occupancy: period.occupancy,
        newClients: period.newClients,
        existingClients: period.existingClients,
        oneshotClients: period.oneshotClients,
        oneshotClientsAll: period.oneshotClientsAll,
        totalAppointments: period.totalAppointments,
        completedAppointments: period.completedAppointments,
        incomeByDay: incomeByDay.isNotEmpty
            ? incomeByDay
            : summary.comparison.current.incomeByDay,
      ),
    ),
    global: summary.global.copyWith(
      clients: summary.global.clients.copyWith(
        total: period.totalClients ?? summary.global.clients.total,
      ),
    ),
  );
}

AnalyticsSummary _summaryWithMonthStatistics({
  required AnalyticsSummary summary,
  required WorkerMonthStatistics monthStats,
  required int year,
  required int month,
}) {
  final services = monthStats.services.entries
      .map(
        (e) => AnalyticsGlobalService(
          name: e.key,
          count: e.value,
        ),
      )
      .toList();

  return summary.copyWith(
    specialist: (summary.specialist ?? const AnalyticsSpecialist()).copyWith(
      performance: monthStats.performance,
    ),
    global: summary.global.copyWith(
      services: services.isNotEmpty ? services : summary.global.services,
    ),
    meta: summary.meta.copyWith(
      canSeePayDue: summary.meta.canSeePayDue || monthStats.payDue > 0,
    ),
  );
}
