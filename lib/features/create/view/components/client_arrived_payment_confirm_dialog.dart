import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/main_button.dart';

/// Индекс статуса «Клиент пришел» в [defaultClientStatusOptions].
const int kClientArrivedStatusIndex = 2;

enum ClientArrivedPaymentDialogResult { pay, saveOnly, dismiss }

/// Подтверждение оплаты при смене статуса на «Клиент пришел».
Future<ClientArrivedPaymentDialogResult?> showClientArrivedPaymentConfirmDialog({
  required BuildContext context,
  required int appointmentId,
}) {
  return showDialog<ClientArrivedPaymentDialogResult>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (dialogContext) {
      final isDark = Theme.of(dialogContext).brightness == Brightness.dark;
      final surface = isDark ? AppColors.primaryDark : Colors.white;
      final onSurface = isDark ? AppColors.primaryWhite : AppColors.primaryDark;
      final muted = isDark ? AppColors.grey : AppColors.tabbarGrey;
      final secondaryBorder = isDark
          ? AppColors.secondaryDarkDark
          : AppColors.secondaryDark;

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
                  'Вы уверены?',
                  style: AppFonts.h4Medium.copyWith(color: onSurface),
                ),
                const Gap(8),
                Text(
                  'Провести оплату за запись №$appointmentId?',
                  style: AppFonts.b2Medium.copyWith(color: muted),
                ),
                const Gap(16),
                MainButton(
                  title: 'Оплатить',
                  onTap: () => Navigator.of(dialogContext).pop(
                    ClientArrivedPaymentDialogResult.pay,
                  ),
                ),
                const Gap(8),
                _DialogSecondaryButton(
                  title: 'Сохранить',
                  onSurface: onSurface,
                  secondaryBorder: secondaryBorder,
                  onPressed: () => Navigator.of(dialogContext).pop(
                    ClientArrivedPaymentDialogResult.saveOnly,
                  ),
                ),
                const Gap(8),
                _DialogSecondaryButton(
                  title: 'Закрыть',
                  onSurface: onSurface,
                  secondaryBorder: secondaryBorder,
                  onPressed: () => Navigator.of(dialogContext).pop(
                    ClientArrivedPaymentDialogResult.dismiss,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _DialogSecondaryButton extends StatelessWidget {
  const _DialogSecondaryButton({
    required this.title,
    required this.onSurface,
    required this.secondaryBorder,
    required this.onPressed,
  });

  final String title;
  final Color onSurface;
  final Color secondaryBorder;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: onSurface,
          side: BorderSide(color: secondaryBorder),
          shape: RoundedRectangleBorder(
            borderRadius: AppDecoration.borderRadius300,
          ),
        ),
        child: Text(
          title,
          style: AppFonts.b2Semi.copyWith(color: onSurface),
        ),
      ),
    );
  }
}
