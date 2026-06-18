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
  const AppDateRangePickerResult({
    this.start,
    this.end,
    this.clearFilter = false,
  });

  final DateTime? start;
  final DateTime? end;

  /// Сбросить применённый фильтр по датам.
  final bool clearFilter;

  static const cleared = AppDateRangePickerResult(clearFilter: true);
}

/// Модальное окно выбора периода: календарь с диапазоном, поля дат, подпись.
class AppDateRangePickerDialog extends StatefulWidget {
  const AppDateRangePickerDialog({
    super.key,
    this.initialStart,
    this.initialEnd,
    this.maxDate,
    this.summaryPrefix = 'Будут показаны уведомления за ',
  });

  final DateTime? initialStart;
  final DateTime? initialEnd;

  /// Последняя доступная для выбора дата (включительно).
  final DateTime? maxDate;

  /// Текст перед датами в подписи, например «Будет показана аналитика за ».
  final String summaryPrefix;

  static Future<AppDateRangePickerResult?> show(
    BuildContext context, {
    DateTime? initialStart,
    DateTime? initialEnd,
    DateTime? maxDate,
    String summaryPrefix = 'Будут показаны уведомления за ',
  }) {
    return showDialog<AppDateRangePickerResult>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (context) => AppDateRangePickerDialog(
        initialStart: initialStart,
        initialEnd: initialEnd,
        maxDate: maxDate,
        summaryPrefix: summaryPrefix,
      ),
    );
  }

  static String formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';

  @override
  State<AppDateRangePickerDialog> createState() =>
      _AppDateRangePickerDialogState();
}

