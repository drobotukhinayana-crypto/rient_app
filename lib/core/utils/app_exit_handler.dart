import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/keys/app_shell_scaffold_key.dart';
import 'package:rient_app/core/routes/route_notifier.dart';
import 'package:rient_app/core/widgets/exit_app_confirm_dialog.dart';
import 'package:rient_app/features/chat/chat_page.dart';
import 'package:rient_app/features/home/view/home_page.dart';
import 'package:rient_app/features/schedule/view/schedule_page.dart';

const _mainShellRouteNames = {
  HomePage.name,
  SchedulePage.name,
  ChatPage.name,
};

bool _isOnMainShellTab(GoRouter? router) {
  if (router == null) return false;
  final name = router.state.name;
  return name != null && _mainShellRouteNames.contains(name);
}

BuildContext? _exitDialogHostContext(BuildContext context) {
  final shellContext = appShellScaffoldKey.currentContext;
  if (shellContext != null && shellContext.mounted) return shellContext;
  final rootContext = rootNavigatorKey.currentContext;
  if (rootContext != null && rootContext.mounted) return rootContext;
  if (context.mounted) return context;
  return null;
}

/// Обработка системной кнопки «назад» на Android.
Future<bool> handleAndroidBackButton(BuildContext context) async {
  if (!Platform.isAndroid) return false;

  final scaffoldState = appShellScaffoldKey.currentState;
  if (scaffoldState?.isDrawerOpen ?? false) {
    scaffoldState!.closeDrawer();
    return true;
  }

  final rootNav = rootNavigatorKey.currentState;
  if (rootNav != null && rootNav.canPop()) {
    rootNav.pop();
    return true;
  }

  final router = GoRouter.maybeOf(context);

  // На корневых вкладках shell go_router может считать canPop=true (история
  // переключений День/Расписание/Сообщения) — не уходим на другую вкладку,
  // а показываем подтверждение выхода из приложения.
  if (_isOnMainShellTab(router)) {
    final hostContext = _exitDialogHostContext(context);
    if (hostContext == null) return true;
    final shouldExit = await showExitAppConfirmDialog(hostContext);
    if (shouldExit) {
      await SystemNavigator.pop();
    }
    return true;
  }

  if (router != null && router.canPop()) {
    router.pop();
    return true;
  }

  final hostContext = _exitDialogHostContext(context);
  if (hostContext == null) return true;
  final shouldExit = await showExitAppConfirmDialog(hostContext);
  if (shouldExit) {
    await SystemNavigator.pop();
  }
  return true;
}
