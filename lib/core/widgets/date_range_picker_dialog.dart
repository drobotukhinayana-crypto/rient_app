import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/main_button.dart';

const _weekdayLabels = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'];

const _monthNominative = [
  'Январь',
  'Февраль',
  'Март',
  'Апрель',
  'Май',
  'Июнь',
  'Июль',
  'Август',
  'Сентябрь',
  'Октябрь',
  'Ноябрь',
  'Декабрь',
];

const _dividerColor = Color(0xFFAEAEB2);
const _rangeSelectedTextColor = Color(0xFF0048B5);
const _rangeEndpointFill = Color(0xFF9EC0F5);
const _rangeBandColor = Color(0xFFE8F1FD);

/// Выбранный период дат.
class AppDateRangePickerResult {
  const AppDateRangePickerResult({this.start, this.end});

  final DateTime? start;
  final DateTime? end;
}

/// Модальное окно выбора периода: календарь с диапазоном, поля дат, подпись.
class AppDateRangePickerDialog extends StatefulWidget {
  const AppDateRangePickerDialog({
    super.key,
    this.initialStart,
    this.initialEnd,
    this.summaryPrefix = 'Будут показаны уведомления за ',
  });

  final DateTime? initialStart;
  final DateTime? initialEnd;

  /// Текст перед датами в подписи, например «Будет показана аналитика за ».
  final String summaryPrefix;

  static Future<AppDateRangePickerResult?> show(
    BuildContext context, {
    DateTime? initialStart,
    DateTime? initialEnd,
    String summaryPrefix = 'Будут показаны уведомления за ',
  }) {
    return showDialog<AppDateRangePickerResult>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (context) => AppDateRangePickerDialog(
        initialStart: initialStart,
        initialEnd: initialEnd,
        summaryPrefix: summaryPrefix,
      ),
    );
  }

  static String formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';

  @override
  State<AppDateRangePickerDialog> createState() => _AppDateRangePickerDialogState();
}

