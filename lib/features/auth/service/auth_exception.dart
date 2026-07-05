import 'package:dio/dio.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';

sealed class AuthException extends CustomException {
  AuthException({super.message, super.stack, super.causedError});
}

class EmailDoesNotExistException extends AuthException {
  EmailDoesNotExistException({super.message});
}

class UnknownAuthException extends AuthException {
  UnknownAuthException({super.message});
}

class ServerErrorException extends AuthException {
  ServerErrorException({super.message});
}

const _defaultAuthErrorMessage =
    'Произошла неизвестная ошибка. Проверьте ваш пароль и попробуйте снова';

String authErrorMessageFrom(
  Object error, {
  String fallback = _defaultAuthErrorMessage,
}) {
  Object? current = error;
  while (current is CustomException && current.causedError != null) {
    current = current.causedError;
  }

  if (current is DioException) {
    final data = current.response?.data;
    if (data is Map) {
      final detail = data['detail'];
      if (detail is String && detail.trim().isNotEmpty) {
        return detail.trim();
      }
      if (detail is List && detail.isNotEmpty) {
        return detail.map((item) => item.toString()).join('\n');
      }
    }
  }

  if (error is CustomException &&
      error.message != null &&
      error.message!.trim().isNotEmpty) {
    return error.message!.trim();
  }

  return fallback;
}
