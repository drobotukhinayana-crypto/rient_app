import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/routes/route_notifier.dart' show rootNavigatorKey;
import 'package:rient_app/core/services/local_storage.dart';
import 'package:rient_app/features/auth/view/auth_page.dart';
import 'package:rient_app/features/auth/view/auth_password_page.dart';
import 'package:rient_app/features/auth/view/otp_page.dart';
import 'package:rient_app/features/auth/view/select_branch_page.dart';
import 'package:rient_app/features/auth/view/select_company_page.dart';
import 'package:rient_app/features/chat/chat_page.dart';
import 'package:rient_app/features/chat/view/providers/push_history_provider.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/launch/launch_page.dart';

/// Навигация на вкладку «Сообщения» при открытии push-уведомления.
class PushNotificationNavigation {
  PushNotificationNavigation._();

  static bool _pendingOpenMessagesTab = false;
  static int? _pendingBranchId;

  static void openMessagesTab({int? branchId}) {
    _pendingOpenMessagesTab = true;
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
    if (_pendingBranchId != null) {
      final applied = await _applyBranchSelection(
        container,
        _pendingBranchId!,
      );
      if (!applied) return;
      _pendingBranchId = null;
    }

    _pendingOpenMessagesTab = false;
    if (routeName == ChatPage.name) return;

    final navContext = rootNavigatorKey.currentContext;
    if (navContext == null || !navContext.mounted) return;

    debugPrint('Push navigation: opening messages tab');
    navContext.goNamed(ChatPage.name);
  }

  static Future<bool> _applyBranchSelection(
    ProviderContainer container,
    int branchId,
  ) async {
    try {
      final branches = await container.read(branchesProvider.future);
      final branch =
          branches.results.where((b) => b.id == branchId).firstOrNull;
      if (branch == null) {
        debugPrint('Push navigation: branch $branchId not found');
        return false;
      }

      final current = container.read(selectedBranchProvider);
      if (current?.id != branchId) {
        container.read(selectedBranchProvider.notifier).state = branch;
        final storage = container.read(localStorageProvider);
        final storageKey = container.read(selectedBranchStorageKeyProvider);
        await storage.saveString(storageKey, branch.id.toString());
        invalidatePushHistoryCache(container);
        debugPrint('Push navigation: switched to branch ${branch.name}');
      }
      return true;
    } catch (e) {
      debugPrint('Push navigation: branch selection failed: $e');
      return false;
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
