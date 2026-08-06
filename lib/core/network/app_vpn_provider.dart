import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:rient_app/core/network/app_vpn.dart';

/// Стрим: VPN включён / выключен.
final vpnStatusProvider = StreamProvider<bool>((ref) {
  return watchVpnActive();
});

/// Доп. разовая проверка (как [connectivityCheckProvider]).
final vpnCheckProvider = FutureProvider<bool>((ref) async {
  ref.watch(vpnStatusProvider);
  return readVpnActive();
});

/// VPN активен по данным ОС (эвристика на iOS/Android).
final Provider<bool> appVpnActiveProvider = Provider<bool>((ref) {
  final stream = ref.watch(vpnStatusProvider);
  final checked = ref.watch(vpnCheckProvider);

  final streamActive = stream.when(
    data: (v) => v,
    loading: () => false,
    error: (_, __) => false,
  );

  // Разовая проверка важнее стрима: disconnect часто не приходит в stream.
  return checked.when(
    data: (v) => v,
    loading: () => streamActive,
    error: (_, __) => streamActive,
  );
});

/// Пока VPN кажется активным — периодически перепроверяем (stream может не обновиться).
/// Когда VPN выключен — медленный polling, чтобы поймать повторное включение.
final vpnActivePollingListenerProvider = Provider<void>((ref) {
  Timer? timer;
  var pollingWhileActive = false;

  Duration pollInterval({required bool vpnActive}) {
    if (vpnActive) {
      return defaultTargetPlatform == TargetPlatform.android
          ? const Duration(seconds: 2)
          : const Duration(seconds: 3);
    }
    return defaultTargetPlatform == TargetPlatform.android
        ? const Duration(seconds: 4)
        : const Duration(seconds: 5);
  }

  void invalidateVpnCheckDeferred() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!ref.mounted) return;
      ref.invalidate(vpnCheckProvider);
    });
  }

  void restartPolling(bool vpnActive) {
    timer?.cancel();
    pollingWhileActive = vpnActive;
    invalidateVpnCheckDeferred();
    timer = Timer.periodic(pollInterval(vpnActive: vpnActive), (_) {
      invalidateVpnCheckDeferred();
    });
  }

  ref.listen<bool>(appVpnActiveProvider, (previous, next) {
    if (previous == next) return;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!ref.mounted) return;
      final active = ref.read(appVpnActiveProvider);
      if (pollingWhileActive == active && timer != null) return;
      restartPolling(active);
    });
  });

  SchedulerBinding.instance.addPostFrameCallback((_) {
    if (!ref.mounted) return;
    restartPolling(ref.read(appVpnActiveProvider));
  });

  ref.onDispose(() => timer?.cancel());
});

/// Снова показываем плашку при новом включении VPN (после выключения).
final vpnBannerSessionListenerProvider = Provider<void>((ref) {
  ref.listen<bool>(appVpnActiveProvider, (previous, next) {
    if (previous != false || next != true) return;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!ref.mounted) return;
      ref.read(vpnBannerDismissedThisSessionProvider.notifier).state = false;
    });
  });
});

/// Плашку закрыли «Понятно» в этой сессии (до перезапуска приложения).
final vpnBannerDismissedThisSessionProvider =
    StateProvider<bool>((ref) => false);

/// VPN включён и плашку ещё не закрыли в этой сессии.
final showVpnBannerProvider = Provider<bool>((ref) {
  if (!ref.watch(appVpnActiveProvider)) return false;
  return !ref.watch(vpnBannerDismissedThisSessionProvider);
});
