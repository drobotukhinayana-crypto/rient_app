import 'package:rient_app/core/network/app_connectivity.dart';
import 'package:rient_app/core/network/app_connectivity_provider.dart';
import 'package:rient_app/core/network/app_offline.dart';
import 'package:rient_app/core/network/network_failure.dart';

/// Проверка перед HTTP: есть ли интерфейс сети и не помечен ли сервер недоступным.
Future<void> ensureNetworkForRequest(dynamic ref) async {
  if (!ref.read(scheduleServerReachableProvider)) {
    throw const AppOfflineException();
  }
  final results = await readConnectivityStatus();
  if (!connectivityHasNetwork(results)) {
    throw const AppOfflineException();
  }
}

/// Ошибка сети для главной/аналитики — включает оффлайн-режим расписания.
void rethrowAsOfflineIfNetworkFailure(dynamic ref, Object error) {
  if (isNetworkFailure(error)) {
    onScheduleNetworkFailure(ref, error);
    throw const AppOfflineException();
  }
}
