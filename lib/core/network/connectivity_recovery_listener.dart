import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/network/app_connectivity_provider.dart';
import 'package:rient_app/core/providers/worker_entity_labels_provider.dart';
import 'package:rient_app/features/home/view/providers/statistics_provider.dart';
import 'package:rient_app/features/home/view/providers/today_revenue_metrics_provider.dart';
import 'package:rient_app/features/home/view/providers/worker_permissions_provider.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_network_recovery.dart';

/// При восстановлении сети проверяет сервер и перезагружает главную.
final connectivityRecoveryListenerProvider = Provider<void>((ref) {
  void onBackOnline() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (!ref.mounted) return;
      if (!await tryRecoverScheduleNetwork(ref)) return;
      ref.invalidate(workerEntityLabelsProvider);
      ref.invalidate(statisticsProvider);
      ref.invalidate(todayRevenueMetricsProvider);
      refreshWorkerPermissions(ref);
    });
  }

  ref.listen(connectivityStatusProvider, (previous, next) {
    final wasOnline = previous?.maybeWhen(
          data: connectivityHasNetwork,
          orElse: () => false,
        ) ??
        false;
    next.whenData((results) {
      final isOnline = connectivityHasNetwork(results);
      if (wasOnline != isOnline) {
        ref.invalidate(connectivityCheckProvider);
      }
      if (!wasOnline && isOnline) onBackOnline();
    });
  });

  ref.listen<bool>(appHasNetworkProvider, (previous, next) {
    if (previous == false && next) onBackOnline();
  });

  ref.listen<bool>(appNoConnectionProvider, (previous, next) {
    if (previous == true && !next) onBackOnline();
  });
});
