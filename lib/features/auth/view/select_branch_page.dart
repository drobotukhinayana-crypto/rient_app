import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/loading_widget.dart';
import 'package:rient_app/core/widgets/main_button.dart';
import 'package:rient_app/features/auth/service/get_auth_branches.dart';
import 'package:rient_app/features/auth/view/components/auth_branch_list_view.dart';
import 'package:rient_app/features/auth/view/components/bottom_panel.dart';
import 'package:rient_app/features/auth/view/providers/branches_id_provider.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/tabbar/view/tab_bar_page.dart';
import 'package:rient_app/resources/resources.dart';

class SelectBranchPage extends StatelessWidget {
  const SelectBranchPage({super.key});

  static const name = 'select_branch_page';
  static const path = '/select_branch_page';

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
                              ref.read(branchesIdProvider.notifier).state =
                                  member.branches.first.id;
                              ref.read(roleProvider.notifier).state =
                                  member.role.value;
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
            child: MainButton(
              title: 'Продолжить',
              onTap: () => TabBarPage.navigate(context),
            ),
          ),

          // нижняя панель
          const BottomPanel(),
        ],
      ),
    );
  }
}
