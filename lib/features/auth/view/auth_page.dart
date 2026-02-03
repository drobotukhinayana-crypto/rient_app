import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/main_button.dart';
import 'package:rient_app/core/widgets/main_text_field.dart';
import 'package:rient_app/features/auth/components/auth_text_button.dart';
import 'package:rient_app/resources/resources.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  static const name = 'auth_page';
  static const path = '/auth_page';

  static void navigate(BuildContext context) => context.goNamed(name);

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
      child: Padding(
        padding: AppDecoration.padding16.copyWith(top: 54),
        child: Column(
          children: [
            // логотип
            Image.asset(AppImages.logoBig),
            Gap(28),

            // заголовок
            Text('Rient', style: AppFonts.bold40),
            Gap(32),

            // поле для ввода почты
            MainTextField(
              label: 'Почта',
              controller: TextEditingController(),
              hintText: 'example@gmail.com',
            ),

            Spacer(),

            // кнопка продолжить
            MainButton(title: 'Продолжить', onTap: () {}),

            Gap(16),

            // пользовательское соглашение
            AuthTextButton(title: 'Пользовательское соглашение?', onTap: () {}),
          ],
        ),
      ),
    );
  }
}
