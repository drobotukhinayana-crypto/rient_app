import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/widgets/loading_widget.dart';
import 'package:rient_app/features/auth/utils/post_login_navigation.dart';
import 'package:rient_app/features/auth/view/auth_page.dart';
import 'package:rient_app/features/launch/controller/launch_state.dart';
import 'package:rient_app/features/launch/controller/launcher_controller.dart';

class LaunchPage extends ConsumerWidget {
  const LaunchPage({super.key});
  static const String name = 'launchPage';
  static const String path = '/launchPage';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(launchControllerProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      state.when(
        initial: () {},
        loading: () {},
        error: (_) => AuthPage.navigate(context),
        loggedIn: () => unawaited(navigateToHomeAfterLogin(context, ref)),
        notLoggedIn: () => AuthPage.navigate(context),
      );
    });
    return const Scaffold(body: LoadingWidget());
  }
}
