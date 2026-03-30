import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/main_button.dart';
import 'package:rient_app/features/auth/logout_action.dart';

/// Диалог подтверждения выхода из аккаунта.
Future<void> showLogoutConfirmDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (dialogContext) {
      final isDark = Theme.of(dialogContext).brightness == Brightness.dark;
      final surface = isDark ? AppColors.primaryDark : Colors.white;
      final onSurface = isDark ? AppColors.primaryWhite : AppColors.primaryDark;

      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 56),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 350),
          child: Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Выйти из аккаунта?',
                  style: AppFonts.h4Medium.copyWith(color: onSurface),
                ),
                const Gap(8),
                Text(
                  'Вы уверены, что хотите выйти из аккаунта?',
                  style: AppFonts.b2Medium.copyWith(
                    color: isDark ? AppColors.grey : AppColors.tabbarGrey,
                  ),
                ),
                const Gap(16),
                MainButton(
                  title: 'Выйти',
                  color: Colors.red,
                  onTap: () => Navigator.of(dialogContext).pop(true),
                ),
                const Gap(8),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: onSurface,
                      side: BorderSide(
                        color: isDark
                            ? AppColors.secondaryDarkDark
                            : AppColors.secondaryDark,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: AppDecoration.borderRadius300,
                      ),
                    ),
                    child: Text(
                      'Отменить',
                      style: AppFonts.b2Semi.copyWith(color: onSurface),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  if (confirmed != true || !context.mounted) return;
  Navigator.of(context).pop();
  await performLogout(ref);
}
