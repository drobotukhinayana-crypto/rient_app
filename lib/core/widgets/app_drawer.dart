import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/language_dropdown_pill.dart';
import 'package:rient_app/core/widgets/logout_confirm_dialog.dart';
import 'package:rient_app/core/widgets/theme_switch_pill.dart';
import 'package:rient_app/features/home/view/home_page.dart';
import 'package:rient_app/features/schedule/view/schedule_page.dart';
import 'package:rient_app/resources/resources.dart';
import 'package:url_launcher/url_launcher.dart';

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

    void closeThen(VoidCallback action) {
      Navigator.of(context).pop();
      action();
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
                    'Rient',
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: isDark
                        ? AppColors.secondaryDarkDark
                        : AppColors.secondaryDark,
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Иван Иванов',
                          style: AppFonts.b1Medium.copyWith(color: onSurface),
                        ),
                        const Gap(4),
                        Text(
                          'Барбер | Вита',
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
            Gap(5),
            _DrawerTile(
              iconAsset: AppImages.timeBurger,
              label: 'График работы',
              onTap: () => closeThen(() => context.goNamed(SchedulePage.name)),
            ),
            Gap(5),
            _DrawerTile(
              iconAsset: AppImages.chartBurger,
              label: 'Аналитика',
              onTap: () => closeThen(() => context.goNamed(HomePage.name)),
            ),
            Gap(5),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Image.asset(AppImages.themeBurger, width: 24, height: 24),
                  const Gap(6),
                  Text(
                    'Тема',
                    style: AppFonts.b2Medium.copyWith(color: onSurface),
                  ),
                  const Spacer(),
                  const ThemeSwitchPill(),
                ],
              ),
            ),
            Gap(5),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AppImages.languageBurger, width: 24, height: 24),
                  const Gap(6),
                  Text(
                    'Локализация',
                    style: AppFonts.b2Medium.copyWith(color: onSurface),
                  ),
                  const Spacer(),
                  const LanguageDropdownPill(showLeadingIcon: false),
                ],
              ),
            ),

            Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: _DrawerSocialPill(
                      iconAsset: AppImages.whatsappIconBurger,
                      uri: Uri.parse('https://wa.me/79854230137'),
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: _DrawerSocialPill(
                      iconAsset: AppImages.telegramBurger,
                      uri: Uri.parse('https://t.me/rientSupport'),
                    ),
                  ),
                ],
              ),
            ),
            Gap(16),

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
              label: 'Выйти из аккаунта',
              labelStyle: AppFonts.c1Regular.copyWith(color: Colors.red),
              onTap: () => showLogoutConfirmDialog(context, ref),
            ),
            Gap(12),
            Center(
              child: Text(
                'v1.0',
                style: AppFonts.c1Regular.copyWith(color: AppColors.grey),
              ),
            ),
            Gap(12),
            Center(
              child: Text(
                'Copyright Rient, 2025',
                style: AppFonts.c1Regular.copyWith(color: AppColors.grey),
              ),
            ),
          ],
        ),
      ),
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
        onTap: () async {
          try {
            if (await canLaunchUrl(uri)) {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            }
          } catch (_) {}
        },
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
    required this.iconAsset,
    required this.label,
    required this.onTap,
    this.labelStyle,
  });

  final String iconAsset;
  final String label;
  final VoidCallback onTap;
  final TextStyle? labelStyle;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final onSurface = isDark
        ? AppColors.primaryDarkDark
        : AppColors.primaryDark;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Image.asset(iconAsset, width: 24, height: 24),
            const Gap(6),
            Expanded(
              child: Text(
                label,
                style:
                    labelStyle ?? AppFonts.b2Medium.copyWith(color: onSurface),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
