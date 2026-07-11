import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:rient_app/core/network/app_connectivity.dart';
import 'package:rient_app/core/network/app_connectivity_provider.dart'
    show
        bindPostBootstrapServerConfirm,
        connectivityCheckProvider,
        connectivityHasNetwork,
        isScheduleSessionBootstrapActive,
        markScheduleServerReachable,
        markScheduleServerUnreachable,
        scheduleNetworkRecoveryUntilProvider;
import 'package:rient_app/features/schedule/view/providers/schedule_offline_invalidation.dart';

bool _scheduleRecoveryInFlight = false;
DateTime? _lastRecoveryStartedAt;

void beginScheduleNetworkRecovery(dynamic ref) {
  markScheduleServerReachable(ref);
  ref.read(scheduleNetworkRecoveryUntilProvider.notifier).state =
      DateTime.now().add(const Duration(seconds: 20));
}

/// Сбрасывает кэш connectivity_plus и ждёт актуальный статус (после включения Wi‑Fi).
/// Не читает производные Provider сразу после invalidate — иначе Riverpod падает
/// с «uninitialized provider» / «rebuild multiple times in the same frame».
Future<bool> refreshConnectivityAndWait(dynamic ref) async {
  ref.invalidate(connectivityCheckProvider);
  // Даём кадру завершиться, чтобы derived-провайдеры не читались mid-rebuild.
  await Future<void>.delayed(Duration.zero);
  try {
    final checked = await ref.read(connectivityCheckProvider.future);
    if (connectivityHasNetwork(checked)) return true;
  } catch (_) {}
  final results = await readConnectivityStatus();
  return connectivityHasNetwork(results);
}

/// Выход из оффлайна при появлении сети — без probe, как при перезапуске приложения.
Future<bool> tryRecoverScheduleNetwork(dynamic ref) async {
  final now = DateTime.now();
  if (_scheduleRecoveryInFlight) {
    return false;
  }
  // Антидребезг: несколько слушателей (stream / hasNetwork / noConnection) срабатывают разом.
  if (_lastRecoveryStartedAt != null &&
      now.difference(_lastRecoveryStartedAt!) <
          const Duration(milliseconds: 800)) {
    return false;
  }
  _scheduleRecoveryInFlight = true;
  _lastRecoveryStartedAt = now;
  try {
    if (!await refreshConnectivityAndWait(ref)) {
      return false;
    }
    if (!ref.mounted) return false;
    markScheduleServerReachable(ref);
    beginScheduleNetworkRecovery(ref);
    // Инвалидация на следующий кадр — SchedulePage и др. не читают mid-rebuild.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!ref.mounted) return;
      invalidateScheduleNetworkProviders(ref);
    });
    return true;
  } finally {
    _scheduleRecoveryInFlight = false;
  }
}

/// После загрузки филиала при старте — не уходим в оффлайн из-за медленного API.
Future<void> confirmScheduleServerWhenBranchReady(dynamic ref) async {
  if (!await refreshConnectivityAndWait(ref)) {
    if (!isScheduleSessionBootstrapActive(ref)) {
      markScheduleServerUnreachable(ref);
    }
    return;
  }
  if (!ref.mounted) return;
  markScheduleServerReachable(ref);
  SchedulerBinding.instance.addPostFrameCallback((_) {
    if (!ref.mounted) return;
    invalidateScheduleNetworkProviders(ref);
  });
}

void registerScheduleNetworkRecoveryBindings() {
  bindPostBootstrapServerConfirm(confirmScheduleServerWhenBranchReady);
}
