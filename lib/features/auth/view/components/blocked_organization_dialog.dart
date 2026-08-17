import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/main_button.dart';

const blockedOrganizationMessage =
    'Выбранная организация заблокирована или закончился срок лицензии';

Future<void> showBlockedOrganizationDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    useRootNavigator: true,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (dialogContext) {
      final isDark = Theme.of(dialogContext).brightness == Brightness.dark;
      final surface = isDark ? AppColors.primaryDark : Colors.white;
      final onSurface =
          isDark ? AppColors.primaryWhite : AppColors.primaryDark;

      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 30),
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
                'Организация недоступна',
                style: AppFonts.h4Medium.copyWith(color: onSurface),
              ),
              const Gap(12),
              Text(
                blockedOrganizationMessage,
                style: AppFonts.b2Medium.copyWith(color: onSurface),
              ),
              const Gap(16),
              MainButton(
                title: 'ОК',
                onTap: () => Navigator.of(dialogContext).pop(),
              ),
            ],
          ),
        ),
      );
    },
  );
}
