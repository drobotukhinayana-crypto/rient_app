import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/widgets/loading_widget.dart';
import 'package:rient_app/features/auth/view/auth_page.dart';
import 'package:rient_app/features/launch/controller/launch_state.dart';
import 'package:rient_app/features/launch/controller/launcher_controller.dart';
import 'package:rient_app/features/tabbar/view/tab_bar_page.dart';

class LaunchPage extends ConsumerWidget {
  const LaunchPage({super.key});
  static const String name = 'launchPage';
  static const String path = '/launchPage';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<LaunchState>(launchControllerProvider, (_, state) {
      state.when(
        initial: () {},
        loading: () {},
        error: (_) => AuthPage.navigate(context),
        loggedIn: () => TabBarPage.navigate(context),
        notLoggedIn: () => AuthPage.navigate(context),
      );
    });
    return const Scaffold(body: LoadingWidget());
  }
}
