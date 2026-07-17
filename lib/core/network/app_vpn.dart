import 'dart:async';

import 'package:flutter/services.dart';
import 'package:vpn_connection_detector/vpn_connection_detector.dart';

const appVpnActiveMessage = 'Включён VPN. Данные могут не отображаться';

/// Разовая проверка VPN. При сбое плагина считаем, что VPN выключен.
Future<bool> readVpnActive() async {
  try {
    return await VpnConnectionDetector.isVpnActive();
  } on MissingPluginException {
    return false;
  } on PlatformException {
    return false;
  } catch (_) {
    return false;
  }
}

/// Стрим статуса VPN (true = включён).
Stream<bool> watchVpnActive() async* {
  yield await readVpnActive();

  try {
    final detector = VpnConnectionDetector();
    yield* detector.vpnConnectionStream.map(
      (state) => state == VpnConnectionState.connected,
    );
  } on MissingPluginException {
    return;
  } on PlatformException {
    return;
  }
}
