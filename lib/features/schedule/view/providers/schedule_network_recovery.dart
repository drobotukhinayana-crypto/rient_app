import 'dart:async';

import 'package:rient_app/core/network/app_connectivity.dart';
import 'package:rient_app/core/network/app_connectivity_provider.dart'
    show
        appHasNetworkProvider,
        bindPostBootstrapServerConfirm,
        connectivityCheckProvider,
        connectivityHasNetwork,
        isScheduleSessionBootstrapActive,
        markScheduleServerReachable,
        markScheduleServerUnreachable,
        scheduleNetworkRecoveryUntilProvider;
import 'package:rient_app/features/schedule/view/providers/schedule_offline_invalidation.dart';

bool _scheduleRecoveryInFlight = false;

void beginScheduleNetworkRecovery(dynamic ref) {
  markScheduleServerReachable(ref);
  ref.read(scheduleNetworkRecoveryUntilProvider.notifier).state =
      DateTime.now().add(const Duration(seconds: 20));
}

/// Сбрасывает кэш connectivity_plus и ждёт актуальный статус (после включения Wi‑Fi).
Future<bool> refreshConnectivityAndWait(dynamic ref) async {
  ref.invalidate(connectivityCheckProvider);
  try {
    await ref.read(connectivityCheckProvider.future);
  } catch (_) {}
  if (ref.read(appHasNetworkProvider)) return true;
  final results = await readConnectivityStatus();
  return connectivityHasNetwork(results);
}

/// Выход из оффлайна при появлении сети — без probe, как при перезапуске приложения.
Future<bool> tryRecoverScheduleNetwork(dynamic ref) async {
  if (_scheduleRecoveryInFlight) {
    return ref.read(appHasNetworkProvider);
  }
  _scheduleRecoveryInFlight = true;
  try {
    if (!await refreshConnectivityAndWait(ref)) {
      return false;
    }
    markScheduleServerReachable(ref);
    beginScheduleNetworkRecovery(ref);
    invalidateScheduleNetworkProviders(ref);
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
  markScheduleServerReachable(ref);
  invalidateScheduleNetworkProviders(ref);
}

void registerScheduleNetworkRecoveryBindings() {
  bindPostBootstrapServerConfirm(confirmScheduleServerWhenBranchReady);
}
