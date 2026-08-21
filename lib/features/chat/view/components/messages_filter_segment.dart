import 'package:flutter/material.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';

enum MessagesFilter { unread, read }

class MessagesFilterSegment extends StatelessWidget {
  const MessagesFilterSegment({
    super.key,
    required this.value,
    required this.unreadCount,
    required this.readCount,
    required this.onChanged,
    this.countsLoading = false,
  });

  final MessagesFilter value;
  final int unreadCount;
  final int readCount;
  final ValueChanged<MessagesFilter> onChanged;
  final bool countsLoading;

  static const _height = 30.0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final trackColor =
        isDark ? const Color(0xff383A43) : const Color(0xffEEEEEF);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: BorderRadius.circular(300),
      ),
      child: SizedBox(
        height: _height,
        child: Row(
          children: [
            Expanded(
              child: _Segment(
                title: 'Непросмотренные',
                count: unreadCount,
                countLoading: countsLoading,
                isSelected: value == MessagesFilter.unread,
                onTap: () => onChanged(MessagesFilter.unread),
              ),
            ),
            Expanded(
              child: _Segment(
                title: 'Просмотренные',
                count: readCount,
                countLoading: countsLoading,
                isSelected: value == MessagesFilter.read,
                onTap: () => onChanged(MessagesFilter.read),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.title,
    required this.count,
    required this.countLoading,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final int count;
  final bool countLoading;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedFill = isDark ? const Color(0xff6C6C71) : AppColors.primaryWhite;
    final textColor =
        isDark ? AppColors.primaryDarkDark : AppColors.primaryDark;
    final textStyle = isSelected
        ? AppFonts.c1Semi.copyWith(color: textColor, fontSize: 11)
        : AppFonts.c1Medium.copyWith(color: textColor, fontSize: 11);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? selectedFill : Colors.transparent,
          borderRadius: BorderRadius.circular(300),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                title,
                style: textStyle,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (countLoading)
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: textColor,
                  ),
                ),
              )
            else
              Text(
                ' ($count)',
                style: textStyle,
                maxLines: 1,
              ),
          ],
        ),
      ),
    );
  }
}
