import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
const _calendarTodayColor = Color(0xFF0048B5);

/// Диапазон дат для фильтра на вкладке «Сообщения».
class MessagesDateRange {
  const MessagesDateRange({this.start, this.end});

  final DateTime? start;
  final DateTime? end;
}

/// Модальное окно выбора периода (календарь + поля «Начальная / Конечная дата»).
class MessagesDateRangeDialog extends StatefulWidget {
  const MessagesDateRangeDialog({
    super.key,
    this.initialStart,
    this.initialEnd,
  });

  final DateTime? initialStart;
  final DateTime? initialEnd;

  static Future<MessagesDateRange?> show(
    BuildContext context, {
    DateTime? initialStart,
    DateTime? initialEnd,
  }) {
    return showDialog<MessagesDateRange>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      builder: (context) => MessagesDateRangeDialog(
        initialStart: initialStart,
        initialEnd: initialEnd,
      ),
    );
  }

  @override
  State<MessagesDateRangeDialog> createState() =>
      _MessagesDateRangeDialogState();
}

class _MessagesDateRangeDialogState extends State<MessagesDateRangeDialog> {
  late DateTime _month;
  DateTime? _start;
  DateTime? _end;
  late final TextEditingController _startController;
  late final TextEditingController _endController;

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
    _startController = TextEditingController(
      text: _start != null ? '${_start!.day}' : '',
    );
    _endController = TextEditingController(
      text: _end != null ? '${_end!.day}' : '',
    );
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  void _syncFieldsFromSelection() {
    _startController.text = _start != null ? '${_start!.day}' : '';
    _endController.text = _end != null ? '${_end!.day}' : '';
  }

  void _applyDayFromField({required bool isStart}) {
    final raw = (isStart ? _startController : _endController).text.trim();
    final day = int.tryParse(raw);
    if (day == null || day < 1 || day > 31) return;
    final lastDay = DateTime(_month.year, _month.month + 1, 0).day;
    if (day > lastDay) return;
    final date = DateTime(_month.year, _month.month, day);
    setState(() {
      if (isStart) {
        _start = date;
        if (_end != null && _end!.isBefore(_start!)) _end = _start;
      } else {
        _end = date;
        if (_start != null && _start!.isAfter(_end!)) _start = _end;
      }
    });
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
      _syncFieldsFromSelection();
    });
  }

  void _prevMonth() {
    setState(() {
      _month = DateTime(_month.year, _month.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _month = DateTime(_month.year, _month.month + 1, 1);
    });
  }

  bool _isSameDay(DateTime? a, DateTime b) {
    if (a == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
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
            _MessagesCalendarGrid(
              month: _month,
              secondaryText: secondaryText,
              rangeStart: _start,
              rangeEnd: _end,
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
                    controller: _startController,
                    fieldFill: fieldFill,
                    primaryText: primaryText,
                    secondaryText: secondaryText,
                    onSubmitted: () => _applyDayFromField(isStart: true),
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
                    controller: _endController,
                    fieldFill: fieldFill,
                    primaryText: primaryText,
                    secondaryText: secondaryText,
                    onSubmitted: () => _applyDayFromField(isStart: false),
                  ),
                ),
              ],
            ),
            const Gap(16),
            Container(height: 1, color: divider),
            const Gap(16),
            MainButton(
              title: 'Сохранить',
              onTap: () {
                Navigator.of(context).pop(
                  MessagesDateRange(start: _start, end: _end ?? _start),
                );
              },
            ),
          ],
        ),
      ),
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

class _MessagesCalendarGrid extends StatelessWidget {
  const _MessagesCalendarGrid({
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

  Color _dayColor(DateTime date, {required bool isCurrentMonth}) {
    if (!isCurrentMonth) return AppColors.grey.withValues(alpha: 0.5);

    final normalized = _dateOnly(date);
    final today = _dateOnly(DateTime.now());

    if (normalized == today) return _calendarTodayColor;
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
                  final selected = isSameDay(rangeStart, date) ||
                      isSameDay(rangeEnd, date);
                  var textColor = _dayColor(date, isCurrentMonth: true);
                  if (selected) textColor = _calendarTodayColor;
                  return _DayCell(
                    date: date,
                    textColor: textColor,
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
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: SizedBox(height: 28),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.textColor,
    required this.onTap,
  });

  final DateTime date;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Text(
            '${date.day}',
            style: AppFonts.regular20.copyWith(color: textColor),
          ),
        ),
      ),
    );
  }
}

class _DateFieldColumn extends StatelessWidget {
  const _DateFieldColumn({
    required this.label,
    required this.labelColor,
    required this.controller,
    required this.fieldFill,
    required this.primaryText,
    required this.secondaryText,
    required this.onSubmitted,
    this.alignEnd = false,
  });

  final String label;
  final Color labelColor;
  final bool alignEnd;
  final TextEditingController controller;
  final Color fieldFill;
  final Color primaryText;
  final Color secondaryText;
  final VoidCallback onSubmitted;

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
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: AppFonts.c1Medium.copyWith(color: primaryText),
            onSubmitted: (_) => onSubmitted(),
            onEditingComplete: onSubmitted,
            decoration: InputDecoration(
              hintText: 'Напишите число',
              hintStyle: AppFonts.c1Regular.copyWith(color: secondaryText),
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            ),
          ),
        ),
      ],
    );
  }
}
