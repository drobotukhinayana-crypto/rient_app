import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/network/app_dio.dart';
import 'package:rient_app/core/services/email_storage.dart';
import 'package:rient_app/core/services/local_storage.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/session_data/data/session_data_storage.dart';
import 'package:rient_app/core/session_data/models/session_data.dart';
import 'package:rient_app/core/session_data/view/controller/session_data_controller.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';
import 'package:rient_app/features/auth/view/providers/branches_id_provider.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/auth/view/providers/password_provider.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService(ref));

class AuthTokenPair {
  const AuthTokenPair({required this.access, this.refresh});

  final String access;
  final String? refresh;
}

class AuthService {
  AuthService(this.ref);

  final Ref ref;

  TokenStorageNotifier get _tokenStorage => ref.read(tokenProvider.notifier);

  AuthTokenPair _parseAuthResponse(Map<String, dynamic> data) {
    final access = data['access'] as String? ?? data['token'] as String?;
    final refresh = data['refresh'] as String?;
    if (access == null || access.isEmpty) {
      throw Exception('Token missing in auth response');
    }
    return AuthTokenPair(access: access, refresh: refresh);
  }

  Future<void> _persistAuthTokens(AuthTokenPair tokens) async {
    await _tokenStorage.updateToken(tokens.access);

    final email = ref.read(emailStorageProvider);
    if (email == null || email.isEmpty) return;

    var password = ref.read(passwordProvider).trim();
    String? refreshToken = tokens.refresh;
    if (password.isEmpty || refreshToken == null) {
      final stored =
          ref.read(sessionDataControllerProvider) ??
          await ref.read(sessionDataStorageProvider).get();
      if (password.isEmpty) {
        password = stored?.password.trim() ?? '';
      }
      refreshToken ??= stored?.refreshToken;
    }
    if (password.isEmpty) return;

    ref.read(passwordProvider.notifier).state = password;
    await ref
        .read(sessionDataControllerProvider.notifier)
        .saveSessionData(
          SessionData(
            email: email,
            password: password,
            token: tokens.access,
            refreshToken: refreshToken,
          ),
        );
  }

  /// POST accounts/token/refresh/ — новый access по refresh-токену.
  Future<void> refreshAccessToken(String refreshToken) async {
    final url = ApiConsts().createUrl('accounts/token/refresh/');
    try {
      final response = await createAppDio().post<Map<String, dynamic>>(
        url,
        data: {'refresh': refreshToken},
        options: Options(
          headers: {'Content-Type': 'application/json'},
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      if (response.statusCode != 200 || response.data == null) {
        throw DioException(
          requestOptions: RequestOptions(path: url),
          response: response,
          type: DioExceptionType.badResponse,
        );
      }
      final pair = _parseAuthResponse(response.data!);
      await _persistAuthTokens(
        AuthTokenPair(
          access: pair.access,
          refresh: pair.refresh ?? refreshToken,
        ),
      );
    } on DioException {
      rethrow;
    } catch (e) {
      throw DioException(
        requestOptions: RequestOptions(path: url),
        error: e,
        type: DioExceptionType.unknown,
      );
    }
  }

  Future<void> requestVerificationCode({
    required String email,
    required String captcha,
  }) async {
    final url = ApiConsts().createUrl('accounts/request_verification_code/');
    final response = await createAppDio().post<Map<String, dynamic>>(
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
    final response = await createAppDio().post<Map<String, dynamic>>(
      url,
      data: FormData.fromMap({
        'email': email,
        'captcha': captcha,
        'verification_code': verificationCode,
      }),
    );

    if (response.statusCode == 200 && response.data!['token'] != null) {
      await _tokenStorage.updateToken(response.data!['token'] as String);
      return;
    } else {
      throw Exception('${response.data}');
    }
  }

  Future<void> getToken({
    required String password,
    required int userAgent,
    required int deviceId,
    int? branchId,
  }) async {
    final url = ApiConsts().createUrl('accounts/token/');
    final email = ref.read(emailStorageProvider);
    final role = ref.read(roleProvider);
    final organizationId = ref.read(organizationIdProvider);
    var resolvedBranchId = branchId;
    if (role != UserRole.owner.value && resolvedBranchId == null) {
      resolvedBranchId = await _resolveBranchIdForAuth(
        email: email,
        password: password,
        organizationId: organizationId,
      );
    }
    final response = await createAppDio().post<Map<String, dynamic>>(
      url,
      data: FormData.fromMap({
        'email': email,
        'password': password,
        'role': role,
        'user_agent': userAgent,
        'device_id': deviceId,
        'organization': organizationId,
        'remember_me': true,
        if (resolvedBranchId != null) 'branch': resolvedBranchId,
        'captcha': '0cAFcWeA5CVv...Hd4jjnjP6igECB-RndwLqpKbelHe8G',
      }),
    );

    if (response.statusCode == 200 && response.data != null) {
      final pair = _parseAuthResponse(response.data!);
      await _persistAuthTokens(pair);
      return;
    }
    throw Exception('${response.data}');
  }

  Future<int?> _resolveBranchIdForAuth({
    required String? email,
    required String password,
    required int organizationId,
  }) async {
    final branchFromState = ref.read(branchesIdProvider);
    if (branchFromState > 0) {
      return branchFromState;
    }

    final savedBranchStr = await ref
        .read(localStorageProvider)
        .getString(
          buildSelectedBranchStorageKey(
            email: email,
            organizationId: organizationId,
            roleId: ref.read(roleProvider),
          ),
        );
    final savedBranchId = int.tryParse(savedBranchStr ?? '');
    if (savedBranchId != null && savedBranchId > 0) {
      return savedBranchId;
    }

    if (email == null || email.isEmpty || password.isEmpty) {
      return null;
    }

    final url = ApiConsts().createUrl('accounts/branches/');
    final response = await createAppDio().post<Map<String, dynamic>>(
      url,
      data: FormData.fromMap({
        'email': email,
        'captcha': '0cAFcWeA5CVv...Hd4jjnjP6igECB-RndwLqpKbelHe8G',
        'password': password,
        'organization': organizationId,
        'remember_me': true,
      }),
    );
    final branches = response.data?['branches'] as List<dynamic>? ?? [];
    if (branches.isEmpty) {
      return null;
    }
    final firstBranchId =
        (branches.first as Map<String, dynamic>)['id'] as int?;
    return firstBranchId;
  }
}
