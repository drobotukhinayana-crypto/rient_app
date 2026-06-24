import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/services/notification_permission_service.dart';
import 'package:rient_app/core/services/push_notification_navigation.dart';
import 'package:rient_app/core/widgets/notification_permission_prompt.dart';
import 'package:rient_app/core/services/unauthorized_handler.dart';
import 'package:rient_app/core/keys/app_shell_scaffold_key.dart';
import 'package:rient_app/core/utils/app_exit_handler.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/widgets/app_drawer.dart';
import 'package:rient_app/core/providers/worker_entity_labels_provider.dart';
import 'package:rient_app/core/widgets/logout_confirm_dialog.dart';
import 'package:rient_app/features/auth/logout_request_provider.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/features/chat/chat_page.dart';
import 'package:rient_app/features/chat/service/notifications_websocket_service.dart';
import 'package:rient_app/features/chat/service/push_registration_service.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/create/view/add_new_entry_page.dart'
    show AddNewEntryPage;
import 'package:rient_app/features/home/view/components/restore_selected_branch.dart';
import 'package:rient_app/features/home/view/providers/worker_permissions_provider.dart';
import 'package:rient_app/features/home/view/home_page.dart';
import 'package:rient_app/features/link/view/widget_link_share.dart';
import 'package:rient_app/core/network/app_offline.dart';
import 'package:rient_app/core/network/connectivity_recovery_listener.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_appointments_refresh.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_offline_provider.dart';
import 'package:rient_app/features/schedule/view/schedule_page.dart';
import 'package:rient_app/resources/resources.dart';

enum Tabs { home, schedule, chat, link }

class TabBarPage extends ConsumerStatefulWidget {
  const TabBarPage({required this.navigationShell, this.initialTab, super.key});

  final StatefulNavigationShell navigationShell;

  final Tabs? initialTab;

  static void navigate(BuildContext context, {Tabs? initialTab}) {
    switch (initialTab) {
      case Tabs.home:
      case null:
        context.goNamed(HomePage.name, extra: initialTab);
      case Tabs.schedule:
        context.goNamed(SchedulePage.name, extra: initialTab);
      case Tabs.chat:
        context.goNamed(ChatPage.name, extra: initialTab);
      case Tabs.link:
        context.goNamed(HomePage.name, extra: initialTab);
    }
  }

  static void openLinkShare(BuildContext context, WidgetRef ref) {
    if (_isOfflineExceptSchedule(ref)) {
      final hostContext = appShellScaffoldKey.currentContext ?? context;
      if (hostContext.mounted) {
        ScaffoldMessenger.maybeOf(hostContext)?.showSnackBar(
          const SnackBar(content: Text(appNoConnectionMessage)),
        );
      }
      return;
    }
    unawaited(WidgetLinkShare.open(context, ref));
  }

  static bool _isOfflineExceptSchedule(WidgetRef ref) {
    return ref.read(appNoConnectionProvider) ||
        ref.read(scheduleOfflineModeProvider);
  }

  static void openCreatePage(BuildContext context, WidgetRef ref) {
    if (_isOfflineExceptSchedule(ref)) {
      showOfflineSnackBar(context);
      return;
    }
    context.pushNamed(AddNewEntryPage.name);
  }

  static void goToScheduleTab(BuildContext context) {
    context.goNamed(SchedulePage.name);
  }

  static int chatTabIndex({required bool showCreateTab}) =>
      showCreateTab ? 3 : 2;

  static int linkTabIndex({required bool showCreateTab}) =>
      showCreateTab ? 4 : 3;

  static bool tabRequiresNetwork(int index, {required bool showCreateTab}) {
    return index == 0 ||
        index == chatTabIndex(showCreateTab: showCreateTab) ||
        index == linkTabIndex(showCreateTab: showCreateTab) ||
        (showCreateTab && index == 2);
  }

  static void showOfflineSnackBar(BuildContext context) {
    final hostContext = appShellScaffoldKey.currentContext ?? context;
    if (!hostContext.mounted) return;
    ScaffoldMessenger.maybeOf(hostContext)?.showSnackBar(
      const SnackBar(content: Text(appNoConnectionMessage)),
    );
  }

  @override
  ConsumerState<TabBarPage> createState() => _TabBarPageState();
}