class _AppDateRangePickerDialogState extends State<AppDateRangePickerDialog> {
  late DateTime _month;
  DateTime? _start;
  DateTime? _end;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _start = widget.initialStart;
    _end = widget.initialEnd;
    _month = DateTime(
      (_start ?? now).year,
      (_start ?? now).month,
      1,
    );
  }

  void _prevMonth() {
    setState(() => _month = DateTime(_month.year, _month.month - 1, 1));
  }

  void _nextMonth() {
    setState(() => _month = DateTime(_month.year, _month.month + 1, 1));
  }

  void _onDayTap(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    setState(() {
      if (_start == null || (_start != null && _end != null)) {
        _start = normalized;
        _end = null;
      } else if (_end == null) {
        if (normalized.isBefore(_start!)) {
          _end = _start;
          _start = normalized;
        } else {
          _end = normalized;
        }
      }
    });
  }

  bool _isSameDay(DateTime? a, DateTime b) {
    if (a == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  (DateTime start, DateTime end)? get _orderedRange {
    if (_start == null) return null;
    final end = _end ?? _start!;
    return _start!.isBefore(end) || _isSameDay(_start, end)
        ? (_start!, end)
        : (end, _start!);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.primaryWhiteDark : Colors.white;
    final primaryText =
        isDark ? AppColors.primaryWhite : AppColors.primaryDark;
    final secondaryText = AppColors.tabbarGrey;
    final accent = AppColors.themeAccent(context);
    final fieldFill =
        isDark ? AppColors.secondaryDarkLight : AppColors.secondaryLight;
    final divider = isDark
        ? AppColors.tabbarGreyDark.withValues(alpha: 0.35)
        : _dividerColor.withValues(alpha: 0.3);
    final range = _orderedRange;
    final startLabel =
        _start != null ? AppDateRangePickerDialog.formatDate(_start!) : '—';
    final endLabel =
        _end != null ? AppDateRangePickerDialog.formatDate(_end!) : '—';
    final showSummary = _start != null && _end != null;

    return Dialog(
      backgroundColor: surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _CalendarHeader(
              month: _month,
              accent: accent,
              primaryText: primaryText,
              onPrevious: _prevMonth,
              onNext: _nextMonth,
            ),
            const Gap(12),
            _RangeCalendarGrid(
              month: _month,
              secondaryText: secondaryText,
              rangeStart: range?.$1,
              rangeEnd: range?.$2,
              isSameDay: _isSameDay,
              onDayTap: _onDayTap,
            ),
            const Gap(12),
            Container(height: 1, color: divider),
            const Gap(12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _DateFieldColumn(
                    label: 'Начальная дата',
                    labelColor: primaryText,
                    value: startLabel,
                    fieldFill: fieldFill,
                    primaryText: primaryText,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 28, left: 8, right: 8),
                  child: Text(
                    '—',
                    style: AppFonts.b2Regular.copyWith(color: secondaryText),
                  ),
                ),
                Expanded(
                  child: _DateFieldColumn(
                    label: 'Конечная дата',
                    labelColor: primaryText,
                    alignEnd: true,
                    value: endLabel,
                    fieldFill: fieldFill,
                    primaryText: primaryText,
                  ),
                ),
              ],
            ),
            if (showSummary) ...[
              const Gap(16),
              _RangeSummaryText(
                prefix: widget.summaryPrefix,
                start: _start!,
                end: _end!,
                isDark: isDark,
              ),
            ],
            const Gap(16),
            Container(height: 1, color: divider),
            const Gap(16),
            MainButton(
              title: 'Сохранить',
              isActive: _start != null,
              onTap: () {
                if (_start == null) return;
                Navigator.of(context).pop(
                  AppDateRangePickerResult(
                    start: _start,
                    end: _end ?? _start,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RangeSummaryText extends StatelessWidget {
  const _RangeSummaryText({
    required this.prefix,
    required this.start,
    required this.end,
    required this.isDark,
  });

  final String prefix;
  final DateTime start;
  final DateTime end;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final rangeText =
        '${AppDateRangePickerDialog.formatDate(start)} - ${AppDateRangePickerDialog.formatDate(end)}';
    final color = isDark ? AppColors.tabbarGreyDark : AppColors.tabbarGrey;

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: prefix,
            style: AppFonts.semi14.copyWith(color: color),
          ),
          TextSpan(
            text: rangeText,
            style: AppFonts.bold14.copyWith(color: color),
          ),
        ],
      ),
      textAlign: TextAlign.left,
    );
  }
}

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({
    required this.month,
    required this.accent,
    required this.primaryText,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime month;
  final Color accent;
  final Color primaryText;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${_monthNominative[month.month - 1]} ${month.year}',
              style: AppFonts.b1Semi.copyWith(color: primaryText),
            ),
            const Gap(4),
            Icon(Icons.chevron_right, size: 20, color: accent),
          ],
        ),
        const Spacer(),
        _NavIcon(icon: Icons.chevron_left, color: accent, onTap: onPrevious),
        const Gap(4),
        _NavIcon(icon: Icons.chevron_right, color: accent, onTap: onNext),
      ],
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: 22, color: color),
      ),
    );
  }
}

class _RangeCalendarGrid extends StatelessWidget {
  const _RangeCalendarGrid({
    required this.month,
    required this.secondaryText,
    required this.rangeStart,
    required this.rangeEnd,
    required this.isSameDay,
    required this.onDayTap,
  });

  final DateTime month;
  final Color secondaryText;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
  final bool Function(DateTime? a, DateTime b) isSameDay;
  final ValueChanged<DateTime> onDayTap;

  static DateTime _dateOnly(DateTime d) =>
      DateTime(d.year, d.month, d.day);

  static bool _isWeekend(DateTime d) =>
      d.weekday == DateTime.saturday || d.weekday == DateTime.sunday;

  bool _isInRange(DateTime date) {
    if (rangeStart == null) return false;
    final end = rangeEnd ?? rangeStart!;
    final start = rangeStart!.isBefore(end) ? rangeStart! : end;
    final last = rangeStart!.isBefore(end) ? end : rangeStart!;
    final d = _dateOnly(date);
    return !d.isBefore(_dateOnly(start)) && !d.isAfter(_dateOnly(last));
  }

