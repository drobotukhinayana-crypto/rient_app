import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/session_data/models/session_data.dart';
import 'package:rient_app/core/session_data/view/controller/session_data_controller.dart';
import 'package:rient_app/core/services/email_storage.dart';
import 'package:rient_app/core/services/local_storage.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/app_service_message.dart';
import 'package:rient_app/core/widgets/loading_widget.dart';
import 'package:rient_app/core/widgets/main_button.dart';
import 'package:rient_app/features/auth/service/get_auth_branches.dart';
import 'package:rient_app/features/auth/service/auth_service.dart';
import 'package:rient_app/features/auth/view/components/auth_branch_list_view.dart';
import 'package:rient_app/features/auth/view/components/bottom_panel.dart';
import 'package:rient_app/features/auth/view/providers/branches_id_provider.dart';
import 'package:rient_app/features/auth/view/providers/password_provider.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/auth/view/providers/role_storage_provider.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/tabbar/view/tab_bar_page.dart';
import 'package:rient_app/resources/resources.dart';

class SelectBranchPage extends StatelessWidget {
  const SelectBranchPage({super.key});

  static const name = 'select_branch_page';
  static const path = '/select_branch_page';

  static void navigate(BuildContext context) => context.pushNamed(name);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: BottomPanel(),
      body: _BodyWidget(),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Row(
              children: [
                // кнопка назад
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Image.asset(
                    isDark ? AppImages.backButtonDark : AppImages.back,
                  ),
                ),
                Gap(12),

                // заголовок
                Text('Филиалы', style: AppFonts.h4Medium),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: AppDecoration.padding16.copyWith(top: 16),
              child: Column(
                children: [
                  // список филиалов
                  Consumer(
                    builder: (_, ref, __) => ref
                        .watch(getAuthBranchesProvider)
                        .when(
                          data: (data) => AuthBranchListView(
                            branchesMembers: data,
                            onSelectedMemberChanged: (member) {
                              final selectedBranchId =
                                  member.branches.first.id;
                              ref.read(branchesIdProvider.notifier).state =
                                  selectedBranchId;
                              ref.read(roleProvider.notifier).state =
                                  member.role.value;
                              ref
                                  .read(roleStorageProvider.notifier)
                                  .setRole(member.role.value);
                              ref
                                  .read(localStorageProvider)
                                  .saveString(
                                    ref.read(selectedBranchStorageKeyProvider),
                                    selectedBranchId.toString(),
                                  );
                            },
                          ),
                          error: (_, __) => Container(),
                          loading: () => LoadingWidget(),
                        ),
                  ),
                ],
              ),
            ),
          ),

          // кнопка продолжения
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
            child: Consumer(
              builder: (_, ref, __) => MainButton(
                title: 'Продолжить',
                onTap: () async {
                  final selectedBranchId = ref.read(branchesIdProvider);
                  if (selectedBranchId <= 0) {
                    showAppServiceMessage(
                      context,
                      message: 'Сначала выберите филиал',
                      variant: AppServiceMessageVariant.info,
                    );
                    return;
                  }
                  await ref
                      .read(localStorageProvider)
                      .saveString(
                        ref.read(selectedBranchStorageKeyProvider),
                        selectedBranchId.toString(),
                      );

                  // Обновляем токен под текущий выбранный филиал,
                  // чтобы серверные данные соответствовали выбору пользователя.
                  final password = ref.read(passwordProvider);
                  try {
                    await ref.read(authServiceProvider).getToken(
                      password: password,
                      deviceId: Platform.operatingSystemVersion.hashCode,
                      userAgent: Platform.operatingSystem.hashCode,
                      branchId: selectedBranchId,
                    );
                    final token = ref.read(tokenProvider);
                    final email = ref.read(emailStorageProvider);
                    if (token != null && email != null && email.isNotEmpty) {
                      await ref
                          .read(sessionDataControllerProvider.notifier)
                          .saveSessionData(
                            SessionData(
                              email: email,
                              password: password,
                              token: token,
                            ),
                          );
                    }
                  } catch (_) {
                    if (!context.mounted) return;
                    showAppServiceMessage(
                      context,
                      message:
                          'Не удалось применить выбранный филиал, попробуйте снова',
                      variant: AppServiceMessageVariant.error,
                    );
                    return;
                  }
                  if (!context.mounted) return;
                  TabBarPage.navigate(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
