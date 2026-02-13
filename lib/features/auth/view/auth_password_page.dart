import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/main_button.dart';
import 'package:rient_app/core/widgets/main_text_field.dart';
import 'package:rient_app/features/auth/view/components/bottom_panel.dart';
import 'package:rient_app/features/auth/view/select_branch_page.dart';
import 'package:rient_app/resources/resources.dart';

final _passwordProvider = StateProvider.autoDispose<String>((ref) => '');

class AuthPasswordPage extends ConsumerStatefulWidget {
  const AuthPasswordPage({super.key});

  static const name = 'auth_password_page';
  static const path = '/auth_password_page';

  static void navigate(BuildContext context) => context.pushNamed(name);

  @override
  ConsumerState<AuthPasswordPage> createState() => _AuthPasswordPageState();
}

class _AuthPasswordPageState extends ConsumerState<AuthPasswordPage> {
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    passwordController.addListener(passwordListener);
  }

  void passwordListener() =>
      ref.read(_passwordProvider.notifier).state = passwordController.text;

  @override
  void dispose() {
    passwordController.removeListener(passwordListener);
    passwordController.dispose();
    super.dispose();
  }

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
                    // логотип
                    Image.asset(AppImages.logoBig),
                    Gap(28),

                    // заголовок
                    Text('Rient', style: AppFonts.bold40),
                    Gap(32),

                    // поле для ввода пароля
                    MainTextField(
                      label: 'Пароль',
                      controller: passwordController,
                      hintText: 'qwerty12345!',
                      isPassword: true,
                    ),
                  ],
                ),
              ),
            ),

            // кнопка
            Padding(
              padding: AppDecoration.padding16.copyWith(bottom: 24),
              child: MainButton(
                title: 'Продолжить',
                onTap: () => SelectBranchPage.navigate(context),
              ),
            ),

            // нижняя панель
            const BottomPanel(),
          ],
        ),
      ),
    );
  }
}
