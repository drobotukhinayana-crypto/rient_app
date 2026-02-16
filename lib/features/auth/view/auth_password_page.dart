import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/session_data/models/session_data.dart';
import 'package:rient_app/core/session_data/view/controller/session_data_controller.dart';
import 'package:rient_app/core/services/email_storage.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/utils/base_state/base_state.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/error_label.dart';
import 'package:rient_app/core/widgets/main_button.dart';
import 'package:rient_app/core/widgets/main_text_field.dart';
import 'package:rient_app/features/auth/view/components/bottom_panel.dart';
import 'package:rient_app/features/auth/view/controllers/get_token_controller.dart';
import 'package:rient_app/features/auth/view/providers/password_provider.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/auth/view/select_branch_page.dart';
import 'package:rient_app/features/tabbar/view/tab_bar_page.dart';
import 'package:rient_app/resources/resources.dart';

final _errorPasswordProvider = StateProvider.autoDispose<String>((ref) => '');

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
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(getTokenControllerProvider, (_, state) {
      state.whenOrNull(
        success: (_) {
          final token = ref.read(tokenProvider);
          final email = ref.read(emailStorageProvider);
          if (token != null && email != null && email.isNotEmpty) {
            ref.read(sessionDataControllerProvider.notifier).saveSessionData(
                  SessionData(email: email, password: '', token: token),
                );
          }
          final roleId = ref.read(roleProvider);
          // Владелец (role = 0) — сразу на TabBar, без выбора филиала
          if (roleId == UserRole.owner.value) {
            TabBarPage.navigate(context);
          } else {
            SelectBranchPage.navigate(context);
          }
        },
        error: (error) {
          ref.read(_errorPasswordProvider.notifier).state =
              'Произошла неизвестная ошибка. Проверьте ваш пароль и попробуйте снова';
        },
      );
    });
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
                      hasError: ref.watch(_errorPasswordProvider).isNotEmpty,
                    ),
                    if (ref.watch(_errorPasswordProvider).isNotEmpty)
                      ErrorLabel(ref.watch(_errorPasswordProvider)),
                  ],
                ),
              ),
            ),

            // кнопка
            Padding(
              padding: AppDecoration.padding16.copyWith(bottom: 24),
              child: MainButton(
                title: 'Продолжить',
                onTap: () {
                  final password = passwordController.text;
                  ref.read(passwordProvider.notifier).state = password;
                  ref.read(getTokenControllerProvider.notifier).getToken(
                        password: password,
                        deviceId: Platform.operatingSystemVersion.hashCode,
                        userAgent: Platform.operatingSystem.hashCode,
                      );
                },
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
