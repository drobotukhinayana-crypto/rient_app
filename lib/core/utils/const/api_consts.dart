import 'dart:convert';

class ApiConsts {
  factory ApiConsts() => ApiConsts._();
  ApiConsts._();
  final bool _isProd = false;
  late final _apiUrl = _isProd ? _prodUrl : _testUrl;
  final _prodUrl = '';
  final _testUrl = 'https://apptest.triobot.ru/api/';

  String createUrl(String endpoint) {
    // Убираем начальный слэш из endpoint, если он есть
    final cleanEndpoint = endpoint.startsWith('/')
        ? endpoint.substring(1)
        : endpoint;
    // Убеждаемся, что _apiUrl заканчивается слэшем
    final baseUrl = _apiUrl.endsWith('/') ? _apiUrl : '$_apiUrl/';
    return baseUrl + cleanEndpoint;
  }

  /// WebSocket уведомлений (тот же хост, что и REST API, без префикса `/api/`).
  String createNotificationsWebSocketUrl({
    required int organizationId,
    required String token,
  }) {
    final baseUri = Uri.parse(_apiUrl);
    final wsScheme = baseUri.scheme == 'https' ? 'wss' : 'ws';
    return Uri(
      scheme: wsScheme,
      host: baseUri.host,
      port: baseUri.hasPort ? baseUri.port : null,
      path: '/ws/notifications/$organizationId/',
      queryParameters: {'token': token},
    ).toString();
  }

  String basicAuth(String email, String password) =>
      'Basic ${base64Encode(utf8.encode('$email:$password'))}';
}
