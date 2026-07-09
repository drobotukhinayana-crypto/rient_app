import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/providers/theme_mode_provider.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/resources/resources.dart';

class ThemeSwitchPill extends ConsumerWidget {
  const ThemeSwitchPill({super.key, this.enabled = true});

  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: Material(
        color: isDark ? AppColors.secondaryDarkLight : AppColors.secondaryLight,
        borderRadius: BorderRadius.circular(300),
        child: InkWell(
          onTap: enabled
              ? () =>
                  ref.read(themeModeProvider.notifier).toggleBetweenLightDark()
              : null,
        borderRadius: BorderRadius.circular(300),
        child: SizedBox(
          width: 95,
          height: 50,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(AppImages.moonFill),
                  Image.asset(AppImages.sunFill, color: AppColors.grey),
                ],
              ),
              AnimatedAlign(
                duration: const Duration(milliseconds: 200),
                alignment: isDark
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 4,
                  ),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.primaryDark
                          : AppColors.primaryWhite,
                      borderRadius: BorderRadius.circular(300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      isDark ? AppImages.moonFill : AppImages.sunFill,

                      color: AppColors.themeAccent(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
