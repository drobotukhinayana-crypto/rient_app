import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/main_button.dart';
import 'package:rient_app/core/widgets/main_text_field.dart';
import 'package:rient_app/features/auth/components/bottom_panel.dart';
import 'package:rient_app/features/tabbar/view/tab_bar_page.dart';
import 'package:rient_app/resources/resources.dart';

class AuthPasswordPage extends StatefulWidget {
  const AuthPasswordPage({super.key});

  static const name = 'auth_password_page';
  static const path = '/auth_password_page';

  static void navigate(BuildContext context) => context.pushNamed(name);

  @override
  State<AuthPasswordPage> createState() => _AuthPasswordPageState();
}

class _AuthPasswordPageState extends State<AuthPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: AppDecoration.padding16.copyWith(top: 54),
                child: Column(
                  children: [
                    Image.asset(AppImages.logoBig),
                    Gap(28),
                    Text('Rient', style: AppFonts.bold40),
                    Gap(32),
                    MainTextField(
                      label: 'Пароль',
                      controller: TextEditingController(),
                      hintText: 'qwerty12345!',
                      isPassword: true,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: AppDecoration.padding16.copyWith(bottom: 24),
              child: MainButton(
                title: 'Продолжить',
                onTap: () => TabBarPage.navigate(context),
              ),
            ),
            const BottomPanel(),
          ],
        ),
      ),
    );
  }
}
