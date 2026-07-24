import 'dart:async';

import 'package:rient_app/features/analytics/view/providers/analytics_statistics_provider.dart';
import 'package:rient_app/features/home/view/providers/selected_date_provider.dart';
import 'package:rient_app/features/home/view/providers/statistics_provider.dart';
import 'package:rient_app/features/home/view/providers/worker_permissions_provider.dart';
import 'package:rient_app/features/schedule/view/providers/appointments_provider.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_offline_provider.dart'
    show beginScheduleNetworkRecovery;
import 'package:rient_app/features/schedule/view/providers/schedule_statistics_provider.dart';
import 'package:rient_app/features/schedule/view/providers/workers_provider.dart'
    show selectedScheduleDateProvider;

DateTime _dateOnly(DateTime date) =>
    DateTime(date.year, date.month, date.day);

/// Дата главной → расписание (полоска дат и записи).
void syncScheduleDateFromHome(dynamic ref) {
  final homeDate = ref.read(selectedDateProvider);
  ref.read(selectedScheduleDateProvider.notifier).state = _dateOnly(homeDate);
}

/// Дата расписания → главная.
void syncHomeDateFromSchedule(dynamic ref) {
  final scheduleDate = ref.read(selectedScheduleDateProvider);
  ref.read(selectedDateProvider.notifier).setDate(_dateOnly(scheduleDate));
}

/// Перед открытием вкладки «Расписание» из таббара.
void prepareScheduleTabOnOpen(dynamic ref) {
  syncScheduleDateFromHome(ref);
  beginScheduleNetworkRecovery(ref);
  ref.invalidate(scheduleAppointmentsProvider);
  ref.invalidate(scheduleStatisticsForWeekProvider);
  ref.invalidate(scheduleStatisticsForMonthProvider);
}

/// Перед открытием вкладки «Главная» из таббара — сразу тянем свежую статистику.
void prepareHomeTabOnOpen(dynamic ref) {
  syncHomeDateFromSchedule(ref);
  refreshWorkerPermissions(ref);
  beginScheduleNetworkRecovery(ref);
  bumpHomeReloadToken(ref);
  ref.invalidate(statisticsProvider);
  ref.invalidate(scheduleAppointmentsProvider);
  unawaited(_prefetchHomeData(ref));
}

Future<void> _prefetchHomeData(dynamic ref) async {
  try {
    await ref.read(statisticsProvider.future);
  } catch (_) {}
}

Future<void> _prefetchAnalyticsData(dynamic ref) async {
  bumpAnalyticsReloadToken(ref);
  ref.invalidate(analyticsSummaryProvider);
}

/// После создания, изменения или удаления записи — обновить расписание, главную и аналитику.
void refreshAfterAppointmentMutation(dynamic ref) {
  beginScheduleNetworkRecovery(ref);
  bumpHomeReloadToken(ref);
  ref.invalidate(scheduleAppointmentsProvider);
  ref.invalidate(statisticsProvider);
  ref.invalidate(scheduleStatisticsForWeekProvider);
  ref.invalidate(scheduleStatisticsForMonthProvider);
  bumpAnalyticsReloadToken(ref);
  ref.invalidate(analyticsSummaryProvider);

  unawaited(_prefetchHomeData(ref));
  unawaited(_prefetchAnalyticsData(ref));
  unawaited(
    Future<void>.delayed(const Duration(milliseconds: 600), () async {
      bumpHomeReloadToken(ref);
      ref.invalidate(statisticsProvider);
      bumpAnalyticsReloadToken(ref);
      ref.invalidate(analyticsSummaryProvider);
      await _prefetchHomeData(ref);
    }),
  );
}
