import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/features/schedule/view/components/work_schedule_mock_data.dart';
import 'package:rient_app/features/schedule/view/components/work_schedule_month_grid.dart'
    show
        workScheduleDayCellGap,
        workScheduleDayColumnWidth,
        workScheduleEmployeeColumnWidth,
        workScheduleEmployeeToGridGap,
        workScheduleInactiveDayFill;

/// Полоска дат месяца над переключателем месяца (в [TopPanel]).
class WorkScheduleMonthDateStrip extends StatelessWidget {
  const WorkScheduleMonthDateStrip({
    super.key,
    required this.month,
    required this.selectedDate,
    required this.scrollController,
    this.onDateSelected,
  });

  final DateTime month;
  final DateTime selectedDate;
  final ScrollController scrollController;
  final ValueChanged<DateTime>? onDateSelected;

  @override
  Widget build(BuildContext context) {
    final days = daysOfMonth(month);

    return Row(
      children: [
        SizedBox(
          width: workScheduleEmployeeColumnWidth + workScheduleEmployeeToGridGap,
        ),
        Expanded(
          child: SizedBox(
            height: 56,
            child: ListView.separated(
              controller: scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: days.length,
              separatorBuilder: (_, __) => const Gap(workScheduleDayCellGap),
              itemBuilder: (context, index) {
                final date = days[index];
                final isSelected = date.year == selectedDate.year &&
                    date.month == selectedDate.month &&
                    date.day == selectedDate.day;
                return SizedBox(
                  width: workScheduleDayColumnWidth,
                  child: GestureDetector(
                    onTap: onDateSelected == null
                        ? null
                        : () => onDateSelected!(date),
                    behavior: HitTestBehavior.opaque,
                    child: WorkScheduleDayHeader(
                      date: date,
                      isSelected: isSelected,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class WorkScheduleDayHeader extends StatelessWidget {
  const WorkScheduleDayHeader({
    super.key,
    required this.date,
    required this.isSelected,
  });

  final DateTime date;
  final bool isSelected;

  static const _weekdayShort = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = AppColors.themeAccent(context);
    final isPast = isPastWorkScheduleDate(date);
    final circleFill = isSelected
        ? accent
        : isPast
        ? (isDark
              ? Color.lerp(WorkScheduleCellColors.shift, Colors.black, 0.65)!
              : WorkScheduleCellColors.dateHeaderPastFill)
        : (isDark
              ? AppColors.secondaryDarkDark
              : workScheduleInactiveDayFill);
    final numberColor = isSelected
        ? AppColors.primaryWhite
        : (isDark ? AppColors.tabbarGreyDark : AppColors.tabbarGrey);
    final weekdayColor = isSelected
        ? accent
        : (isDark ? AppColors.tabbarGreyDark : AppColors.tabbarGrey);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: circleFill,
            shape: BoxShape.circle,
          ),
          child: Text(
            '${date.day}',
            style: AppFonts.c2Tabbar.copyWith(
              color: numberColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Gap(2),
        Text(
          _weekdayShort[date.weekday - 1],
          style: AppFonts.c2Tabbar.copyWith(
            color: weekdayColor,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
