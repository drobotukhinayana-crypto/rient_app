import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/services/notification_permission_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/main_button.dart';

/// Показывает пояснение и запрашивает системное разрешение на уведомления.
/// Возвращает `true`, если после диалога разрешение выдано.
Future<bool> maybeRequestNotificationPermissionAfterLogin(
  BuildContext context,
  WidgetRef ref, {
  required bool showDeniedSettingsPrompt,
}) async {
  final status = await NotificationPermissionService.getStatus();
  if (status == AppNotificationPermissionStatus.granted) {
    return true;
  }

  if (status == AppNotificationPermissionStatus.notDetermined) {
    final prefs = await SharedPreferences.getInstance();
    final declined = prefs.getString(notificationExplainPromptDeclinedKey);
    if (declined == '1') {
      return false;
    }

    if (!context.mounted) return false;
    final shouldRequest = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      barrierDismissible: false,
      builder: (dialogContext) => _NotificationExplainDialog(
        onLater: () async {
          await prefs.setString(notificationExplainPromptDeclinedKey, '1');
          if (dialogContext.mounted) {
            Navigator.of(dialogContext).pop(false);
          }
        },
        onAllow: () => Navigator.of(dialogContext).pop(true),
      ),
    );
    if (shouldRequest != true || !context.mounted) return false;

    final afterRequest = await NotificationPermissionService.request();
    if (afterRequest == AppNotificationPermissionStatus.granted) {
      return true;
    }

    if (showDeniedSettingsPrompt && context.mounted) {
      await showNotificationPermissionDeniedDialog(context);
    }
    return false;
  }

  if (showDeniedSettingsPrompt && context.mounted) {
    await showNotificationPermissionDeniedDialog(context);
  }
  return false;
}

/// Запрос из экрана настроек — без explain-диалога «Не сейчас».
Future<bool> ensureNotificationPermissionFromSettings(BuildContext context) async {
  final status = await NotificationPermissionService.getStatus();
  if (status == AppNotificationPermissionStatus.granted) {
    return true;
  }

  if (status == AppNotificationPermissionStatus.notDetermined) {
    final afterRequest = await NotificationPermissionService.request();
    if (afterRequest == AppNotificationPermissionStatus.granted) {
      return true;
    }
  }

  if (context.mounted) {
    await showNotificationPermissionDeniedDialog(context);
  }
  return false;
}

Future<void> showNotificationPermissionDeniedDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    useRootNavigator: true,
    builder: (dialogContext) {
      final isDark = Theme.of(dialogContext).brightness == Brightness.dark;
      final surface = isDark ? AppColors.primaryDark : Colors.white;
      final onSurface = isDark ? AppColors.primaryWhite : AppColors.primaryDark;
      final accent = AppColors.themeAccent(dialogContext);

      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 32),
        child: Container(
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Уведомления отключены',
                style: AppFonts.b1Medium.copyWith(color: onSurface),
                textAlign: TextAlign.center,
              ),
              const Gap(12),
              Text(
                'Чтобы не пропускать записи и сообщения, включите '
                'уведомления для Rient в настройках телефона.',
                style: AppFonts.c1Regular.copyWith(color: AppColors.grey),
                textAlign: TextAlign.center,
              ),
              const Gap(20),
              MainButton(
                title: 'Открыть настройки',
                height: 44,
                onTap: () async {
                  await NotificationPermissionService
                      .openSystemNotificationSettings();
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
                  }
                },
              ),
              const Gap(8),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(
                  'Позже',
                  style: AppFonts.b1Medium.copyWith(color: accent),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class _NotificationExplainDialog extends StatelessWidget {
  const _NotificationExplainDialog({
    required this.onLater,
    required this.onAllow,
  });

  final Future<void> Function() onLater;
  final VoidCallback onAllow;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.primaryDark : Colors.white;
    final onSurface = isDark ? AppColors.primaryWhite : AppColors.primaryDark;
    final accent = AppColors.themeAccent(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Включить уведомления?',
              style: AppFonts.b1Medium.copyWith(color: onSurface),
              textAlign: TextAlign.center,
            ),
            const Gap(12),
            Text(
              'Rient пришлёт напоминания о записях, сообщениях клиентов '
              'и изменениях в расписании.',
              style: AppFonts.c1Regular.copyWith(color: AppColors.grey),
              textAlign: TextAlign.center,
            ),
            const Gap(20),
            MainButton(
              title: 'Разрешить',
              height: 44,
              onTap: onAllow,
            ),
            const Gap(8),
            TextButton(
              onPressed: () => unawaited(onLater()),
              child: Text(
                'Не сейчас',
                style: AppFonts.b1Medium.copyWith(color: accent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
