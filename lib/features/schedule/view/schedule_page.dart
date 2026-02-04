import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/date_strip.dart';
import 'package:rient_app/core/widgets/default_container.dart';
import 'package:rient_app/core/widgets/month_calendar.dart';
import 'package:rient_app/core/widgets/top_panel.dart';
import 'package:rient_app/core/widgets/view_mode_segmented_control.dart';

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
          TopPanel(
            title: 'Расписание',
            showViewModeSwitcher: true,
            onScheduleStateChanged: _onScheduleStateChanged,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: AppDecoration.padding16.copyWith(top: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 100,
                    width: 114,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) =>
                          DefaultContainerWidget(
                            borderRadius: BorderRadius.circular(20),
                            hasShadow: false,
                            color: Colors.white,
                            child: Column(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppColors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Gap(8),
                                Text('Иван Иванов', style: AppFonts.c1Medium),
                                Gap(4),
                                Text(
                                  'Барбер',
                                  style: AppFonts.c2Tabbar.copyWith(
                                    color: AppColors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      separatorBuilder: (BuildContext context, int index) =>
                          Gap(4),
                      itemCount: 5,
                    ),
                  ),
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
          ),
        ],
      ),
    );
  }
}
