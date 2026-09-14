import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/loading_widget.dart';
import 'package:rient_app/features/chat/view/components/message_notification_item.dart';

class MessageNotificationCard extends StatelessWidget {
  const MessageNotificationCard({
    super.key,
    required this.item,
    this.onOpenCard,
    this.onLicenseAction,
    this.onView,
    this.isOpening = false,
    this.isMarkingRead = false,
  });

  final MessageNotificationItem item;
  final VoidCallback? onOpenCard;
  final VoidCallback? onLicenseAction;
  final VoidCallback? onView;
  final bool isOpening;
  final bool isMarkingRead;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.primaryWhiteDark : Colors.white;
    final titleColor = isDark ? AppColors.primaryWhite : AppColors.primaryDark;
    final bodyColor = AppColors.tabbarGrey;
    final accent = item.accentIsWarning
        ? (isDark ? AppColors.yelDark : AppColors.yel)
        : AppColors.themeAccent(context);

    final hasAppointmentAction =
        item.appointmentId != null && (onOpenCard != null || isOpening);
    final hasLicenseAction = item.isLicenseNotification &&
        (onLicenseAction != null || isOpening);

    final header = Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: AppFonts.b1Semi.copyWith(color: titleColor),
          ),
          const Gap(6),
          Text(
            item.description,
            style: AppFonts.b2Regular.copyWith(
              color: bodyColor,
              height: 1.35,
            ),
          ),
          const Gap(10),
          Text(
            item.timestamp,
            style: AppFonts.c1Regular.copyWith(
              color: bodyColor,
            ),
          ),
        ],
      ),
    );

    final action = hasAppointmentAction
        ? Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            child: Center(
              child: isOpening
                  ? const LoadingWidget(side: 22)
                  : GestureDetector(
                      onTap: onOpenCard,
                      behavior: HitTestBehavior.opaque,
                      child: Text(
                        'Перейти в карточку >',
                        style: AppFonts.medium14.copyWith(
                          color: accent,
                        ),
                      ),
                    ),
            ),
          )
        : hasLicenseAction
        ? Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            child: Center(
              child: isOpening
                  ? const LoadingWidget(side: 22)
                  : GestureDetector(
                      onTap: onLicenseAction,
                      behavior: HitTestBehavior.opaque,
                      child: Text(
                        _licenseActionLabel(item),
                        style: AppFonts.medium14.copyWith(
                          color: accent,
                        ),
                      ),
                    ),
            ),
          )
        : null;

    final content = Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (item.showAccent)
              Container(width: 3, color: accent),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (onView == null)
                    header
                  else
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onView,
                        child: header,
                      ),
                    ),
                  if (action != null) action,
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (!isMarkingRead) return content;
    return Stack(
      children: [
        Opacity(opacity: 0.55, child: content),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(child: LoadingWidget(side: 28)),
          ),
        ),
      ],
    );
  }
}

String _licenseActionLabel(MessageNotificationItem item) {
  if (item.licensePaymentUrl != null && item.licensePaymentUrl!.isNotEmpty) {
    return 'Перейти к оплате >';
  }
  return 'Понятно';
}