class _TabBarPageState extends ConsumerState<TabBarPage>
    with WidgetsBindingObserver {
  DateTime? _lastResumeRefreshAt;
  StreamSubscription<RemoteMessage>? _fcmForegroundSubscription;
  bool _deniedSettingsPromptShownThisSession = false;
  bool _permissionFlowInProgress = false;

  bool _showCreateTab() {
    final roleId = ref.watch(roleProvider);
    if (roleId != UserRole.worker.value) {
      return true;
    }
    final permissionsAsync = ref.watch(workerPermissionsProvider);
    return permissionsAsync.value?.createSchedule == true;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      resetScheduleNetworkStateForSession(ref);
      ref.read(pushMessagingBootstrapProvider);
      unawaited(_ensurePushPermissionAndRegistration());
      unawaited(
        ref.read(notificationsWebSocketControllerProvider).ensureConnected(),
      );
      PushNotificationNavigation.tryOpenMessagesTabNow();
      _redirectToScheduleIfOffline();
    });
    _fcmForegroundSubscription =
        FirebaseMessaging.onMessage.listen((_) {
      refreshPushHistoryFromRealtime(ref);
    });
  }

  Future<void> _ensurePushPermissionAndRegistration({
    bool showDeniedSettingsPrompt = true,
  }) async {
    if (!mounted || _permissionFlowInProgress) return;
    _permissionFlowInProgress = true;
    try {
      var granted = await NotificationPermissionService.hasGrantedPermission();
      if (!granted) {
        if (!mounted) return;
        final shouldShowDeniedPrompt =
            showDeniedSettingsPrompt && !_deniedSettingsPromptShownThisSession;
        granted = await maybeRequestNotificationPermissionAfterLogin(
          context,
          ref,
          showDeniedSettingsPrompt: shouldShowDeniedPrompt,
        );
        if (shouldShowDeniedPrompt &&
            !granted &&
            await NotificationPermissionService.getStatus() ==
                AppNotificationPermissionStatus.denied) {
          _deniedSettingsPromptShownThisSession = true;
        }
      }

      if (!mounted) return;
      if (granted) {
        await ref.read(pushRegistrationServiceProvider).registerForActiveSession();
      }
    } finally {
      _permissionFlowInProgress = false;
    }
  }

  Future<void> _registerPushForActiveSession() async {
    final token = ref.read(tokenProvider);
    final organizationId = ref.read(organizationIdProvider);
    if (token == null || token.isEmpty || organizationId <= 0) return;
    if (!await NotificationPermissionService.hasGrantedPermission()) return;

    await ref.read(pushRegistrationServiceProvider).registerForActiveSession();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_fcmForegroundSubscription?.cancel());
    _fcmForegroundSubscription = null;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    unawaited(_handleAppResumed());
  }

  Future<void> _handleAppResumed() async {
    if (!mounted) return;
    ref.invalidate(workerEntityLabelsProvider);
    if (ref.read(scheduleOfflineModeProvider) &&
        ref.read(appHasNetworkProvider)) {
      unawaited(tryRecoverScheduleNetwork(ref));
    }
    if (ref.read(appHasNetworkProvider) &&
        ref.read(scheduleServerReachableProvider)) {
      ref.invalidate(connectivityCheckProvider);
      invalidateScheduleNetworkProvidersDeferred(ref);
      refreshWorkerPermissions(ref);
    }
    final now = DateTime.now();
    final lastAt = _lastResumeRefreshAt;
    if (lastAt != null && now.difference(lastAt) < const Duration(seconds: 30)) {
      return;
    }
    _lastResumeRefreshAt = now;
    if (!mounted) return;
    await _ensurePushPermissionAndRegistration(
      showDeniedSettingsPrompt: false,
    );
    if (!mounted) return;
    await refreshTokenSilentlyIfPossible(ref);
    if (!mounted) return;
    unawaited(
      ref.read(notificationsWebSocketControllerProvider).ensureConnected(),
    );
    refreshPushHistoryFromRealtime(ref);
  }

  int _linkNavbarIndex(bool showCreateTab) => showCreateTab ? 4 : 3;

  int _navbarIndexFromShell(bool showCreateTab) {
    if (!showCreateTab) return widget.navigationShell.currentIndex;
    return widget.navigationShell.currentIndex < 2
        ? widget.navigationShell.currentIndex
        : widget.navigationShell.currentIndex + 1;
  }

  void _redirectToScheduleIfOffline() {
    if (!mounted) return;
    final offline = ref.read(appNoConnectionProvider) ||
        ref.read(scheduleOfflineModeProvider);
    if (!offline) return;

    final router = GoRouter.of(context);
    // Просмотр записи в оффлайне — отдельный экран поверх табов, не сбрасывать.
    if (router.state.name == AddNewEntryPage.name) return;

    if (widget.navigationShell.currentIndex == 1) return;

    TabBarPage.goToScheduleTab(context);
  }

  void navigateOnTabIndexed(int index, {required bool showCreateTab}) {
    FocusManager.instance.primaryFocus?.unfocus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _performTabNavigation(index, showCreateTab: showCreateTab);
    });
  }

  void _performTabNavigation(int index, {required bool showCreateTab}) {
    if (!mounted) return;
    final offline = ref.read(appNoConnectionProvider) ||
        ref.read(scheduleOfflineModeProvider);
    if (offline && index != 1) {
      if (showCreateTab && index == 2) {
        final hostContext = appShellScaffoldKey.currentContext ?? context;
        if (hostContext.mounted) {
          ScaffoldMessenger.maybeOf(hostContext)?.showSnackBar(
            const SnackBar(
              content: Text(
                'Нет интернета. Создание записи недоступно в оффлайн режиме',
              ),
            ),
          );
        }
      } else {
        TabBarPage.showOfflineSnackBar(context);
      }
      return;
    }
    if (showCreateTab && index == 2) {
      TabBarPage.openCreatePage(context, ref);
      return;
    }
    if (index == _linkNavbarIndex(showCreateTab)) {
      TabBarPage.openLinkShare(context, ref);
      return;
    }
    final shellIndex = showCreateTab && index > 2 ? index - 1 : index;
    final alreadyHere = shellIndex == widget.navigationShell.currentIndex;

    if (alreadyHere) {
      switch (shellIndex) {
        case 0:
          refreshAfterAppointmentMutation(ref);
          context.goNamed(HomePage.name);
        case 1:
          context.goNamed(SchedulePage.name);
        case 2:
          context.goNamed(ChatPage.name);
      }
    } else {
      if (shellIndex == 0) {
        refreshAfterAppointmentMutation(ref);
      }
      widget.navigationShell.goBranch(shellIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final showCreateTab = _showCreateTab();
    final noConnection = ref.watch(appNoConnectionProvider);
    final scheduleOffline = ref.watch(scheduleOfflineModeProvider);
    final offlineExceptSchedule = noConnection || scheduleOffline;

    ref.watch(connectivityRecoveryListenerProvider);
    ref.watch(scheduleServerUnreachableListenerProvider);

    ref.listen<bool>(appNoConnectionProvider, (previous, next) {
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _redirectToScheduleIfOffline();
      });
    });
    ref.listen<bool>(scheduleOfflineModeProvider, (previous, next) {
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _redirectToScheduleIfOffline();
      });
    });

    ref.listen<int>(logoutRequestProvider, (previous, next) {
      if (next <= 0 || next == previous) return;
      final hostContext = appShellScaffoldKey.currentContext;
      if (hostContext == null || !hostContext.mounted) return;
      unawaited(showLogoutConfirmDialog(hostContext, ref));
    });

    ref.listen<int>(organizationIdProvider, (previous, next) {
      if (next > 0 && previous != next) {
        ref.invalidate(workerEntityLabelsProvider);
        unawaited(_registerPushForActiveSession());
        unawaited(
          ref.read(notificationsWebSocketControllerProvider).ensureConnected(),
        );
      }
    });
    ref.listen<String?>(tokenProvider, (previous, next) {
      if (previous == next) return;
      if (next == null || next.isEmpty) {
        unawaited(
          ref.read(notificationsWebSocketControllerProvider).disconnect(),
        );
        return;
      }
      unawaited(
        ref.read(notificationsWebSocketControllerProvider).ensureConnected(),
      );
      unawaited(_registerPushForActiveSession());
    });
    ref.listen<int>(currentBranchIdProvider, (previous, next) {
      if (next > 0 && previous != next) {
        unawaited(_registerPushForActiveSession());
      }
    });
    ref.listen<int>(roleProvider, (previous, next) {
      if (next > 0 && previous != next) {
        unawaited(_registerPushForActiveSession());
      }
    });
    ref.listen(branchesProvider, (previous, next) {
      next.whenData((_) {
        if (!mounted) return;
        unawaited(_registerPushForActiveSession());
      });
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (!Platform.isAndroid) return;
        unawaited(handleAndroidBackButton(context));
      },
      child: RestoreSelectedBranch(
      child: Scaffold(
        key: appShellScaffoldKey,
        backgroundColor: isDark
            ? AppColors.secondaryDarkLight
            : AppColors.tabBarScreenBackground,
        drawer: const AppDrawer(),
        body: widget.navigationShell,
        bottomNavigationBar: _NavbarWidget(
          currentIndex: offlineExceptSchedule
              ? 1
              : _navbarIndexFromShell(showCreateTab),
          showCreateTab: showCreateTab,
          offlineExceptSchedule: offlineExceptSchedule,
          onTabTapped: (idx) =>
              navigateOnTabIndexed(idx, showCreateTab: showCreateTab),
        ),
      ),
    ),
    );
  }
}

