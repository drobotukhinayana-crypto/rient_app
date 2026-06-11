import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:rient_app/core/painting/diagonal_hatch.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/features/home/data/models/statistics/statistics.dart';
import 'package:rient_app/features/schedule/utils/worker_work_day.dart';

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
    this.occupancyByDay,
    this.initialDate,
    this.selectedDate,
    this.visibleWeekStart,
    this.daysWithData,
    this.onDateSelected,
    this.showFullDateLabel = true,
    this.useGreyCircles = false,
    this.useMonthCalendarCircleFill = false,
    /// Дни недели (1=пн … 7=вс), когда у мастера смена; иначе кружок штрихуется.
    this.workingWeekdays,
    this.resolveNonWorkingDay,
    /// График работы: все дни #ECEEF2, невыбранные — светлый текст, выбранный — тёмный.
    this.workScheduleWeekDates = false,
    /// Отступ слева, чтобы дни совпали с колонками сетки (колонка сотрудников).
    this.leadingInset = 0,
  });

  /// Начальная выбранная дата (по умолчанию сегодня).
  final DateTime? initialDate;

  /// Текущая выбранная дата. Если передана, используется вместо initialDate.
  final DateTime? selectedDate;

  /// Понедельник видимой недели (режим «Неделя» в расписании). Если задан,
  /// семь кружков всегда соответствуют этой неделе, а [selectedDate] только
  /// подсвечивает день; иначе неделя строится вокруг [selectedDate]/[initialDate].
  final DateTime? visibleWeekStart;

  /// Даты, у которых есть данные (для отображения дуги).
  final Set<DateTime>? daysWithData;

  /// Callback при выборе даты.
  final ValueChanged<DateTime>? onDateSelected;

  /// Показывать подпись с текущей датой (например, «Среда, 4 февраля»). В режиме недели/месяца на расписании передают [false].
  final bool showFullDateLabel;

  /// При true фон невыбранных кружков — SecondaryDark (режим «День»). При false — белый (Неделя/Месяц).
  final bool useGreyCircles;

  /// Заливка невыбранных кружков как в месячном календаре: светлая — [AppColors.primaryWhite], тёмная — [AppColors.primaryWhiteDark].
  final bool useMonthCalendarCircleFill;
  final List<OccupancyByDay>? occupancyByDay;

  /// См. [DateStrip.workingWeekdays].
  final Set<int>? workingWeekdays;

  /// Точечные выходные (ручные дни в графике). Если задано — имеет приоритет над [workingWeekdays].
  final bool Function(DateTime date)? resolveNonWorkingDay;

  final bool workScheduleWeekDates;

  final double leadingInset;

  static const _workScheduleCircleFill = Color(0xFFECEEF2);

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
    if (oldWidget.initialDate != widget.initialDate ||
        oldWidget.selectedDate != widget.selectedDate ||
        oldWidget.visibleWeekStart != widget.visibleWeekStart ||
        oldWidget.workingWeekdays != widget.workingWeekdays ||
        oldWidget.resolveNonWorkingDay != widget.resolveNonWorkingDay) {
      _buildDates();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _buildDates() {
    final DateTime anchor;
    if (widget.visibleWeekStart != null) {
      final d = widget.visibleWeekStart!;
      anchor = DateTime(d.year, d.month, d.day);
    } else {
      final selected =
          widget.selectedDate ?? widget.initialDate ?? DateTime.now();
      anchor = DateTime(selected.year, selected.month, selected.day);
    }
    final monday = anchor.subtract(Duration(days: anchor.weekday - 1));
    _dates = List.generate(7, (i) => monday.add(Duration(days: i)));
  }

  bool _isNonWorkingDay(DateTime d) {
    final resolve = widget.resolveNonWorkingDay;
    if (resolve != null) return resolve(d);
    final w = widget.workingWeekdays;
    if (w == null) return false;
    return !w.contains(d.weekday);
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
    final selected =
        widget.selectedDate ?? widget.initialDate ?? DateTime.now();
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
              if (widget.leadingInset > 0)
                SizedBox(width: widget.leadingInset),
              Expanded(
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
                            isSelected:
                                _stateFor(_dates[i]) == _DayState.selected,
                            showArc:
                                !widget.workScheduleWeekDates &&
                                _stateFor(_dates[i]) ==
                                    _DayState.pastWithData &&
                                _hasData(_dates[i]),
                            size: _circleSize,
                            useGreyCircles: widget.useGreyCircles,
                            useMonthCalendarCircleFill:
                                widget.useMonthCalendarCircleFill,
                            workScheduleWeekDates:
                                widget.workScheduleWeekDates,
                            isDark:
                                Theme.of(context).brightness ==
                                Brightness.dark,
                            occupancyPercent:
                                widget.occupancyByDay
                                    ?.firstWhereOrNull(
                                      (element) =>
                                          isSameCalendarDay(
                                            element.date,
                                            _dates[i],
                                          ),
                                    )
                                    ?.occupancy ??
                                0,
                            isNonWorkingDay: _isNonWorkingDay(_dates[i]),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        if (widget.showFullDateLabel) ...[
          const SizedBox(height: 8),
          Text(
            _fullDateText(
              widget.selectedDate ?? widget.initialDate ?? DateTime.now(),
            ),
            style: AppFonts.b2Medium.copyWith(color: AppColors.grey),
          ),
        ],
      ],
    );
  }
}