class _AppDateRangePickerDialogState extends State<AppDateRangePickerDialog> {
  late DateTime _month;
  DateTime? _start;
  DateTime? _end;

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  DateTime? get _maxDate =>
      widget.maxDate == null ? null : _dateOnly(widget.maxDate!);

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final max = _maxDate;
    _start = widget.initialStart;
    _end = widget.initialEnd;
    if (max != null) {
      if (_start != null && _dateOnly(_start!).isAfter(max)) {
        _start = max;
        _end = null;
      }
      if (_end != null && _dateOnly(_end!).isAfter(max)) {
        _end = max;
      }
    }
    final initial = _start ?? max ?? now;
    var month = DateTime(initial.year, initial.month, 1);
    if (max != null) {
      final maxMonth = DateTime(max.year, max.month, 1);
      if (month.isAfter(maxMonth)) month = maxMonth;
    }
    _month = month;
  }

  void _prevMonth() {
    setState(() => _month = DateTime(_month.year, _month.month - 1, 1));
  }

  bool get _canGoNextMonth {
    final max = _maxDate;
    if (max == null) return true;
    final maxMonth = DateTime(max.year, max.month, 1);
    return _month.isBefore(maxMonth);
  }

  void _nextMonth() {
    if (!_canGoNextMonth) return;
    setState(() => _month = DateTime(_month.year, _month.month + 1, 1));
  }

  void _onDayTap(DateTime date) {
    final normalized = _dateOnly(date);
    final max = _maxDate;
    if (max != null && normalized.isAfter(max)) return;
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
    final primaryText = isDark ? AppColors.primaryWhite : AppColors.primaryDark;
    final secondaryText = isDark
        ? AppColors.tabbarGreyDark
        : AppColors.tabbarGrey;
    final accent = AppColors.themeAccent(context);
    final fieldFill = isDark
        ? AppColors.secondaryDarkLight
        : AppColors.secondaryLight;
    final divider = isDark
        ? AppColors.tabbarGreyDark.withValues(alpha: 0.35)
        : _dividerColor.withValues(alpha: 0.3);
    final range = _orderedRange;
    final startLabel = _start != null
        ? AppDateRangePickerDialog.formatDate(_start!)
        : '—';
    final endLabel = _end != null
        ? AppDateRangePickerDialog.formatDate(_end!)
        : '—';
    final showSummary = _start != null && _end != null;
    final showClearFilter =
        showSummary || widget.initialStart != null || widget.initialEnd != null;

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
              onNext: _canGoNextMonth ? _nextMonth : null,
            ),
            const Gap(12),
            _RangeCalendarGrid(
              month: _month,
              isDark: isDark,
              maxDate: _maxDate,
              rangeStart: range?.$1,
              rangeEnd: range?.$2,
              isSameDay: _isSameDay,
              onDayTap: _onDayTap,
            ),
            const Gap(12),
            Container(height: 1, color: divider),
            const Gap(12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Начальная дата',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppFonts.medium13.copyWith(color: primaryText),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Text(
                    'Конечная дата',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: AppFonts.medium13.copyWith(color: primaryText),
                  ),
                ),
              ],
            ),
            const Gap(6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _DateValueField(
                    value: startLabel,
                    fieldFill: fieldFill,
                    primaryText: primaryText,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '—',
                    style: AppFonts.b2Regular.copyWith(color: secondaryText),
                  ),
                ),
                Expanded(
                  child: _DateValueField(
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
            if (showClearFilter) ...[
              const Gap(8),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.of(
                    context,
                  ).pop(AppDateRangePickerResult.cleared),
                  behavior: HitTestBehavior.opaque,
                  child: Text(
                    'Сбросить фильтр',
                    style: AppFonts.semi14.copyWith(color: accent),
                  ),
                ),
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
                var start = _dateOnly(_start!);
                var end = _dateOnly(_end ?? _start!);
                final max = _maxDate;
                if (max != null) {
                  if (start.isAfter(max)) start = max;
                  if (end.isAfter(max)) end = max;
                }
                Navigator.of(context).pop(
                  AppDateRangePickerResult(start: start, end: end),
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
  final VoidCallback? onNext;

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
        _NavIcon(
          icon: Icons.chevron_right,
          color: onNext == null ? accent.withValues(alpha: 0.35) : accent,
          onTap: onNext,
        ),
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
  final VoidCallback? onTap;

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
    required this.isDark,
    required this.maxDate,
    required this.rangeStart,
    required this.rangeEnd,
    required this.isSameDay,
    required this.onDayTap,
  });

  final DateTime month;
  final bool isDark;
  final DateTime? maxDate;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
  final bool Function(DateTime? a, DateTime b) isSameDay;
  final ValueChanged<DateTime> onDayTap;

  Color get _weekdayLabelColor =>
      isDark ? AppColors.tabbarGreyDark : AppColors.tabbarGrey;

  static DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

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

  bool _isDisabled(DateTime date) {
    if (maxDate == null) return false;
    return _dateOnly(date).isAfter(_dateOnly(maxDate!));
  }

  Color _defaultDayColor(DateTime date, {required bool inRange}) {
    final normalized = _dateOnly(date);
    final today = _dateOnly(DateTime.now());

    if (_isDisabled(date)) {
      return isDark
          ? AppColors.tabbarGreyDark.withValues(alpha: 0.35)
          : AppColors.tabbarGrey.withValues(alpha: 0.45);
    }

    if (inRange) return _rangeSelectedTextColor;

    if (normalized == today) {
      return isDark ? AppColors.mainAccentDark : _rangeSelectedTextColor;
    }
    if (_isWeekend(date) || normalized.isBefore(today)) {
      return isDark ? AppColors.tabbarGreyDark : AppColors.grey;
    }
    return isDark ? AppColors.primaryWhite : AppColors.primaryDark;
  }

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final daysInMonth = lastDay.day;
    final leadingEmpty = firstDay.weekday - 1;
    final totalCells = leadingEmpty + daysInMonth;
    final rows = (totalCells / 7).ceil();
    final hasRangeEnd = rangeEnd != null && !isSameDay(rangeStart, rangeEnd!);

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
                  style: AppFonts.c2Tabbar.copyWith(color: _weekdayLabelColor),
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
                      hasRangeEnd &&
                      rangeEnd != null &&
                      isSameDay(rangeEnd, date);
                  final inRange = _isInRange(date);
                  final inMiddle = inRange && !isStart && !isEnd;
                  final isDisabled = _isDisabled(date);

                  return _RangeDayCell(
                    date: date,
                    isDark: isDark,
                    isDisabled: isDisabled,
                    isRangeStart: isStart,
                    isRangeEnd: isEnd,
                    inRangeMiddle: inMiddle,
                    showRangeBand: inRange && hasRangeEnd,
                    defaultTextColor: _defaultDayColor(date, inRange: inRange),
                    onTap: isDisabled ? null : () => onDayTap(date),
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
    required this.isDark,
    required this.isDisabled,
    required this.isRangeStart,
    required this.isRangeEnd,
    required this.inRangeMiddle,
    required this.showRangeBand,
    required this.defaultTextColor,
    required this.onTap,
  });

  final DateTime date;
  final bool isDark;
  final bool isDisabled;
  final bool isRangeStart;
  final bool isRangeEnd;
  final bool inRangeMiddle;
  final bool showRangeBand;
  final Color defaultTextColor;
  final VoidCallback? onTap;

  static const _circleSize = 38.0;
  static const _bandInset = 2.0;

  Color get _rangeBandColorThemed =>
      isDark ? const Color(0xFF3D4F6E) : _rangeBandColor;

  Color get _rangeEndpointFillThemed =>
      isDark ? AppColors.mainAccentDark : _rangeEndpointFill;

  @override
  Widget build(BuildContext context) {
    final dayText = '${date.day}';
    final isEndpoint = isRangeStart || isRangeEnd;
    final isSingleDay = isRangeStart && !showRangeBand;

    final textColor = isEndpoint || isSingleDay
        ? (isDark ? AppColors.primaryWhite : _rangeSelectedTextColor)
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
                child: ColoredBox(color: _rangeBandColorThemed),
              ),
            if (isRangeStart && showRangeBand)
              Positioned(
                left: _circleSize / 2,
                right: 0,
                top: _bandInset,
                bottom: _bandInset,
                child: ColoredBox(color: _rangeBandColorThemed),
              ),
            if (isRangeEnd)
              Positioned(
                left: 0,
                right: _circleSize / 2,
                top: _bandInset,
                bottom: _bandInset,
                child: ColoredBox(color: _rangeBandColorThemed),
              ),
            if (isEndpoint || isSingleDay)
              Container(
                width: _circleSize,
                height: _circleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _rangeEndpointFillThemed,
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

class _DateValueField extends StatelessWidget {
  const _DateValueField({
    required this.value,
    required this.fieldFill,
    required this.primaryText,
  });

  final String value;
  final Color fieldFill;
  final Color primaryText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: fieldFill,
        borderRadius: AppDecoration.borderRadius300,
      ),
      child: Text(
        value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppFonts.c1Medium.copyWith(color: primaryText),
      ),
    );
  }
}
