import 'package:flutter/material.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/features/schedule/view/components/view_mode_segmented_control.dart';
import 'package:rient_app/resources/resources.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

/// Элемент записи в расписании с отдельными цветами заливки и акцента.
class ScheduleAppointmentItem {
  const ScheduleAppointmentItem({
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.notes,
    required this.backgroundColor,
    required this.accentColor,
    this.hasComment = false,
  });

  final DateTime startTime;
  final DateTime endTime;
  final String subject;
  final String notes;
  final Color backgroundColor;
  final Color accentColor;
  final bool hasComment;
}

/// Календарь с записями и перерывом (день или неделя).
class ScheduleCalendarOneUserWidget extends StatelessWidget {
  const ScheduleCalendarOneUserWidget({
    super.key,
    required this.date,
    required this.items,
    this.viewMode = ViewMode.week,
  });

  /// Для дня — выбранная дата, для недели — понедельник недели.
  final DateTime date;
  final List<ScheduleAppointmentItem> items;
  final ViewMode viewMode;

  List<TimeRegion> _getSpecialRegions() {
    DateTime at(int h, int m) =>
        DateTime(date.year, date.month, date.day, h, m);
    return [
      TimeRegion(
        startTime: at(12, 0),
        endTime: at(14, 0),
        enablePointerInteraction: false,
        recurrenceRule: 'FREQ=DAILY;INTERVAL=1',
      ),
    ];
  }

  CalendarDataSource _calendarDataSource() {
    final appointments = items
        .map(
          (e) => Appointment(
            startTime: e.startTime,
            endTime: e.endTime,
            subject: e.subject,
            notes: e.notes,
            color: e.accentColor,
          ),
        )
        .toList();
    return _ScheduleCalendarDataSource(appointments);
  }

  ScheduleAppointmentItem? _findItem(Appointment a) {
    for (final e in items) {
      if (e.startTime == a.startTime &&
          e.endTime == a.endTime &&
          e.subject == a.subject) {
        return e;
      }
    }
    return null;
  }

  static const _timeRulerSize = 50.0;

  Widget _buildTimeRegion(BuildContext context, TimeRegionDetails details) {
    return CustomPaint(painter: _HatchPainter(timeRulerWidth: _timeRulerSize));
  }

  Widget _buildScheduleEntry(
    BuildContext context,
    CalendarAppointmentDetails details,
  ) {
    final a = details.appointments.first as Appointment;
    final bounds = details.bounds;
    final start = a.startTime;
    final end = a.endTime;
    final timeStr =
        '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}-'
        '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
    final item = _findItem(a);
    final accentColor = item?.accentColor ?? a.color;
    final backgroundColor =
        item?.backgroundColor ?? a.color.withValues(alpha: 0.2);

    if (viewMode == ViewMode.week) {
      return Container(
        width: bounds.width,
        height: bounds.height,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(6),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              timeStr,
              style: AppFonts.c2Tabbar.copyWith(
                color: accentColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (item?.hasComment == true) ...[
              const SizedBox(height: 4),
              Center(
                child: Image.asset(
                  AppImages.comment,
                  width: 14,
                  height: 14,
                  color: accentColor,
                ),
              ),
            ],
          ],
        ),
      );
    }

    final customerName = a.notes ?? '';
    final serviceName = a.subject;

    return Container(
      width: bounds.width,
      height: bounds.height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(width: 3, color: accentColor),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              timeStr,
                              style: AppFonts.c1Medium.copyWith(
                                color: accentColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 14,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              color: accentColor,
                            ),
                            Text(
                              customerName,
                              style: AppFonts.c1Medium.copyWith(
                                color: accentColor,
                              ),

                              overflow: TextOverflow.ellipsis,
                            ),
                            Container(
                              width: 1,
                              height: 14,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              color: accentColor,
                            ),

                            Image.asset(
                              AppImages.comment,
                              width: 18,
                              height: 18,
                              color: accentColor,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          serviceName,
                          style: AppFonts.c1Regular.copyWith(
                            color: accentColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Новая',
                          style: AppFonts.c2Tabbar.copyWith(
                            color: AppColors.primaryWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  CalendarView get _calendarView =>
      viewMode == ViewMode.day ? CalendarView.day : CalendarView.week;

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      key: ValueKey(viewMode),
      view: _calendarView,
      initialDisplayDate: date,
      headerHeight: 0,
      viewHeaderHeight: 0,
      showDatePickerButton: false,
      showCurrentTimeIndicator: true,
      todayHighlightColor: AppColors.red,
      dataSource: _calendarDataSource(),
      appointmentBuilder: _buildScheduleEntry,
      specialRegions: _getSpecialRegions(),
      timeRegionBuilder: _buildTimeRegion,
      timeSlotViewSettings: TimeSlotViewSettings(
        startHour: 9,
        endHour: 21,
        timeIntervalHeight: 60,
        timeFormat: 'HH:mm',
        timeRulerSize: _timeRulerSize,
      ),
    );
  }
}

class _ScheduleCalendarDataSource extends CalendarDataSource {
  _ScheduleCalendarDataSource(List<Appointment> source) {
    appointments = source;
  }
}

/// Штриховка: линии не заходят на колонку времени.
class _HatchPainter extends CustomPainter {
  _HatchPainter({this.timeRulerWidth = 50.0});

  final double timeRulerWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = AppColors.primaryDark.withValues(alpha: 0.04);
    canvas.drawRect(Offset.zero & size, bg);

    final line = Paint()
      ..color = AppColors.primaryDark.withValues(alpha: 0.18)
      ..strokeWidth = 1;

    const step = 25.0;
    final run = size.height * 2;

    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    for (double x = -run; x < size.width + run; x += step) {
      canvas.drawLine(Offset(x, size.height), Offset(x + run, 0), line);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _HatchPainter oldDelegate) =>
      oldDelegate.timeRulerWidth != timeRulerWidth;
}
