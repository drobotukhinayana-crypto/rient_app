import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/features/schedule/utils/appointment_inventory_conflict_utils.dart';

/// Диалог конфликта инвентаря: «Всё равно записать» / «Отменить».
Future<bool?> showAppointmentInventoryConflictDialog({
  required BuildContext context,
  required AppointmentInventoryConflictException conflict,
}) {
  final inventoryLabel = conflict.inventoryLabel;
  final conflictLines = conflict.conflictLines;

  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (dialogContext) {
      final isDark = Theme.of(dialogContext).brightness == Brightness.dark;
      final surface = isDark ? AppColors.primaryDark : Colors.white;
      final onSurface = isDark ? AppColors.primaryWhite : AppColors.primaryDark;
      final muted = isDark ? AppColors.grey : AppColors.tabbarGrey;
      final accent = AppColors.themeAccent(dialogContext);
      final divider = isDark ? AppColors.secondaryDarkDark : AppColors.secondaryDark;

      final intro = inventoryLabel == null || inventoryLabel.isEmpty
          ? 'Инвентарь в выбранное время будут использоваться:'
          : 'Инвентарь «$inventoryLabel» в выбранное время будут использоваться:';

      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                  child: Text(
                    intro,
                    textAlign: TextAlign.center,
                    style: AppFonts.b2Medium.copyWith(color: onSurface),
                  ),
                ),
                if (conflictLines.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      children: [
                        for (final line in conflictLines) ...[
                          Text(
                            line,
                            textAlign: TextAlign.center,
                            style: AppFonts.b2Medium.copyWith(color: muted),
                          ),
                          const Gap(4),
                        ],
                      ],
                    ),
                  ),
                Divider(height: 1, thickness: 1, color: divider),
                SizedBox(
                  height: 48,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(dialogContext).pop(true),
                          style: TextButton.styleFrom(
                            foregroundColor: accent,
                            shape: const RoundedRectangleBorder(),
                          ),
                          child: Text(
                            'Записать',
                            style: AppFonts.b2Semi.copyWith(color: accent),
                          ),
                        ),
                      ),
                      Container(width: 1, height: 48, color: divider),
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(dialogContext).pop(false),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.red,
                            shape: const RoundedRectangleBorder(),
                          ),
                          child: Text(
                            'Отменить',
                            style: AppFonts.b2Semi.copyWith(color: AppColors.red),
                          ),
                        ),
                      ),
                    ],
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
