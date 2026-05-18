import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/change_time_picker_dialog.dart';
import 'package:rient_app/core/widgets/custom_switch_widget.dart';
import 'package:rient_app/core/widgets/default_container.dart';
import 'package:rient_app/core/widgets/main_button.dart';

class SpecialistSchedulePageArgs {
  const SpecialistSchedulePageArgs({
    required this.employeeId,
    required this.employeeName,
    this.pictureUrl,
  });

  final String employeeId;
  final String employeeName;
  final String? pictureUrl;
}

class SpecialistSchedulePage extends StatefulWidget {
  const SpecialistSchedulePage({super.key, required this.args});

  final SpecialistSchedulePageArgs args;

  static const name = 'specialist_schedule_page';
  static const path = 'specialist_schedule';

  @override
  State<SpecialistSchedulePage> createState() => _SpecialistSchedulePageState();
}

class _SpecialistSchedulePageState extends State<SpecialistSchedulePage> {
  static const _scheduleTypes = ['Неделя', 'Месяц'];
  static const _defaultGroupStart = '09:00';
  static const _defaultGroupEnd = '20:00';

  String _scheduleType = _scheduleTypes.first;
  bool _weekdaysExpanded = true;
  bool _weekendsExpanded = true;

  late String _weekdayGroupStart;
  late String _weekdayGroupEnd;
  late List<_DayScheduleDraft> _weekdays;

  late String _weekendGroupStart;
  late String _weekendGroupEnd;
  late List<_DayScheduleDraft> _weekends;

