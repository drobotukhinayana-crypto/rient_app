import 'package:flutter/material.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/widgets/top_panel.dart';
import 'package:rient_app/features/schedule/view/components/date_strip.dart';
import 'package:rient_app/features/schedule/view/components/month_calendar.dart';
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
  ViewMode _viewMode = ViewMode.week;
  late DateTime _weekStart;
  late DateTime _monthStart;

  static const _specialists = [
    SpecialistItem(name: 'Иванов Иван', role: 'Барбер'),
    SpecialistItem(name: 'Иванова Алина', role: 'Барбер'),
    SpecialistItem(name: 'Петров Пётр', role: 'Мастер маникюра'),
    SpecialistItem(name: 'Сидорова Анна', role: 'Визажист'),
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
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // список специалистов
                  if (_viewMode == ViewMode.day)
                    Padding(
                      padding: AppDecoration.padding16,
                      child: SpecialistListView(specialists: _specialists),
                    )
                  else
                    Padding(
                      padding: AppDecoration.padding16.copyWith(top: 20),
                      child: Column(
                        children: [
                          if (_viewMode == ViewMode.week)
                            DateStrip(
                              initialDate: _weekStart,
                              showFullDateLabel: false,
                            ),

                          if (_viewMode == ViewMode.month)
                            MonthCalendar(month: _monthStart),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
