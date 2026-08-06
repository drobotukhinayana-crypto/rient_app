import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:rient_app/core/network/app_connectivity.dart';
import 'package:rient_app/core/network/app_vpn_provider.dart';
import 'package:rient_app/core/network/network_failure.dart';
import 'package:rient_app/core/network/post_vpn_grace_provider.dart';

export 'package:rient_app/core/network/app_connectivity.dart'
    show connectivityHasNetwork, connectivityHasUnderlyingNetwork;

/// Сбрасывается в `false` при ошибке API расписания; восстанавливается при появлении сети.
final scheduleServerReachableProvider = StateProvider<bool>((ref) => true);

/// Пока активно — сетевые ошибки не переводят приложение обратно в оффлайн (pull-to-refresh).
final scheduleNetworkRecoveryUntilProvider = StateProvider<DateTime?>(
  (ref) => null,
);

/// После старта / входа — не уходим в оффлайн из-за гонки запросов до загрузки филиала.
final scheduleSessionBootstrapUntilProvider = StateProvider<DateTime?>(
  (ref) => null,
);

bool isScheduleNetworkRecoveryActive(dynamic ref) {
  final until = ref.read(scheduleNetworkRecoveryUntilProvider);
  return until != null && DateTime.now().isBefore(until);
}

bool isScheduleSessionBootstrapActive(dynamic ref) {
  final until = ref.read(scheduleSessionBootstrapUntilProvider);
  return until != null && DateTime.now().isBefore(until);
}

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

bool _onlineFromResults(List<ConnectivityResult> results) =>
    connectivityHasNetwork(results);

/// Есть ли интернет по данным ОС (Wi‑Fi / мобильная сеть).
final Provider<bool> appHasNetworkProvider = Provider<bool>((ref) {
  final stream = ref.watch(connectivityStatusProvider);
  final checked = ref.watch(connectivityCheckProvider);
  final graceUntil = ref.watch(postVpnConnectivityGraceUntilProvider);
  final postVpnGrace =
      graceUntil != null && DateTime.now().isBefore(graceUntil);

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

  // Android: после VPN stream и check расходятся — не показываем «нет интернета».
  if (postVpnGrace) {
    return streamOnline || checkOnline;
  }
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
  ref.read(scheduleSessionBootstrapUntilProvider.notifier).state =
      DateTime.now().add(const Duration(seconds: 6));
  ref.invalidate(connectivityCheckProvider);
  Future<void>.delayed(const Duration(seconds: 6), () {
    if (!ref.mounted) return;
    ref.read(scheduleSessionBootstrapUntilProvider.notifier).state = null;
    _runPostBootstrapServerConfirm(ref);
  });
}

/// Задаётся из [schedule_network_recovery.dart] (без циклического импорта).
Future<void> Function(dynamic ref)? _postBootstrapServerConfirm;

void bindPostBootstrapServerConfirm(Future<void> Function(dynamic ref) fn) {
  _postBootstrapServerConfirm = fn;
}

void _runPostBootstrapServerConfirm(dynamic ref) {
  final fn = _postBootstrapServerConfirm;
  if (fn == null) return;
  unawaited(fn(ref));
}

/// @deprecated Используйте [markScheduleServerUnreachable].
void markAppNetworkUnavailable(dynamic ref) => markScheduleServerUnreachable(ref);

/// @deprecated Используйте [markScheduleServerReachable].
void markAppNetworkAvailable(dynamic ref) => markScheduleServerReachable(ref);

/// Сетевая ошибка API — сразу включаем оффлайн-режим (не ждём таймауты других запросов).
void onScheduleNetworkFailure(dynamic ref, Object error) {
  if (isClientHttpError(error)) return;
  if (!isNetworkFailure(error)) return;
  if (!ref.mounted) return;
  if (isScheduleNetworkRecoveryActive(ref)) return;
  if (isScheduleSessionBootstrapActive(ref)) return;
  // С VPN API часто падает при живом Wi‑Fi; показываем VPN-плашку, не оффлайн.
  if (ref.read(appVpnActiveProvider)) return;
  markScheduleServerUnreachable(ref);
}
