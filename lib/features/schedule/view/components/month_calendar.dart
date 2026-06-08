import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rient_app/core/painting/diagonal_hatch.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/features/home/data/models/statistics/statistics.dart';

const _weekdayLabels = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'];

const _headerDividerColor = Color(0xFFAEAEB2);
const _headerDividerOpacity = 0.3;

class MonthCalendar extends StatelessWidget {
  const MonthCalendar({
    super.key,
    required this.month,
    this.slotsByDay,
    this.occupancyByDay,
    /// Дни недели (1=пн … 7=вс), когда у мастера есть смена. Если задано —
    /// остальные дни **текущего месяца** визуально помечаются как выходные.
    this.workingWeekdays,
    this.resolveNonWorkingDay,
    this.onDayTap,
  });

  /// Первый день отображаемого месяца (любая дата в месяце).
  final DateTime month;

  /// Количество слотов по дням (день месяца -> число). Если null, плейсхолдер +2/+7.
  final Map<int, int>? slotsByDay;

  /// Заполненность по дням (для отрисовки дуги на кружках).
  final List<OccupancyByDay>? occupancyByDay;

  /// См. [MonthCalendar.workingWeekdays].
  final Set<int>? workingWeekdays;

  /// Ручные выходные и точечные правки графика (приоритет над [workingWeekdays]).
  final bool Function(DateTime date)? resolveNonWorkingDay;

  final ValueChanged<DateTime>? onDayTap;

  static bool _isNonWorkingDay(
    DateTime date,
    bool isCurrentMonth,
    Set<int>? workingWeekdays,
    bool Function(DateTime date)? resolveNonWorkingDay,
  ) {
    if (!isCurrentMonth) return false;
    if (resolveNonWorkingDay != null) return resolveNonWorkingDay(date);
    if (workingWeekdays == null) return false;
    return !workingWeekdays.contains(date.weekday);
  }

