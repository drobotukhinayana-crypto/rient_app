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
