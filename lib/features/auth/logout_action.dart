import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/routes/router_provider.dart';
import 'package:rient_app/core/services/email_storage.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/session_data/view/controller/session_data_controller.dart';
import 'package:rient_app/features/auth/service/get_auth_branches.dart';
import 'package:rient_app/features/auth/service/get_auth_company.dart';
import 'package:rient_app/features/auth/view/auth_page.dart';
import 'package:rient_app/features/auth/view/providers/branches_id_provider.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/auth/view/providers/password_provider.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/auth/view/providers/role_storage_provider.dart';
import 'package:rient_app/features/auth/view/providers/selected_organization_member_provider.dart';
import 'package:rient_app/features/chat/service/push_registration_service.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';

/// Очистка сессии из UI-слоя (WidgetRef) и переход на экран входа.
Future<void> performLogout(WidgetRef ref) async {
  await ref.read(pushRegistrationServiceProvider).deactivateCurrentDevice();
  await ref.read(sessionDataControllerProvider.notifier).deleteSessionData();
  await ref.read(tokenProvider.notifier).clearToken();
  await ref.read(emailStorageProvider.notifier).clearEmail();
  await ref.read(organizationIdProvider.notifier).clearOrganizationId();
  ref.read(roleProvider.notifier).state = 0;
  await ref.read(roleStorageProvider.notifier).clearRole();
  ref.read(branchesIdProvider.notifier).state = 0;
  ref.read(passwordProvider.notifier).state = '';
  ref.read(selectedOrganizationMemberProvider.notifier).state = null;
  ref.read(selectedBranchProvider.notifier).state = null;
  ref.invalidate(getAuthOrganiztionsProvider);
  ref.invalidate(getAuthBranchesProvider);
  ref.read(routerProvider).goNamed(AuthPage.name);
}

/// Очистка сессии из сервисов/провайдеров (Ref) и переход на экран входа.
Future<void> performLogoutWithRef(Ref ref) async {
  await ref.read(pushRegistrationServiceProvider).deactivateCurrentDevice();
  await ref.read(sessionDataControllerProvider.notifier).deleteSessionData();
  await ref.read(tokenProvider.notifier).clearToken();
  await ref.read(emailStorageProvider.notifier).clearEmail();
  await ref.read(organizationIdProvider.notifier).clearOrganizationId();
  ref.read(roleProvider.notifier).state = 0;
  await ref.read(roleStorageProvider.notifier).clearRole();
  ref.read(branchesIdProvider.notifier).state = 0;
  ref.read(passwordProvider.notifier).state = '';
  ref.read(selectedOrganizationMemberProvider.notifier).state = null;
  ref.read(selectedBranchProvider.notifier).state = null;
  ref.invalidate(getAuthOrganiztionsProvider);
  ref.invalidate(getAuthBranchesProvider);
  ref.read(routerProvider).goNamed(AuthPage.name);
}
