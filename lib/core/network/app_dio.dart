import 'package:dio/dio.dart';

/// Таймауты для API расписания и главной — баланс между ожиданием и оффлайн-кэшем.
Dio createAppDio() {
  return Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
    ),
  );
}