/// Кружок загруженности одного дня — тот же вид, что в [DateStrip] (режим «Неделя»).
class ScheduleDayLoadCircle extends StatelessWidget {
  const ScheduleDayLoadCircle({
    super.key,
    required this.date,
    required this.occupancyPercent,
    this.isSelected = false,
    this.zeroOccupancyFill = DateStrip._workScheduleCircleFill,
    this.useMonthCalendarCircleFill = true,
    this.circleFill,
  });

  final DateTime date;
  final double occupancyPercent;
  final bool isSelected;
  final Color zeroOccupancyFill;
  final bool useMonthCalendarCircleFill;
  final Color? circleFill;

  static const circleSize = 41.0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dayNumberColor =
        isDark ? AppColors.primaryWhite : AppColors.primaryDark;
    final isEmpty = occupancyPercent <= 0;

    return _DateCircleItem(
      date: date,
      occupancyPercent: occupancyPercent,
      isSelected: isSelected,
      showArc: occupancyPercent > 0,
      size: circleSize,
      useGreyCircles: true,
      useMonthCalendarCircleFill: useMonthCalendarCircleFill,
      workScheduleWeekDates: false,
      isDark: isDark,
      circleFillOverride:
          circleFill ?? (isEmpty ? zeroOccupancyFill : null),
      dayNumberStyle: AppFonts.medium18.copyWith(color: dayNumberColor),
    );
  }
}

class _DateCircleItem extends StatelessWidget {
  const _DateCircleItem({
    this.occupancyPercent = 0,
    required this.date,
    required this.isSelected,
    required this.showArc,
    required this.size,
    required this.useGreyCircles,
    required this.useMonthCalendarCircleFill,
    required this.workScheduleWeekDates,
    required this.isDark,
    this.isNonWorkingDay = false,
    this.circleFillOverride,
    this.dayNumberStyle,
  });

  final double occupancyPercent;
  final DateTime date;
  final bool isSelected;
  final bool showArc;
  final double size;
  final bool useGreyCircles;
  final bool useMonthCalendarCircleFill;
  final bool workScheduleWeekDates;
  final bool isDark;
  final bool isNonWorkingDay;
  final Color? circleFillOverride;
  final TextStyle? dayNumberStyle;

  @override
  Widget build(BuildContext context) {
    final weekdayShort = _weekdayShort[date.weekday - 1];
    final accent = AppColors.themeAccentBrightness(
      isDark ? Brightness.dark : Brightness.light,
    );
    final highlightCircle = isSelected;
    final unselectedFillColor = circleFillOverride ??
        (workScheduleWeekDates
            ? (isDark
                ? AppColors.secondaryDarkDark
                : DateStrip._workScheduleCircleFill)
            : useMonthCalendarCircleFill
            ? (isDark ? AppColors.primaryWhiteDark : AppColors.primaryWhite)
            : (isDark
                  ? AppColors.secondaryDarkDark
                  : (useGreyCircles
                        ? AppColors.secondaryDark
                        : AppColors.primaryWhite)));

    final dayNumberColor = workScheduleWeekDates
        ? (highlightCircle
              ? AppColors.primaryWhite
              : (isDark ? AppColors.tabbarGreyDark : AppColors.tabbarGrey))
        : isSelected
        ? AppColors.primaryWhite
        : isNonWorkingDay
        ? (isDark ? AppColors.primaryDarkDark : AppColors.primaryDark)
        : isDark
        ? (showArc ? AppColors.primaryDarkDark : AppColors.tabbarGreyDark)
        : (showArc ? AppColors.primaryDark : AppColors.grey);

    final weekdayLabelColor = workScheduleWeekDates
        ? (highlightCircle
              ? accent
              : (isDark ? AppColors.tabbarGreyDark : AppColors.tabbarGrey))
        : isSelected
        ? accent
        : (isDark ? AppColors.tabbarGreyDark : AppColors.tabbarGrey);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _DateCirclePainter(
              isSelected: highlightCircle,
              showArc: showArc,
              unselectedFillColor: unselectedFillColor,
              isDark: isDark,
              occupancyPercent: occupancyPercent,
              isNonWorkingDay: isNonWorkingDay,
              keepCircleFillWhenSelected:
                  workScheduleWeekDates && !highlightCircle,
            ),
            child: Center(
              child: Text(
                '${date.day}',
                style:
                    dayNumberStyle ??
                    AppFonts.b1Medium.copyWith(color: dayNumberColor),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          weekdayShort,
          style: AppFonts.c2Tabbar.copyWith(color: weekdayLabelColor),
        ),
      ],
    );
  }
}

