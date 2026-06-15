import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/services/app_lock/app_lock_mode.dart';
import 'package:rient_app/core/services/app_lock/app_lock_service.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/error_label.dart';
import 'package:rient_app/core/widgets/main_button.dart';
import 'package:rient_app/core/widgets/otp_input.dart';
import 'package:rient_app/features/auth/logout_action.dart';
import 'package:rient_app/features/auth/view/providers/app_lock_provider.dart';
import 'package:rient_app/resources/resources.dart';

const _pinLength = 4;

class AppLockListener extends ConsumerStatefulWidget {
  const AppLockListener({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppLockListener> createState() => _AppLockListenerState();
}

class _AppLockListenerState extends ConsumerState<AppLockListener>
    with WidgetsBindingObserver {
  bool _pinHasError = false;
  int _pinInputKey = 0;
  bool _showForgotPinPrompt = false;
  bool _isForgotPinLoggingOut = false;
  bool _isBiometricUnlockInProgress = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _isBiometricUnlockInProgress = false;
      ref.read(appLockUiProvider.notifier).lockIfEnabled();
      return;
    }

    if (state == AppLifecycleState.resumed) {
      _scheduleBiometricUnlockIfNeeded();
    }
  }

  void _scheduleBiometricUnlockIfNeeded() {
    final lockState = ref.read(appLockUiProvider);
    if (!lockState.isLocked || lockState.mode != AppLockMode.biometric) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(_tryBiometricUnlock());
    });
  }

  bool get _canPromptBiometrics {
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    return lifecycle == null || lifecycle == AppLifecycleState.resumed;
  }

  void _resetPinInput() {
    _pinHasError = false;
    _pinInputKey++;
  }

  bool _usesPinInput(AppLockUiState lockState) {
    return lockState.mode != AppLockMode.biometric;
  }

  Future<void> _tryBiometricUnlock() async {
    if (_isBiometricUnlockInProgress || !_canPromptBiometrics) return;

    final lockState = ref.read(appLockUiProvider);
    if (!lockState.isLocked || lockState.mode != AppLockMode.biometric) return;

    _isBiometricUnlockInProgress = true;
    try {
      final service = ref.read(appLockServiceProvider);
      final ok = await service.authenticateWithBiometrics(
        reason: 'Разблокируйте приложение',
      );
      if (!mounted || !ok) return;
      ref.read(appLockUiProvider.notifier).unlock();
    } finally {
      _isBiometricUnlockInProgress = false;
    }
  }

  Future<void> _onPinCompleted(String pin) async {
    final service = ref.read(appLockServiceProvider);
    final ok = await service.verifyPin(pin);
    if (!mounted) return;
    if (!ok) {
      setState(() {
        _pinHasError = true;
        _pinInputKey++;
      });
      return;
    }
    ref.read(appLockUiProvider.notifier).unlock();
  }

  void _onPinChanged(String _) {
    if (_pinHasError) {
      setState(() => _pinHasError = false);
    }
  }

  void _onForgotPin() {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _showForgotPinPrompt = true);
  }

  void _dismissForgotPinPrompt() {
    if (_isForgotPinLoggingOut) return;
    setState(() {
      _showForgotPinPrompt = false;
      _isForgotPinLoggingOut = false;
    });
  }

  Future<void> _confirmForgotPinLogout() async {
    if (_isForgotPinLoggingOut) return;
    setState(() => _isForgotPinLoggingOut = true);
    await performLogout(ref);
    if (!mounted) return;
    setState(() {
      _showForgotPinPrompt = false;
      _isForgotPinLoggingOut = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AppLockUiState>(appLockUiProvider, (previous, next) {
      if (next.isLocked &&
          next.mode == AppLockMode.biometric &&
          previous?.isLocked != true) {
        _scheduleBiometricUnlockIfNeeded();
      }
      if (next.isLocked && _usesPinInput(next)) {
        if (previous?.isLocked != true) {
          setState(() {
            _resetPinInput();
            _showForgotPinPrompt = false;
            _isForgotPinLoggingOut = false;
          });
        }
      }
      if (!next.isLocked && previous?.isLocked == true) {
        setState(() {
          _resetPinInput();
          _showForgotPinPrompt = false;
          _isForgotPinLoggingOut = false;
        });
      }
    });

    final lockState = ref.watch(appLockUiProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final usesPinInput = _usesPinInput(lockState);

    return Stack(
      children: [
        widget.child,
        if (lockState.isLocked)
          Positioned.fill(
            child: Material(
              color: isDark
                  ? AppColors.secondaryDarkLight
                  : AppColors.tabBarScreenBackground,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(AppImages.logoBig, height: 72),
                                const Gap(24),
                                Text(
                                  'Приложение заблокировано',
                                  style: AppFonts.h4Medium,
                                  textAlign: TextAlign.center,
                                ),
                                const Gap(12),
                                Text(
                                  lockState.mode == AppLockMode.biometric
                                      ? 'Подтвердите вход с помощью биометрии'
                                      : 'Введите PIN-код для продолжения',
                                  style: AppFonts.b2Regular.copyWith(
                                    color: AppColors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                if (usesPinInput) ...[
                                  const Gap(32),
                                  OtpInput(
                                    key: ValueKey(_pinInputKey),
                                    length: _pinLength,
                                    hasError: _pinHasError,
                                    fieldBackgroundColor: isDark
                                        ? AppColors.secondaryLightDark
                                        : AppColors.primaryWhite,
                                    idleBorderColor: AppColors.grey.withValues(
                                      alpha: 0.45,
                                    ),
                                    onChanged: _onPinChanged,
                                    onCompleted: _onPinCompleted,
                                  ),
                                  if (_pinHasError) ...[
                                    const Gap(12),
                                    const ErrorLabel(
                                      'Неверный PIN-код',
                                      alignment: Alignment.center,
                                    ),
                                  ],
                                  const Gap(16),
                                  TextButton(
                                    onPressed: _onForgotPin,
                                    child: Text(
                                      'Забыли PIN-код?',
                                      style: AppFonts.b2Regular.copyWith(
                                        color: AppColors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (lockState.mode == AppLockMode.biometric) ...[
                        MainButton(
                          title: 'Разблокировать',
                          onTap: _tryBiometricUnlock,
                        ),
                        const Gap(12),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        if (lockState.isLocked && _showForgotPinPrompt)
          Positioned.fill(
            child: Material(
              color: Colors.black.withValues(alpha: 0.45),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Material(
                    color: isDark
                        ? AppColors.primaryWhiteDark
                        : AppColors.primaryWhite,
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Забыли PIN-код?',
                            style: AppFonts.h4Medium,
                            textAlign: TextAlign.center,
                          ),
                          const Gap(12),
                          Text(
                            'PIN хранится только на этом устройстве и не может быть восстановлен. '
                            'Чтобы задать новый PIN, выйдите из аккаунта и войдите снова.',
                            style: AppFonts.b2Regular.copyWith(
                              color: AppColors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Gap(20),
                          MainButton(
                            title: 'Выйти и войти',
                            isLoading: _isForgotPinLoggingOut,
                            onTap: () => unawaited(_confirmForgotPinLogout()),
                          ),
                          const Gap(8),
                          TextButton(
                            onPressed:
                                _isForgotPinLoggingOut ? null : _dismissForgotPinPrompt,
                            child: const Text('Отмена'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
