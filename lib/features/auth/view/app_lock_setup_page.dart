import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/routes/route_notifier.dart'
    show rootNavigatorKey;
import 'package:rient_app/core/services/app_lock/app_lock_service.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/app_service_message.dart';
import 'package:rient_app/core/widgets/error_label.dart';
import 'package:rient_app/core/widgets/main_button.dart';
import 'package:rient_app/core/widgets/otp_input.dart';
import 'package:rient_app/features/auth/view/providers/app_lock_provider.dart';
import 'package:rient_app/features/tabbar/view/tab_bar_page.dart';
import 'package:rient_app/resources/resources.dart';

enum _AppLockSetupStep { choose, pin }

enum _PinSetupSubStep { enter, confirm }

class AppLockSetupPage extends ConsumerStatefulWidget {
  const AppLockSetupPage({super.key});

  static const name = 'app_lock_setup_page';
  static const path = '/app_lock_setup_page';

  static void navigate(BuildContext context) => context.goNamed(name);

  @override
  ConsumerState<AppLockSetupPage> createState() => _AppLockSetupPageState();
}

class _AppLockSetupPageState extends ConsumerState<AppLockSetupPage> {
  static const _pinLength = 4;
  static const _pinSubtitleHeight = 44.0;

  _AppLockSetupStep _step = _AppLockSetupStep.choose;
  _PinSetupSubStep _pinSubStep = _PinSetupSubStep.enter;
  bool _isLoading = false;
  bool? _canUseBiometrics;
  String? _biometricLabel;
  String? _enteredPin;
  bool _pinHasError = false;
  String? _pinError;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadBiometricInfo();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _resetScrollPosition() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollController.hasClients) return;
      _scrollController.jumpTo(0);
    });
  }

  Future<void> _loadBiometricInfo() async {
    final service = ref.read(appLockServiceProvider);
    final canUseBiometrics = await service.canUseBiometrics();
    final biometricLabel = canUseBiometrics
        ? await service.biometricLabel()
        : null;
    if (!mounted) return;
    setState(() {
      _canUseBiometrics = canUseBiometrics;
      _biometricLabel = biometricLabel;
    });
  }

  Future<void> _finishSetup() async {
    if (!mounted) return;
    TabBarPage.navigate(context);
  }

  void _showSetupSuccessMessage(String message) {
    final rootContext = rootNavigatorKey.currentContext;
    if (rootContext == null || !rootContext.mounted) return;
    showAppServiceMessage(rootContext, message: message);
  }

  Future<void> _enableBiometric() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    final service = ref.read(appLockServiceProvider);
    try {
      await service.enableBiometric();
      await ref.read(appLockUiProvider.notifier).onBiometricEnabled();
      if (!mounted) return;
      await _finishSetup();
      _showSetupSuccessMessage('Блокировка по $_biometricLabel включена');
    } on AppLockSetupException catch (e) {
      if (mounted) {
        showAppServiceMessage(
          context,
          message: e.message,
          variant: AppServiceMessageVariant.error,
        );
      }
    } catch (_) {
      if (mounted) {
        showAppServiceMessage(
          context,
          message: 'Не удалось включить биометрию',
          variant: AppServiceMessageVariant.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _savePin(String pin) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _pinError = null;
      _pinHasError = false;
    });

    final service = ref.read(appLockServiceProvider);
    try {
      await service.enablePin(pin);
      await ref.read(appLockUiProvider.notifier).onPinEnabled();
      if (!mounted) return;
      await _finishSetup();
      _showSetupSuccessMessage('PIN-код для входа установлен');
    } on AppLockSetupException catch (e) {
      if (mounted) {
        setState(() {
          _pinError = e.message;
          _pinHasError = true;
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onPinEnterCompleted(String pin) {
    setState(() {
      _enteredPin = pin;
      _pinSubStep = _PinSetupSubStep.confirm;
      _pinHasError = false;
      _pinError = null;
    });
    _resetScrollPosition();
  }

  void _onPinConfirmCompleted(String pin) {
    if (pin != _enteredPin) {
      setState(() {
        _pinHasError = true;
        _pinError = 'PIN-коды не совпадают';
        _pinSubStep = _PinSetupSubStep.enter;
        _enteredPin = null;
      });
      _resetScrollPosition();
      return;
    }
    unawaited(_savePin(pin));
  }

  void _onPinChanged(String _) {
    if (_pinHasError) {
      setState(() {
        _pinHasError = false;
        _pinError = null;
      });
    }
  }

  void _goBackFromPinSetup() {
    if (_pinSubStep == _PinSetupSubStep.confirm) {
      setState(() {
        _pinSubStep = _PinSetupSubStep.enter;
        _enteredPin = null;
        _pinHasError = false;
        _pinError = null;
      });
      _resetScrollPosition();
      return;
    }

    setState(() {
      _step = _AppLockSetupStep.choose;
      _pinSubStep = _PinSetupSubStep.enter;
      _enteredPin = null;
      _pinHasError = false;
      _pinError = null;
    });
    _resetScrollPosition();
  }

  Widget _buildSubtitle(String text) {
    final subtitle = Text(
      text,
      style: AppFonts.b2Regular,
      textAlign: TextAlign.center,
    );

    if (_step != _AppLockSetupStep.pin) {
      return SizedBox(width: double.infinity, child: subtitle);
    }

    return SizedBox(
      width: double.infinity,
      height: _pinSubtitleHeight,
      child: subtitle,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_canUseBiometrics == null) {
      return PopScope(
        canPop: false,
        child: Scaffold(
          body: SafeArea(child: Center(child: CircularProgressIndicator())),
        ),
      );
    }

    final canUseBiometrics = _canUseBiometrics!;
    final biometricLabel = _biometricLabel;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: AppDecoration.padding16.copyWith(top: 54, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(AppImages.logoBig),
                const Gap(28),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    _step == _AppLockSetupStep.choose
                        ? 'Защитить приложение'
                        : _pinSubStep == _PinSetupSubStep.enter
                        ? 'Установите PIN-код'
                        : 'Повторите PIN-код',
                    style: AppFonts.h1Semi,
                    textAlign: TextAlign.center,
                  ),
                ),
                const Gap(16),
                _buildSubtitle(
                  _step == _AppLockSetupStep.choose
                      ? canUseBiometrics
                            ? 'После входа можно быстро разблокировать приложение по $biometricLabel или PIN-коду.'
                            : 'После входа можно быстро разблокировать приложение по PIN-коду.'
                      : _pinSubStep == _PinSetupSubStep.enter
                      ? 'Введите $_pinLength цифры для разблокировки приложения.'
                      : 'Введите PIN-код ещё раз для подтверждения.',
                ),
                const Gap(32),
                if (_step == _AppLockSetupStep.choose) ...[
                  if (canUseBiometrics) ...[
                    MainButton(
                      title: 'Использовать $biometricLabel',
                      isLoading: _isLoading,
                      onTap: _enableBiometric,
                    ),
                    const Gap(12),
                  ],
                  MainButton(
                    title: 'Установить PIN-код',
                    isLoading: _isLoading,
                    onTap: () {
                      setState(() {
                        _step = _AppLockSetupStep.pin;
                        _pinSubStep = _PinSetupSubStep.enter;
                        _enteredPin = null;
                        _pinHasError = false;
                        _pinError = null;
                      });
                      _resetScrollPosition();
                    },
                  ),
                ] else ...[
                  Align(
                    alignment: Alignment.center,
                    child: OtpInput(
                      key: ValueKey(_pinSubStep),
                      length: _pinLength,
                      hasError: _pinHasError,
                      onChanged: _onPinChanged,
                      onCompleted: _pinSubStep == _PinSetupSubStep.enter
                          ? _onPinEnterCompleted
                          : _onPinConfirmCompleted,
                    ),
                  ),
                  if (_pinHasError && _pinError != null) ...[
                    const Gap(12),
                    ErrorLabel(_pinError!, alignment: Alignment.center),
                  ],
                  const Gap(24),
                  TextButton(
                    onPressed: _isLoading ? null : _goBackFromPinSetup,
                    child: const Text('Назад'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
