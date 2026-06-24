import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/network/network_failure.dart';
import 'package:rient_app/core/services/local_storage.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/session_data/data/session_data_storage.dart';
import 'package:rient_app/core/session_data/models/session_data.dart';
import 'package:rient_app/core/session_data/view/controller/session_data_controller.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/features/auth/service/auth_service.dart';
import 'package:rient_app/core/routes/router_provider.dart';
import 'package:rient_app/features/auth/logout_action.dart';
import 'package:rient_app/features/auth/view/auth_page.dart';
import 'package:rient_app/features/auth/view/auth_password_page.dart';
import 'package:rient_app/features/auth/view/otp_page.dart';
import 'package:rient_app/features/auth/view/select_branch_page.dart';
import 'package:rient_app/features/auth/view/select_company_page.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/auth/view/providers/password_provider.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/auth/view/providers/role_storage_provider.dart';
import 'package:rient_app/features/launch/launch_page.dart';

bool _isUnauthorizedHandlingInProgress = false;
bool _isSilentRefreshInProgress = false;

/// Экраны входа: на них и между ними 401 не должен сбрасывать сессию.
const _authFlowPaths = {
  LaunchPage.path,
  AuthPage.path,
  OtpPage.path,
  SelectCompanyPage.path,
  SelectBranchPage.path,
  AuthPasswordPage.path,
};

enum _TokenRefreshOutcome {
  success,
  networkFailure,
  authFailure,
}

DioException? dioExceptionFrom(Object? error) {
  if (error == null) return null;
  if (error is DioException) return error;
  if (error is CustomException) return dioExceptionFrom(error.causedError);
  return null;
}

Future<SessionData?> _readStoredSession(dynamic ref) async {
  final inMemory = ref.read(sessionDataControllerProvider);
  if (inMemory != null) return inMemory;
  return ref.read(sessionDataStorageProvider).get();
}

bool _hasCompletedLoginSession(SessionData? session) {
  if (session == null) return false;
  if (session.password.trim().isNotEmpty) return true;
  final refresh = session.refreshToken?.trim() ?? '';
  return refresh.isNotEmpty;
}

bool _isOnAuthFlowScreen(String location) =>
    _authFlowPaths.contains(location);

bool _isAuthRefreshFailure(Object? error) {
  if (error == null) return true;
  if (isNetworkFailure(error)) return false;
  final dio = dioExceptionFrom(error);
  if (dio == null) return false;
  final code = dio.response?.statusCode;
  return code != null && code >= 400 && code < 500;
}

Future<_TokenRefreshOutcome> _refreshWithPassword(dynamic ref, String password) async {
  try {
    await ref.read(authServiceProvider).getToken(
          password: password,
          deviceId: DateTime.now().millisecondsSinceEpoch,
          userAgent: 'flutter_app'.hashCode,
        );
    final token = ref.read(tokenProvider);
    if (token == null || token.isEmpty) {
      return _TokenRefreshOutcome.authFailure;
    }
    return _TokenRefreshOutcome.success;
  } catch (e) {
    if (isNetworkFailure(e)) {
      return _TokenRefreshOutcome.networkFailure;
    }
    if (_isAuthRefreshFailure(e)) {
      return _TokenRefreshOutcome.authFailure;
    }
    return _TokenRefreshOutcome.networkFailure;
  }
}

Future<_TokenRefreshOutcome> _tryRefreshTokenSilently(dynamic ref) async {
  final savedRole = ref.read(roleStorageProvider);
  final currentRole = ref.read(roleProvider);
  if (currentRole == 0 && savedRole > 0) {
    ref.read(roleProvider.notifier).state = savedRole;
  }

  final currentOrganizationId = ref.read(organizationIdProvider);
  if (currentOrganizationId <= 0) {
    final savedOrganizationIdRaw = await ref
        .read(localStorageProvider)
        .getString('organization_id');
    final savedOrganizationId = int.tryParse(savedOrganizationIdRaw ?? '') ?? 0;
    if (savedOrganizationId > 0) {
      await ref
          .read(organizationIdProvider.notifier)
          .setOrganizationId(savedOrganizationId);
    }
  }

  final session = await _readStoredSession(ref);
  var password = ref.read(passwordProvider).trim();
  if (password.isEmpty) {
    password = session?.password.trim() ?? '';
    if (password.isNotEmpty) {
      ref.read(passwordProvider.notifier).state = password;
    }
  }

  final refreshToken = session?.refreshToken?.trim();
  if (refreshToken != null && refreshToken.isNotEmpty) {
    try {
      await ref.read(authServiceProvider).refreshAccessToken(refreshToken);
      return _TokenRefreshOutcome.success;
    } catch (e) {
      if (isNetworkFailure(e)) {
        return _TokenRefreshOutcome.networkFailure;
      }
      if (!_isAuthRefreshFailure(e)) {
        return _TokenRefreshOutcome.networkFailure;
      }
    }
  }

  if (password.isEmpty) {
    return _TokenRefreshOutcome.authFailure;
  }

  final outcome = await _refreshWithPassword(ref, password);
  return outcome;
}

/// Публичный мягкий refresh токена (без logout), удобен для lifecycle-resume.
Future<bool> refreshTokenSilentlyIfPossible(dynamic ref) async {
  if (_isSilentRefreshInProgress || _isUnauthorizedHandlingInProgress) {
    return false;
  }
  _isSilentRefreshInProgress = true;
  try {
    final outcome = await _tryRefreshTokenSilently(ref);
    return outcome == _TokenRefreshOutcome.success;
  } finally {
    _isSilentRefreshInProgress = false;
  }
}

/// При 401 (просроченный токен) пробует обновить токен; logout только при ошибке авторизации.
/// 403 — нет прав на ресурс, сессию не сбрасываем.
Future<void> handleUnauthorizedIfNeeded(Ref ref, Object error) async {
  if (_isUnauthorizedHandlingInProgress) return;

  final dio = dioExceptionFrom(error);
  if (dio == null) return;
  if (dio.response?.statusCode != 401) return;

  final token = ref.read(tokenProvider);
  if (token == null || token.isEmpty) return;

  final location = ref.read(routerProvider).state.uri.path;
  if (_isOnAuthFlowScreen(location)) return;

  final session = await _readStoredSession(ref);
  // После OTP есть только verification token — полной сессии ещё нет.
  if (!_hasCompletedLoginSession(session)) return;

  _isUnauthorizedHandlingInProgress = true;
  try {
    final outcome = await _tryRefreshTokenSilently(ref);
    switch (outcome) {
      case _TokenRefreshOutcome.success:
        return;
      case _TokenRefreshOutcome.networkFailure:
        return;
      case _TokenRefreshOutcome.authFailure:
        await performLogoutWithRef(ref);
    }
  } finally {
    _isUnauthorizedHandlingInProgress = false;
  }
}
