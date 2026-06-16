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
import 'package:rient_app/features/schedule/view/providers/schedule_statistics_provider.dart';

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

  final hasWorkerFilter = workerId != null && workerId > 0;
  final isWorkerRole = roleId == UserRole.worker.value;

  if (query.type == 'month') {
    if (hasWorkerFilter) {
      try {
        final monthStats =
            await ref.read(statisticsServiceProvider).getMonthStatistics(
                  year: query.start.year,
                  month: query.start.month,
                  workerId: workerId,
                );
        result = _summaryWithWorkerStatistics(
          summary: result,
          workerStats: monthStats,
          year: query.start.year,
          month: query.start.month,
        );
      } catch (_) {}
      result = await _enrichSummaryWithMonthOccupancy(
        ref,
        summary: result,
        monthStart: query.start,
        workerId: workerId,
      );
      return result.copyWith(workerId: workerId);
    }

    if (!isWorkerRole) {
      try {
        final branchStats =
            await ref.read(statisticsServiceProvider).getBranchStatisticsComparison(
                  startDate: query.start,
                  endDate: query.end,
                  type: 'month',
                );
        result = _summaryWithBranchStatistics(
          summary: result,
          period: branchStats.current,
        );
      } catch (_) {}
    }

    result = await _enrichSummaryWithMonthOccupancy(
      ref,
      summary: result,
      monthStart: query.start,
      workerId: workerId,
    );

    return result;
  }

  if (hasWorkerFilter) {
    try {
      final stats = await ref.read(statisticsServiceProvider).getStatistics(
            startDate: query.start,
            endDate: query.end,
            workerId: workerId,
          );
      result = _summaryWithIntervalStatistics(summary: result, stats: stats);
      result = _summaryWithWorkerIntervalOverlay(
        summary: result,
        stats: stats,
      );
    } catch (_) {}
    return result.copyWith(workerId: workerId);
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
    result = _summaryWithIntervalStatistics(summary: result, stats: stats);
  } catch (_) {}

  return result;
});

String _analyticsDateKey(DateTime date) =>
    '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