  Color _defaultDayColor(DateTime date) {
    final normalized = _dateOnly(date);
    final today = _dateOnly(DateTime.now());

    if (normalized == today) return _rangeSelectedTextColor;
    if (_isWeekend(date) || normalized.isBefore(today)) {
      return AppColors.grey;
    }
    return AppColors.primaryDark;
  }

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final daysInMonth = lastDay.day;
    final leadingEmpty = firstDay.weekday - 1;
    final totalCells = leadingEmpty + daysInMonth;
    final rows = (totalCells / 7).ceil();
    final hasRangeEnd =
        rangeEnd != null && !isSameDay(rangeStart, rangeEnd!);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: List.generate(
            7,
            (i) => Expanded(
              child: Center(
                child: Text(
                  _weekdayLabels[i],
                  style: AppFonts.c2Tabbar.copyWith(color: secondaryText),
                ),
              ),
            ),
          ),
        ),
        const Gap(8),
        Table(
          defaultColumnWidth: const FlexColumnWidth(1),
          children: [
            for (var row = 0; row < rows; row++)
              TableRow(
                children: List.generate(7, (col) {
                  final index = row * 7 + col;
                  if (index < leadingEmpty ||
                      index >= leadingEmpty + daysInMonth) {
                    return const _EmptyDayCell();
                  }
                  final dayNum = index - leadingEmpty + 1;
                  final date = DateTime(month.year, month.month, dayNum);
                  final isStart = isSameDay(rangeStart, date);
                  final isEnd =
                      hasRangeEnd && rangeEnd != null && isSameDay(rangeEnd, date);
                  final inRange = _isInRange(date);
                  final inMiddle = inRange && !isStart && !isEnd;

                  return _RangeDayCell(
                    date: date,
                    isRangeStart: isStart,
                    isRangeEnd: isEnd,
                    inRangeMiddle: inMiddle,
                    showRangeBand: inRange && hasRangeEnd,
                    defaultTextColor: _defaultDayColor(date),
                    onTap: () => onDayTap(date),
                  );
                }),
              ),
          ],
        ),
      ],
    );
  }
}

class _EmptyDayCell extends StatelessWidget {
  const _EmptyDayCell();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 40);
  }
}

class _RangeDayCell extends StatelessWidget {
  const _RangeDayCell({
    required this.date,
    required this.isRangeStart,
    required this.isRangeEnd,
    required this.inRangeMiddle,
    required this.showRangeBand,
    required this.defaultTextColor,
    required this.onTap,
  });

  final DateTime date;
  final bool isRangeStart;
  final bool isRangeEnd;
  final bool inRangeMiddle;
  final bool showRangeBand;
  final Color defaultTextColor;
  final VoidCallback onTap;

  static const _circleSize = 38.0;
  static const _bandInset = 2.0;

  @override
  Widget build(BuildContext context) {
    final dayText = '${date.day}';
    final isEndpoint = isRangeStart || isRangeEnd;
    final isSingleDay = isRangeStart && !showRangeBand;

    final textColor = isEndpoint || isSingleDay
        ? _rangeSelectedTextColor
        : defaultTextColor;

    return SizedBox(
      height: 40,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            if (inRangeMiddle)
              Positioned(
                left: 0,
                right: 0,
                top: _bandInset,
                bottom: _bandInset,
                child: const ColoredBox(color: _rangeBandColor),
              ),
            if (isRangeStart && showRangeBand)
              Positioned(
                left: _circleSize / 2,
                right: 0,
                top: _bandInset,
                bottom: _bandInset,
                child: const ColoredBox(color: _rangeBandColor),
              ),
            if (isRangeEnd)
              Positioned(
                left: 0,
                right: _circleSize / 2,
                top: _bandInset,
                bottom: _bandInset,
                child: const ColoredBox(color: _rangeBandColor),
              ),
            if (isEndpoint || isSingleDay)
              Container(
                width: _circleSize,
                height: _circleSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: _rangeEndpointFill,
                ),
                alignment: Alignment.center,
                child: Text(
                  dayText,
                  style: AppFonts.medium20.copyWith(color: textColor),
                ),
              )
            else
              Text(
                dayText,
                style: AppFonts.regular20.copyWith(color: textColor),
              ),
          ],
        ),
      ),
    );
  }
}

class _DateFieldColumn extends StatelessWidget {
  const _DateFieldColumn({
    required this.label,
    required this.labelColor,
    required this.value,
    required this.fieldFill,
    required this.primaryText,
    this.alignEnd = false,
  });

  final String label;
  final Color labelColor;
  final bool alignEnd;
  final String value;
  final Color fieldFill;
  final Color primaryText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment:
              alignEnd ? Alignment.centerRight : Alignment.centerLeft,
          child: Text(
            label,
            style: AppFonts.medium15.copyWith(color: labelColor),
          ),
        ),
        const Gap(6),
        Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: fieldFill,
            borderRadius: AppDecoration.borderRadius300,
          ),
          child: Text(
            value,
            style: AppFonts.c1Medium.copyWith(color: primaryText),
          ),
        ),
      ],
    );
  }
}
