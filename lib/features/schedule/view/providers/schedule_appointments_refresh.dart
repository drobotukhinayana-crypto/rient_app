import 'package:rient_app/features/home/view/providers/statistics_provider.dart';
import 'package:rient_app/features/home/view/providers/today_revenue_metrics_provider.dart';
import 'package:rient_app/features/schedule/view/providers/appointments_provider.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_statistics_provider.dart';

/// После создания, изменения или удаления записи — обновить расписание и главную.
void refreshAfterAppointmentMutation(dynamic ref) {
  ref.invalidate(scheduleAppointmentsProvider);
  ref.invalidate(statisticsProvider);
  ref.invalidate(todayRevenueMetricsProvider);
  ref.invalidate(scheduleStatisticsForWeekProvider);
  ref.invalidate(scheduleStatisticsForMonthProvider);
}
