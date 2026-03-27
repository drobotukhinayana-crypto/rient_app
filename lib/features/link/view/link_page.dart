import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/email_storage.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/session_data/view/controller/session_data_controller.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/widgets/main_button.dart';
import 'package:rient_app/features/auth/service/get_auth_branches.dart';
import 'package:rient_app/features/auth/service/get_auth_company.dart';
import 'package:rient_app/features/auth/view/auth_page.dart';
import 'package:rient_app/features/auth/view/providers/branches_id_provider.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/auth/view/providers/password_provider.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';

class LinkPage extends StatelessWidget {
  const LinkPage({super.key});

  static const name = 'link_page';
  static const path = '/link_page';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.tabBarScreenBackground,
      body: _BodyWidget(),
    );
  }
}

class _BodyWidget extends ConsumerWidget {
  const _BodyWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Padding(
        padding: AppDecoration.padding16,
        child: Column(
          children: [
            MainButton(
              title: 'Выход',
              onTap: () async {
                await ref
                    .read(sessionDataControllerProvider.notifier)
                    .deleteSessionData();
                await ref.read(tokenProvider.notifier).clearToken();
                await ref.read(emailStorageProvider.notifier).clearEmail();
                await ref
                    .read(organizationIdProvider.notifier)
                    .clearOrganizationId();
                ref.read(roleProvider.notifier).state = 0;
                ref.read(branchesIdProvider.notifier).state = 0;
                ref.read(passwordProvider.notifier).state = '';
                ref.invalidate(getAuthOrganiztionsProvider);
                ref.invalidate(getAuthBranchesProvider);
                AuthPage.navigate(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
