import 'package:flutter/material.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/features/schedule/data/models/appointments_api/appointments_api.dart';
import 'package:rient_app/features/schedule/view/components/view_mode_segmented_control.dart';
import 'package:rient_app/resources/resources.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

/// Элемент записи в расписании с отдельными цветами заливки и акцента.
class ScheduleAppointmentItem {
  const ScheduleAppointmentItem({
    this.id,
    this.source,
    required this.startTime,
    required this.endTime,
    required this.subject,
    required this.notes,
    required this.backgroundColor,
    required this.accentColor,
    this.hasComment = false,
  });

  final int? id;
  final AppointmentApi? source;
  final DateTime startTime;
  final DateTime endTime;
  final String subject;
  final String notes;
  final Color backgroundColor;
  final Color accentColor;
  final bool hasComment;
}

/// Календарь с записями и перерывом (день или неделя).
class ScheduleCalendarOneUserWidget extends StatefulWidget {
  const ScheduleCalendarOneUserWidget({
    super.key,
    required this.date,
    required this.items,
    this.viewMode = ViewMode.week,
    this.startHour = 9,
    this.endHour = 21,
    this.weekWorkHoursByWeekday,
    this.breakStart,
    this.breakEnd,
    this.workerStartHour,
    this.workerEndHour,
    this.timeRulerSize = kDefaultTimeRulerSize,
    this.onScrollPositionReady,
    this.onAppointmentTap,
  });

  static const kDefaultTimeRulerSize = 50.0;

  /// Для дня — выбранная дата, для недели — понедельник недели.
  final DateTime date;
  final List<ScheduleAppointmentItem> items;
  final ViewMode viewMode;
  final double startHour;
  final double endHour;
  final Map<int, ({double startHour, double endHour})>? weekWorkHoursByWeekday;
  final String? breakStart;
  final String? breakEnd;

  /// Окно смены мастера в дне: штриховка до/после относительно [startHour]/[endHour] филиала.
  final double? workerStartHour;
  final double? workerEndHour;

  /// Ширина шкалы времени (0 — только у первой колонки в мультидне).
  final double timeRulerSize;

  /// Для синхронной прокрутки нескольких календарей дня (один общий [ScrollPosition]).
  final ValueChanged<ScrollPosition>? onScrollPositionReady;
  final ValueChanged<ScheduleAppointmentItem>? onAppointmentTap;

  @override
  State<ScheduleCalendarOneUserWidget> createState() =>
      _ScheduleCalendarOneUserWidgetState();
}

