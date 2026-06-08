import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/routes/route_notifier.dart' show rootNavigatorKey;
import 'package:rient_app/features/auth/view/auth_page.dart';
import 'package:rient_app/features/auth/view/auth_password_page.dart';
import 'package:rient_app/features/auth/view/otp_page.dart';
import 'package:rient_app/features/auth/view/select_branch_page.dart';
import 'package:rient_app/features/auth/view/select_company_page.dart';
import 'package:rient_app/features/chat/chat_page.dart';
import 'package:rient_app/features/launch/launch_page.dart';

/// Навигация на вкладку «Сообщения» при открытии push-уведомления.
class PushNotificationNavigation {
  PushNotificationNavigation._();

  static bool _pendingOpenMessagesTab = false;

  static void openMessagesTab() {
    _pendingOpenMessagesTab = true;
    tryOpenMessagesTabNow();
  }

  static void tryOpenMessagesTabNow() {
    if (!_pendingOpenMessagesTab) return;

    final context = rootNavigatorKey.currentContext;
    if (context == null || !context.mounted) return;

    final router = GoRouter.of(context);
    final routeName = router.state.name;
    if (_isPreShellRoute(routeName)) return;

    _pendingOpenMessagesTab = false;
    if (routeName == ChatPage.name) return;

    debugPrint('Push navigation: opening messages tab');
    context.goNamed(ChatPage.name);
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
