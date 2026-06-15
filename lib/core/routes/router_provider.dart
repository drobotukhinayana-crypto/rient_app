import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/routes/route_notifier.dart'
    show rootNavigatorKey, RouterNotifier;
import 'package:rient_app/features/launch/launch_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = RouterNotifier(ref: ref);

  return GoRouter(
    refreshListenable: router,
    initialLocation: LaunchPage.path,
    navigatorKey: rootNavigatorKey,
    redirect: router.redirect,
    routes: router.routes,
  );
});