  @override
  void initState() {
    super.initState();
    _weekdayGroupStart = _defaultGroupStart;
    _weekdayGroupEnd = _defaultGroupEnd;
    _weekdays = _defaultDays(const ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ']);
    _weekendGroupStart = _defaultGroupStart;
    _weekendGroupEnd = _defaultGroupEnd;
    _weekends = _defaultDays(const ['СБ', 'ВС']);
  }

  List<_DayScheduleDraft> _defaultDays(List<String> labels) => [
        for (final label in labels)
          _DayScheduleDraft(
            label: label,
            enabled: true,
            start: _defaultGroupStart,
            end: _defaultGroupEnd,
          ),
      ];

  void _applyGroupTimesToWeekdays() {
    setState(() {
      _weekdays = _weekdays
          .map(
            (d) => d.copyWith(
              start: _weekdayGroupStart,
              end: _weekdayGroupEnd,
            ),
          )
          .toList();
    });
  }

  void _applyGroupTimesToWeekends() {
    setState(() {
      _weekends = _weekends
          .map(
            (d) => d.copyWith(
              start: _weekendGroupStart,
              end: _weekendGroupEnd,
            ),
          )
          .toList();
    });
  }

  Widget _buildDaySection({
    required String groupTitle,
    required bool expanded,
    required String groupStart,
    required String groupEnd,
    required List<_DayScheduleDraft> days,
    required VoidCallback onToggleExpanded,
    required VoidCallback onPickGroupStart,
    required VoidCallback onPickGroupEnd,
    required void Function(int index, _DayScheduleDraft day) onDayChanged,
  }) {
    return _ScheduleDaysSection(
      groupTitle: groupTitle,
      expanded: expanded,
      groupStart: groupStart,
      groupEnd: groupEnd,
      days: days,
      onToggleExpanded: onToggleExpanded,
      onPickGroupStart: onPickGroupStart,
      onPickGroupEnd: onPickGroupEnd,
      onDayEnabledChanged: (index, enabled) {
        onDayChanged(index, days[index].copyWith(enabled: enabled));
      },
      onPickDayStart: (index) => _pickTime(
        days[index].start,
        (v) => onDayChanged(index, days[index].copyWith(start: v)),
      ),
      onPickDayEnd: (index) => _pickTime(
        days[index].end,
        (v) => onDayChanged(index, days[index].copyWith(end: v)),
      ),
      onPickBreakStart: (index) {
        final current = days[index].breakStart ?? '13:00';
        _pickTime(current, (v) {
          onDayChanged(index, days[index].copyWith(breakStart: v));
        });
      },
      onPickBreakEnd: (index) {
        final current = days[index].breakEnd ?? '14:00';
        _pickTime(current, (v) {
          onDayChanged(index, days[index].copyWith(breakEnd: v));
        });
      },
    );
  }

  Future<void> _pickTime(String current, ValueChanged<String> onPicked) async {
    final picked = await showChangeTimePicker(
      context,
      initialTime: current,
    );
    if (picked == null || !mounted) return;
    onPicked(picked);
  }

  void _onSave() {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenBackground = isDark
        ? AppColors.secondaryDarkLight
        : AppColors.tabBarScreenBackground;
    final accent = AppColors.themeAccent(context);

    return Scaffold(
      backgroundColor: screenBackground,
      body: Column(
        children: [
          _SpecialistScheduleHeader(
            onBack: () => context.pop(),
            onMore: () {},
          ),
          Expanded(
            child: ListView(
              padding: AppDecoration.padding16.copyWith(top: 12, bottom: 16),
              children: [
                _ScheduleTypeRow(
                  value: _scheduleType,
                  options: _scheduleTypes,
                  onChanged: (value) => setState(() => _scheduleType = value),
                ),
                const Gap(12),
                _buildDaySection(
                  groupTitle: 'ПН–ПТ',
                  expanded: _weekdaysExpanded,
                  groupStart: _weekdayGroupStart,
                  groupEnd: _weekdayGroupEnd,
                  days: _weekdays,
                  onToggleExpanded: () {
                    setState(() => _weekdaysExpanded = !_weekdaysExpanded);
                  },
                  onPickGroupStart: () => _pickTime(_weekdayGroupStart, (v) {
                    setState(() => _weekdayGroupStart = v);
                    _applyGroupTimesToWeekdays();
                  }),
                  onPickGroupEnd: () => _pickTime(_weekdayGroupEnd, (v) {
                    setState(() => _weekdayGroupEnd = v);
                    _applyGroupTimesToWeekdays();
                  }),
                  onDayChanged: (index, day) {
                    setState(() => _weekdays[index] = day);
                  },
                ),
                const Gap(12),
                _buildDaySection(
                  groupTitle: 'СБ–ВС',
                  expanded: _weekendsExpanded,
                  groupStart: _weekendGroupStart,
                  groupEnd: _weekendGroupEnd,
                  days: _weekends,
                  onToggleExpanded: () {
                    setState(() => _weekendsExpanded = !_weekendsExpanded);
                  },
                  onPickGroupStart: () => _pickTime(_weekendGroupStart, (v) {
                    setState(() => _weekendGroupStart = v);
                    _applyGroupTimesToWeekends();
                  }),
                  onPickGroupEnd: () => _pickTime(_weekendGroupEnd, (v) {
                    setState(() => _weekendGroupEnd = v);
                    _applyGroupTimesToWeekends();
                  }),
                  onDayChanged: (index, day) {
                    setState(() => _weekends[index] = day);
                  },
                ),
              ],
            ),
          ),
          Container(
            color: isDark ? AppColors.primaryWhiteDark : Colors.white,
            padding: EdgeInsets.fromLTRB(
              16,
              12,
              16,
              12 + MediaQuery.paddingOf(context).bottom,
            ),
            child: Row(
              children: [
                Expanded(
                  child: MainButton(
                    title: 'Отменить',
                    color: isDark
                        ? AppColors.secondaryDarkLight
                        : AppColors.secondaryLight,
                    textColor: accent,
                    onTap: () => context.pop(),
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: MainButton(
                    title: 'Сохранить',
                    onTap: _onSave,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DayScheduleDraft {
  const _DayScheduleDraft({
    required this.label,
    required this.enabled,
    this.start = '09:00',
    this.end = '20:00',
    this.breakStart,
    this.breakEnd,
  });

  final String label;
  final bool enabled;
  final String start;
  final String end;
  final String? breakStart;
  final String? breakEnd;

  _DayScheduleDraft copyWith({
    bool? enabled,
    String? start,
    String? end,
    String? breakStart,
    String? breakEnd,
  }) {
    return _DayScheduleDraft(
      label: label,
      enabled: enabled ?? this.enabled,
      start: start ?? this.start,
      end: end ?? this.end,
      breakStart: breakStart ?? this.breakStart,
      breakEnd: breakEnd ?? this.breakEnd,
    );
  }
}

class _SpecialistScheduleHeader extends StatelessWidget {
  const _SpecialistScheduleHeader({
    required this.onBack,
    required this.onMore,
  });

  final VoidCallback onBack;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? AppColors.primaryWhite : AppColors.primaryDark;
    final circleColor = isDark
        ? AppColors.secondaryDarkLight
        : AppColors.secondaryLight;

    return DefaultContainerWidget(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(24),
        bottomRight: Radius.circular(24),
      ),
      hasShadow: false,
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top + 8,
        bottom: 12,
        left: 16,
        right: 16,
      ),
      color: isDark ? AppColors.primaryWhiteDark : Colors.white,
      child: Row(
        children: [
          _HeaderIconButton(
            color: circleColor,
            onTap: onBack,
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: iconColor,
            ),
          ),
          const Gap(12),
          Expanded(
            child: Text(
              'График специалиста',
              style: AppFonts.h3Medium.copyWith(
                color: isDark ? AppColors.primaryWhite : AppColors.primaryDark,
              ),
            ),
          ),
          _HeaderIconButton(
            color: circleColor,
            onTap: onMore,
            child: Icon(
              Icons.more_horiz_rounded,
              size: 22,
              color: AppColors.themeAccent(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.color,
    required this.onTap,
    required this.child,
  });

  final Color color;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

class _ScheduleTypeRow extends StatelessWidget {
  const _ScheduleTypeRow({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.primaryWhite : AppColors.primaryDark;

    return Row(
      children: [
        Text(
          'Тип расписания',
          style: AppFonts.b1Medium.copyWith(color: textColor),
        ),
        const Spacer(),
        _ScheduleTypeDropdown(
          value: value,
          options: options,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _ScheduleTypeDropdown extends StatelessWidget {
  const _ScheduleTypeDropdown({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = AppColors.themeAccent(context);

    return PopupMenuButton<String>(
      onSelected: onChanged,
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: (context) => options
          .map(
            (option) => PopupMenuItem<String>(
              value: option,
              child: Text(option, style: AppFonts.c1Regular),
            ),
          )
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColors.secondaryDarkLight : AppColors.secondaryLight,
          borderRadius: AppDecoration.borderRadius300,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: AppFonts.c1Medium.copyWith(color: accent),
            ),
            const Gap(4),
            Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: accent),
          ],
        ),
      ),
    );
  }
}

class _ScheduleDaysSection extends StatelessWidget {
  const _ScheduleDaysSection({
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
    required this.onPickBreakStart,
    required this.onPickBreakEnd,
  });

  final String groupTitle;
  final bool expanded;
  final String groupStart;
  final String groupEnd;
  final List<_DayScheduleDraft> days;
  final VoidCallback onToggleExpanded;
  final VoidCallback onPickGroupStart;
  final VoidCallback onPickGroupEnd;
  final void Function(int index, bool enabled) onDayEnabledChanged;
  final void Function(int index) onPickDayStart;
  final void Function(int index) onPickDayEnd;
  final void Function(int index) onPickBreakStart;
  final void Function(int index) onPickBreakEnd;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? AppColors.primaryWhiteDark : Colors.white;
    final dividerColor =
        isDark ? AppColors.secondaryDarkDark : AppColors.secondaryDark;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                _TimeRangeFields(
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
              _DayScheduleContent(
                day: days[i],
                onEnabledChanged: (enabled) =>
                    onDayEnabledChanged(i, enabled),
                onPickStart: () => onPickDayStart(i),
                onPickEnd: () => onPickDayEnd(i),
                onPickBreakStart: () => onPickBreakStart(i),
                onPickBreakEnd: () => onPickBreakEnd(i),
              ),
            ],
        ],
      ),
    );
  }
}

class _DayScheduleContent extends StatelessWidget {
  const _DayScheduleContent({
    required this.day,
    required this.onEnabledChanged,
    required this.onPickStart,
    required this.onPickEnd,
    required this.onPickBreakStart,
    required this.onPickBreakEnd,
  });

  final _DayScheduleDraft day;
  final ValueChanged<bool> onEnabledChanged;
  final VoidCallback onPickStart;
  final VoidCallback onPickEnd;
  final VoidCallback onPickBreakStart;
  final VoidCallback onPickBreakEnd;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeLabelColor =
        isDark ? AppColors.primaryWhite : AppColors.primaryDark;
    final inactiveLabelColor = AppColors.tabbarGrey;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
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
              _TimeRangeFields(
                start: day.start,
                end: day.end,
                enabled: day.enabled,
                onPickStart: onPickStart,
                onPickEnd: onPickEnd,
              ),
            ],
          ),
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
              _TimeRangeFields(
                start: day.breakStart,
                end: day.breakEnd,
                enabled: day.enabled,
                placeholder: true,
                onPickStart: onPickBreakStart,
                onPickEnd: onPickBreakEnd,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimeRangeFields extends StatelessWidget {
  const _TimeRangeFields({
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
        _TimePill(
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
              color: AppColors.tabbarGrey,
            ),
          ),
        ),
        _TimePill(
          value: end,
          placeholder: placeholder,
          enabled: enabled,
          onTap: enabled ? onPickEnd : null,
        ),
      ],
    );
  }
}

class _TimePill extends StatelessWidget {
  const _TimePill({
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
    final fillColor = !enabled
        ? (isDark ? AppColors.forthLightDark : AppColors.forthLight)
        : (isDark ? AppColors.secondaryDarkLight : AppColors.secondaryLight);

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
            color: hasValue
                ? (isDark ? AppColors.primaryWhite : AppColors.primaryDark)
                : AppColors.tabbarGrey.withValues(alpha: 0.5),
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
