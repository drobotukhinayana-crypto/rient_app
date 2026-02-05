import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

class AuthService {
  final ApiConsts _apiConsts = ApiConsts();
  final Dio _dio = Dio();
  final String _requestVerificationCode = 'accounts/request_verification_code/';

  Future<void> requestVerificationCode({
    required String email,
    required String captcha,
  }) async {
    final response = await _dio.post(
      _apiConsts.createUrl(_requestVerificationCode),
      data: <String, String>{'email': email, 'captcha': captcha},
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('${response.statusCode}');
    }
  }
}
