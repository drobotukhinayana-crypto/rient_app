import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/features/auth/view/auth_page.dart';
import 'package:rient_app/features/auth/view/otp_page.dart';
import 'package:rient_app/features/auth/view/select_branch_page.dart';
import 'package:rient_app/features/auth/view/select_company_page.dart';
import 'package:rient_app/features/chat/chat_page.dart';
import 'package:rient_app/features/create/view/create_page.dart';
import 'package:rient_app/features/home/view/home_page.dart';
import 'package:rient_app/features/launch/launch_page.dart';
import 'package:rient_app/features/link/view/link_page.dart';
import 'package:rient_app/features/schedule/view/schedule_page.dart';
import 'package:rient_app/features/tabbar/view/tab_bar_page.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

final _rootNavigatorHome = GlobalKey<NavigatorState>(debugLabel: 'home');
final _rootNavigatorSchedule = GlobalKey<NavigatorState>(
  debugLabel: 'schedule',
);
final _rootNavigatorCreate = GlobalKey<NavigatorState>(debugLabel: 'create');
final _rootNavigatorChat = GlobalKey<NavigatorState>(debugLabel: 'chat');
final _rootNavigatorLink = GlobalKey<NavigatorState>(debugLabel: 'link');

class RouterNotifier extends ChangeNotifier {
  RouterNotifier({required this.ref});

  final Ref ref;

  List<RouteBase> get routes => [
    _launch,
    _auth,
    _otp,
    _selectCompany,
    _selectBranch,

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          TabBarPage(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          navigatorKey: _rootNavigatorHome,
          routes: [_homeTab],
        ),
        StatefulShellBranch(
          navigatorKey: _rootNavigatorSchedule,
          routes: [_scheduleTab],
        ),
        StatefulShellBranch(
          navigatorKey: _rootNavigatorCreate,
          routes: [_createTab],
        ),
        StatefulShellBranch(
          navigatorKey: _rootNavigatorChat,
          routes: [_chatTab],
        ),
        StatefulShellBranch(
          navigatorKey: _rootNavigatorLink,
          routes: [_linkTab],
        ),
      ],
    ),
  ];
}

final GoRoute _launch = GoRoute(
  name: LaunchPage.name,
  path: LaunchPage.path,
  parentNavigatorKey: rootNavigatorKey,
  pageBuilder: (_, state) {
    return MaterialPage(key: state.pageKey, child: const LaunchPage());
  },
);

final GoRoute _homeTab = GoRoute(
  name: HomePage.name,
  path: HomePage.path,
  routes: const [],
  pageBuilder: (_, state) =>
      MaterialPage(key: state.pageKey, child: const HomePage()),
);

final GoRoute _scheduleTab = GoRoute(
  name: SchedulePage.name,
  path: SchedulePage.path,
  routes: [],
  pageBuilder: (_, state) =>
      MaterialPage(key: state.pageKey, child: const SchedulePage()),
);

final GoRoute _createTab = GoRoute(
  name: CreatePage.name,
  path: CreatePage.path,
  routes: const [],
  pageBuilder: (_, state) =>
      MaterialPage(key: state.pageKey, child: const CreatePage()),
);

final GoRoute _chatTab = GoRoute(
  name: ChatPage.name,
  path: ChatPage.path,
  routes: const [],
  pageBuilder: (_, state) =>
      MaterialPage(key: state.pageKey, child: const ChatPage()),
);

final GoRoute _linkTab = GoRoute(
  name: LinkPage.name,
  path: LinkPage.path,
  routes: const [],
  pageBuilder: (_, state) =>
      MaterialPage(key: state.pageKey, child: const LinkPage()),
);

final GoRoute _auth = GoRoute(
  name: AuthPage.name,
  path: AuthPage.path,
  routes: const [],
  pageBuilder: (_, state) =>
      MaterialPage(key: state.pageKey, child: const AuthPage()),
);

final GoRoute _otp = GoRoute(
  name: OtpPage.name,
  path: OtpPage.path,
  routes: const [],
  pageBuilder: (_, state) =>
      MaterialPage(key: state.pageKey, child: const OtpPage()),
);

final GoRoute _selectCompany = GoRoute(
  name: SelectCompanyPage.name,
  path: SelectCompanyPage.path,
  routes: const [],
  pageBuilder: (_, state) =>
      MaterialPage(key: state.pageKey, child: const SelectCompanyPage()),
);

final GoRoute _selectBranch = GoRoute(
  name: SelectBranchPage.name,
  path: SelectBranchPage.path,
  routes: const [],
  pageBuilder: (_, state) =>
      MaterialPage(key: state.pageKey, child: const SelectBranchPage()),
);
