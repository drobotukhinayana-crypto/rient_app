import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/utils/base_state/base_state.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/custom_dialog.dart';
import 'package:rient_app/core/widgets/error_label.dart';
import 'package:rient_app/core/widgets/otp_input.dart';
import 'package:rient_app/features/auth/view/components/bottom_panel.dart';
import 'package:rient_app/features/auth/view/controllers/get_otp_contoller.dart';
import 'package:rient_app/features/auth/view/select_company_page.dart';
import 'package:rient_app/resources/resources.dart';

class OtpPage extends StatelessWidget {
  const OtpPage({required this.email, super.key});

  final String email;

  static const name = 'otp_page';
  static const path = '/otp_page';

  static void navigate(BuildContext context, {required String email}) =>
      context.pushNamed(name, extra: email);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _BodyWidget(email: email));
  }
}

class _BodyWidget extends ConsumerStatefulWidget {
  const _BodyWidget({required this.email});

  final String email;

  @override
  ConsumerState<_BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends ConsumerState<_BodyWidget> {
  bool _otpHasError = false;
  static const _resendSeconds = 45;
  int _secondsLeft = _resendSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = _resendSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_secondsLeft <= 1) {
          _timer?.cancel();
          _secondsLeft = 0;
        } else {
          _secondsLeft--;
        }
      });
    });
  }

  void _onResendCode() async {
    await ref
        .read(getOtpControllerProvider.notifier)
        .getOtp(widget.email, '0cAFcWeA5CVv...Hd4jjnjP6igECB-RndwLqpKbelHe8G');
    _startTimer();
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _onOtpCompleted(String code) {
    // TODO: заменить на реальную проверку кода через API
    const validCode = '1234';
    if (code == validCode) {
      SelectCompanyPage.navigate(context);
    } else {
      setState(() => _otpHasError = true);
    }
  }

  void _onOtpChanged(String code) {
    if (_otpHasError) setState(() => _otpHasError = false);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(getOtpControllerProvider, (_, state) {
      state.whenOrNull(
        success: (value) => _startTimer(),
        error: (error) {
          // TODO: Возможно, стоит отобразить ошибку пользователю
        },
      );
    });

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: AppDecoration.padding16.copyWith(top: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // кнопка назад
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Image.asset(AppImages.back),
                      ),

                      // кнопка информации
                      GestureDetector(
                        onTap: () => CustomDialog.show(
                          context,
                          title: 'Где найти код?',
                          description: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Мы отправили код на вашу почту\n',
                                  style: AppFonts.c1Medium,
                                ),
                                TextSpan(
                                  text: widget.email,
                                  style: AppFonts.c1Bold,
                                ),
                                TextSpan(
                                  text:
                                      ' проверьте входящие письма и спам, если код не пришел, нажмите кнопку ',
                                  style: AppFonts.c1Medium,
                                ),
                                TextSpan(
                                  text: '“Отправить новый код”',
                                  style: AppFonts.c1Bold,
                                ),
                                TextSpan(
                                  text: ' когда таймер закончится',
                                  style: AppFonts.c1Medium,
                                ),
                              ],
                            ),
                          ),
                          titleButton: 'Закрыть',
                          onTap: () => context.pop(),
                        ),
                        child: Image.asset(AppImages.info),
                      ),
                    ],
                  ),
                  // логотип
                  Image.asset(AppImages.logoBig),
                  Gap(28),

                  // заголовок
                  Text('Rient', style: AppFonts.bold40),
                  Gap(24),

                  // текст с почтой
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Введите код, отправленный на вашу почту\n',
                            style: AppFonts.c1Medium,
                          ),
                          TextSpan(text: widget.email, style: AppFonts.c1Bold),
                        ],
                      ),
                    ),
                  ),
                  Gap(16),

                  // поле для ввода кода
                  OtpInput(
                    hasError: _otpHasError,
                    onCompleted: _onOtpCompleted,
                    onChanged: _onOtpChanged,
                  ),

                  // ошибка
                  if (_otpHasError)
                    const ErrorLabel(
                      'Неверный код, попробуйте еще раз',
                      alignment: Alignment.center,
                    ),

                  Gap(16),

                  // кнопка отправки нового кода и секундомер
                  TextButton(
                    onPressed:
                        _secondsLeft > 0 ||
                            ref.watch(getOtpControllerProvider).isLoading
                        ? null
                        : _onResendCode,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'Отправить новый код',
                      style: AppFonts.c1Medium.copyWith(
                        color:
                            (_secondsLeft > 0 ||
                                ref.watch(getOtpControllerProvider).isLoading)
                            ? AppColors.grey
                            : AppColors.mainAccent,
                      ),
                    ),
                  ),

                  // секундомер
                  if (_secondsLeft > 0) ...[
                    Gap(4),
                    Text(
                      _formatTime(_secondsLeft),
                      style: AppFonts.c1Medium.copyWith(
                        color: AppColors.mainAccent,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // нижняя панель
          const BottomPanel(),
        ],
      ),
    );
  }
}
