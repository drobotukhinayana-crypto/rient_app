import 'package:rient_app/core/network/network_failure.dart';

/// Сообщение при отсутствии сети или связи с API.
const appNoConnectionMessage = 'Отсутствует интернет или связь с сервером';

/// Баннер оффлайн-режима расписания.
const scheduleOfflineBannerMessage =
    'Нет интернета. Включен оффлайн режим';

/// Бросается провайдерами, когда запрос невозможен без сети.
class AppOfflineException implements Exception {
  const AppOfflineException();

  @override
  String toString() => appNoConnectionMessage;
}

bool isAppOfflineError(Object? error) => error is AppOfflineException;

/// Показать «нет интернета» в UI (оффлайн-исключение или сетевая ошибка Dio/TLS).
bool shouldShowNoConnectionMessage(Object? error) {
  return isAppOfflineError(error) || isNetworkFailure(error);
}
