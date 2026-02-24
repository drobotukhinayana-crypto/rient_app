import 'package:flutter/material.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';

/// Короткие названия дней недели (Пн, Вт, ...).
const _weekdayShort = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'];

/// Полные названия дней недели.
const _weekdayLong = [
  'Понедельник',
  'Вторник',
  'Среда',
  'Четверг',
  'Пятница',
  'Суббота',
  'Воскресенье',
];

/// Названия месяцев в родительном падеже.
const _monthGenitive = [
  'января',
  'февраля',
  'марта',
  'апреля',
  'мая',
  'июня',
  'июля',
  'августа',
  'сентября',
  'октября',
  'ноября',
  'декабря',
];

enum _DayState { pastWithData, selected, future }

class DateStrip extends StatefulWidget {
  const DateStrip({
    super.key,
    this.initialDate,
    this.selectedDate,
    this.daysWithData,
    this.onDateSelected,
    this.showFullDateLabel = true,
    this.useGreyCircles = false,
  });

  /// Начальная выбранная дата (по умолчанию сегодня).
  final DateTime? initialDate;

  /// Текущая выбранная дата. Если передана, используется вместо initialDate.
  final DateTime? selectedDate;

  /// Даты, у которых есть данные (для отображения дуги).
  final Set<DateTime>? daysWithData;

  /// Callback при выборе даты.
  final ValueChanged<DateTime>? onDateSelected;

  /// Показывать подпись с текущей датой (например, «Среда, 4 февраля»). В режиме недели/месяца на расписании передают [false].
  final bool showFullDateLabel;

  /// При true фон невыбранных кружков — SecondaryDark (режим «День»). При false — белый (Неделя/Месяц).
  final bool useGreyCircles;

  @override
  State<DateStrip> createState() => _DateStripState();
}

class _DateStripState extends State<DateStrip> {
  static const _circleSize = 41.0;

  late List<DateTime> _dates;

  @override
  void initState() {
    super.initState();
    _buildDates();
  }

  @override
  void didUpdateWidget(covariant DateStrip oldWidget) {
    if (oldWidget.initialDate != widget.initialDate) _buildDates();
    super.didUpdateWidget(oldWidget);
  }

  void _buildDates() {
    final selected = widget.selectedDate ?? widget.initialDate ?? DateTime.now();
    final weekday = selected.weekday;
    final monday = selected.subtract(Duration(days: weekday - 1));
    _dates = List.generate(7, (i) => monday.add(Duration(days: i)));
  }

  bool _hasData(DateTime d) {
    final normalized = DateTime(d.year, d.month, d.day);
    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);
    if (normalized.isAfter(todayNorm)) return false;
    if (widget.daysWithData != null) {
      return widget.daysWithData!.any(
        (x) =>
            x.year == normalized.year &&
            x.month == normalized.month &&
            x.day == normalized.day,
      );
    }
    // По умолчанию показываем дугу у всех прошедших дней
    return true;
  }

  _DayState _stateFor(DateTime d) {
    final selected = widget.selectedDate ?? widget.initialDate ?? DateTime.now();
    final normalized = DateTime(d.year, d.month, d.day);
    final selectedNorm = DateTime(selected.year, selected.month, selected.day);
    final today = DateTime.now();
    final todayNorm = DateTime(today.year, today.month, today.day);

    if (normalized == selectedNorm) return _DayState.selected;
    if (normalized.isBefore(todayNorm)) return _DayState.pastWithData;
    return _DayState.future;
  }

  String _fullDateText(DateTime d) {
    final w = _weekdayLong[d.weekday - 1];
    final m = _monthGenitive[d.month - 1];
    return '$w, ${d.day} $m';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 72,
          child: Row(
            children: [
              for (var i = 0; i < _dates.length; i++) ...[
                if (i > 0) const SizedBox(width: 4),
                Expanded(
                  child: GestureDetector(
                    onTap: widget.onDateSelected != null
                        ? () => widget.onDateSelected!(_dates[i])
                        : null,
                    child: _DateCircleItem(
                      date: _dates[i],
                      isSelected: _stateFor(_dates[i]) == _DayState.selected,
                      showArc:
                          _stateFor(_dates[i]) == _DayState.pastWithData &&
                          _hasData(_dates[i]),
                      size: _circleSize,
                      useGreyCircles: widget.useGreyCircles,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (widget.showFullDateLabel) ...[
          const SizedBox(height: 8),
          Text(
            _fullDateText(widget.selectedDate ?? widget.initialDate ?? DateTime.now()),
            style: AppFonts.b2Medium.copyWith(color: AppColors.grey),
          ),
        ],
      ],
    );
  }
}

class _DateCircleItem extends StatelessWidget {
  const _DateCircleItem({
    required this.date,
    required this.isSelected,
    required this.showArc,
    required this.size,
    required this.useGreyCircles,
  });

  final DateTime date;
  final bool isSelected;
  final bool showArc;
  final double size;
  final bool useGreyCircles;

  @override
  Widget build(BuildContext context) {
    final weekdayShort = _weekdayShort[date.weekday - 1];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _DateCirclePainter(
              isSelected: isSelected,
              showArc: showArc,
              useGreyCircles: useGreyCircles,
            ),
            child: Center(
              child: Text(
                '${date.day}',
                style: AppFonts.b1Medium.copyWith(
                  color: isSelected
                      ? AppColors.primaryWhite
                      : (showArc ? AppColors.primaryDark : AppColors.grey),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          weekdayShort,
          style: AppFonts.c2Tabbar.copyWith(
            color: isSelected ? AppColors.mainAccent : AppColors.tabbarGrey,
          ),
        ),
      ],
    );
  }
}

class _DateCirclePainter extends CustomPainter {
  _DateCirclePainter({
    required this.isSelected,
    required this.showArc,
    required this.useGreyCircles,
  });

  final bool isSelected;
  final bool showArc;
  final bool useGreyCircles;
  static const _arcStrokeWidth = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1;

    final unselectedColor = useGreyCircles
        ? AppColors.secondaryDark
        : AppColors.primaryWhite;
    final bgPaint = Paint()
      ..color = isSelected ? AppColors.mainAccent : unselectedColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    if (isSelected) {
      // Обводка выбранного дня — SecondaryAccent
      final outlinePaint = Paint()
        ..color = AppColors.secondaryAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = _arcStrokeWidth;
      canvas.drawCircle(center, radius - 1, outlinePaint);
    }

    if (!isSelected && showArc) {
      // Дуга внизу круга (7–5 ч) — есть данные
      final arcPaint = Paint()
        ..color = AppColors.mainAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = _arcStrokeWidth
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 1),
        1.15 * 3.14159, // ~7 ч
        1.0 * 3.14159, // до ~5 ч
        false,
        arcPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DateCirclePainter oldDelegate) {
    return oldDelegate.isSelected != isSelected ||
        oldDelegate.showArc != showArc ||
        oldDelegate.useGreyCircles != useGreyCircles;
  }
}
