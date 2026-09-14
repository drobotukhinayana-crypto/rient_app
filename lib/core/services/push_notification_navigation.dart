import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/routes/route_notifier.dart' show rootNavigatorKey;
import 'package:rient_app/features/auth/service/get_auth_company.dart';
import 'package:rient_app/features/auth/view/auth_page.dart';
import 'package:rient_app/features/auth/view/auth_password_page.dart';
import 'package:rient_app/features/auth/view/otp_page.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/auth/view/providers/role_storage_provider.dart';
import 'package:rient_app/features/auth/view/providers/selected_organization_member_provider.dart';
import 'package:rient_app/features/auth/view/select_branch_page.dart';
import 'package:rient_app/features/auth/view/select_company_page.dart';
import 'package:rient_app/features/chat/chat_page.dart';
import 'package:rient_app/features/chat/view/providers/push_history_provider.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/launch/launch_page.dart';
import 'package:rient_app/features/tabbar/view/tab_bar_page.dart';

/// Навигация на вкладку «Сообщения» при открытии push-уведомления.
class PushNotificationNavigation {
  PushNotificationNavigation._();

  static bool _pendingOpenMessagesTab = false;
  static int? _pendingBranchId;
  static int? _pendingOrganizationId;

  static void openMessagesTab({int? branchId, int? organizationId}) {
    _pendingOpenMessagesTab = true;
    if (organizationId != null && organizationId > 0) {
      _pendingOrganizationId = organizationId;
    }
    if (branchId != null && branchId > 0) {
      _pendingBranchId = branchId;
    }
    tryOpenMessagesTabNow();
  }

  static void tryOpenMessagesTabNow() {
    unawaited(_tryOpenMessagesTabNowAsync());
  }

  static Future<void> _tryOpenMessagesTabNowAsync() async {
    if (!_pendingOpenMessagesTab) return;

    final context = rootNavigatorKey.currentContext;
    if (context == null || !context.mounted) return;

    final router = GoRouter.of(context);
    final routeName = router.state.name;
    if (_isPreShellRoute(routeName)) return;

    final container = ProviderScope.containerOf(context, listen: false);

    final organizationId = _pendingOrganizationId;
    if (organizationId != null) {
      await _applyOrganizationSelection(container, organizationId);
      _pendingOrganizationId = null;
    }

    final branchId = _pendingBranchId;
    if (branchId != null) {
      await _applyBranchSelection(container, branchId);
      _pendingBranchId = null;
    }

    final navContext = rootNavigatorKey.currentContext;
    if (navContext == null || !navContext.mounted) return;

    _pendingOpenMessagesTab = false;

    final currentRoute = GoRouter.of(navContext).state.name;
    if (currentRoute == ChatPage.name) {
      debugPrint('Push navigation: already on messages tab');
      invalidatePushHistoryCache(container);
      return;
    }

    debugPrint('Push navigation: opening messages tab');
    TabBarPage.navigate(navContext, initialTab: Tabs.chat);
  }

  static Future<void> _applyOrganizationSelection(
    ProviderContainer container,
    int organizationId,
  ) async {
    try {
      final current = container.read(organizationIdProvider);
      if (current == organizationId) return;

      final members = await container.read(getAuthOrganiztionsProvider.future);
      final member = members
          .where((item) => item.organization.id == organizationId)
          .firstOrNull;
      if (member == null) {
        debugPrint('Push navigation: organization $organizationId not found');
        return;
      }
      if (member.organization.isBlocked) {
        debugPrint('Push navigation: organization $organizationId is blocked');
        return;
      }

      await container
          .read(organizationIdProvider.notifier)
          .setOrganizationId(organizationId);
      container.read(selectedOrganizationMemberProvider.notifier).state =
          member;
      container.read(roleProvider.notifier).state = member.role.value;
      await container
          .read(roleStorageProvider.notifier)
          .setRole(member.role.value);

      container.invalidate(branchesProvider);
      await container.read(branchesProvider.future);
      invalidatePushHistoryCache(container);
      debugPrint('Push navigation: switched to organization $organizationId');
    } catch (e) {
      debugPrint('Push navigation: organization selection failed: $e');
    }
  }

  static Future<void> _applyBranchSelection(
    ProviderContainer container,
    int branchId,
  ) async {
    try {
      final applied = await selectBranchById(container, branchId);
      if (!applied) {
        debugPrint('Push navigation: branch $branchId not found');
        return;
      }
      invalidatePushHistoryCache(container);
      debugPrint('Push navigation: switched to branch $branchId');
    } catch (e) {
      debugPrint('Push navigation: branch selection failed: $e');
    }
  }

  static bool _isPreShellRoute(String? routeName) {
    return routeName == LaunchPage.name ||
        routeName == AuthPage.name ||
        routeName == OtpPage.name ||
        routeName == SelectCompanyPage.name ||
        routeName == SelectBranchPage.name ||
        routeName == AuthPasswordPage.name;
  }
}
