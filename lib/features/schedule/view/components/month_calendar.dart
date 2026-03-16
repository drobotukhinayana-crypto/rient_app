import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
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
    this.onDayTap,
  });

  /// Первый день отображаемого месяца (любая дата в месяце).
  final DateTime month;

  /// Количество слотов по дням (день месяца -> число). Если null, плейсхолдер +2/+7.
  final Map<int, int>? slotsByDay;

  /// Заполненность по дням (для отрисовки дуги на кружках).
  final List<OccupancyByDay>? occupancyByDay;

  final ValueChanged<DateTime>? onDayTap;

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
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 1,
          color: _headerDividerColor.withOpacity(_headerDividerOpacity),
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
                      slots: null,
                      occupancyPercent: occupancy,
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
                      slots: null,
                      occupancyPercent: occupancy,
                      onTap: onDayTap != null ? () => onDayTap!(date) : null,
                    );
                  }
                  final dayNum = index - leadingEmpty + 1;
                  final date = DateTime(month.year, month.month, dayNum);
                  final slots =
                      slotsByDay?[dayNum] ?? (dayNum % 3 == 0 ? 2 : 7);
                  final showArc = slotsByDay != null
                      ? slotsByDay!.containsKey(dayNum)
                      : true;
                  final occupancy = occupancyByDay != null
                      ? _occupancyForDate(occupancyByDay!, date)
                      : 0.0;
                  return _DayCell(
                    date: date,
                    isCurrentMonth: true,
                    slots: slots,
                    showArc: showArc && slots > 0,
                    occupancyPercent: occupancy,
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
    this.slots,
    this.showArc = false,
    this.occupancyPercent = 0,
    this.onTap,
  });

  final DateTime date;
  final bool isCurrentMonth;
  final int? slots;
  final bool showArc;
  final double occupancyPercent;
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
                  showArc: showArc,
                  occupancyPercent: occupancyPercent,
                ),
                child: Center(
                  child: Text(
                    '${date.day}',
                    style: AppFonts.b1Medium.copyWith(
                      color: isCurrentMonth
                          ? AppColors.primaryDark
                          : AppColors.tabbarGrey,
                    ),
                  ),
                ),
              ),
            ),
            if (isCurrentMonth && slots != null && slots! > 0) ...[
              const SizedBox(height: 2),
              Text(
                '+$slots',
                style: AppFonts.c2Tabbar.copyWith(color: AppColors.tabbarGrey),
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
    required this.showArc,
    this.occupancyPercent = 0,
  });

  final bool isCurrentMonth;
  final bool showArc;
  final double occupancyPercent;

  static const _arcStrokeWidth = 2.5;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1;

    final bgPaint = Paint()
      ..color = AppColors.primaryWhite
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    // Дуга заполненности (как в полоске дат): обводка по кругу по проценту
    if (isCurrentMonth && (showArc || occupancyPercent > 0)) {
      final percent = occupancyPercent.clamp(0.0, 100.0);
      final sweepAngle = (2 * 3.1415926535) * (percent / 100.0);
      const startAngle = -3.1415926535 / 2;

      final arcPaint = Paint()
        ..color = AppColors.mainAccent
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
  }

  @override
  bool shouldRepaint(covariant _MonthDayCirclePainter old) =>
      old.isCurrentMonth != isCurrentMonth ||
      old.showArc != showArc ||
      old.occupancyPercent != occupancyPercent;
}
