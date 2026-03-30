import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/keys/app_shell_scaffold_key.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/widgets/app_drawer.dart';
import 'package:rient_app/features/chat/chat_page.dart';
import 'package:rient_app/features/create/view/add_new_entry_page.dart'
    show AddNewEntryPage;
import 'package:rient_app/features/home/view/components/restore_selected_branch.dart';
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

class _TabBarPageState extends ConsumerState<TabBarPage> {
  int get _navbarIndexFromShell => widget.navigationShell.currentIndex < 2
      ? widget.navigationShell.currentIndex
      : widget.navigationShell.currentIndex + 1;

  void navigateOnTabIndexed(int index) {
    if (index == 2) {
      TabBarPage.openCreatePage(context);
      return;
    }
    final shellIndex = index < 2 ? index : index - 1;
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
    return RestoreSelectedBranch(
      child: Scaffold(
        key: appShellScaffoldKey,
        backgroundColor: isDark
            ? AppColors.secondaryDarkLight
            : AppColors.tabBarScreenBackground,
        drawer: const AppDrawer(),
        body: widget.navigationShell,
        bottomNavigationBar: _NavbarWidget(
          currentIndex: _navbarIndexFromShell,
          onTabTapped: navigateOnTabIndexed,
        ),
      ),
    );
  }
}

class _NavbarWidget extends StatelessWidget {
  const _NavbarWidget({required this.currentIndex, required this.onTabTapped});
  final int currentIndex;
  final void Function(int) onTabTapped;

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
                    isActive: currentIndex == 3,
                    imageAsset: AppImages.chatTab,
                    title: 'Сообщения',
                    onTap: () => onTabTapped(3),
                  ),
                ),
                Expanded(
                  child: _NavbarIcon(
                    isActive: currentIndex == 4,
                    imageAsset: AppImages.linkTab,
                    title: 'Ссылка',
                    onTap: () => onTabTapped(4),
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
