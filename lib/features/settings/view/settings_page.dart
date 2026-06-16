import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
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
      try {
        await ref.read(currentPushSettingsDeviceProvider.future);
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

class _PushNotificationsTileState extends ConsumerState<_PushNotificationsTile> {
  bool _isUpdating = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final deviceAsync = ref.watch(currentPushSettingsDeviceProvider);
    final pushEnabled = deviceAsync.value?.pushEnabled ?? true;
    final isLoading = deviceAsync.isLoading || _isUpdating;

    return Material(
      color: isDark ? AppColors.primaryWhiteDark : Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: SwitchListTile(
        title: Text(
          'Push-уведомления',
          style: AppFonts.b1Medium.copyWith(
            color: isDark ? AppColors.primaryWhite : AppColors.primaryDark,
          ),
        ),
        subtitle: deviceAsync.hasError
            ? Text(
                'Не удалось загрузить настройки',
                style: AppFonts.c1Regular.copyWith(color: AppColors.red),
              )
            : null,
        value: pushEnabled,
        onChanged: isLoading
            ? null
            : (value) async {
                setState(() => _isUpdating = true);
                try {
                  if (value) {
                    var granted =
                        await NotificationPermissionService.hasGrantedPermission();
                    if (!granted) {
                      if (!context.mounted) return;
                      granted =
                          await maybeRequestNotificationPermissionAfterLogin(
                        context,
                        ref,
                        showDeniedSettingsPrompt: true,
                      );
                    }
                    if (!granted) {
                      if (!context.mounted) return;
                      showAppServiceMessage(
                        context,
                        message: 'Разрешите уведомления в настройках телефона',
                        variant: AppServiceMessageVariant.info,
                      );
                      return;
                    }
                  }
                  await setPushEnabled(ref, value);
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
    );
  }
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
