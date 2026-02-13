import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService(ref));

class AuthService {
  AuthService(this.ref);

  final Ref ref;

  TokenStorageNotifier get _tokenStorage => ref.read(tokenProvider.notifier);
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

    if (response.statusCode == 200 && response.data!['token'] != null) {
      _tokenStorage.updateToken(response.data!['token'] as String);
      return;
    } else {
      throw Exception('${response.data}');
    }
  }

  Future<void> getToken({
    required String email,
    required String password,
    required int role,
    required String userAgent,
    required String deviceId,
    required int organization,
    required bool rememberMe,
    required List<String> branches,
  }) async {
    final url = ApiConsts().createUrl('accounts/token/');
    final response = await Dio().post<Map<String, dynamic>>(
      url,
      data: FormData.fromMap({
        'email': email,
        'password': password,
        'role': role,
        'user_agent': userAgent,
        'device_id': deviceId,
        'organization': organization,
        'remember_me': true,
        'branches': [],
      }),
    );

    if (response.statusCode == 200 && response.data!['token'] != null) {
      _tokenStorage.updateToken(response.data!['token'] as String);
      return;
    } else {
      throw Exception('${response.data}');
    }
  }
}
