import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/routes/route_notifier.dart' show rootNavigatorKey;
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';

const appExitDialogTitle = 'Rient Admin';

/// Диалог подтверждения выхода из приложения (Android «назад» на корневом экране).
Future<bool> showExitAppConfirmDialog([BuildContext? context]) async {
  final hostContext = context ?? rootNavigatorKey.currentContext;
  if (hostContext == null || !hostContext.mounted) return false;

  final result = await showDialog<bool>(
    context: hostContext,
    useRootNavigator: true,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (dialogContext) {
      final isDark = Theme.of(dialogContext).brightness == Brightness.dark;
      final surface = isDark ? AppColors.primaryDark : Colors.white;
      final onSurface = isDark ? AppColors.primaryWhite : AppColors.primaryDark;

      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 48),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Выйти из $appExitDialogTitle?',
                  style: AppFonts.h4Medium.copyWith(color: onSurface),
                  textAlign: TextAlign.center,
                ),
                const Gap(20),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: OutlinedButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(false),
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
                            'Нет',
                            style: AppFonts.b2Semi.copyWith(color: onSurface),
                          ),
                        ),
                      ),
                    ),
                    const Gap(12),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () =>
                              Navigator.of(dialogContext).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.themeAccent(
                              dialogContext,
                            ),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppDecoration.borderRadius300,
                            ),
                          ),
                          child: Text('Да', style: AppFonts.b2Semi),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );

  return result == true;
}
