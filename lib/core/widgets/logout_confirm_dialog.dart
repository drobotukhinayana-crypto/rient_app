import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/keys/app_shell_scaffold_key.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/loading_widget.dart';
import 'package:rient_app/features/auth/logout_action.dart';

/// Диалог подтверждения выхода из аккаунта.
Future<void> showLogoutConfirmDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  await showDialog<void>(
    context: context,
    useRootNavigator: true,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.5),
    builder: (dialogContext) => _LogoutConfirmDialog(ref: ref),
  );
}

class _LogoutConfirmDialog extends ConsumerStatefulWidget {
  const _LogoutConfirmDialog({required this.ref});

  final WidgetRef ref;

  @override
  ConsumerState<_LogoutConfirmDialog> createState() =>
      _LogoutConfirmDialogState();
}

class _LogoutConfirmDialogState extends ConsumerState<_LogoutConfirmDialog> {
  bool _isLoggingOut = false;

  Future<void> _onConfirmLogout() async {
    if (_isLoggingOut) return;
    setState(() => _isLoggingOut = true);
    appShellScaffoldKey.currentState?.closeDrawer();
    await performLogout(widget.ref);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.primaryDark : Colors.white;
    final onSurface = isDark ? AppColors.primaryWhite : AppColors.primaryDark;
    final muted = isDark ? AppColors.grey : AppColors.tabbarGrey;

    return PopScope(
      canPop: !_isLoggingOut,
      child: Dialog(
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
            child: _isLoggingOut
                ? _LogoutLoadingBody(onSurface: onSurface, muted: muted)
                : _LogoutConfirmBody(
                    onSurface: onSurface,
                    muted: muted,
                    onConfirm: _onConfirmLogout,
                    onCancel: () => Navigator.of(context).pop(),
                  ),
          ),
        ),
      ),
    );
  }
}

class _LogoutConfirmBody extends StatelessWidget {
  const _LogoutConfirmBody({
    required this.onSurface,
    required this.muted,
    required this.onConfirm,
    required this.onCancel,
  });

  final Color onSurface;
  final Color muted;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
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
          style: AppFonts.b2Medium.copyWith(color: muted),
        ),
        const Gap(16),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: AppDecoration.borderRadius300,
              ),
            ),
            child: Text('Выйти', style: AppFonts.b2Semi),
          ),
        ),
        const Gap(8),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: onSurface,
              side: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
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
    );
  }
}

class _LogoutLoadingBody extends StatelessWidget {
  const _LogoutLoadingBody({
    required this.onSurface,
    required this.muted,
  });

  final Color onSurface;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const LoadingWidget(side: 36),
          const Gap(16),
          Text(
            'Выходим из аккаунта…',
            style: AppFonts.b1Medium.copyWith(color: onSurface),
            textAlign: TextAlign.center,
          ),
          const Gap(8),
          Text(
            'Подождите немного',
            style: AppFonts.b2Medium.copyWith(color: muted),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
