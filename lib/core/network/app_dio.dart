import 'package:dio/dio.dart';

/// Токен мобильного клиента для stage (captcha / media).
const appMobileToken =
    'daf583a54f2bd384f805c2eb59781757a751aebbf4e969bc5020004b027c9bf7';

/// Таймауты для API расписания и главной — баланс между ожиданием и оффлайн-кэшем.
/// Во все запросы добавляет заголовок X-MOBILE-TOKEN (нужен для captcha на stage).
Dio createAppDio() {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
      preserveHeaderCase: true,
      headers: {
        'X-MOBILE-TOKEN': appMobileToken,
      },
    ),
  );
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        options.preserveHeaderCase = true;
        options.headers['X-MOBILE-TOKEN'] = appMobileToken;
        handler.next(options);
      },
    ),
  );
  return dio;
}
