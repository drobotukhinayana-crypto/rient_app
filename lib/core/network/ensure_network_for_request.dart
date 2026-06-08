import 'package:rient_app/core/network/app_connectivity.dart';
import 'package:rient_app/core/network/app_connectivity_provider.dart';
import 'package:rient_app/core/network/app_offline.dart';
import 'package:rient_app/core/network/network_failure.dart';

/// Проверка перед HTTP: есть ли интерфейс сети (без залипшего флага API).
Future<void> ensureNetworkForRequest(dynamic ref) async {
  final results = await readConnectivityStatus();
  if (!connectivityHasNetwork(results)) {
    throw const AppOfflineException();
  }
}

/// Ошибка сети для главной/аналитики — не переводит расписание в оффлайн.
void rethrowAsOfflineIfNetworkFailure(dynamic ref, Object error) {
  if (isNetworkFailure(error)) {
    throw const AppOfflineException();
  }
}
