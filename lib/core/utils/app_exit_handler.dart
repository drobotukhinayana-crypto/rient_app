import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/routes/route_notifier.dart';
import 'package:rient_app/core/widgets/exit_app_confirm_dialog.dart';

/// Обработка системной кнопки «назад» на Android.
Future<bool> handleAndroidBackButton(BuildContext context) async {
  if (!Platform.isAndroid) return false;

  final rootNav = rootNavigatorKey.currentState;
  if (rootNav != null && rootNav.canPop()) {
    rootNav.pop();
    return true;
  }

  final router = GoRouter.maybeOf(context);
  if (router != null && router.canPop()) {
    router.pop();
    return true;
  }

  final shouldExit = await showExitAppConfirmDialog(context);
  if (shouldExit) {
    await SystemNavigator.pop();
  }
  return true;
}
