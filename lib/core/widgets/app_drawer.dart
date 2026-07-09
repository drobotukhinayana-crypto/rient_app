import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/network/app_offline.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/language_dropdown_pill.dart';
import 'package:rient_app/core/widgets/loading_widget.dart';
import 'package:rient_app/features/auth/logout_request_provider.dart';
import 'package:rient_app/core/widgets/theme_switch_pill.dart';
import 'package:rient_app/features/analytics/view/analytics_page.dart';
import 'package:rient_app/features/analytics/view/providers/analytics_statistics_provider.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/home/view/providers/account_profile_provider.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_offline_provider.dart';
import 'package:rient_app/features/schedule/view/work_schedule_page.dart';
import 'package:rient_app/features/settings/view/settings_page.dart';
import 'package:rient_app/core/models/worker_entity_labels.dart';
import 'package:rient_app/core/providers/worker_entity_labels_provider.dart';
import 'package:rient_app/core/utils/open_support_link.dart';
import 'package:rient_app/resources/resources.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark
        ? AppColors.primaryWhiteDark
        : AppColors.primaryWhite;
    final onSurface = isDark
        ? AppColors.primaryDarkDark
        : AppColors.primaryDark;
    final profileAsync = ref.watch(accountProfileProvider);
    final profile = profileAsync.value;
    final showProfileLoader =
        profileAsync.isLoading || profileAsync.isRefreshing;
    final roleId = ref.watch(roleProvider);
    final userEmail = (profile?.email ?? '').trim();
    final userName = userEmail.isNotEmpty ? userEmail : 'Пользователь';
    final nameJobLine = () {
      final n = (profile?.workerDisplayName ?? '').trim();
      final j = (profile?.workerSpecialization ?? '').trim();
      if (n.isNotEmpty && j.isNotEmpty) return '$n | $j';
      if (n.isNotEmpty) return n;
      if (j.isNotEmpty) return j;
      return null;
    }();
    final branchName = (ref.watch(currentBranchProvider)?.name ?? '').trim();
    final displayRoleId = profile?.roleId ?? roleId;
    String roleTitle;
    try {
      roleTitle = UserRole.fromInt(displayRoleId).title;
    } catch (_) {
      roleTitle = 'Сотрудник';
    }
    final roleAndBranch = branchName.isEmpty
        ? roleTitle
        : '$roleTitle | $branchName';
    final showWorkSchedule =
        roleId == UserRole.owner.value || roleId == UserRole.worker.value;
    final showAnalytics = roleId != UserRole.administrator.value;
    final showSettings = roleId != UserRole.worker.value &&
        roleId != UserRole.administrator.value;
    final isWorkerRole = roleId == UserRole.worker.value;
    final workerLabels =
        ref.watch(workerEntityLabelsProvider).value ??
        WorkerEntityLabels.defaults;
    final offlineExceptSchedule = ref.watch(appNoConnectionProvider) ||
        ref.watch(scheduleOfflineModeProvider);
    final avatarInitial = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';
    final avatarUrl = (profile?.avatarThumbnail?.isNotEmpty ?? false)
        ? profile!.avatarThumbnail
        : profile?.avatar;

    void closeThen(VoidCallback action) {
      Navigator.of(context).pop();
      action();
    }

    void onDrawerItemTap({required bool enabled, required VoidCallback action}) {
      if (!enabled) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(appNoConnectionMessage)),
        );
        return;
      }
      closeThen(action);
    }

    return Drawer(
      backgroundColor: surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
              child: Row(
                children: [
                  Image.asset(AppImages.logoMini, width: 40, height: 40),
                  const Spacer(),
                  Text(
                    'Rient Admin',
                    style: AppFonts.h3Medium.copyWith(color: onSurface),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Image.asset(
                      AppImages.closeBurger,
                      width: 40,
                      height: 40,
                    ),
                    tooltip: MaterialLocalizations.of(context).closeButtonLabel,
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: isDark
                  ? AppColors.secondaryDarkDark
                  : AppColors.secondaryDark,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: showProfileLoader
                          ? const SizedBox(
                              height: 72,
                              child: Center(
                                child: LoadingWidget(side: 28),
                              ),
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: AppColors.themeAccent(
                                    context,
                                  ).withValues(alpha: 0.2),
                                  backgroundImage: avatarUrl != null &&
                                          avatarUrl.isNotEmpty
                                      ? NetworkImage(avatarUrl)
                                      : null,
                                  child: avatarUrl == null || avatarUrl.isEmpty
                                      ? Text(
                                          avatarInitial,
                                          style: AppFonts.b1Medium.copyWith(
                                            color: AppColors.themeAccent(
                                              context,
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                                const Gap(12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userName,
                                        style: AppFonts.b1Medium.copyWith(
                                          color: onSurface,
                                        ),
                                      ),
                                      if (nameJobLine != null) ...[
                                        const Gap(4),
                                        Text(
                                          nameJobLine,
                                          style: AppFonts.c1Regular.copyWith(
                                            color: isDark
                                                ? AppColors.grey
                                                : AppColors.tabbarGrey,
                                          ),
                                        ),
                                      ],
                                      const Gap(4),
                                      Text(
                                        roleAndBranch,
                                        style: AppFonts.c1Regular.copyWith(
                                          color: isDark
                                              ? AppColors.grey
                                              : AppColors.tabbarGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                    ),
                    if (showWorkSchedule) ...[
                      const Gap(5),
                      _DrawerTile(
                        iconAsset: AppImages.timeBurger,
                        label: workerLabels.workScheduleTitle(
                          isWorkerRole: isWorkerRole,
                        ),
                        enabled: !offlineExceptSchedule,
                        onTap: () => onDrawerItemTap(
                          enabled: !offlineExceptSchedule,
                          action: () =>
                              context.pushNamed(WorkSchedulePage.name),
                        ),
                      ),
                    ],
                    if (showAnalytics) ...[
                      const Gap(5),
                      _DrawerTile(
                        iconAsset: AppImages.chartBurger,
                        label: 'Аналитика',
                        enabled: !offlineExceptSchedule,
                        onTap: () => onDrawerItemTap(
                          enabled: !offlineExceptSchedule,
                          action: () {
                            prepareAnalyticsOnOpen(ref);
                            context.pushNamed(AnalyticsPage.name);
                          },
                        ),
                      ),
                    ],
                    if (showSettings) ...[
                      const Gap(5),
                      _DrawerTile(
                        icon: Icons.settings_outlined,
                        label: 'Настройки',
                        onTap: () => closeThen(
                          () => context.pushNamed(SettingsPage.name),
                        ),
                      ),
                    ],
                    const Gap(5),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            AppImages.themeBurger,
                            width: 24,
                            height: 24,
                          ),
                          const Gap(6),
                          Text(
                            'Тема',
                            style: AppFonts.b2Medium.copyWith(
                              color: onSurface,
                            ),
                          ),
                          const Spacer(),
                          const ThemeSwitchPill(),
                        ],
                      ),
                    ),
                    const Gap(5),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            AppImages.languageBurger,
                            width: 24,
                            height: 24,
                          ),
                          const Gap(6),
                          Text(
                            'Локализация',
                            style: AppFonts.b2Medium.copyWith(
                              color: onSurface,
                            ),
                          ),
                          const Spacer(),
                          const LanguageDropdownPill(
                            showLeadingIcon: false,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _DrawerFooter(
              isDark: isDark,
              onLogout: () {
                Navigator.of(context).pop();
                requestLogout(ref);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerFooter extends StatelessWidget {
  const _DrawerFooter({
    required this.isDark,
    required this.onLogout,
  });

  final bool isDark;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Row(
            children: [
              Expanded(
                child: _DrawerSocialPill(
                  iconAsset: AppImages.whatsappIconBurger,
                  uri: supportWhatsAppUri,
                ),
              ),
              const Gap(12),
              Expanded(
                child: _DrawerSocialPill(
                  iconAsset: AppImages.telegramBurger,
                  uri: supportTelegramUri,
                ),
              ),
            ],
          ),
        ),
        const Gap(8),
        _DrawerTile(
          iconAsset: AppImages.personBurger,
          label: 'Пользовательское соглашение',
          labelStyle: AppFonts.c1Regular.copyWith(
            color: isDark ? AppColors.mainAccentDark : AppColors.mainAccent,
          ),
          onTap: () {},
        ),
        _DrawerTile(
          iconAsset: AppImages.logoutBurger,
          iconColor: Colors.red,
          label: 'Выйти из аккаунта',
          labelStyle: AppFonts.c1Regular.copyWith(color: Colors.red),
          onTap: onLogout,
        ),
        const Gap(8),
        Center(
          child: Text(
            'v1.0',
            style: AppFonts.c1Regular.copyWith(color: AppColors.grey),
          ),
        ),
        const Gap(4),
        Center(
          child: Text(
            'Copyright Rient, 2025',
            style: AppFonts.c1Regular.copyWith(color: AppColors.grey),
          ),
        ),
        const Gap(8),
      ],
    );
  }
}

/// Две кнопки-соцсети внизу drawer (как на экране входа).
class _DrawerSocialPill extends StatelessWidget {
  const _DrawerSocialPill({required this.iconAsset, required this.uri});

  final String iconAsset;
  final Uri uri;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.secondaryDarkLight : AppColors.secondaryLight;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(300),
      child: InkWell(
        onTap: () => openSupportLink(uri, context: context),
        borderRadius: BorderRadius.circular(300),
        child: SizedBox(
          height: 48,
          child: Center(child: Image.asset(iconAsset, height: 28)),
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    this.iconAsset,
    this.icon,
    required this.label,
    required this.onTap,
    this.labelStyle,
    this.iconColor,
    this.enabled = true,
  }) : assert(iconAsset != null || icon != null);

  final String? iconAsset;
  final IconData? icon;
  final String label;
  final VoidCallback onTap;
  final TextStyle? labelStyle;
  final Color? iconColor;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final onSurface = isDark
        ? AppColors.primaryDarkDark
        : AppColors.primaryDark;
    final drawerIconColor = AppColors.themeAccent(context);
    final contentColor = enabled
        ? onSurface
        : (isDark ? AppColors.tabbarGreyDark : AppColors.tabbarGrey)
            .withValues(alpha: 0.45);

    return InkWell(
      onTap: onTap,
      child: Opacity(
        opacity: enabled ? 1 : 0.55,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              if (iconAsset != null)
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    enabled
                        ? (iconColor ?? drawerIconColor)
                        : contentColor,
                    BlendMode.srcIn,
                  ),
                  child: Image.asset(iconAsset!, width: 24, height: 24),
                )
              else
                Icon(
                  icon,
                  size: 24,
                  color: enabled
                      ? (iconColor ?? AppColors.mainAccentDark)
                      : contentColor,
                ),
              const Gap(6),
              Expanded(
                child: Text(
                  label,
                  style: labelStyle ??
                      AppFonts.b2Medium.copyWith(color: contentColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
