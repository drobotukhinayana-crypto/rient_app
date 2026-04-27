import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/email_storage.dart';
import 'package:rient_app/core/services/local_storage.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/session_data/models/session_data.dart';
import 'package:rient_app/core/session_data/view/controller/session_data_controller.dart';
import 'package:rient_app/features/auth/service/auth_service.dart';
import 'package:rient_app/features/auth/logout_action.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/auth/view/providers/password_provider.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/auth/view/providers/role_storage_provider.dart';

bool _isUnauthorizedHandlingInProgress = false;
bool _isSilentRefreshInProgress = false;

Future<bool> _tryRefreshTokenSilently(Ref ref) async {
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

  var password = ref.read(passwordProvider).trim();
  if (password.isEmpty) {
    password = ref.read(sessionDataControllerProvider)?.password.trim() ?? '';
  }
  if (password.isEmpty) return false;

  try {
    await ref.read(authServiceProvider).getToken(
      password: password,
      deviceId: DateTime.now().millisecondsSinceEpoch,
      userAgent: 'flutter_app'.hashCode,
    );
    final token = ref.read(tokenProvider);
    final email = ref.read(emailStorageProvider);
    if (token == null || token.isEmpty || email == null || email.isEmpty) {
      return false;
    }
    ref.read(passwordProvider.notifier).state = password;
    await ref.read(sessionDataControllerProvider.notifier).saveSessionData(
      SessionData(email: email, password: password, token: token),
    );
    return true;
  } catch (_) {
    return false;
  }
}

/// Публичный мягкий refresh токена (без logout), удобен для lifecycle-resume.
Future<bool> refreshTokenSilentlyIfPossible(Ref ref) async {
  if (_isSilentRefreshInProgress || _isUnauthorizedHandlingInProgress) {
    return false;
  }
  _isSilentRefreshInProgress = true;
  try {
    return await _tryRefreshTokenSilently(ref);
  } finally {
    _isSilentRefreshInProgress = false;
  }
}

/// При 401/просроченном токене очищает сессию и переводит на экран входа.
Future<void> handleUnauthorizedIfNeeded(Ref ref, Object error) async {
  if (_isUnauthorizedHandlingInProgress) return;
  if (error is! DioException) return;

  final code = error.response?.statusCode;
  final isUnauthorized = code == 401 || code == 403;
  if (!isUnauthorized) return;

  _isUnauthorizedHandlingInProgress = true;
  try {
    final refreshed = await _tryRefreshTokenSilently(ref);
    if (refreshed) return;
    await performLogoutWithRef(ref);
  } finally {
    _isUnauthorizedHandlingInProgress = false;
  }
}

