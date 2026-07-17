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
  final checkActive = checked.when(
    data: (v) => v,
    loading: () => streamActive,
    error: (_, __) => streamActive,
  );

  return streamActive || checkActive;
});

/// Плашку закрыли «Понятно» в этой сессии (сбрасывается при перезапуске приложения).
final vpnBannerDismissedThisSessionProvider =
    StateProvider<bool>((ref) => false);

/// VPN включён и плашку ещё не закрыли в этой сессии.
final showVpnBannerProvider = Provider<bool>((ref) {
  if (!ref.watch(appVpnActiveProvider)) return false;
  return !ref.watch(vpnBannerDismissedThisSessionProvider);
});