class _DateCirclePainter extends CustomPainter {
  _DateCirclePainter({
    required this.isSelected,
    required this.showArc,
    required this.unselectedFillColor,
    required this.isDark,
    required this.occupancyPercent,
    this.isNonWorkingDay = false,
    this.keepCircleFillWhenSelected = false,
  });

  final bool isSelected;
  final bool showArc;
  final Color unselectedFillColor;
  final bool isDark;
  final double occupancyPercent;
  final bool isNonWorkingDay;
  final bool keepCircleFillWhenSelected;
  static const _arcStrokeWidth = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1;

    final selectedFill = AppColors.themeAccentBrightness(
      isDark ? Brightness.dark : Brightness.light,
    );
    final circleFill = isSelected && !keepCircleFillWhenSelected
        ? selectedFill
        : unselectedFillColor;
    final bgPaint = Paint()
      ..color = circleFill
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, bgPaint);

    if (isSelected && !keepCircleFillWhenSelected) {
      // Если есть данные или заполняемость
      if (showArc || occupancyPercent > 0) {
        // Базовая обводка выбранного дня — MainAccent (синий)
        // Теперь MainAccent — это основной цвет заполнения
        final baseOutlinePaint = Paint()
          ..color = selectedFill
          ..style = PaintingStyle.stroke
          ..strokeWidth = _arcStrokeWidth;
        canvas.drawCircle(center, radius - 1, baseOutlinePaint);

        // Дуга "свободного" места или акцентная дуга поверх — SecondaryAccent (светлый)
        // Если вы хотите, чтобы 10% были светлыми на синем фоне:
        if (occupancyPercent > 0) {
          final arcPaint = Paint()
            ..color = isDark
                ? AppColors.secondaryAccentDark
                : AppColors.secondaryAccent
            ..style = PaintingStyle.stroke
            ..strokeWidth = _arcStrokeWidth
            ..strokeCap = StrokeCap.round;

          final percent = occupancyPercent.clamp(0.0, 100.0);
          final sweepAngle = (2 * 3.1415926535) * (percent / 100.0);
          const startAngle = -3.1415926535 / 2;

          canvas.drawArc(
            Rect.fromCircle(center: center, radius: radius - 1),
            startAngle,
            sweepAngle,
            false,
            arcPaint,
          );
        }
      }
    }

    // Дуга occupancy для невыбранного дня — показываем у всех дней недели, у которых есть данные
    if (!isSelected && (showArc || occupancyPercent > 0)) {
      final arcPaint = Paint()
        ..color = AppColors.themeAccentBrightness(
          isDark ? Brightness.dark : Brightness.light,
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = _arcStrokeWidth
        ..strokeCap = StrokeCap.round;

      final percent = occupancyPercent.clamp(0.0, 100.0);
      final sweepAngle = (2 * 3.1415926535) * (percent / 100.0);
      const startAngle = -3.1415926535 / 2;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 1),
        startAngle,
        sweepAngle,
        false,
        arcPaint,
      );
    }

    if (isNonWorkingDay) {
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
  bool shouldRepaint(covariant _DateCirclePainter oldDelegate) {
    return oldDelegate.isSelected != isSelected ||
        oldDelegate.showArc != showArc ||
        oldDelegate.unselectedFillColor != unselectedFillColor ||
        oldDelegate.isDark != isDark ||
        oldDelegate.occupancyPercent != occupancyPercent ||
        oldDelegate.isNonWorkingDay != isNonWorkingDay ||
        oldDelegate.keepCircleFillWhenSelected != keepCircleFillWhenSelected;
  }
}
