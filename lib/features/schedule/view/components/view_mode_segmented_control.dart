import 'package:flutter/material.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';

enum ViewMode { day, week, month }

class ViewModeSegmentedControl extends StatelessWidget {
  const ViewModeSegmentedControl({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final ViewMode value;
  final ValueChanged<ViewMode> onChanged;

  static const _labels = ['День', 'Неделя', 'Месяц'];

  static const _height = 30.0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final trackColor = isDark
        ? const Color(0xff383A43)
        : const Color(0xffEEEEEF);

    return Container(
      clipBehavior: Clip.none,
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
                label: _labels[0],
                isSelected: value == ViewMode.day,
                isFirst: true,
                isLast: false,
                onTap: () => onChanged(ViewMode.day),
              ),
            ),
            Expanded(
              child: _Segment(
                label: _labels[1],
                isSelected: value == ViewMode.week,
                isFirst: false,
                isLast: false,
                onTap: () => onChanged(ViewMode.week),
              ),
            ),
            Expanded(
              child: _Segment(
                label: _labels[2],
                isSelected: value == ViewMode.month,
                isFirst: false,
                isLast: true,
                onTap: () => onChanged(ViewMode.month),
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
    required this.label,
    required this.isSelected,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedFill = isDark ? Color(0xff6C6C71) : AppColors.primaryWhite;
    final textColor = isDark
        ? AppColors.primaryDarkDark
        : AppColors.primaryDark;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? selectedFill : Colors.transparent,
          borderRadius: BorderRadius.circular(300),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: isSelected
              ? AppFonts.c1Semi.copyWith(color: textColor)
              : AppFonts.c1Medium.copyWith(color: textColor),
        ),
      ),
    );
  }
}
