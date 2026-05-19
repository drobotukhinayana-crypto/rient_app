import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/features/analytics/view/analytics_page.dart';
import 'package:rient_app/features/settings/view/settings_page.dart';
import 'package:rient_app/features/auth/view/auth_page.dart';
import 'package:rient_app/features/auth/view/auth_password_page.dart';
import 'package:rient_app/features/auth/view/otp_page.dart';
import 'package:rient_app/features/auth/view/select_branch_page.dart';
import 'package:rient_app/features/auth/view/select_company_page.dart';
import 'package:rient_app/features/chat/chat_page.dart';
import 'package:rient_app/features/create/view/add_new_entry_page.dart'
    show AddNewEntryInitialData, AddNewEntryPage;
import 'package:rient_app/features/home/view/home_page.dart';
import 'package:rient_app/features/launch/launch_page.dart';
import 'package:rient_app/features/link/view/link_page.dart';
import 'package:rient_app/features/schedule/view/schedule_page.dart';
import 'package:rient_app/features/schedule/view/specialist_schedule_page.dart';
import 'package:rient_app/features/schedule/view/work_schedule_page.dart';
import 'package:rient_app/features/schedule/data/models/appointments_api/appointments_api.dart';
import 'package:rient_app/features/tabbar/view/tab_bar_page.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

final _rootNavigatorHome = GlobalKey<NavigatorState>(debugLabel: 'home');
final _rootNavigatorSchedule = GlobalKey<NavigatorState>(
  debugLabel: 'schedule',
);
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
    _authPassword,

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
          navigatorKey: _rootNavigatorChat,
          routes: [_chatTab],
        ),
        StatefulShellBranch(
          navigatorKey: _rootNavigatorLink,
          routes: [_linkTab],
        ),
      ],
    ),
    _addNewEntryRoute,
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
  routes: [
    GoRoute(
      name: AnalyticsPage.name,
      path: AnalyticsPage.path,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (_, state) => MaterialPage(
        key: state.pageKey,
        child: const AnalyticsPage(),
      ),
    ),
    GoRoute(
      name: SettingsPage.name,
      path: SettingsPage.path,
      parentNavigatorKey: rootNavigatorKey,
      pageBuilder: (_, state) => MaterialPage(
        key: state.pageKey,
        child: const SettingsPage(),
      ),
    ),
  ],
  pageBuilder: (_, state) =>
      MaterialPage(key: state.pageKey, child: const HomePage()),
);

final GoRoute _scheduleTab = GoRoute(
  name: SchedulePage.name,
  path: SchedulePage.path,
  routes: [
    GoRoute(
      name: WorkSchedulePage.name,
      path: WorkSchedulePage.path,
      pageBuilder: (_, state) => MaterialPage(
        key: state.pageKey,
        child: const WorkSchedulePage(),
      ),
      routes: [
        GoRoute(
          name: SpecialistSchedulePage.name,
          path: SpecialistSchedulePage.path,
          parentNavigatorKey: rootNavigatorKey,
          pageBuilder: (_, state) {
            final extra = state.extra;
            final args = extra is SpecialistSchedulePageArgs
                ? extra
                : const SpecialistSchedulePageArgs(
                    employeeId: '',
                    employeeName: 'Специалист',
                  );
            return MaterialPage(
              key: state.pageKey,
              child: SpecialistSchedulePage(args: args),
            );
          },
        ),
      ],
    ),
  ],
  pageBuilder: (_, state) =>
      MaterialPage(key: state.pageKey, child: const SchedulePage()),
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
  pageBuilder: (_, state) => MaterialPage(
    key: state.pageKey,
    child: OtpPage(email: state.extra as String),
  ),
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

final GoRoute _authPassword = GoRoute(
  name: AuthPasswordPage.name,
  path: AuthPasswordPage.path,
  routes: const [],
  pageBuilder: (_, state) =>
      MaterialPage(key: state.pageKey, child: const AuthPasswordPage()),
);

final GoRoute _addNewEntryRoute = GoRoute(
  name: AddNewEntryPage.name,
  path: AddNewEntryPage.path,
  parentNavigatorKey: rootNavigatorKey,
  pageBuilder: (_, state) => MaterialPage(
    key: state.pageKey,
    child: AddNewEntryPage(
      initialAppointment: state.extra is AppointmentApi
          ? state.extra! as AppointmentApi
          : null,
      isEditMode: state.extra is AppointmentApi,
      initialData: state.extra is AddNewEntryInitialData
          ? state.extra! as AddNewEntryInitialData
          : null,
    ),
  ),
);
