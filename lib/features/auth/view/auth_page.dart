import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/utils/base_state/base_state.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/utils/exstensions/string_exstension.dart';
import 'package:rient_app/core/widgets/main_button.dart';
import 'package:rient_app/core/widgets/main_text_field.dart';
import 'package:rient_app/features/auth/view/components/auth_text_button.dart';
import 'package:rient_app/features/auth/view/components/bottom_panel.dart';
import 'package:rient_app/features/auth/view/components/country_dropdown.dart';
import 'package:rient_app/features/auth/view/controllers/get_otp_contoller.dart';
import 'package:rient_app/features/auth/view/otp_page.dart';
import 'package:rient_app/resources/resources.dart';

final _emailProvider = StateProvider.autoDispose<String>((ref) => '');

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  static const name = 'auth_page';
  static const path = '/auth_page';

  static void navigate(BuildContext context) => context.pushNamed(name);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _BodyWidget());
  }
}

class _BodyWidget extends ConsumerStatefulWidget {
  const _BodyWidget();

  @override
  ConsumerState<_BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends ConsumerState<_BodyWidget> {
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController.addListener(emailListener);
  }

  void emailListener() =>
      ref.read(_emailProvider.notifier).state = emailController.text;

  @override
  void dispose() {
    emailController.removeListener(emailListener);
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(getOtpControllerProvider, (_, state) {
      state.whenOrNull(success: (value) => OtpPage.navigate(context));
    });

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: AppDecoration.padding16.copyWith(top: 54),
              child: Column(
                children: [
                  // логотип
                  Image.asset(AppImages.logoBig),
                  Gap(28),

                  // заголовок
                  Text('Rient', style: AppFonts.bold40),
                  Gap(32),

                  // выбор страны
                  const CountryDropdown(),
                  Gap(16),

                  // поле для ввода почты
                  MainTextField(
                    label: 'Почта',
                    controller: emailController,
                    hintText: 'example@gmail.com',
                  ),

                  Gap(24),
                ],
              ),
            ),
          ),

          // кнопка и соглашение
          Padding(
            padding: AppDecoration.padding16.copyWith(bottom: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // кнопка продолжения
                MainButton(
                  title: 'Продолжить',
                  isActive: ref.watch(_emailProvider).isEmail,
                  isLoading: ref.watch(getOtpControllerProvider).isLoading,
                  onTap: () {
                    ref
                        .read(getOtpControllerProvider.notifier)
                        .getOtp(
                          ref.read(_emailProvider),
                          '0cAFcWeA5CVv...Hd4jjnvnlP6igECB-RndwLqpKbelHe8G',
                        );
                  },
                ),
                Gap(16),

                // пользовательское соглашение
                AuthTextButton(
                  title: 'Пользовательское соглашение?',
                  onTap: () {},
                ),
              ],
            ),
          ),

          // нижняя панель
          const BottomPanel(),
        ],
      ),
    );
  }
}