/// Загруженность и дневной доход из `statistics_one` для интервала / одного дня.
AnalyticsSummary _summaryWithIntervalStatistics({
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

  final incomeByDay = [
    for (final item in stats.incomeByDay ?? const <IncomeByDay>[])
      AnalyticsIncomeByDay(
        date: _analyticsDateKey(item.date),
        income: item.income,
        payDue: item.payDue,
      ),
  ];

  var next = summary;
  if (occupancyByDay.isNotEmpty) {
    next = next.copyWith(
      occupancy: occupancyByDay,
      summary: next.summary.copyWith(occupancyByDay: occupancyByDay),
    );
  }

  if (incomeByDay.isEmpty) return next;

  final totalIncome =
      incomeByDay.fold<double>(0, (sum, item) => sum + item.incomeValue);
  final totalPayDue =
      incomeByDay.fold<double>(0, (sum, item) => sum + item.payDueValue);

  return next.copyWith(
    summary: next.summary.copyWith(incomeByDay: incomeByDay),
    comparison: next.comparison.copyWith(
      current: next.comparison.current.copyWith(
        totalIncome: totalIncome,
        incomeByDay: incomeByDay,
      ),
    ),
    meta: next.meta.copyWith(
      canSeeIncome: next.meta.canSeeIncome || totalIncome > 0,
      canSeePayDue: next.meta.canSeePayDue || totalPayDue > 0,
    ),
  );
}

/// Месячный доход, к выплате и производительность мастера — `me/statistics/` / `workers/{id}/statistics/`.
AnalyticsSummary _summaryWithWorkerStatistics({
  required AnalyticsSummary summary,
  required WorkerMonthStatistics workerStats,
  required int year,
  required int month,
}) {
  final services = workerStats.services.entries
      .map(
        (e) => AnalyticsGlobalService(
          name: e.key,
          count: e.value,
        ),
      )
      .toList();

  final monthDateKey = '$year-${month.toString().padLeft(2, '0')}-01';
  final incomeByDay = [
    AnalyticsIncomeByDay(
      date: monthDateKey,
      income: workerStats.income,
      payDue: workerStats.payDue,
    ),
  ];

  final totalAppointments = workerStats.clients + workerStats.cancellations;

  return summary.copyWith(
    specialist: (summary.specialist ?? const AnalyticsSpecialist()).copyWith(
      performance: workerStats.performance,
    ),
    summary: summary.summary.copyWith(
      occupancy: workerStats.occupancy,
      incomeByDay: incomeByDay,
      appointments: AnalyticsAppointments(
        total: totalAppointments,
        cancelled: workerStats.cancellations,
        newCount: summary.summary.appointments.newCount,
      ),
    ),
    comparison: summary.comparison.copyWith(
      current: summary.comparison.current.copyWith(
        totalIncome: workerStats.income,
        totalClients: workerStats.clients,
        occupancy: workerStats.occupancy,
        totalAppointments: totalAppointments,
        completedAppointments: workerStats.clients,
        incomeByDay: incomeByDay,
      ),
    ),
    global: summary.global.copyWith(
      services: services,
      clients: AnalyticsGlobalClients(total: workerStats.clients),
    ),
    meta: summary.meta.copyWith(
      canSeeIncome: summary.meta.canSeeIncome || workerStats.income > 0,
      canSeePayDue: true,
    ),
  );
}

/// Для интервала/дня: подставляем только метрики мастера, без демографии филиала.
AnalyticsSummary _summaryWithWorkerIntervalOverlay({
  required AnalyticsSummary summary,
  required Statistics stats,
}) {
  final incomeByDay = [
    for (final item in stats.incomeByDay ?? const <IncomeByDay>[])
      AnalyticsIncomeByDay(
        date: _analyticsDateKey(item.date),
        income: item.income,
        payDue: item.payDue,
      ),
  ];
  final totalIncome = incomeByDay.fold<double>(
    0,
    (sum, item) => sum + item.incomeValue,
  );
  final totalPayDue = incomeByDay.fold<double>(
    0,
    (sum, item) => sum + item.payDueValue,
  );

  return summary.copyWith(
    summary: summary.summary.copyWith(
      occupancy: stats.occupancy,
      incomeByDay: incomeByDay.isNotEmpty
          ? incomeByDay
          : summary.summary.incomeByDay,
      appointments: AnalyticsAppointments(
        total: stats.appointments.total,
        cancelled: stats.appointments.cancelled,
        newCount: stats.appointments.newCount,
      ),
    ),
    comparison: summary.comparison.copyWith(
      current: summary.comparison.current.copyWith(
        totalIncome: totalIncome > 0 ? totalIncome : null,
        totalClients: (stats.appointments.total - stats.appointments.cancelled)
            .clamp(0, stats.appointments.total),
        newClients: stats.appointments.newCount,
        occupancy: stats.occupancy > 0 ? stats.occupancy : null,
        totalAppointments: stats.appointments.total,
        completedAppointments:
            (stats.appointments.total - stats.appointments.cancelled)
                .clamp(0, stats.appointments.total),
        incomeByDay: incomeByDay.isNotEmpty
            ? incomeByDay
            : summary.comparison.current.incomeByDay,
      ),
    ),
    global: summary.global.copyWith(
      clients: AnalyticsGlobalClients(
        total: (stats.appointments.total - stats.appointments.cancelled)
            .clamp(0, stats.appointments.total),
      ),
      services: const [],
    ),
    meta: summary.meta.copyWith(
      canSeeIncome: summary.meta.canSeeIncome || totalIncome > 0,
      canSeePayDue: summary.meta.canSeePayDue || totalPayDue > 0,
    ),
  );
}

/// Дневная загруженность из `statistics_one` по неделям — как в расписании и на главной.
Future<AnalyticsSummary> _enrichSummaryWithMonthOccupancy(
  Ref ref, {
  required AnalyticsSummary summary,
  required DateTime monthStart,
  int? workerId,
}) async {
  final monthKey =
      '${monthStart.year}-${monthStart.month.toString().padLeft(2, '0')}';
  try {
    final stats = await ref.read(
      scheduleStatisticsForMonthProvider(
        ScheduleStatisticsQuery(
          periodKey: monthKey,
          workerId: workerId != null && workerId > 0 ? workerId : null,
        ),
      ).future,
    );
    if (stats.occupancyByDay.isEmpty) return summary;

    final occupancyByDay = [
      for (final day in stats.occupancyByDay)
        AnalyticsOccupancyDay(
          date: _analyticsDateKey(day.date),
          occupancy: day.occupancy,
        ),
    ];

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
