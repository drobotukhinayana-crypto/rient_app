import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/open_support_link.dart';
import 'package:rient_app/core/widgets/language_dropdown_pill.dart';
import 'package:rient_app/core/widgets/theme_switch_pill.dart';
import 'package:rient_app/resources/resources.dart';

class BottomPanel extends ConsumerWidget {
  const BottomPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      top: false,
      minimum: EdgeInsets.zero,
      child: Container(
      padding: const EdgeInsets.only(top: 20, bottom: 16),
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
                  uri: supportWhatsAppUri,
                ),
                Gap(12),
                _ContactChip(
                  icon: AppImages.telegram,
                  label: 'Tg - @rientSupport',
                  uri: supportTelegramUri,
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
      ),
    );
  }
}

class _ContactChip extends StatelessWidget {
  const _ContactChip({
    required this.icon,
    required this.label,
    required this.uri,
  });

  final String icon;
  final String label;
  final Uri uri;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => openSupportLink(uri, context: context),
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(icon),
    );
  }
}
