import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

/// Когда нативный плагин недоступен (hot restart, тесты) — не блокируем приложение.
const assumeOnlineConnectivity = [ConnectivityResult.wifi];

Future<List<ConnectivityResult>> readConnectivityStatus() async {
  try {
    return await Connectivity().checkConnectivity();
  } on MissingPluginException {
    return assumeOnlineConnectivity;
  } on PlatformException {
    return assumeOnlineConnectivity;
  }
}

Stream<List<ConnectivityResult>> watchConnectivityStatus() async* {
  yield await readConnectivityStatus();

  try {
    yield* Connectivity().onConnectivityChanged.transform(
      StreamTransformer<List<ConnectivityResult>, List<ConnectivityResult>>.fromHandlers(
        handleError: (error, stackTrace, sink) {
          if (error is MissingPluginException || error is PlatformException) {
            return;
          }
          sink.addError(error, stackTrace);
        },
      ),
    );
  } on MissingPluginException {
    return;
  } on PlatformException {
    return;
  }
}
