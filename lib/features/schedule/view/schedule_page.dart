import 'package:flutter/material.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/widgets/top_panel.dart';
import 'package:rient_app/features/schedule/view/components/date_strip.dart';
import 'package:rient_app/features/schedule/view/components/month_calendar.dart';
import 'package:rient_app/features/schedule/view/components/schedule_calendar_one_user_widget.dart';
import 'package:rient_app/features/schedule/view/components/specialist_list_view.dart';
import 'package:rient_app/features/schedule/view/components/specialist_select_dialog.dart';
import 'package:rient_app/features/schedule/view/components/view_mode_segmented_control.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  static const name = 'schedule_page';
  static const path = '/schedule_page';

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  ViewMode _viewMode = ViewMode.day;
  late DateTime _weekStart;
  late DateTime _monthStart;

  static const _specialists = [
    SpecialistItem(name: 'Иванов Иван', role: 'Барбер'),
    SpecialistItem(name: 'Иванова Алина', role: 'Барбер'),
  ];

  @override
  void initState() {
    super.initState();
    _syncToNow();
  }

  void _syncToNow() {
    final now = DateTime.now();
    final weekday = now.weekday;
    _weekStart = now.subtract(Duration(days: weekday - 1));
    _monthStart = DateTime(now.year, now.month, 1);
  }

  void _onScheduleStateChanged(
    ViewMode viewMode,
    DateTime weekStart,
    DateTime monthStart,
  ) {
    setState(() {
      _viewMode = viewMode;
      _weekStart = weekStart;
      _monthStart = monthStart;
    });
  }

  static List<ScheduleAppointmentItem> _scheduleItems(DateTime day) => [
    ScheduleAppointmentItem(
      startTime: DateTime(day.year, day.month, day.day, 10, 0),
      endTime: DateTime(day.year, day.month, day.day, 11, 0),
      subject: 'Стрижка удлиненная',
      notes: 'Антон Иванов',
      backgroundColor: AppColors.lightGreen,
      accentColor: AppColors.green,
    ),
    ScheduleAppointmentItem(
      startTime: DateTime(day.year, day.month, day.day, 15, 0),
      endTime: DateTime(day.year, day.month, day.day, 17, 0),
      subject: 'Стрижка удлиненная',
      notes: 'Антон Иванов',
      backgroundColor: AppColors.lightYel,
      accentColor: AppColors.yel,
      hasComment: true,
    ),
  ];

  static List<ScheduleAppointmentItem> _scheduleItemsForWeek(
    DateTime weekStart,
  ) {
    final items = <ScheduleAppointmentItem>[];
    for (var d = 0; d < 7; d++) {
      final day = weekStart.add(Duration(days: d));
      items.addAll(_scheduleItems(day));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.tabBarScreenBackground,
      body: Column(
        children: [
          // верхняя панель
          TopPanel(
            title: 'Расписание',
            showViewModeSwitcher: true,
            onScheduleStateChanged: _onScheduleStateChanged,
            specialists: _specialists,
          ),
          Expanded(
            child: _viewMode == ViewMode.day
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_specialists.length >= 3)
                        Padding(
                          padding: AppDecoration.padding16,
                          child: SpecialistListView(specialists: _specialists),
                        ),
                      Expanded(
                        child: ScheduleCalendarOneUserWidget(
                          key: const ValueKey('schedule_day'),
                          date: DateTime.now(),
                          items: _scheduleItems(DateTime.now()),
                          viewMode: ViewMode.day,
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_viewMode == ViewMode.week) ...[
                        Padding(
                          padding: AppDecoration.padding16.copyWith(
                            top: 20,
                            left: 40,
                          ),
                          child: DateStrip(
                            initialDate: _weekStart,
                            showFullDateLabel: false,
                          ),
                        ),
                        Expanded(
                          child: ScheduleCalendarOneUserWidget(
                            key: const ValueKey('schedule_week'),
                            date: _weekStart,
                            items: _scheduleItemsForWeek(_weekStart),
                            viewMode: ViewMode.week,
                          ),
                        ),
                      ],
                      if (_viewMode == ViewMode.month)
                        Expanded(
                          child: Padding(
                            padding: AppDecoration.padding16.copyWith(top: 20),
                            child: SingleChildScrollView(
                              child: MonthCalendar(month: _monthStart),
                            ),
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
