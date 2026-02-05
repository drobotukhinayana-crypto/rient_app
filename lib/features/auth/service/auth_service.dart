import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

class AuthService {
  Future<void> requestVerificationCode({
    required String email,
    required String captcha,
  }) async {
    final url = ApiConsts().createUrl('accounts/request_verification_code/');
    final response = await Dio().post<Map<String, dynamic>>(
      url,
      data: FormData.fromMap({'email': email, 'captcha': captcha}),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('${response.data}');
    }
  }

  Future<void> verifyVerificationCode({
    required String email,
    required String captcha,
    required String verificationCode,
  }) async {
    final url = ApiConsts().createUrl('accounts/verify/');
    final response = await Dio().post<Map<String, dynamic>>(
      url,
      data: FormData.fromMap({
        'email': email,
        'captcha': captcha,
        'verification_code': verificationCode,
      }),
    );

    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('${response.data}');
    }
  }
}
