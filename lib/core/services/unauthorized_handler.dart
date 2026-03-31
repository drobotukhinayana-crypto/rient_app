import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/auth/logout_action.dart';

bool _isUnauthorizedHandlingInProgress = false;

bool _looksLikeInvalidTokenPayload(Object? data) {
  final raw = data?.toString().toLowerCase() ?? '';
  if (raw.isEmpty) return false;
  return raw.contains('token') &&
      (raw.contains('invalid') ||
          raw.contains('not valid') ||
          raw.contains('expired') ||
          raw.contains('unauthorized'));
}

/// При 401/просроченном токене очищает сессию и переводит на экран входа.
Future<void> handleUnauthorizedIfNeeded(Ref ref, Object error) async {
  if (_isUnauthorizedHandlingInProgress) return;
  if (error is! DioException) return;

  final code = error.response?.statusCode;
  final data = error.response?.data;
  final isUnauthorized = code == 401 || (code == 403 && _looksLikeInvalidTokenPayload(data));
  if (!isUnauthorized) return;

  _isUnauthorizedHandlingInProgress = true;
  try {
    await performLogoutWithRef(ref);
  } finally {
    _isUnauthorizedHandlingInProgress = false;
  }
}

