import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/features/chat/chat_page.dart';
import 'package:rient_app/features/create/view/create_page.dart';
import 'package:rient_app/features/home/view/home_page.dart';
import 'package:rient_app/features/link/view/link_page.dart';
import 'package:rient_app/features/schedule/view/schedule_page.dart';
import 'package:rient_app/resources/resources.dart';

enum Tabs { home, schedule, create, chat, link }

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
      case Tabs.create:
        context.goNamed(CreatePage.name, extra: initialTab);
      case Tabs.chat:
        context.goNamed(ChatPage.name, extra: initialTab);
      case Tabs.link:
        context.goNamed(LinkPage.name, extra: initialTab);
    }
  }

  @override
  ConsumerState<TabBarPage> createState() => _TabBarPageState();
}

class _TabBarPageState extends ConsumerState<TabBarPage> {
  void navigateOnTabIndexed(int index) {
    final alreadyHere = index == widget.navigationShell.currentIndex;
    if (alreadyHere) {
      switch (index) {
        case 0:
          context.goNamed(HomePage.name);
        case 1:
          context.goNamed(SchedulePage.name);
        case 2:
          context.goNamed(CreatePage.name);
        case 3:
          context.goNamed(ChatPage.name);
        case 4:
          context.goNamed(LinkPage.name);
      }
    } else {
      widget.navigationShell.goBranch(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: _NavbarWidget(
        currentIndex: widget.navigationShell.currentIndex,
        onTabTapped: navigateOnTabIndexed,
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
    final safeArea = MediaQuery.of(context).viewPadding.bottom;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(
            color: Color(0xffD9D9D9),
            height: 0.25,
            thickness: 0.25,
          ),
          const Gap(8),
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
    final iconColor = isActive ? AppColors.mainAccent : AppColors.tabbarGrey;
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
