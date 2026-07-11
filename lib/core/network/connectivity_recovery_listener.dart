import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/network/app_connectivity_provider.dart';
import 'package:rient_app/core/providers/worker_entity_labels_provider.dart';
import 'package:rient_app/features/home/view/providers/statistics_provider.dart';
import 'package:rient_app/features/home/view/providers/today_revenue_metrics_provider.dart';
import 'package:rient_app/features/home/view/providers/worker_permissions_provider.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_network_recovery.dart';

bool _backOnlineScheduled = false;

/// При восстановлении сети проверяет сервер и перезагружает главную.
final connectivityRecoveryListenerProvider = Provider<void>((ref) {
  void onBackOnline() {
    // Один колбэк на событие: stream + derived bool срабатывают почти одновременно.
    if (_backOnlineScheduled) return;
    _backOnlineScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _backOnlineScheduled = false;
      if (!ref.mounted) return;
      if (!await tryRecoverScheduleNetwork(ref)) return;
      if (!ref.mounted) return;
      ref.invalidate(workerEntityLabelsProvider);
      ref.invalidate(statisticsProvider);
      ref.invalidate(todayRevenueMetricsProvider);
      refreshWorkerPermissions(ref);
    });
  }

  // Единственный источник: статус ОС. Не дублируем через appHasNetwork / appNoConnection —
  // они derived от этого же stream и дают тройной вызов recovery.
  ref.listen(connectivityStatusProvider, (previous, next) {
    final wasOnline = previous?.maybeWhen(
          data: connectivityHasNetwork,
          orElse: () => false,
        ) ??
        false;
    next.whenData((results) {
      final isOnline = connectivityHasNetwork(results);
      if (wasOnline != isOnline) {
        // Откладываем invalidate, чтобы не пересобирать derived в том же listen.
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (!ref.mounted) return;
          ref.invalidate(connectivityCheckProvider);
        });
      }
      if (!wasOnline && isOnline) onBackOnline();
    });
  });
});
