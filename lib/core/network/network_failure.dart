import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';

/// Сетевой сбой (нет интернета, обрыв TLS, таймаут и т.п.).
bool isNetworkFailure(Object? error) {
  if (error == null) return false;

  if (error is CustomException) {
    return isNetworkFailure(error.causedError);
  }

  if (error is DioException) {
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return true;
    }
    if (error.type == DioExceptionType.unknown) {
      return isNetworkFailure(error.error);
    }
    return false;
  }

  return error is SocketException ||
      error is HandshakeException ||
      error is HttpException ||
      error is IOException ||
      error is TimeoutException;
}
