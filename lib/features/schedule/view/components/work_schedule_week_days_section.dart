import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/custom_switch_widget.dart';
import 'package:rient_app/features/schedule/view/providers/specialist_schedule_loader.dart';

class WorkScheduleWeekDaysSection extends StatelessWidget {
  const WorkScheduleWeekDaysSection({
    super.key,
    required this.groupTitle,
    required this.expanded,
    required this.groupStart,
    required this.groupEnd,
    required this.days,
    required this.onToggleExpanded,
    required this.onPickGroupStart,
    required this.onPickGroupEnd,
    required this.onDayEnabledChanged,
    required this.onPickDayStart,
    required this.onPickDayEnd,
    this.showBreaks = true,
    this.onPickBreakStart,
    this.onPickBreakEnd,
    this.onClearBreak,
  });

  final String groupTitle;
  final bool expanded;
  final String groupStart;
  final String groupEnd;
  final List<SpecialistDayDraft> days;
  final VoidCallback onToggleExpanded;
  final VoidCallback onPickGroupStart;
  final VoidCallback onPickGroupEnd;
  final void Function(int index, bool enabled) onDayEnabledChanged;
  final void Function(int index) onPickDayStart;
  final void Function(int index) onPickDayEnd;
  final bool showBreaks;
  final void Function(int index)? onPickBreakStart;
  final void Function(int index)? onPickBreakEnd;
  final void Function(int index)? onClearBreak;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dividerColor =
        isDark ? AppColors.secondaryDarkDark : AppColors.secondaryDark;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              GestureDetector(
                onTap: onToggleExpanded,
                behavior: HitTestBehavior.opaque,
                child: Row(
                  children: [
                    Icon(
                      expanded
                          ? Icons.keyboard_arrow_down_rounded
                          : Icons.keyboard_arrow_right_rounded,
                      size: 22,
                      color: AppColors.themeAccent(context),
                    ),
                    const Gap(4),
                    Text(
                      groupTitle,
                      style: AppFonts.b1Medium.copyWith(
                        color: isDark
                            ? AppColors.primaryWhite
                            : AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              WorkScheduleTimeRangeFields(
                start: groupStart,
                end: groupEnd,
                onPickStart: onPickGroupStart,
                onPickEnd: onPickGroupEnd,
              ),
            ],
          ),
        ),
        if (expanded)
          for (var i = 0; i < days.length; i++) ...[
            Divider(height: 1, thickness: 1, color: dividerColor),
            WorkScheduleDayScheduleContent(
              day: days[i],
              showBreaks: showBreaks,
              onEnabledChanged: (enabled) => onDayEnabledChanged(i, enabled),
              onPickStart: () => onPickDayStart(i),
              onPickEnd: () => onPickDayEnd(i),
              onPickBreakStart: showBreaks && onPickBreakStart != null
                  ? () => onPickBreakStart!(i)
                  : null,
              onPickBreakEnd:
                  showBreaks && onPickBreakEnd != null ? () => onPickBreakEnd!(i) : null,
              onClearBreak:
                  showBreaks && onClearBreak != null ? () => onClearBreak!(i) : null,
            ),
          ],
      ],
    );
  }
}

class WorkScheduleDayScheduleContent extends StatelessWidget {
  const WorkScheduleDayScheduleContent({
    super.key,
    required this.day,
    required this.onEnabledChanged,
    required this.onPickStart,
    required this.onPickEnd,
    this.showBreaks = true,
    this.onPickBreakStart,
    this.onPickBreakEnd,
    this.onClearBreak,
  });

