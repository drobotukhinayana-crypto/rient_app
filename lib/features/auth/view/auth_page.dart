import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/utils/base_state/base_state.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/utils/exstensions/string_exstension.dart';
import 'package:rient_app/core/utils/open_support_link.dart';
import 'package:rient_app/core/widgets/error_label.dart';
import 'package:rient_app/core/widgets/main_button.dart';
import 'package:rient_app/core/widgets/main_text_field.dart';
import 'package:rient_app/features/auth/view/components/bottom_panel.dart';
import 'package:rient_app/features/auth/view/components/country_dropdown.dart';
import 'package:rient_app/features/auth/view/controllers/get_otp_contoller.dart';
import 'package:rient_app/features/auth/view/otp_page.dart';
import 'package:rient_app/resources/resources.dart';

final _emailProvider = StateProvider.autoDispose<String>((ref) => '');
final _emailErrorProvider = StateProvider.autoDispose<String>((ref) => '');

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  static const name = 'auth_page';
  static const path = '/auth_page';

  static void navigate(BuildContext context) => context.goNamed(name);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: BottomPanel(),
      body: _BodyWidget(),
    );
  }
}

class _BodyWidget extends ConsumerStatefulWidget {
  const _BodyWidget();

  @override
  ConsumerState<_BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends ConsumerState<_BodyWidget> {
  final emailController = TextEditingController();
  bool _agreementAccepted = false;

  static final Uri _agreementUri =
      Uri.parse('https://rient.ru/doc/agreement_use_mobile_app.pdf');

  @override
  void initState() {
    super.initState();
    emailController.addListener(emailListener);
  }

  void emailListener() =>
      ref.read(_emailProvider.notifier).state = emailController.text;

  Future<void> _openAgreement() async {
    if (!mounted) return;
    await openExternalUrl(
      _agreementUri,
      context: context,
      failureMessage: 'Не удалось открыть пользовательское соглашение',
    );
  }

  void _onAgreementChanged(bool? value) {
    setState(() => _agreementAccepted = value ?? false);
  }

  @override
  void dispose() {
    emailController.removeListener(emailListener);
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(getOtpControllerProvider, (_, state) {
      state.whenOrNull(
        success: (value) {
          // Переходим на OTP только если мы ещё на экране Auth (успех от запроса кода).
          // Иначе при успешной верификации OTP этот listener тоже сработает и снова откроет OTP.
          if (!context.mounted) return;
          if (ModalRoute.of(context)?.isCurrent ?? false) {
            OtpPage.navigate(context, email: ref.read(_emailProvider));
          }
        },
        error: (error) {
          ref.read(_emailErrorProvider.notifier).state =
              'Произошла неизвестная ошибка. Проверьте вашу почту и попробуйте снова';
        },
      );
    });

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: AppDecoration.padding16.copyWith(top: 54, bottom: 16),
        child: Column(
          children: [
            // логотип
            Image.asset(AppImages.logoBig),
            Gap(28),

            // заголовок
            Text('Rient Admin', style: AppFonts.h1Semi),
            Gap(32),

            // выбор страны
            const CountryDropdown(),
            Gap(16),

            // поле для ввода почты
            MainTextField(
              label: 'Почта',
              controller: emailController,
              canEdit: _agreementAccepted,
              hasError: ref.watch(_emailErrorProvider).isNotEmpty,
              hintText: 'Ваш адрес электронной почты',
            ),
            if (ref.watch(_emailErrorProvider).isNotEmpty)
              ErrorLabel(ref.watch(_emailErrorProvider)),
            Gap(24),

            // кнопка продолжения
            MainButton(
              title: 'Продолжить',
              isActive:
                  _agreementAccepted && ref.watch(_emailProvider).isEmail,
              isLoading: ref.watch(getOtpControllerProvider).isLoading,
              onTap: () async => ref.read(getOtpControllerProvider.notifier).getOtp(
                    ref.read(_emailProvider),
                    '0cAFcWeA5CVv...Hd4jjnjP6igECB-RndwLqpKbelHe8G',
                  ),
            ),
            Gap(16),

            _AgreementCheckbox(
              value: _agreementAccepted,
              onChanged: _onAgreementChanged,
              onAgreementTap: _openAgreement,
            ),
            Gap(8),
          ],
        ),
      ),
    );
  }
}

class _AgreementCheckbox extends StatelessWidget {
  const _AgreementCheckbox({
    required this.value,
    required this.onChanged,
    required this.onAgreementTap,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onAgreementTap;

  @override
  Widget build(BuildContext context) {
    final linkStyle = AppFonts.c1Regular.copyWith(
      color: AppColors.themeAccent(context),
      decoration: TextDecoration.underline,
      decorationColor: AppColors.themeAccent(context),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.themeAccent(context),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            side: BorderSide(
              color: value
                  ? AppColors.themeAccent(context)
                  : AppColors.grey.withValues(alpha: 0.8),
            ),
          ),
        ),
        const Gap(8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('Я принимаю ', style: AppFonts.c1Regular),
                GestureDetector(
                  onTap: onAgreementTap,
                  child: Text('Пользовательское соглашение', style: linkStyle),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
