import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:rient_app/core/services/app_lock/app_lock_mode.dart';
import 'package:rient_app/core/services/app_lock/app_lock_service.dart';
import 'package:rient_app/core/services/token_storage.dart';

class AppLockUiState {
  const AppLockUiState({
    required this.isLocked,
    required this.isEnabled,
    this.mode,
  });

  const AppLockUiState.initial()
      : isLocked = false,
        isEnabled = false,
        mode = null;

  final bool isLocked;
  final bool isEnabled;
  final AppLockMode? mode;

  AppLockUiState copyWith({
    bool? isLocked,
    bool? isEnabled,
    AppLockMode? mode,
    bool clearMode = false,
  }) {
    return AppLockUiState(
      isLocked: isLocked ?? this.isLocked,
      isEnabled: isEnabled ?? this.isEnabled,
      mode: clearMode ? null : (mode ?? this.mode),
    );
  }
}

final appLockUiProvider =
    StateNotifierProvider<AppLockController, AppLockUiState>(
  (ref) => AppLockController(ref),
);

class AppLockController extends StateNotifier<AppLockUiState> {
  AppLockController(this.ref) : super(const AppLockUiState.initial()) {
    ref.listen<String?>(tokenProvider, (_, __) {
      unawaited(_syncLockWithSession());
    });
    unawaited(_syncLockWithSession());
  }

  final Ref ref;
  bool _unlockedThisSession = false;

  AppLockService get _service => ref.read(appLockServiceProvider);

  bool get _hasSession {
    final token = ref.read(tokenProvider);
    return token != null && token.isNotEmpty;
  }

  Future<void> _syncLockWithSession() async {
    final mode = await _service.getMode();
    final enabled = mode != null;
    final hasSession = _hasSession;
    final shouldLock =
        enabled && hasSession && (!_unlockedThisSession || state.isLocked);
    state = state.copyWith(
      isEnabled: enabled,
      mode: mode,
      clearMode: mode == null,
      isLocked: shouldLock,
    );
  }

  Future<void> refreshSettings() async {
    final mode = await _service.getMode();
    final enabled = mode != null;
    final hasSession = _hasSession;
    final shouldLock =
        enabled && hasSession && (!_unlockedThisSession || state.isLocked);
    state = state.copyWith(
      isEnabled: enabled,
      mode: mode,
      clearMode: mode == null,
      isLocked: shouldLock,
    );
  }

  void lockIfEnabled() {
    if (!_hasSession || !state.isEnabled) return;
    if (state.isLocked) return;
    state = state.copyWith(isLocked: true);
  }

  void unlock() {
    if (!state.isLocked) return;
    _unlockedThisSession = true;
    state = state.copyWith(isLocked: false);
  }

  Future<void> onSessionEnded() async {
    _unlockedThisSession = false;
    state = const AppLockUiState.initial();
  }

  Future<void> onBiometricEnabled() async {
    await refreshSettings();
    unlock();
  }

  Future<void> onPinEnabled() async {
    await refreshSettings();
    unlock();
  }
}