class _NavbarWidget extends StatelessWidget {
  const _NavbarWidget({
    required this.currentIndex,
    required this.onTabTapped,
    required this.showCreateTab,
    required this.offlineExceptSchedule,
  });
  final int currentIndex;
  final void Function(int) onTabTapped;
  final bool showCreateTab;
  final bool offlineExceptSchedule;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final safeArea = MediaQuery.of(context).viewPadding.bottom;
    final barColor = isDark ? AppColors.primaryWhiteDark : Colors.white;
    final tabsEnabled = !offlineExceptSchedule;

    return ColoredBox(
      color: barColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Gap(10),
          Row(
            children: [
              Expanded(
                child: _NavbarIcon(
                  isActive: currentIndex == 0,
                  imageAsset: AppImages.homeTab,
                  title: 'Главная',
                  enabled: tabsEnabled,
                  onTap: () => onTabTapped(0),
                ),
              ),
              Expanded(
                child: _NavbarIcon(
                  isActive: currentIndex == 1,
                  imageAsset: AppImages.calendarTab,
                  title: 'Расписание',
                  onTap: () => onTabTapped(1),
                  hasCartCountLabel: true,
                ),
              ),
              if (showCreateTab)
                Expanded(
                  child: _NavbarIcon(
                    isActive: currentIndex == 2,
                    imageAsset: AppImages.addTab,
                    title: 'Создать',
                    enabled: tabsEnabled,
                    onTap: () => onTabTapped(2),
                  ),
                ),
              Expanded(
                child: _NavbarIcon(
                  isActive: currentIndex == TabBarPage.chatTabIndex(showCreateTab: showCreateTab),
                  imageAsset: AppImages.chatTab,
                  title: 'Сообщения',
                  enabled: tabsEnabled,
                  onTap: () => onTabTapped(TabBarPage.chatTabIndex(showCreateTab: showCreateTab)),
                ),
              ),
              Expanded(
                child: _NavbarIcon(
                  isActive: false,
                  imageAsset: AppImages.linkTab,
                  title: 'Ссылка',
                  enabled: tabsEnabled,
                  onTap: () => onTabTapped(TabBarPage.linkTabIndex(showCreateTab: showCreateTab)),
                ),
              ),
            ],
          ),
          Gap(safeArea),
        ],
      ),
    );
  }
}

class _NavbarIcon extends StatelessWidget {
  const _NavbarIcon({
    required this.onTap,
    required this.isActive,
    required this.imageAsset,
    required this.title,
    this.hasCartCountLabel = false,
    this.enabled = true,
  });
  final bool isActive;
  final String imageAsset;
  final String title;
  final VoidCallback onTap;
  final bool hasCartCountLabel;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = AppColors.themeAccent(context);
    final iconColor = !enabled
        ? (isDark ? AppColors.tabbarGreyDark : AppColors.tabbarGrey)
            .withValues(alpha: 0.45)
        : isActive
        ? accent
        : isDark
        ? AppColors.tabbarGreyDark
        : AppColors.tabbarGrey;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: enabled ? onTap : null,
      child: SizedBox(
        height: 56,
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                child: Image.asset(imageAsset, key: ValueKey(isActive)),
              ),
            ),
            const Gap(3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: iconColor,
              ),
              child: Text(title, textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }
}
