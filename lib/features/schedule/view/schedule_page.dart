import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/services/local_storage.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/widgets/top_panel.dart';
import 'package:rient_app/features/create/view/add_new_entry_page.dart';
import 'package:rient_app/features/home/data/models/branches_api/branches_api.dart';
import 'package:rient_app/features/home/data/models/statistics/statistics.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/schedule/data/models/appointments_api/appointments_api.dart';
import 'package:rient_app/features/schedule/data/models/available_workers_api/available_workers_api.dart';
import 'package:rient_app/features/schedule/data/models/workers_api/workers_api.dart';
import 'package:rient_app/features/schedule/view/components/date_strip.dart';
import 'package:rient_app/features/schedule/view/components/month_calendar.dart';
import 'package:rient_app/features/schedule/view/components/schedule_calendar_day_multi_column.dart';
import 'package:rient_app/features/schedule/view/components/schedule_calendar_one_user_widget.dart';
import 'package:rient_app/features/schedule/view/components/specialist_list_view.dart';
import 'package:rient_app/features/schedule/view/components/specialist_select_dialog.dart';
import 'package:rient_app/features/schedule/view/components/view_mode_segmented_control.dart';
import 'package:rient_app/features/schedule/view/providers/appointments_provider.dart';
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
  final ScrollController _daySpecialistsScrollController = ScrollController();
  final ScrollController _dayCalendarScrollController = ScrollController();
  bool _syncingDayHorizontalScroll = false;

  @override
  void initState() {
    super.initState();
    _syncToNow();
    _daySpecialistsScrollController.addListener(_onSpecialistsScrolled);
    _dayCalendarScrollController.addListener(_onCalendarScrolled);
  }

  @override
  void dispose() {
    _daySpecialistsScrollController.removeListener(_onSpecialistsScrolled);
    _dayCalendarScrollController.removeListener(_onCalendarScrolled);
    _daySpecialistsScrollController.dispose();
    _dayCalendarScrollController.dispose();
    super.dispose();
  }

  void _onSpecialistsScrolled() {
    if (_syncingDayHorizontalScroll || !_dayCalendarScrollController.hasClients) {
      return;
    }
    final source = _daySpecialistsScrollController.position;
    final targetPosition = _dayCalendarScrollController.position;
    final target = source.pixels.clamp(
      targetPosition.minScrollExtent,
      targetPosition.maxScrollExtent,
    );
    if ((targetPosition.pixels - target).abs() < 0.5) return;
    _syncingDayHorizontalScroll = true;
    _dayCalendarScrollController.jumpTo(target);
    _syncingDayHorizontalScroll = false;
  }

  void _onCalendarScrolled() {
    if (_syncingDayHorizontalScroll || !_daySpecialistsScrollController.hasClients) {
      return;
    }
    final source = _dayCalendarScrollController.position;
    final targetPosition = _daySpecialistsScrollController.position;
    final target = source.pixels.clamp(
      targetPosition.minScrollExtent,
      targetPosition.maxScrollExtent,
    );
    if ((targetPosition.pixels - target).abs() < 0.5) return;
    _syncingDayHorizontalScroll = true;
    _daySpecialistsScrollController.jumpTo(target);
    _syncingDayHorizontalScroll = false;
  }

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
    // Если выбранный день не попадает в видимую неделю (например, вчера в режиме
    // «День», а навигатор показывает текущую неделю) — переносим на сегодня в
    // пределах этой недели, чтобы полоска и календарь совпадали.
    if (viewMode == ViewMode.week) {
      final ws = DateTime(weekStart.year, weekStart.month, weekStart.day);
      final sunday = ws.add(const Duration(days: 6));
      final cur = ref.read(selectedScheduleDateProvider);
      final curNorm = DateTime(cur.year, cur.month, cur.day);
      if (curNorm.isBefore(ws) || curNorm.isAfter(sunday)) {
        final n = DateTime.now();
        final today = DateTime(n.year, n.month, n.day);
        DateTime clamped;
        if (today.isBefore(ws)) {
          clamped = ws;
        } else if (today.isAfter(sunday)) {
          clamped = sunday;
        } else {
          clamped = today;
        }
        ref.read(selectedScheduleDateProvider.notifier).state = clamped;
      }
    }
  }

  static DateTime _toDateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  static DateTime _safeParseToLocal(String? raw, DateTime fallback) {
    if (raw == null || raw.isEmpty) return fallback;
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return fallback;
    return parsed.toLocal();
  }

  /// Цвета по статусу записи: 0 жёлтый, 1 фиолетовый, 2 зелёный, 3–4 красный.
  static ({Color backgroundColor, Color accentColor})
  _colorsForAppointmentStatus(int status) {
    switch (status) {
      case 0:
        return (
          backgroundColor: AppColors.lightYel,
          accentColor: AppColors.yel,
        );
      case 1:
        return (
          backgroundColor: AppColors.lightPurple,
          accentColor: AppColors.purple,
        );
      case 2:
        return (
          backgroundColor: AppColors.lightGreen,
          accentColor: AppColors.green,
        );
      case 3:
      case 4:
        return (
          backgroundColor: AppColors.lightRed,
          accentColor: AppColors.red,
        );
      default:
        return (
          backgroundColor: AppColors.lightGreen,
          accentColor: AppColors.green,
        );
    }
  }

  static ScheduleAppointmentItem _mapAppointmentToItem(
    AppointmentApi appointment,
  ) {
    final fallbackStart = _safeParseToLocal(
      appointment.datetime,
      DateTime.now(),
    );
    var start = fallbackStart;
    var end = start.add(const Duration(minutes: 30));

    if (appointment.services.isNotEmpty) {
      final first = appointment.services.first;
      start = _safeParseToLocal(first.datetime, fallbackStart);
      var maxEnd = start.add(
        Duration(
          minutes: first.totalDurationMinutes <= 0
              ? 30
              : first.totalDurationMinutes,
        ),
      );
      for (final service in appointment.services) {
        final serviceStart = _safeParseToLocal(service.datetime, start);
        final serviceEnd = serviceStart.add(
          Duration(
            minutes: service.totalDurationMinutes <= 0
                ? 30
                : service.totalDurationMinutes,
          ),
        );
        if (serviceEnd.isAfter(maxEnd)) {
          maxEnd = serviceEnd;
        }
      }
      end = maxEnd;
    }

    final serviceNames = appointment.services
        .map((s) => (s.name ?? '').trim())
        .where((name) => name.isNotEmpty)
        .toList();

    final subject = serviceNames.isEmpty ? 'Услуга' : serviceNames.join(', ');
    final notes = appointment.client?.fullName.isNotEmpty == true
        ? appointment.client!.fullName
        : '${appointment.worker?.firstName ?? ''} ${appointment.worker?.lastName ?? ''}'
              .trim();
    final hasComment = appointment.hasComment;
    final colors = _colorsForAppointmentStatus(appointment.status);

    return ScheduleAppointmentItem(
      id: appointment.id,
      source: appointment,
      startTime: start,
      endTime: end,
      subject: subject,
      notes: notes,
      backgroundColor: colors.backgroundColor,
      accentColor: colors.accentColor,
      hasComment: hasComment,
    );
  }

  static List<ScheduleAppointmentItem> _mapAppointmentsForRange(
    List<AppointmentApi> appointments,
    DateTime start,
    DateTime end,
  ) {
    final startDate = _toDateOnly(start);
    final endDate = _toDateOnly(end);
    final mapped = <ScheduleAppointmentItem>[];
    for (final appointment in appointments) {
      final date = _safeParseToLocal(appointment.datetime, startDate);
      final dateOnly = _toDateOnly(date);
      if (dateOnly.isBefore(startDate) || dateOnly.isAfter(endDate)) continue;
      mapped.add(_mapAppointmentToItem(appointment));
    }
    mapped.sort((a, b) => a.startTime.compareTo(b.startTime));
    return mapped;
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
      final isSameDay =
          patternDay == day || (day == 'wen' && patternDay == 'wed');
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
      minStart = minStart == null
          ? start
          : (start < minStart ? start : minStart);
      maxEnd = maxEnd == null ? end : (end > maxEnd ? end : maxEnd);
    }

    if (minStart == null || maxEnd == null || maxEnd <= minStart) {
      return (startHour: 9.0, endHour: 21.0);
    }

    return (startHour: minStart, endHour: maxEnd);
  }

  static ({String? breakStart, String? breakEnd}) _breakForSpecialist(
    List<AvailableWorkerShift> shifts,
    int? specialistId,
  ) {
    if (shifts.isEmpty) {
      return (breakStart: null, breakEnd: null);
    }
    AvailableWorkerShift? shift;
    if (specialistId == null) {
      shift = shifts.first;
    } else {
      for (final item in shifts) {
        if (item.worker.id == specialistId) {
          shift = item;
          break;
        }
      }
    }
    return (breakStart: shift?.breakStart, breakEnd: shift?.breakEnd);
  }

  static ({double? start, double? end}) _workerShiftHoursForId(
    List<AvailableWorkerShift> shifts,
    int workerId,
  ) {
    for (final s in shifts) {
      if (s.worker.id != workerId) continue;
      if (s.timeStart.isEmpty || s.timeEnd.isEmpty) {
        return (start: null, end: null);
      }
      final start = _timeToHour(s.timeStart);
      final end = _timeToHour(s.timeEnd);
      if (end <= start) return (start: null, end: null);
      return (start: start, end: end);
    }
    return (start: null, end: null);
  }

  static int? _weekdayFromPatternDay(String? day) {
    switch ((day ?? '').toLowerCase()) {
      case 'mon':
        return DateTime.monday;
      case 'tue':
        return DateTime.tuesday;
      case 'wen':
      case 'wed':
        return DateTime.wednesday;
      case 'thu':
        return DateTime.thursday;
      case 'fri':
        return DateTime.friday;
      case 'sat':
        return DateTime.saturday;
      case 'sun':
        return DateTime.sunday;
      default:
        return null;
    }
  }

  static Map<int, ({double startHour, double endHour})> _workHoursByWeekday(
    List<SchedulePattern> patterns,
  ) {
    final result = <int, ({double startHour, double endHour})>{};
    for (final pattern in patterns) {
      if (!(pattern.active ?? false)) continue;
      final weekday = _weekdayFromPatternDay(pattern.day);
      if (weekday == null) continue;
      final start = _timeToHour(pattern.timeStart);
      final end = _timeToHour(pattern.timeEnd);
      if (start <= 0 || end <= 0 || end <= start) continue;
      result[weekday] = (startHour: start, endHour: end);
    }
    return result;
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
    final availableWorkersAsync = ref.watch(
      availableWorkersForDateProvider(selectedDate),
    );
    final availableWorkersLoading = availableWorkersAsync.isLoading;
    final weekKey = scheduleWeekKey(
      _viewMode == ViewMode.day ? selectedDate : _weekStart,
    );
    final monthKey = scheduleMonthKey(_monthStart);
    final weekStatisticsAsync = ref.watch(
      scheduleStatisticsForWeekProvider(weekKey),
    );
    final occupancyByDay = weekStatisticsAsync.value?.occupancyByDay ?? [];
    final weekStatisticsLoading = weekStatisticsAsync.isLoading;
    final monthStatisticsAsync = ref.watch(
      scheduleStatisticsForMonthProvider(monthKey),
    );
    final monthOccupancyByDay =
        monthStatisticsAsync.value?.occupancyByDay ?? [];
    final monthStatisticsLoading = monthStatisticsAsync.isLoading;
    final monthAppointmentsByDay =
        monthStatisticsAsync.value?.appointmentsByDay ?? [];
    final slotsByDay = _slotsByDayFromAppointments(
      monthAppointmentsByDay,
      _monthStart,
    );
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
    final selectedSpecialistId = initialSelected?.id;
    final selectedBreak = _breakForSpecialist(
      availableWorkersAsync.value ?? const [],
      selectedSpecialistId,
    );
    final selectedWorkerHours = selectedSpecialistId != null
        ? _workerShiftHoursForId(
            availableWorkersAsync.value ?? const [],
            selectedSpecialistId,
          )
        : (start: null, end: null);
    final weekWorkHours = _workHoursForWeek(
      currentBranch?.schedulePatterns ?? const [],
    );
    final weekWorkHoursByWeekday = _workHoursByWeekday(
      currentBranch?.schedulePatterns ?? const [],
    );
    final dayStart = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    final dayEnd = dayStart
        .add(const Duration(days: 1))
        .subtract(const Duration(milliseconds: 1));
    final weekStartDate = DateTime(
      _weekStart.year,
      _weekStart.month,
      _weekStart.day,
    );
    final weekEndDate = weekStartDate
        .add(const Duration(days: 7))
        .subtract(const Duration(milliseconds: 1));
    final multiDayColumns =
        _viewMode == ViewMode.day && specialists.isNotEmpty;
    final dayAppsBySpecialistIndex = multiDayColumns
        ? <AsyncValue<List<AppointmentApi>>>[
            for (var i = 0; i < specialists.length; i++)
              ref.watch(
                scheduleAppointmentsProvider(
                  AppointmentsQuery(
                    workerId: specialists[i].id,
                    dateTimeGte: dayStart,
                    dateTimeLte: dayEnd,
                  ),
                ),
              ),
          ]
        : const <AsyncValue<List<AppointmentApi>>>[];
    final dayAppointmentsSingleAsync = multiDayColumns
        ? const AsyncValue.data(<AppointmentApi>[])
        : ref.watch(
            scheduleAppointmentsProvider(
              AppointmentsQuery(
                workerId: selectedSpecialistId,
                dateTimeGte: dayStart,
                dateTimeLte: dayEnd,
              ),
            ),
          );
    final weekAppointmentsAsync = ref.watch(
      scheduleAppointmentsProvider(
        AppointmentsQuery(
          workerId: selectedSpecialistId,
          dateTimeGte: weekStartDate,
          dateTimeLte: weekEndDate,
        ),
      ),
    );
    final dayItems = _mapAppointmentsForRange(
      dayAppointmentsSingleAsync.value ?? const [],
      dayStart,
      dayEnd,
    );
    final weekItems = _mapAppointmentsForRange(
      weekAppointmentsAsync.value ?? const [],
      weekStartDate,
      weekEndDate,
    );
    final dayAppointmentsLoading = multiDayColumns
        ? dayAppsBySpecialistIndex.any((a) => a.isLoading)
        : dayAppointmentsSingleAsync.isLoading;
    final showGlobalLoader =
        availableWorkersLoading ||
        (_viewMode == ViewMode.day && dayAppointmentsLoading) ||
        (_viewMode == ViewMode.week && weekAppointmentsAsync.isLoading) ||
        (_viewMode == ViewMode.week && weekStatisticsLoading) ||
        (_viewMode == ViewMode.month && monthStatisticsLoading);

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
                  ref.read(selectedScheduleDateProvider.notifier).state =
                      DateTime(date.year, date.month, date.day);
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
                            if (specialists.isNotEmpty)
                              Padding(
                                padding: AppDecoration.padding16,
                                child: SpecialistListView(
                                  specialists: specialists,
                                  scrollController: _daySpecialistsScrollController,
                                ),
                              ),
                            Expanded(
                              child: specialists.isNotEmpty
                                  ? ScheduleCalendarDayMultiColumn(
                                      key: ValueKey(
                                        'schedule_day_multi_${scheduleDateKey(selectedDate)}',
                                      ),
                                      date: selectedDate,
                                      branchStartHour: dayWorkHours.startHour,
                                      branchEndHour: dayWorkHours.endHour,
                                      horizontalScrollController:
                                          _dayCalendarScrollController,
                                      columnWidth: 114,
                                      columns: () {
                                        final shifts =
                                            availableWorkersAsync.value ??
                                            const [];
                                        return [
                                          for (
                                            var i = 0;
                                            i < specialists.length;
                                            i++
                                          )
                                            ScheduleCalendarDayColumn(
                                              workerId: specialists[i].id!,
                                              name: specialists[i].name,
                                              items: _mapAppointmentsForRange(
                                                dayAppsBySpecialistIndex[i]
                                                        .value ??
                                                    const [],
                                                dayStart,
                                                dayEnd,
                                              ),
                                              breakStart: _breakForSpecialist(
                                                shifts,
                                                specialists[i].id,
                                              ).breakStart,
                                              breakEnd: _breakForSpecialist(
                                                shifts,
                                                specialists[i].id,
                                              ).breakEnd,
                                              workerStartHour:
                                                  _workerShiftHoursForId(
                                                    shifts,
                                                    specialists[i].id!,
                                                  ).start,
                                              workerEndHour:
                                                  _workerShiftHoursForId(
                                                    shifts,
                                                    specialists[i].id!,
                                                  ).end,
                                            ),
                                        ];
                                      }(),
                                      onAppointmentTap: (item) {
                                        final appointment = item.source;
                                        if (appointment == null) return;
                                        context.pushNamed(
                                          AddNewEntryPage.name,
                                          extra: appointment,
                                        );
                                      },
                                    )
                                  : ScheduleCalendarOneUserWidget(
                                      key: ValueKey(
                                        'schedule_day_${scheduleDateKey(selectedDate)}',
                                      ),
                                      date: selectedDate,
                                      items: dayItems,
                                      viewMode: ViewMode.day,
                                      startHour: dayWorkHours.startHour,
                                      endHour: dayWorkHours.endHour,
                                      breakStart: selectedBreak.breakStart,
                                      breakEnd: selectedBreak.breakEnd,
                                      workerStartHour:
                                          selectedWorkerHours.start,
                                      workerEndHour: selectedWorkerHours.end,
                                      onAppointmentTap: (item) {
                                        final appointment = item.source;
                                        if (appointment == null) return;
                                        context.pushNamed(
                                          AddNewEntryPage.name,
                                          extra: appointment,
                                        );
                                      },
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
                                        visibleWeekStart: _weekStart,
                                        onDateSelected: null,
                                        showFullDateLabel: false,
                                        useGreyCircles: true,
                                        occupancyByDay: occupancyByDay,
                                      ),
                                    ),
                                    Expanded(
                                      child: ScheduleCalendarOneUserWidget(
                                        key: ValueKey('schedule_week_$weekKey'),
                                        date: _weekStart,
                                        items: weekItems,
                                        viewMode: ViewMode.week,
                                        startHour: weekWorkHours.startHour,
                                        endHour: weekWorkHours.endHour,
                                        weekWorkHoursByWeekday:
                                            weekWorkHoursByWeekday,
                                        breakStart: selectedBreak.breakStart,
                                        breakEnd: selectedBreak.breakEnd,
                                        onAppointmentTap: (item) {
                                          final appointment = item.source;
                                          if (appointment == null) return;
                                          context.pushNamed(
                                            AddNewEntryPage.name,
                                            extra: appointment,
                                          );
                                        },
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
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}
