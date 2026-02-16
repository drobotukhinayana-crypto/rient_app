import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/email_storage.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';

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
    required String password,
    required int userAgent,
    required int deviceId,
  }) async {
    final url = ApiConsts().createUrl('accounts/token/');
    final email = ref.read(emailStorageProvider);
    final role = ref.read(roleProvider);
    final organizationId = ref.read(organizationIdProvider);
    final response = await Dio().post<Map<String, dynamic>>(
      url,
      data: FormData.fromMap({
        'email': email,
        'password': password,
        'role': role,
        'user_agent': userAgent,
        'device_id': deviceId,
        'organization': organizationId,
        'remember_me': true,
        'branch': 3,
        'captcha': '0cAFcWeA5CVv...Hd4jjnjP6igECB-RndwLqpKbelHe8G',
      }),
    );

    if (response.statusCode == 200) {
      // Новый формат: access + refresh; старый: token
      final accessToken = response.data!['access'] as String?;
      final legacyToken = response.data!['token'] as String?;
      final token = accessToken ?? legacyToken;
      if (token != null && token.isNotEmpty) {
        await _tokenStorage.updateToken(token);
        return;
      }
    }
    throw Exception('${response.data}');
  }
}
