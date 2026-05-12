import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/services/unauthorized_handler.dart';
import 'package:rient_app/core/keys/app_shell_scaffold_key.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/widgets/app_drawer.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/chat/chat_page.dart';
import 'package:rient_app/features/create/view/add_new_entry_page.dart'
    show AddNewEntryPage;
import 'package:rient_app/features/home/view/components/restore_selected_branch.dart';
import 'package:rient_app/features/home/view/providers/worker_permissions_provider.dart';
import 'package:rient_app/features/home/view/home_page.dart';
import 'package:rient_app/features/link/view/link_page.dart';
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
        context.goNamed(LinkPage.name, extra: initialTab);
    }
  }

  static void openCreatePage(BuildContext context) {
    context.pushNamed(AddNewEntryPage.name);
  }

  @override
  ConsumerState<TabBarPage> createState() => _TabBarPageState();
}

class _TabBarPageState extends ConsumerState<TabBarPage>
    with WidgetsBindingObserver {
  DateTime? _lastResumeRefreshAt;

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
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    unawaited(_handleAppResumed());
  }

  Future<void> _handleAppResumed() async {
    if (!mounted) return;
    final now = DateTime.now();
    final lastAt = _lastResumeRefreshAt;
    if (lastAt != null && now.difference(lastAt) < const Duration(seconds: 30)) {
      return;
    }
    _lastResumeRefreshAt = now;
    await refreshTokenSilentlyIfPossible(ref as Ref);
  }

  int _navbarIndexFromShell(bool showCreateTab) {
    if (!showCreateTab) return widget.navigationShell.currentIndex;
    return widget.navigationShell.currentIndex < 2
        ? widget.navigationShell.currentIndex
        : widget.navigationShell.currentIndex + 1;
  }

  void navigateOnTabIndexed(int index, {required bool showCreateTab}) {
    if (showCreateTab && index == 2) {
      TabBarPage.openCreatePage(context);
      return;
    }
    final shellIndex = showCreateTab && index > 2 ? index - 1 : index;
    final alreadyHere = shellIndex == widget.navigationShell.currentIndex;
    if (alreadyHere) {
      switch (shellIndex) {
        case 0:
          context.goNamed(HomePage.name);
        case 1:
          context.goNamed(SchedulePage.name);
        case 2:
          context.goNamed(ChatPage.name);
        case 3:
          context.goNamed(LinkPage.name);
      }
    } else {
      widget.navigationShell.goBranch(shellIndex);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final showCreateTab = _showCreateTab();
    return RestoreSelectedBranch(
      child: Scaffold(
        key: appShellScaffoldKey,
        backgroundColor: isDark
            ? AppColors.secondaryDarkLight
            : AppColors.tabBarScreenBackground,
        drawer: const AppDrawer(),
        body: widget.navigationShell,
        bottomNavigationBar: _NavbarWidget(
          currentIndex: _navbarIndexFromShell(showCreateTab),
          showCreateTab: showCreateTab,
          onTabTapped: (idx) =>
              navigateOnTabIndexed(idx, showCreateTab: showCreateTab),
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
  });
  final int currentIndex;
  final void Function(int) onTabTapped;
  final bool showCreateTab;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final safeArea = MediaQuery.of(context).viewPadding.bottom;
    final screenBackground = isDark
        ? AppColors.secondaryDarkLight
        : AppColors.tabBarScreenBackground;
    return Container(
      color: screenBackground,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: isDark ? AppColors.primaryWhiteDark : AppColors.secondaryLight,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Gap(10),
            Row(
              children: [
                Expanded(
                  child: _NavbarIcon(
                    isActive: currentIndex == 0,
                    imageAsset: AppImages.homeTab,
                    title: 'Главная',
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
                      onTap: () => onTabTapped(2),
                    ),
                  ),
                Expanded(
                  child: _NavbarIcon(
                    isActive: currentIndex == (showCreateTab ? 3 : 2),
                    imageAsset: AppImages.chatTab,
                    title: 'Сообщения',
                    onTap: () => onTabTapped(showCreateTab ? 3 : 2),
                  ),
                ),
                Expanded(
                  child: _NavbarIcon(
                    isActive: currentIndex == (showCreateTab ? 4 : 3),
                    imageAsset: AppImages.linkTab,
                    title: 'Ссылка',
                    onTap: () => onTabTapped(showCreateTab ? 4 : 3),
                  ),
                ),
              ],
            ),
            Gap(safeArea),
          ],
        ),
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
  });
  final bool isActive;
  final String imageAsset;
  final String title;
  final VoidCallback onTap;
  final bool hasCartCountLabel;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = AppColors.themeAccent(context);
    final iconColor = isActive
        ? accent
        : isDark
        ? AppColors.tabbarGreyDark
        : AppColors.tabbarGrey;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
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
