import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/core/providers/notification_permission_status_provider.dart';
import 'package:rient_app/core/services/notification_permission_service.dart';
import 'package:rient_app/core/widgets/app_service_message.dart';
import 'package:rient_app/core/widgets/app_refresh_indicator.dart';
import 'package:rient_app/core/widgets/default_container.dart';
import 'package:rient_app/core/widgets/notification_permission_prompt.dart';
import 'package:rient_app/features/home/view/components/entity_selector_pill.dart';
import 'package:rient_app/features/chat/view/providers/push_settings_provider.dart';
import 'package:rient_app/features/settings/view/components/settings_worker_picker_sheet.dart';
import 'package:rient_app/resources/resources.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  static const name = 'settings_page';
  static const path = 'settings';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roleId = ref.watch(roleProvider);
    if (roleId == UserRole.worker.value ||
        roleId == UserRole.administrator.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.pop();
      });
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenBg = isDark
        ? AppColors.secondaryDarkLight
        : AppColors.tabBarScreenBackground;

    Future<void> onRefresh() async {
      invalidatePushSettings(ref);
      invalidateNotificationPermissionStatus(ref);
      try {
        await ref.read(currentPushSettingsDeviceProvider.future);
        await ref.read(notificationPermissionStatusProvider.future);
      } catch (_) {}
    }

    return Scaffold(
      backgroundColor: screenBg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SettingsHeader(isDark: isDark, onBack: () => context.pop()),
          Expanded(
            child: AppRefreshIndicator(
              onRefresh: onRefresh,
              child: ListView(
                physics: AppRefreshIndicator.scrollPhysics,
                padding: AppDecoration.padding16.copyWith(top: 12),
                children: [
                const _PushNotificationsTile(),
                const Gap(12),
                _SettingsTile(
                  iconAsset: AppImages.ban,
                  title: 'Сбросить доступ сотруднику',
                  onTap: () => SettingsWorkerPickerSheet.show(
                    context,
                    action: SettingsWorkerAction.resetAccess,
                  ),
                ),
                const Gap(12),
                _SettingsTile(
                  iconAsset: AppImages.webremove,
                  title: 'Запретить онлайн запись',
                  onTap: () => SettingsWorkerPickerSheet.show(
                    context,
                    action: SettingsWorkerAction.prohibitOnlineBooking,
                  ),
                ),
              ],
            ),
          ),
        ),
        ],
      ),
    );
  }
}

class _PushNotificationsTile extends ConsumerStatefulWidget {
  const _PushNotificationsTile();

  @override
  ConsumerState<_PushNotificationsTile> createState() =>
      _PushNotificationsTileState();
}

