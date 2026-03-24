import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/local_storage.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/widgets/top_panel.dart';
import 'package:rient_app/features/schedule/data/models/available_workers_api/available_workers_api.dart';
import 'package:rient_app/features/schedule/data/models/workers_api/workers_api.dart';
import 'package:rient_app/features/schedule/view/components/date_strip.dart';
import 'package:rient_app/features/schedule/view/components/month_calendar.dart';
import 'package:rient_app/features/schedule/view/components/schedule_calendar_one_user_widget.dart';
import 'package:rient_app/features/schedule/view/components/specialist_list_view.dart';
import 'package:rient_app/features/schedule/view/components/specialist_select_dialog.dart';
import 'package:rient_app/features/schedule/view/components/view_mode_segmented_control.dart';
import 'package:rient_app/features/home/data/models/branches_api/branches_api.dart';
import 'package:rient_app/features/home/data/models/statistics/statistics.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_statistics_provider.dart';
import 'package:rient_app/features/schedule/view/providers/schedules_provider.dart';
import 'package:rient_app/features/schedule/view/providers/workers_provider.dart';

class SchedulePage extends ConsumerStatefulWidget {
  const SchedulePage({super.key});

  static const name = 'schedule_page';
  static const path = '/schedule_page';

  @override
  ConsumerState<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends ConsumerState<SchedulePage> {
  ViewMode _viewMode = ViewMode.day;
  late DateTime _weekStart;
  late DateTime _monthStart;

  static List<SpecialistItem> _availableToSpecialists(
    List<AvailableWorkerShift> shifts,
    List<WorkerApi> allWorkers,
  ) {
    final workersById = {for (final w in allWorkers) w.id: w};
    final seen = <int>{};
    final specialists = <SpecialistItem>[];
    for (final shift in shifts) {
      final worker = shift.worker;
      if (seen.contains(worker.id)) continue;
      seen.add(worker.id);
      final fullWorker = workersById[worker.id];
      final name = '${worker.firstName ?? ''} ${worker.lastName ?? ''}'.trim();
      specialists.add(
        SpecialistItem(
          name: name.isEmpty ? 'Специалист' : name,
          role: worker.specialization ?? '',
          id: worker.id,
          pictureUrl: fullWorker?.pictureThumbnail ?? fullWorker?.picture,
        ),
      );
    }
    return specialists;
  }

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
    // При смене недели синхронизируем выбранную дату с понедельником этой недели,
    // чтобы полоска дат и календарь показывали актуальную неделю и выбранный день.
    if (viewMode == ViewMode.week) {
      ref.read(selectedScheduleDateProvider.notifier).state = DateTime(
        weekStart.year,
        weekStart.month,
        weekStart.day,
      );
    }
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

  static double _timeToHour(String? value) {
    if (value == null || value.isEmpty) return 0;
    final parts = value.split(':');
    if (parts.length < 2) return 0;
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    return hour + (minute / 60);
  }

  static String _weekdayKey(DateTime date) {
    switch (date.weekday) {
      case DateTime.monday:
        return 'mon';
      case DateTime.tuesday:
        return 'tue';
      case DateTime.wednesday:
        return 'wen';
      case DateTime.thursday:
        return 'thu';
      case DateTime.friday:
        return 'fri';
      case DateTime.saturday:
        return 'sat';
      case DateTime.sunday:
      default:
        return 'sun';
    }
  }

  static ({double startHour, double endHour}) _workHoursForDate(
    DateTime date,
    List<SchedulePattern> patterns,
  ) {
    final day = _weekdayKey(date);
    SchedulePattern? pattern;
    for (final item in patterns) {
      final patternDay = (item.day ?? '').toLowerCase();
      final isSameDay = patternDay == day || (day == 'wen' && patternDay == 'wed');
      if (isSameDay && (item.active ?? false)) {
        pattern = item;
        break;
      }
    }

    if (pattern == null) {
      return (startHour: 9.0, endHour: 21.0);
    }

    final start = _timeToHour(pattern.timeStart);
    final end = _timeToHour(pattern.timeEnd);
    if (start <= 0 || end <= 0 || end <= start) {
      return (startHour: 9.0, endHour: 21.0);
    }

    return (startHour: start, endHour: end);
  }

  static ({double startHour, double endHour}) _workHoursForWeek(
    List<SchedulePattern> patterns,
  ) {
    final active = patterns.where((p) => p.active ?? false).toList();
    if (active.isEmpty) {
      return (startHour: 9.0, endHour: 21.0);
    }

    double? minStart;
    double? maxEnd;
    for (final pattern in active) {
      final start = _timeToHour(pattern.timeStart);
      final end = _timeToHour(pattern.timeEnd);
      if (start <= 0 || end <= 0 || end <= start) continue;
      minStart = minStart == null ? start : (start < minStart ? start : minStart);
      maxEnd = maxEnd == null ? end : (end > maxEnd ? end : maxEnd);
    }

    if (minStart == null || maxEnd == null || maxEnd <= minStart) {
      return (startHour: 9.0, endHour: 21.0);
    }

    return (startHour: minStart, endHour: maxEnd);
  }

  /// Количество записей по дням месяца из [appointmentsByDay] (день месяца 1–31 → total).
  static Map<int, int> _slotsByDayFromAppointments(
    List<AppointmentByDayItem> appointmentsByDay,
    DateTime month,
  ) {
    final result = <int, int>{};
    final year = month.year;
    final monthNum = month.month;
    for (final item in appointmentsByDay) {
      final parsed = DateTime.tryParse(item.date);
      if (parsed == null) continue;
      if (parsed.year != year || parsed.month != monthNum) continue;
      result[parsed.day] = item.appointments.total;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final workersAsync = ref.watch(scheduleWorkersProvider);
    final currentBranch = ref.watch(currentBranchProvider);
    final selectedDate = ref.watch(selectedScheduleDateProvider);
    final availableWorkersAsync = ref.watch(availableWorkersForDateProvider(selectedDate));
    final availableWorkersLoading = availableWorkersAsync.isLoading;
    final weekKey = scheduleWeekKey(
      _viewMode == ViewMode.day ? selectedDate : _weekStart,
    );
    final monthKey = scheduleMonthKey(_monthStart);
    final weekStatisticsAsync =
        ref.watch(scheduleStatisticsForWeekProvider(weekKey));
    final occupancyByDay = weekStatisticsAsync.value?.occupancyByDay ?? [];
    final weekStatisticsLoading = weekStatisticsAsync.isLoading;
    final monthStatisticsAsync =
        ref.watch(scheduleStatisticsForMonthProvider(monthKey));
    final monthOccupancyByDay =
        monthStatisticsAsync.value?.occupancyByDay ?? [];
    final monthStatisticsLoading = monthStatisticsAsync.isLoading;
    final monthAppointmentsByDay =
        monthStatisticsAsync.value?.appointmentsByDay ?? [];
    final slotsByDay = _slotsByDayFromAppointments(
      monthAppointmentsByDay,
      _monthStart,
    );
    final showGlobalLoader =
        availableWorkersLoading ||
        (_viewMode == ViewMode.week && weekStatisticsLoading) ||
        (_viewMode == ViewMode.month && monthStatisticsLoading);
    // Для всех режимов показываем активных сотрудников на выбранную дату.
    final specialists = availableWorkersAsync.maybeWhen(
      data: (available) {
        if (available.isEmpty) return <SpecialistItem>[];
        return _availableToSpecialists(
          available,
          workersAsync.value?.results ?? const [],
        );
      },
      orElse: () => <SpecialistItem>[],
    );
    final savedSelectedId = ref.watch(selectedSpecialistIdProvider);
    final initialSelected = specialists.isEmpty
        ? null
        : (savedSelectedId != null
              ? specialists.firstWhere(
                  (s) => s.id == savedSelectedId,
                  orElse: () => specialists.first,
                )
              : specialists.first);
    final dayWorkHours = _workHoursForDate(
      selectedDate,
      currentBranch?.schedulePatterns ?? const [],
    );
    final weekWorkHours = _workHoursForWeek(
      currentBranch?.schedulePatterns ?? const [],
    );

    ref.listen(scheduleWorkersProvider, (prev, next) {
      next.whenData((_) async {
        if (ref.read(restoredSpecialistSelectionProvider)) return;
        final storage = ref.read(localStorageProvider);
        final idStr = await storage.getString(selectedSpecialistIdStorageKey);
        final id = int.tryParse(idStr ?? '');
        if (id != null && context.mounted) {
          ref.read(selectedSpecialistIdProvider.notifier).state = id;
        }
        if (context.mounted) {
          ref.read(restoredSpecialistSelectionProvider.notifier).state = true;
        }
      });
    });

    return Scaffold(
      backgroundColor: AppColors.tabBarScreenBackground,
      body: Stack(
        children: [
          Column(
            children: [
              TopPanel(
                title: 'Расписание',
                showViewModeSwitcher: true,
                onScheduleStateChanged: _onScheduleStateChanged,
                specialists: specialists,
                initialSelectedSpecialist: initialSelected,
                onSpecialistSelected: (s) async {
                  ref.read(selectedSpecialistIdProvider.notifier).state = s.id;
                  final storage = ref.read(localStorageProvider);
                  await storage.saveString(
                    selectedSpecialistIdStorageKey,
                    s.id.toString(),
                  );
                },
                scheduleSelectedDate: selectedDate,
                occupancyByDay: occupancyByDay,
                onScheduleDateSelected: (date) {
                  ref.read(selectedScheduleDateProvider.notifier).state = DateTime(
                    date.year,
                    date.month,
                    date.day,
                  );
                },
              ),
              Expanded(
                child: workersAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (err, _) => Center(
                    child: Padding(
                      padding: AppDecoration.padding16,
                      child: Text(
                        'Не удалось загрузить список специалистов',
                        style: TextStyle(color: AppColors.grey),
                      ),
                    ),
                  ),
                  data: (_) => _viewMode == ViewMode.day
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (specialists.length >= 3)
                              Padding(
                                padding: AppDecoration.padding16,
                                child: SpecialistListView(specialists: specialists),
                              ),
                            Expanded(
                              child: ScheduleCalendarOneUserWidget(
                                key: ValueKey(
                                  'schedule_day_${scheduleDateKey(selectedDate)}',
                                ),
                                date: selectedDate,
                                items: _scheduleItems(selectedDate),
                                viewMode: ViewMode.day,
                                startHour: dayWorkHours.startHour,
                                endHour: dayWorkHours.endHour,
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_viewMode == ViewMode.week) ...[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: AppDecoration.padding16.copyWith(
                                        top: 20,
                                        left: 40,
                                      ),
                                      child: DateStrip(
                                        key: ValueKey('week_strip_$weekKey'),
                                        initialDate: _weekStart,
                                        selectedDate: selectedDate,
                                        onDateSelected: (date) {
                                          ref
                                              .read(
                                                selectedScheduleDateProvider
                                                    .notifier,
                                              )
                                              .state = DateTime(
                                            date.year,
                                            date.month,
                                            date.day,
                                          );
                                        },
                                        showFullDateLabel: false,
                                        useGreyCircles: true,
                                        occupancyByDay: occupancyByDay,
                                      ),
                                    ),
                                    Expanded(
                                      child: ScheduleCalendarOneUserWidget(
                                        key: ValueKey('schedule_week_$weekKey'),
                                        date: _weekStart,
                                        items: _scheduleItemsForWeek(_weekStart),
                                        viewMode: ViewMode.week,
                                        startHour: weekWorkHours.startHour,
                                        endHour: weekWorkHours.endHour,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            if (_viewMode == ViewMode.month)
                              Expanded(
                                child: Padding(
                                  padding: AppDecoration.padding16.copyWith(
                                    top: 20,
                                  ),
                                  child: SingleChildScrollView(
                                    child: MonthCalendar(
                                      key: ValueKey('month_$monthKey'),
                                      month: _monthStart,
                                      slotsByDay: slotsByDay,
                                      occupancyByDay: monthOccupancyByDay,
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
          if (showGlobalLoader)
            Positioned.fill(
              child: Container(
                color: AppColors.tabBarScreenBackground.withValues(alpha: 0.35),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
