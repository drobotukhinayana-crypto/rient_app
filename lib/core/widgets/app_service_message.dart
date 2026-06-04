import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/resources/resources.dart';

enum AppServiceMessageVariant { success, error, info }

/// Отступ плашки от верха экрана (под шапкой «Расписание» / «График работы»).
const double kAppServiceMessageTopInset = 108;

OverlayEntry? _activeAppServiceMessageEntry;
Timer? _activeAppServiceMessageTimer;

/// Сервисное сообщение в стиле Figma: белая «пилюля», иконка, текст, закрытие.
class AppServiceMessage extends StatelessWidget {
  const AppServiceMessage({
    super.key,
    required this.message,
    this.variant = AppServiceMessageVariant.success,
    this.onClose,
  });

  final String message;
  final AppServiceMessageVariant variant;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: const Color(0xFFE5E7EB),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _VariantIcon(variant: variant),
            const Gap(10),
            Expanded(
              child: Text(
                message,
                style: AppFonts.b1Medium.copyWith(
                  color: AppColors.primaryDark,
                  height: 1.25,
                ),
              ),
            ),
            if (onClose != null) ...[
              const Gap(8),
              GestureDetector(
                onTap: onClose,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.close,
                    size: 20,
                    color: AppColors.grey.withValues(alpha: 0.85),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _VariantIcon extends StatelessWidget {
  const _VariantIcon({required this.variant});

  final AppServiceMessageVariant variant;

  @override
  Widget build(BuildContext context) {
    if (variant == AppServiceMessageVariant.success) {
      return Image.asset(
        AppImages.successFilled,
        width: 32,
        height: 32,
      );
    }

    final (Color bg, IconData icon) = switch (variant) {
      AppServiceMessageVariant.error => (
          AppColors.red,
          Icons.close_rounded,
        ),
      AppServiceMessageVariant.info => (
          AppColors.mainAccent,
          Icons.info_outline_rounded,
        ),
      AppServiceMessageVariant.success => throw StateError('unreachable'),
    };

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 20, color: Colors.white),
    );
  }
}

void _dismissActiveAppServiceMessage() {
  _activeAppServiceMessageTimer?.cancel();
  _activeAppServiceMessageTimer = null;
  _activeAppServiceMessageEntry?.remove();
  _activeAppServiceMessageEntry = null;
}

/// Показывает сервисное сообщение сверху (как в Figma), не снизу как SnackBar.
void showAppServiceMessage(
  BuildContext context, {
  required String message,
  AppServiceMessageVariant variant = AppServiceMessageVariant.success,
  Duration duration = const Duration(seconds: 4),
  double topInset = kAppServiceMessageTopInset,
  ScaffoldMessengerState? messenger,
}) {
  if (messenger != null) {
    messenger.hideCurrentSnackBar();
  } else {
    ScaffoldMessenger.maybeOf(context)?.hideCurrentSnackBar();
  }

  _dismissActiveAppServiceMessage();

  final overlay = Overlay.of(context, rootOverlay: true);
  final top = MediaQuery.paddingOf(context).top + topInset;

  late OverlayEntry entry;
  void dismiss() {
    if (_activeAppServiceMessageEntry == entry) {
      _dismissActiveAppServiceMessage();
    } else {
      entry.remove();
    }
  }

  entry = OverlayEntry(
    builder: (overlayContext) => Positioned(
      top: top,
      left: 16,
      right: 16,
      child: AppServiceMessage(
        message: message,
        variant: variant,
        onClose: dismiss,
      ),
    ),
  );

  _activeAppServiceMessageEntry = entry;
  overlay.insert(entry);
  _activeAppServiceMessageTimer = Timer(duration, dismiss);
}
