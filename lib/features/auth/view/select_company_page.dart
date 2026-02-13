import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/loading_widget.dart';
import 'package:rient_app/core/widgets/main_button.dart';
import 'package:rient_app/features/auth/service/get_auth_organiztions.dart';
import 'package:rient_app/features/auth/view/auth_password_page.dart';
import 'package:rient_app/features/auth/view/components/auth_company_list_view.dart';
import 'package:rient_app/features/auth/view/components/bottom_panel.dart';
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
                  child: Image.asset(AppImages.back),
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
                          data: (data) =>
                              AuthCompanyListView(organizationMembers: data),
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
              onTap: () => AuthPasswordPage.navigate(context),
            ),
          ),

          // нижняя панель
          const BottomPanel(),
        ],
      ),
    );
  }
}
