import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:rient_app/core/network/app_connectivity.dart';
import 'package:rient_app/core/network/network_failure.dart';

/// Сбрасывается в `false` при ошибке API расписания; восстанавливается при появлении сети.
final scheduleServerReachableProvider = StateProvider<bool>((ref) => true);

final connectivityStatusProvider =
    StreamProvider<List<ConnectivityResult>>((ref) {
  return watchConnectivityStatus();
});

/// Дополнительная проверка (stream на симуляторе иногда «wifi» без интернета).
final connectivityCheckProvider =
    FutureProvider<List<ConnectivityResult>>((ref) async {
  ref.watch(connectivityStatusProvider);
  return readConnectivityStatus();
});

bool connectivityHasNetwork(List<ConnectivityResult> results) {
  return results.any((r) => r != ConnectivityResult.none);
}

bool _onlineFromResults(List<ConnectivityResult> results) =>
    connectivityHasNetwork(results);

/// Есть ли интернет по данным ОС (Wi‑Fi / мобильная сеть).
final Provider<bool> appHasNetworkProvider = Provider<bool>((ref) {
  final stream = ref.watch(connectivityStatusProvider);
  final checked = ref.watch(connectivityCheckProvider);

  final streamOnline = stream.when(
    data: _onlineFromResults,
    loading: () => true,
    error: (_, __) => true,
  );
  final checkOnline = checked.when(
    data: _onlineFromResults,
    loading: () => streamOnline,
    error: (_, __) => streamOnline,
  );

  return streamOnline && checkOnline;
});

/// Нет интернета — только connectivity (не залипает после ошибки API).
final Provider<bool> appNoConnectionProvider = Provider<bool>(
  (ref) => !ref.watch(appHasNetworkProvider),
);

/// Ошибка API расписания — оффлайн-режим расписания, главная не блокируется.
void markScheduleServerUnreachable(dynamic ref) {
  ref.read(scheduleServerReachableProvider.notifier).state = false;
}

void markScheduleServerReachable(dynamic ref) {
  ref.read(scheduleServerReachableProvider.notifier).state = true;
}

/// Сброс после входа / выхода — не залипать в оффлайне прошлой сессии.
void resetScheduleNetworkStateForSession(dynamic ref) {
  markScheduleServerReachable(ref);
  ref.invalidate(connectivityCheckProvider);
}

/// @deprecated Используйте [markScheduleServerUnreachable].
void markAppNetworkUnavailable(dynamic ref) => markScheduleServerUnreachable(ref);

/// @deprecated Используйте [markScheduleServerReachable].
void markAppNetworkAvailable(dynamic ref) => markScheduleServerReachable(ref);

/// Сетевая ошибка API — кэш расписания, без оффлайн-UI (он только при отсутствии сети).
void onScheduleNetworkFailure(dynamic ref, Object error) {
  if (isClientHttpError(error)) return;
  if (!isNetworkFailure(error)) return;
  SchedulerBinding.instance.addPostFrameCallback((_) {
    if (!ref.mounted) return;
    markScheduleServerUnreachable(ref);
  });
}
