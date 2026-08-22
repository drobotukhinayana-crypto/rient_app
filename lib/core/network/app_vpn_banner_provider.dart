import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/network/app_vpn_provider.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_offline_provider.dart';

/// VPN включён и плашку показываем: в оффлайне — всегда, иначе пока не нажали «Понятно».
final showAppVpnBannerProvider = Provider<bool>((ref) {
  if (!ref.watch(appVpnActiveProvider)) return false;
  if (ref.watch(scheduleOfflineModeProvider)) return true;
  return !ref.watch(vpnBannerDismissedThisSessionProvider);
});
