import 'package:flutter_riverpod/legacy.dart';

/// После отключения VPN connectivity_plus на Android долго отдаёт stale «none».
final postVpnConnectivityGraceUntilProvider = StateProvider<DateTime?>(
  (ref) => null,
);

bool isPostVpnConnectivityGraceActive(dynamic ref) {
  final until = ref.read(postVpnConnectivityGraceUntilProvider);
  return until != null && DateTime.now().isBefore(until);
}

void beginPostVpnConnectivityGrace(dynamic ref) {
  ref.read(postVpnConnectivityGraceUntilProvider.notifier).state =
      DateTime.now().add(const Duration(seconds: 15));
}