class _PushNotificationsTileState extends ConsumerState<_PushNotificationsTile>
    with WidgetsBindingObserver {
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      invalidateNotificationPermissionStatus(ref);
    }
  }

  Future<void> _enablePushNotifications() async {
    if (!mounted) return;
    final granted = await ensureNotificationPermissionFromSettings(context);
    invalidateNotificationPermissionStatus(ref);
    if (!granted || !mounted) return;

    await setPushEnabled(ref, true);
    invalidatePushSettings(ref);
  }

  Future<void> _openSystemNotificationSettings() async {
    await NotificationPermissionService.openSystemNotificationSettings();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final deviceAsync = ref.watch(currentPushSettingsDeviceProvider);
    final permissionAsync = ref.watch(notificationPermissionStatusProvider);
    final pushEnabled = deviceAsync.value?.pushEnabled ?? true;
    final permissionGranted =
        permissionAsync.value == AppNotificationPermissionStatus.granted;
    final isLoading =
        deviceAsync.isLoading || permissionAsync.isLoading || _isUpdating;
    final accent = AppColors.themeAccent(context);
    final titleColor = isDark ? AppColors.primaryWhite : AppColors.primaryDark;

    final status = _resolvePushStatus(
      pushEnabled: pushEnabled,
      permissionGranted: permissionGranted,
      hasLoadError: deviceAsync.hasError,
      permissionLoadError: permissionAsync.hasError,
    );

    return Material(
      color: isDark ? AppColors.primaryWhiteDark : Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SwitchListTile(
            title: Text(
              'Push-уведомления',
              style: AppFonts.b1Medium.copyWith(color: titleColor),
            ),
            subtitle: Text(
              status.subtitle,
              style: AppFonts.c1Regular.copyWith(color: status.color),
            ),
            value: pushEnabled,
            onChanged: isLoading
                ? null
                : (value) async {
                    setState(() => _isUpdating = true);
                    try {
                      if (value) {
                        await _enablePushNotifications();
                      } else {
                        await setPushEnabled(ref, false);
                        invalidatePushSettings(ref);
                      }
                    } catch (_) {
                      if (!context.mounted) return;
                      showAppServiceMessage(
                        context,
                        message: 'Не удалось изменить настройку',
                        variant: AppServiceMessageVariant.error,
                      );
                    } finally {
                      if (mounted) setState(() => _isUpdating = false);
                    }
                  },
          ),
          if (!permissionGranted && !permissionAsync.isLoading) ...[
            const Divider(height: 1),
            TextButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      setState(() => _isUpdating = true);
                      try {
                        final status = await NotificationPermissionService
                            .getStatus();
                        if (!context.mounted) return;
                        if (status ==
                            AppNotificationPermissionStatus.notDetermined) {
                          await _enablePushNotifications();
                        } else {
                          await _openSystemNotificationSettings();
                        }
                      } finally {
                        invalidateNotificationPermissionStatus(ref);
                        if (mounted) setState(() => _isUpdating = false);
                      }
                    },
              child: Text(
                status.actionLabel,
                style: AppFonts.b2Medium.copyWith(color: accent),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PushStatusUi {
  const _PushStatusUi({
    required this.subtitle,
    required this.color,
    required this.actionLabel,
  });

  final String subtitle;
  final Color color;
  final String actionLabel;
}

_PushStatusUi _resolvePushStatus({
  required bool pushEnabled,
  required bool permissionGranted,
  required bool hasLoadError,
  required bool permissionLoadError,
}) {
  if (hasLoadError) {
    return const _PushStatusUi(
      subtitle: 'Не удалось загрузить настройки',
      color: AppColors.red,
      actionLabel: 'Разрешить уведомления',
    );
  }
  if (permissionLoadError) {
    return const _PushStatusUi(
      subtitle: 'Не удалось проверить разрешение',
      color: AppColors.red,
      actionLabel: 'Разрешить уведомления',
    );
  }
  if (!permissionGranted) {
    return const _PushStatusUi(
      subtitle: 'Нет разрешения в настройках телефона',
      color: AppColors.red,
      actionLabel: 'Разрешить уведомления',
    );
  }
  if (!pushEnabled) {
    return const _PushStatusUi(
      subtitle: 'Отключены в приложении',
      color: AppColors.grey,
      actionLabel: 'Открыть настройки телефона',
    );
  }
  return const _PushStatusUi(
    subtitle: 'Уведомления включены',
    color: AppColors.green,
    actionLabel: 'Открыть настройки телефона',
  );
}

class _SettingsHeader extends StatelessWidget {
  const _SettingsHeader({required this.isDark, required this.onBack});

  final bool isDark;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final circleColor = isDark
        ? AppColors.secondaryDarkLight
        : AppColors.secondaryLight;
    final iconColor = isDark ? AppColors.primaryWhite : AppColors.primaryDark;

    return DefaultContainerWidget(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(24),
        bottomRight: Radius.circular(24),
      ),
      hasShadow: false,
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top + 8,
        bottom: 14,
        left: 16,
        right: 16,
      ),
      color: isDark ? AppColors.primaryWhiteDark : Colors.white,
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: circleColor,
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: iconColor,
              ),
            ),
          ),
          const Gap(12),
          Expanded(
            child: Text(
              'Настройки',
              style: AppFonts.h3Medium.copyWith(
                color: isDark ? AppColors.primaryWhite : AppColors.primaryDark,
              ),
            ),
          ),
          const ProfileSelectorPill(),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.iconAsset,
    required this.title,
    required this.onTap,
  });

  final String iconAsset;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = AppColors.themeAccent(context);
    final cardColor = isDark ? AppColors.primaryWhiteDark : Colors.white;
    final titleColor = isDark ? AppColors.primaryWhite : AppColors.primaryDark;

    return DefaultContainerWidget(
      color: cardColor,
      hasShadow: true,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Image.asset(iconAsset, width: 24, height: 24),
            const Gap(12),
            Expanded(
              child: Text(
                title,
                style: AppFonts.b2Medium.copyWith(color: titleColor),
              ),
            ),
            Icon(Icons.chevron_right, size: 22, color: accent),
          ],
        ),
      ),
    );
  }
}
