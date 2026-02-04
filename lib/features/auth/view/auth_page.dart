import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/main_button.dart';
import 'package:rient_app/core/widgets/main_text_field.dart';
import 'package:rient_app/features/auth/view/components/auth_text_button.dart';
import 'package:rient_app/features/auth/view/components/bottom_panel.dart';
import 'package:rient_app/features/auth/view/components/country_dropdown.dart';
import 'package:rient_app/features/auth/view/otp_page.dart';
import 'package:rient_app/resources/resources.dart';

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

class _BodyWidget extends StatelessWidget {
  const _BodyWidget();

  @override
  Widget build(BuildContext context) {
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
                    controller: TextEditingController(),
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
                  onTap: () => OtpPage.navigate(context),
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
