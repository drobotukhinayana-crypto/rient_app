import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/network/app_connectivity_provider.dart';
import 'package:rient_app/core/providers/worker_entity_labels_provider.dart';
import 'package:rient_app/features/home/view/providers/statistics_provider.dart';
import 'package:rient_app/features/home/view/providers/today_revenue_metrics_provider.dart';

/// При восстановлении сети перезагружает главную.
final connectivityRecoveryListenerProvider = Provider<void>((ref) {
  void onBackOnline() {
    markScheduleServerReachable(ref);
    ref.invalidate(workerEntityLabelsProvider);
    ref.invalidate(statisticsProvider);
    ref.invalidate(todayRevenueMetricsProvider);
    ref.invalidate(connectivityCheckProvider);
  }

  ref.listen(connectivityStatusProvider, (previous, next) {
    next.whenData((results) {
      if (connectivityHasNetwork(results)) onBackOnline();
    });
  });

  ref.listen<bool>(appHasNetworkProvider, (previous, next) {
    if (previous == false && next) onBackOnline();
  });
});
