import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/app_lock/app_lock_service.dart';
import 'package:rient_app/features/auth/view/app_lock_setup_page.dart';
import 'package:rient_app/features/chat/service/push_registration_service.dart';
import 'package:rient_app/features/tabbar/view/tab_bar_page.dart';

Future<void> navigateToHomeAfterLogin(
  BuildContext context,
  WidgetRef ref,
) async {
  final service = ref.read(appLockServiceProvider);
  if (await service.shouldOfferSetup()) {
    if (context.mounted) {
      AppLockSetupPage.navigate(context);
    }
    return;
  }

  if (context.mounted) {
    TabBarPage.navigate(context);
  }

  // Токен уже в сессии, TabBar ещё не смонтирован — регистрируем FCM сразу.
  unawaited(ref.read(pushRegistrationServiceProvider).registerCurrentDevice());
}
