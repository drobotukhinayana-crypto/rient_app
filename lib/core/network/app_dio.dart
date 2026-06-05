import 'package:dio/dio.dart';

/// Короткие таймауты — быстрее оффлайн и кэш вместо бесконечного лоадера.
Dio createAppDio() {
  return Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 4),
      receiveTimeout: const Duration(seconds: 6),
      sendTimeout: const Duration(seconds: 6),
    ),
  );
}
