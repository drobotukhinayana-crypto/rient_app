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
    this.onView,
    this.isOpening = false,
  });

  final MessageNotificationItem item;
  final VoidCallback? onOpenCard;
  final VoidCallback? onView;
  final bool isOpening;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.primaryWhiteDark : Colors.white;
    final titleColor = isDark ? AppColors.primaryWhite : AppColors.primaryDark;
    final bodyColor = AppColors.tabbarGrey;
    final accent = AppColors.themeAccent(context);

    final content = Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (item.showAccent) Container(width: 3, color: accent),
            Expanded(
              child: Padding(
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
                    if (item.appointmentId != null &&
                        (onOpenCard != null || isOpening)) ...[
                      const Gap(16),
                      Center(
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
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (onView == null) return content;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onView,
        borderRadius: BorderRadius.circular(16),
        child: content,
      ),
    );
  }
}
