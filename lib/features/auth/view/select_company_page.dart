import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/loading_widget.dart';
import 'package:rient_app/core/widgets/main_button.dart';
import 'package:rient_app/features/auth/service/get_auth_company.dart';
import 'package:rient_app/features/auth/view/auth_password_page.dart';
import 'package:rient_app/features/auth/view/components/auth_company_list_view.dart';
import 'package:rient_app/features/auth/view/components/bottom_panel.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/auth/view/providers/password_provider.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/auth/view/providers/role_storage_provider.dart';
import 'package:rient_app/features/auth/view/providers/selected_organization_member_provider.dart';
import 'package:rient_app/resources/resources.dart';

class SelectCompanyPage extends StatelessWidget {
  const SelectCompanyPage({super.key});

  static const name = 'select_company_page';
  static const path = '/select_company_page';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          // заголовок
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Image.asset(
                    isDark ? AppImages.backButtonDark : AppImages.back,
                  ),
                ),
                Gap(12),
                Text('Компании', style: AppFonts.h4Medium),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: AppDecoration.padding16.copyWith(top: 16),
              child: Column(
                children: [
                  // список компаний
                  Consumer(
                    builder: (_, ref, __) => ref
                        .watch(getAuthOrganiztionsProvider)
                        .when(
                          data: (data) => AuthCompanyListView(
                            organizationMembers: data,
                            onSelectedMemberChanged: (member) {
                              ref.read(selectedOrganizationMemberProvider.notifier).state =
                                  member;
                              ref.read(organizationIdProvider.notifier).setOrganizationId(
                                  member.organization.id);
                              ref.read(roleProvider.notifier).state =
                                  member.role.value;
                              ref
                                  .read(roleStorageProvider.notifier)
                                  .setRole(member.role.value);
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
                onTap: () {
                  final selectedMember =
                      ref.read(selectedOrganizationMemberProvider);
                  if (selectedMember == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Сначала выберите компанию'),
                      ),
                    );
                    return;
                  }
                  ref
                      .read(organizationIdProvider.notifier)
                      .setOrganizationId(selectedMember.organization.id);
                  ref.read(roleProvider.notifier).state = selectedMember.role.value;
                  ref
                      .read(roleStorageProvider.notifier)
                      .setRole(selectedMember.role.value);
                  // На смене пользователя очищаем пароль от предыдущего входа.
                  ref.read(passwordProvider.notifier).state = '';
                  AuthPasswordPage.navigate(context);
                },
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