class _ScheduleCalendarOneUserWidgetState
    extends State<ScheduleCalendarOneUserWidget> {
  bool _scrollRegistered = false;

  @override
  void didUpdateWidget(covariant ScheduleCalendarOneUserWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.date != widget.date ||
        oldWidget.onScrollPositionReady != widget.onScrollPositionReady) {
      _scrollRegistered = false;
    }
  }

  List<TimeRegion> _getSpecialRegions() {
    DateTime at(DateTime base, double hour) {
      final h = hour.floor();
      final m = ((hour - h) * 60).round();
      return DateTime(base.year, base.month, base.day, h, m);
    }

    double? parseTimeToHour(String? value) {
      if (value == null || value.isEmpty) return null;
      final parts = value.split(':');
      if (parts.length < 2) return null;
      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);
      if (hour == null || minute == null) return null;
      return hour + (minute / 60);
    }

    final regions = <TimeRegion>[];
    final breakStartHour = parseTimeToHour(widget.breakStart);
    final breakEndHour = parseTimeToHour(widget.breakEnd);
    if (breakStartHour != null &&
        breakEndHour != null &&
        breakEndHour > breakStartHour) {
      regions.add(
        TimeRegion(
          startTime: at(widget.date, breakStartHour),
          endTime: at(widget.date, breakEndHour),
          enablePointerInteraction: false,
          recurrenceRule: widget.viewMode == ViewMode.week
              ? 'FREQ=DAILY;INTERVAL=1'
              : null,
        ),
      );
    }

    if (widget.viewMode == ViewMode.day &&
        widget.workerStartHour != null &&
        widget.workerEndHour != null &&
        widget.workerEndHour! > widget.workerStartHour!) {
      final branchStart = widget.startHour;
      final branchEnd = widget.endHour;
      final wStart = widget.workerStartHour!;
      final wEnd = widget.workerEndHour!;
      if (wStart > branchStart) {
        final leftEnd = wStart < branchEnd ? wStart : branchEnd;
        if (leftEnd > branchStart) {
          regions.add(
            TimeRegion(
              startTime: at(widget.date, branchStart),
              endTime: at(widget.date, leftEnd),
              enablePointerInteraction: false,
            ),
          );
        }
      }
      if (wEnd < branchEnd) {
        final rightStart = wEnd > branchStart ? wEnd : branchStart;
        if (branchEnd > rightStart) {
          regions.add(
            TimeRegion(
              startTime: at(widget.date, rightStart),
              endTime: at(widget.date, branchEnd),
              enablePointerInteraction: false,
            ),
          );
        }
      }
    }

    if (widget.viewMode == ViewMode.week &&
        widget.weekWorkHoursByWeekday != null) {
      final weekStart = DateTime(
        widget.date.year,
        widget.date.month,
        widget.date.day,
      );
      for (var i = 0; i < 7; i++) {
        final day = weekStart.add(Duration(days: i));
        final hours = widget.weekWorkHoursByWeekday![day.weekday];

        if (hours == null) {
          regions.add(
            TimeRegion(
              startTime: at(day, widget.startHour),
              endTime: at(day, widget.endHour),
              enablePointerInteraction: false,
            ),
          );
          continue;
        }

        if (hours.startHour > widget.startHour) {
          regions.add(
            TimeRegion(
              startTime: at(day, widget.startHour),
              endTime: at(day, hours.startHour),
              enablePointerInteraction: false,
            ),
          );
        }
        if (hours.endHour < widget.endHour) {
          regions.add(
            TimeRegion(
              startTime: at(day, hours.endHour),
              endTime: at(day, widget.endHour),
              enablePointerInteraction: false,
            ),
          );
        }
      }
    }

    if (widget.onScrollPositionReady != null && regions.isEmpty) {
      regions.add(
        TimeRegion(
          startTime: at(widget.date, widget.startHour),
          endTime: at(widget.date, widget.startHour + 1 / 60),
          enablePointerInteraction: false,
        ),
      );
    }

    return regions;
  }

  CalendarDataSource _calendarDataSource() {
    final appointments = widget.items
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
    for (final e in widget.items) {
      if (e.startTime == a.startTime &&
          e.endTime == a.endTime &&
          e.subject == a.subject) {
        return e;
      }
    }
    return null;
  }

  Widget _buildTimeRegion(BuildContext context, TimeRegionDetails details) {
    if (widget.onScrollPositionReady != null && !_scrollRegistered) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _scrollRegistered) return;
        final scrollable = Scrollable.maybeOf(context);
        if (scrollable != null) {
          _scrollRegistered = true;
          widget.onScrollPositionReady!(scrollable.position);
        }
      });
    }
    if (details.bounds.height < 2) {
      return const SizedBox.shrink();
    }
    return CustomPaint(
      painter: _HatchPainter(timeRulerWidth: widget.timeRulerSize),
    );
  }

  Widget _buildScheduleEntry(
    BuildContext context,
    CalendarAppointmentDetails details,
  ) {
    final a = details.appointments.first as Appointment;
    final bounds = details.bounds;
    final start = a.startTime;
    final end = a.endTime;
    final timeStartLine =
        '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}-';
    final timeEndLine =
        '${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
    final timeStr = '$timeStartLine\n$timeEndLine';
    final item = _findItem(a);
    final accentColor = item?.accentColor ?? a.color;
    final backgroundColor =
        item?.backgroundColor ?? a.color.withValues(alpha: 0.2);

    if (widget.viewMode == ViewMode.week) {
      return GestureDetector(
        onTap: item == null || widget.onAppointmentTap == null
            ? null
            : () => widget.onAppointmentTap!(item),
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: bounds.width,
          height: bounds.height,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          alignment: Alignment.center,
          child: SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    timeStr,
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.center,
                    style: AppFonts.c2Tabbar.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w600,
                      height: 1.1,
                    ),
                  ),
                  if (item?.hasComment == true) ...[
                    const SizedBox(height: 2),
                    Image.asset(
                      AppImages.comment,
                      width: 14,
                      height: 14,
                      color: accentColor,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    }

    final serviceName = a.subject;

    return GestureDetector(
      onTap: item == null || widget.onAppointmentTap == null
          ? null
          : () => widget.onAppointmentTap!(item),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: bounds.width,
        height: bounds.height,
        clipBehavior: Clip.antiAlias,
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
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '$timeStartLine$timeEndLine',
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                textAlign: TextAlign.center,
                                style: AppFonts.c1Medium.copyWith(
                                  color: accentColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  height: 1.1,
                                ),
                              ),
                              if (item?.hasComment == true) ...[
                                Image.asset(
                                  AppImages.comment,
                                  width: 18,
                                  height: 18,
                                  color: accentColor,
                                ),
                              ],
                            ],
                          ),

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
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  CalendarView get _calendarView =>
      widget.viewMode == ViewMode.day ? CalendarView.day : CalendarView.week;

  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      key: ValueKey(widget.viewMode),
      view: _calendarView,
      initialDisplayDate: widget.date,
      firstDayOfWeek: 1,

      /// Не переключать вид (например неделя → день) по тапу по шапке с датами.
      allowViewNavigation: false,
      viewNavigationMode: ViewNavigationMode.none,
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
        startHour: widget.startHour,
        endHour: widget.endHour,
        timeIntervalHeight: 60,
        timeFormat: 'HH:mm',
        timeRulerSize: widget.timeRulerSize,
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
