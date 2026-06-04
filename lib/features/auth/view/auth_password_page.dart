import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/session_data/models/session_data.dart';
import 'package:rient_app/core/session_data/view/controller/session_data_controller.dart';
import 'package:rient_app/core/services/email_storage.dart';
import 'package:rient_app/core/services/local_storage.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/utils/base_state/base_state.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/error_label.dart';
import 'package:rient_app/core/widgets/main_button.dart';
import 'package:rient_app/core/widgets/main_text_field.dart';
import 'package:rient_app/features/auth/service/get_auth_branches.dart';
import 'package:rient_app/features/auth/view/components/bottom_panel.dart';
import 'package:rient_app/features/auth/view/controllers/get_token_controller.dart';
import 'package:rient_app/features/auth/view/providers/branches_id_provider.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/auth/view/providers/password_provider.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/auth/view/providers/role_storage_provider.dart';
import 'package:rient_app/features/auth/view/providers/selected_organization_member_provider.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
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
  bool _isAutoSingleBranchLogin = false;

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isTokenLoading = ref.watch(getTokenControllerProvider).isLoading;
    ref.listen(getTokenControllerProvider, (_, state) {
      state.whenOrNull(
        success: (_) {
          final token = ref.read(tokenProvider);
          final email = ref.read(emailStorageProvider);
          final password = ref.read(passwordProvider);
          if (token != null && email != null && email.isNotEmpty) {
            ref.read(sessionDataControllerProvider.notifier).saveSessionData(
                  SessionData(email: email, password: password, token: token),
                );
          }
          final roleId = ref.read(roleProvider);
          // Владелец (role = 0) — сразу на TabBar, без выбора филиала
          if (roleId == UserRole.owner.value || _isAutoSingleBranchLogin) {
            _isAutoSingleBranchLogin = false;
            TabBarPage.navigate(context);
          } else {
            SelectBranchPage.navigate(context);
          }
        },
        error: (error) {
          _isAutoSingleBranchLogin = false;
          ref.read(_errorPasswordProvider.notifier).state =
              'Произошла неизвестная ошибка. Проверьте ваш пароль и попробуйте снова';
        },
      );
    });
    return Scaffold(
      bottomNavigationBar: const BottomPanel(),
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: AppDecoration.padding16.copyWith(top: 54, bottom: 16),
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
                  Gap(24),

                  // кнопка
                  MainButton(
                    title: 'Продолжить',
                    isLoading: isTokenLoading,
                    onTap: () async {
                      final password = passwordController.text;
                      final selectedMember = ref.read(
                        selectedOrganizationMemberProvider,
                      );
                      if (selectedMember != null) {
                        ref
                            .read(organizationIdProvider.notifier)
                            .setOrganizationId(selectedMember.organization.id);
                        ref.read(roleProvider.notifier).state =
                            selectedMember.role.value;
                        await ref
                            .read(roleStorageProvider.notifier)
                            .setRole(selectedMember.role.value);
                      }
                      ref.read(passwordProvider.notifier).state = password;
                      final roleId = ref.read(roleProvider);
                      if (roleId == UserRole.owner.value) {
                        _isAutoSingleBranchLogin = false;
                        ref.read(getTokenControllerProvider.notifier).getToken(
                              password: password,
                              deviceId: Platform.operatingSystemVersion.hashCode,
                              userAgent: Platform.operatingSystem.hashCode,
                            );
                        return;
                      }
                      try {
                        final branchMembers = await ref.read(
                          getAuthBranchesProvider.future,
                        );
                        if (!mounted) return;
                        if (branchMembers.length == 1 &&
                            branchMembers.first.branches.isNotEmpty) {
                          final branchId = branchMembers.first.branches.first.id;
                          ref.read(branchesIdProvider.notifier).state = branchId;
                          await ref
                              .read(localStorageProvider)
                              .saveString(
                                ref.read(selectedBranchStorageKeyProvider),
                                branchId.toString(),
                              );
                          _isAutoSingleBranchLogin = true;
                          ref
                              .read(getTokenControllerProvider.notifier)
                              .getToken(
                                password: password,
                                deviceId: Platform.operatingSystemVersion.hashCode,
                                userAgent: Platform.operatingSystem.hashCode,
                                branchId: branchId,
                              );
                          return;
                        }
                      } catch (_) {
                        // Если не удалось подгрузить филиалы, остаемся в стандартном сценарии.
                      }
                      _isAutoSingleBranchLogin = false;
                      if (!mounted) return;
                      SelectBranchPage.navigate(this.context);
                    },
                  ),
                  Gap(8),
                ],
              ),
            ),
            if (isTokenLoading)
              Positioned.fill(
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: 0.25),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
