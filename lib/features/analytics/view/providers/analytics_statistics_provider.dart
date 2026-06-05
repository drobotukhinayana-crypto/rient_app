import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/analytics/data/models/analytics_summary/analytics_summary.dart';
import 'package:rient_app/features/analytics/service/analytics_service.dart';
import 'package:rient_app/features/analytics/utils/worker_day_occupancy.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/home/service/statistics_service.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/home/view/providers/current_worker_id_provider.dart';
import 'package:rient_app/features/schedule/utils/worker_work_day.dart';
import 'package:rient_app/features/schedule/view/providers/appointments_provider.dart';
import 'package:rient_app/features/schedule/view/providers/worker_schedules_range_provider.dart';

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
  if (roleId != UserRole.worker.value) {
    result = await _summaryWithWorkerTopServices(
      ref,
      summary: summary,
      workerId: workerId,
      start: query.start,
      end: query.end,
    );
  }

  return _summaryWithWorkerOccupancy(
    ref,
    summary: result,
    workerId: workerId,
    start: query.start,
    end: query.end,
  );
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

Future<AnalyticsSummary> _summaryWithWorkerOccupancy(
  Ref ref, {
  required AnalyticsSummary summary,
  required int workerId,
  required DateTime start,
  required DateTime end,
}) async {
  final startNorm = dateOnly(start);
  final endNorm = dateOnly(end);

  final schedulesData = await ref.read(
    workerSchedulesRangeProvider(
      WorkerSchedulesRangeQuery(
        workerId: workerId,
        rangeStart: startNorm,
        rangeEnd: endNorm,
      ),
    ).future,
  );

  final appointments = await ref.read(
    scheduleAppointmentsProvider(
      AppointmentsQuery(
        workerId: workerId,
        dateTimeGte: startNorm,
        dateTimeLte: DateTime(
          endNorm.year,
          endNorm.month,
          endNorm.day,
          23,
          59,
          59,
        ),
      ),
    ).future,
  );

  final occupancyByDay = buildWorkerOccupancyByDay(
    rangeStart: startNorm,
    rangeEnd: endNorm,
    schedulesByDate: schedulesData.schedulesByDate,
    appointments: appointments,
  );

  if (occupancyByDay.isEmpty) return summary;

  final periodOccupancy = averageOccupancyPercent(occupancyByDay);

  return summary.copyWith(
    occupancy: occupancyByDay,
    summary: summary.summary.copyWith(
      occupancy: periodOccupancy,
      occupancyByDay: occupancyByDay,
    ),
  );
}
