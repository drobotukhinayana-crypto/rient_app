import 'dart:async';

import 'package:rient_app/features/home/view/providers/statistics_provider.dart';
import 'package:rient_app/features/schedule/view/providers/appointments_provider.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_offline_provider.dart'
    show beginScheduleNetworkRecovery;
import 'package:rient_app/features/schedule/view/providers/schedule_statistics_provider.dart';

Future<void> _prefetchHomeData(dynamic ref) async {
  try {
    await ref.read(statisticsProvider.future);
  } catch (_) {}
}

/// После создания, изменения или удаления записи — обновить расписание и главную.
void refreshAfterAppointmentMutation(dynamic ref) {
  beginScheduleNetworkRecovery(ref);
  ref.invalidate(scheduleAppointmentsProvider);
  ref.invalidate(statisticsProvider);
  ref.invalidate(scheduleStatisticsForWeekProvider);
  ref.invalidate(scheduleStatisticsForMonthProvider);

  unawaited(_prefetchHomeData(ref));
  unawaited(
    Future<void>.delayed(const Duration(milliseconds: 600), () async {
      ref.invalidate(statisticsProvider);
      await _prefetchHomeData(ref);
    }),
  );
}