  final SpecialistDayDraft day;
  final ValueChanged<bool> onEnabledChanged;
  final VoidCallback onPickStart;
  final VoidCallback onPickEnd;
  final bool showBreaks;
  final VoidCallback? onPickBreakStart;
  final VoidCallback? onPickBreakEnd;
  final VoidCallback? onClearBreak;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeLabelColor =
        isDark ? AppColors.primaryWhite : AppColors.primaryDark;
    final inactiveLabelColor = AppColors.tabbarGrey;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Column(
        children: [
          Row(
            children: [
              CustomSwitchWidget(
                value: day.enabled,
                onChanged: onEnabledChanged,
              ),
              const Gap(8),
              SizedBox(
                width: 28,
                child: Text(
                  day.label.toLowerCase(),
                  style: AppFonts.b1Medium.copyWith(
                    color: day.enabled ? activeLabelColor : inactiveLabelColor,
                  ),
                ),
              ),
              const Spacer(),
              WorkScheduleTimeRangeFields(
                start: day.start,
                end: day.end,
                enabled: day.enabled,
                onPickStart: onPickStart,
                onPickEnd: onPickEnd,
              ),
            ],
          ),
          if (showBreaks &&
              onPickBreakStart != null &&
              onPickBreakEnd != null) ...[
            const Gap(10),
            Row(
              children: [
                Text(
                  'Перерыв',
                  style: AppFonts.c1Regular.copyWith(
                    color: (day.enabled ? activeLabelColor : inactiveLabelColor)
                        .withValues(alpha: 0.7),
                  ),
                ),
                const Spacer(),
                WorkScheduleTimeRangeFields(
                  start: day.breakStart,
                  end: day.breakEnd,
                  enabled: day.enabled,
                  placeholder: true,
                  onPickStart: onPickBreakStart!,
                  onPickEnd: onPickBreakEnd!,
                ),
              ],
            ),
            if (day.enabled && _dayBreakIsSet(day) && onClearBreak != null) ...[
              const Gap(6),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onClearBreak,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'Сбросить перерыв',
                    style: AppFonts.c1Medium.copyWith(
                      color: AppColors.themeAccent(context),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

bool _dayBreakIsSet(SpecialistDayDraft day) {
  final start = day.breakStart?.trim() ?? '';
  final end = day.breakEnd?.trim() ?? '';
  return start.isNotEmpty || end.isNotEmpty;
}

class WorkScheduleTimeRangeFields extends StatelessWidget {
  const WorkScheduleTimeRangeFields({
    super.key,
    required this.start,
    required this.end,
    required this.onPickStart,
    required this.onPickEnd,
    this.enabled = true,
    this.placeholder = false,
  });

  final String? start;
  final String? end;
  final VoidCallback onPickStart;
  final VoidCallback onPickEnd;
  final bool enabled;
  final bool placeholder;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        WorkScheduleTimePill(
          value: start,
          placeholder: placeholder,
          enabled: enabled,
          onTap: enabled ? onPickStart : null,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            '–',
            style: AppFonts.c1Regular.copyWith(
              color: enabled
                  ? (Theme.of(context).brightness == Brightness.dark
                      ? AppColors.primaryWhite
                      : AppColors.primaryDark)
                  : AppColors.tabbarGrey,
            ),
          ),
        ),
        WorkScheduleTimePill(
          value: end,
          placeholder: placeholder,
          enabled: enabled,
          onTap: enabled ? onPickEnd : null,
        ),
      ],
    );
  }
}

class WorkScheduleTimePill extends StatelessWidget {
  const WorkScheduleTimePill({
    super.key,
    required this.value,
    required this.placeholder,
    required this.enabled,
    this.onTap,
  });

  final String? value;
  final bool placeholder;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasValue = value != null && value!.isNotEmpty;
    final fillColor =
        isDark ? AppColors.secondaryDarkLight : AppColors.secondaryLight;
    final textColor = !enabled || !hasValue
        ? AppColors.tabbarGrey.withValues(alpha: 0.5)
        : (isDark ? AppColors.primaryWhite : AppColors.primaryDark);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 58,
        height: 32,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: AppDecoration.borderRadius300,
        ),
        child: Text(
          hasValue ? value! : (placeholder ? '' : '--:--'),
          style: AppFonts.c1Medium.copyWith(
            color: textColor,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
