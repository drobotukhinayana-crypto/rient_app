import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/widgets/language_dropdown_pill.dart';
import 'package:rient_app/core/widgets/theme_switch_pill.dart';
import 'package:rient_app/resources/resources.dart';
import 'package:url_launcher/url_launcher.dart';

class BottomPanel extends ConsumerWidget {
  const BottomPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.only(top: 20, bottom: 30),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: Color(0xff000000).withValues(alpha: 0.1),
          ),
        ],
        color: isDark ? AppColors.primaryDark : AppColors.primaryWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _ContactChip(
                  icon: AppImages.whatsapp,
                  label: 'wa - +7(985)423-01-37',
                  uri: Uri.parse('https://wa.me/79854230137'),
                ),
                Gap(12),
                _ContactChip(
                  icon: AppImages.telegram,
                  label: 'Tg - @rientSupport',
                  uri: Uri.parse('https://t.me/rientSupport'),
                ),
                const Spacer(),
                const LanguageDropdownPill(),
                const Spacer(),
                const ThemeSwitchPill(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactChip extends StatelessWidget {
  const _ContactChip({
    required this.icon,
    required this.label,
    required this.uri,
    this.fallbackUri,
  });

  final String icon;
  final String label;
  final Uri uri;
  final Uri? fallbackUri;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        try {
          // 1) пробуем открыть приложение
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
            return;
          }

          // 2) fallback на https
          if (fallbackUri != null && await canLaunchUrl(fallbackUri!)) {
            await launchUrl(fallbackUri!, mode: LaunchMode.externalApplication);
            return;
          }

          // тут можно показать SnackBar, если ничего не открылось
        } catch (e) {
          // тоже можно показать SnackBar/лог
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(icon),
    );
  }
}