  static double _occupancyForDate(
    List<OccupancyByDay> list,
    DateTime date,
  ) {
    final d = DateTime(date.year, date.month, date.day);
    final item = list.firstWhereOrNull(
      (e) =>
          e.date.year == d.year &&
          e.date.month == d.month &&
          e.date.day == d.day,
    );
    return item?.occupancy ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0);
    final daysInMonth = lastDay.day;
    // Понедельник = 1, воскресенье = 7
    final startWeekday = firstDay.weekday;
    final leadingEmpty = startWeekday - 1;
    final totalCells = leadingEmpty + daysInMonth;
    final rows = (totalCells / 7).ceil();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Заголовки дней недели
        Row(
          children: List.generate(
            7,
            (i) => Expanded(
              child: Center(
                child: Text(
                  _weekdayLabels[i],
                  style: AppFonts.c2Tabbar.copyWith(
                    color: isDark
                        ? AppColors.primaryDarkDark
                        : AppColors.primaryDark,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 1,
          color: isDark
              ? AppColors.tabbarGreyDark.withValues(alpha: 0.35)
              : _headerDividerColor
                    .withValues(alpha: _headerDividerOpacity),
        ),
        const SizedBox(height: 12),
        // Сетка дней
        Table(
          defaultColumnWidth: const FlexColumnWidth(1),
          children: [
            for (var row = 0; row < rows; row++)
              TableRow(
                children: List.generate(7, (col) {
                  final index = row * 7 + col;
                  if (index < leadingEmpty) {
                    final date = firstDay.subtract(
                      Duration(days: leadingEmpty - index),
                    );
                    final occupancy = occupancyByDay != null
                        ? _occupancyForDate(occupancyByDay!, date)
                        : 0.0;
                    return _DayCell(
                      date: date,
                      isCurrentMonth: false,
                      isDark: isDark,
                      slots: null,
                      occupancyPercent: occupancy,
                      isNonWorkingDay: MonthCalendar._isNonWorkingDay(
                        date,
                        false,
                        workingWeekdays,
                        resolveNonWorkingDay,
                      ),
                      onTap: onDayTap != null ? () => onDayTap!(date) : null,
                    );
                  }
                  if (index >= leadingEmpty + daysInMonth) {
                    final dayNum = index - leadingEmpty - daysInMonth + 1;
                    final nextMonth = DateTime(month.year, month.month + 1);
                    final date = DateTime(
                      nextMonth.year,
                      nextMonth.month,
                      dayNum,
                    );
                    final occupancy = occupancyByDay != null
                        ? _occupancyForDate(occupancyByDay!, date)
                        : 0.0;
                    return _DayCell(
                      date: date,
                      isCurrentMonth: false,
                      isDark: isDark,
                      slots: null,
                      occupancyPercent: occupancy,
                      isNonWorkingDay: MonthCalendar._isNonWorkingDay(
                        date,
                        false,
                        workingWeekdays,
                        resolveNonWorkingDay,
                      ),
                      onTap: onDayTap != null ? () => onDayTap!(date) : null,
                    );
                  }
                  final dayNum = index - leadingEmpty + 1;
                  final date = DateTime(month.year, month.month, dayNum);
                  final isNonWorkingDay = MonthCalendar._isNonWorkingDay(
                    date,
                    true,
                    workingWeekdays,
                    resolveNonWorkingDay,
                  );
                  /// Только если API вернул день: иначе без подписи (не показываем +0 и не подставляем фиктивные числа).
                  final rawSlots = slotsByDay?[dayNum];
                  final slots = isNonWorkingDay ? null : rawSlots;
                  final showArc = !isNonWorkingDay &&
                      (slotsByDay != null
                          ? slotsByDay!.containsKey(dayNum)
                          : true);
                  final occupancy = !isNonWorkingDay && occupancyByDay != null
                      ? _occupancyForDate(occupancyByDay!, date)
                      : 0.0;
                  return _DayCell(
                    date: date,
                    isCurrentMonth: true,
                    isDark: isDark,
                    slots: slots,
                    showArc: showArc && (slots != null && slots > 0),
                    occupancyPercent: occupancy,
                    isNonWorkingDay: isNonWorkingDay,
                    onTap: onDayTap != null ? () => onDayTap!(date) : null,
                  );
                }),
              ),
          ],
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.isCurrentMonth,
    required this.isDark,
    this.slots,
    this.showArc = false,
    this.occupancyPercent = 0,
    this.isNonWorkingDay = false,
    this.onTap,
  });

  final DateTime date;
  final bool isCurrentMonth;
  final bool isDark;
  final int? slots;
  final bool showArc;
  final double occupancyPercent;
  final bool isNonWorkingDay;
  final VoidCallback? onTap;

  static const _cellSize = 40.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: _cellSize,
              height: _cellSize,
              child: CustomPaint(
                painter: _MonthDayCirclePainter(
                  isCurrentMonth: isCurrentMonth,
                  isDark: isDark,
                  showArc: showArc,
                  occupancyPercent: occupancyPercent,
                  isNonWorkingDay: isNonWorkingDay,
                ),
                child: Center(
                  child: Text(
                    '${date.day}',
                    style: AppFonts.b1Medium.copyWith(
                      color: !isCurrentMonth
                          ? (isDark
                              ? AppColors.tabbarGreyDark
                              : AppColors.tabbarGrey)
                          : (isDark
                              ? AppColors.primaryDarkDark
                              : AppColors.primaryDark),
                    ),
                  ),
                ),
              ),
            ),
            if (isCurrentMonth &&
                !isNonWorkingDay &&
                slots != null &&
                slots! > 0) ...[
              const SizedBox(height: 2),
              Text(
                '+$slots',
                style: AppFonts.c2Tabbar.copyWith(
                  color: isDark
                      ? AppColors.tabbarGreyDark
                      : AppColors.tabbarGrey,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MonthDayCirclePainter extends CustomPainter {
  _MonthDayCirclePainter({
    required this.isCurrentMonth,
    required this.isDark,
    required this.showArc,
    this.occupancyPercent = 0,
    this.isNonWorkingDay = false,
  });

  final bool isCurrentMonth;
  final bool isDark;
  final bool showArc;
  final double occupancyPercent;
  final bool isNonWorkingDay;

  static const _arcStrokeWidth = 2.5;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1;

    final bgPaint = Paint()
      ..color = isDark ? AppColors.primaryWhiteDark : AppColors.primaryWhite
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    // Дуга заполненности (как в полоске дат): обводка по кругу по проценту
    if (isCurrentMonth &&
        !isNonWorkingDay &&
        (showArc || occupancyPercent > 0)) {
      final percent = occupancyPercent.clamp(0.0, 100.0);
      final sweepAngle = (2 * 3.1415926535) * (percent / 100.0);
      const startAngle = -3.1415926535 / 2;

      final arcPaint = Paint()
        ..color =
            AppColors.themeAccentBrightness(
              isDark ? Brightness.dark : Brightness.light,
            )
        ..style = PaintingStyle.stroke
        ..strokeWidth = _arcStrokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 1),
        startAngle,
        sweepAngle,
        false,
        arcPaint,
      );
    }

    // Выходной мастера: параллельные диагонали в круге (как в ячейке недели)
    if (isCurrentMonth && isNonWorkingDay) {
      paintDiagonalStripeHatchInCircle(
        canvas,
        size,
        center,
        radius,
        isDark: isDark,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MonthDayCirclePainter old) =>
      old.isCurrentMonth != isCurrentMonth ||
      old.isDark != isDark ||
      old.showArc != showArc ||
      old.occupancyPercent != occupancyPercent ||
      old.isNonWorkingDay != isNonWorkingDay;
}
