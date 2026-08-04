import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/models/worker_entity_labels.dart';
import 'package:rient_app/core/providers/worker_entity_labels_provider.dart';
import 'package:rient_app/core/services/local_storage.dart';
import 'package:rient_app/core/utils/appointment_backdate.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/app_exit_handler.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/widgets/app_refresh_indicator.dart';
import 'package:rient_app/core/widgets/schedule_offline_banner.dart';
import 'package:rient_app/core/widgets/top_panel.dart';
import 'package:rient_app/features/schedule/service/schedule_offline_sync_service.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_offline_provider.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/create/view/add_new_entry_page.dart';
import 'package:rient_app/features/home/data/models/branches_api/branches_api.dart';
import 'package:rient_app/features/home/view/providers/current_worker_id_provider.dart';
import 'package:rient_app/features/home/view/providers/worker_permissions_provider.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/home/view/providers/organization_settings_provider.dart';
import 'package:rient_app/features/schedule/data/models/appointments_api/appointments_api.dart';
import 'package:rient_app/features/schedule/data/models/available_workers_api/available_workers_api.dart';
import 'package:rient_app/features/schedule/data/models/schedules_api/schedules_api.dart';
import 'package:rient_app/features/schedule/data/models/workers_api/workers_api.dart';
import 'package:rient_app/features/schedule/view/components/date_strip.dart';
import 'package:rient_app/features/schedule/view/components/month_calendar.dart';
import 'package:rient_app/features/schedule/view/components/schedule_calendar_day_multi_column.dart'
    show
        ScheduleCalendarDayColumn,
        ScheduleCalendarDayMultiColumn,
        scheduleDaySpecialistColumnWidth,
        scheduleDaySpecialistLeadingInset,
        scheduleDaySpecialistRowHorizontalPadding;
import 'package:rient_app/features/schedule/view/components/schedule_calendar_one_user_widget.dart';
import 'package:rient_app/features/schedule/view/components/specialist_list_view.dart';
import 'package:rient_app/features/schedule/view/components/specialist_select_dialog.dart';
import 'package:rient_app/features/schedule/view/components/view_mode_segmented_control.dart';
import 'package:rient_app/features/schedule/view/providers/appointments_provider.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_cell_interval_provider.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_statistics_provider.dart';
import 'package:rient_app/features/schedule/view/providers/schedules_provider.dart';
import 'package:rient_app/features/schedule/view/providers/work_schedule_provider.dart';
import 'package:rient_app/features/schedule/view/providers/worker_schedules_range_provider.dart';
import 'package:rient_app/features/schedule/utils/schedule_branch_bounds.dart';
import 'package:rient_app/features/schedule/utils/worker_schedule_template.dart';
import 'package:rient_app/features/schedule/utils/worker_work_day.dart';
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
  int _refreshVersion = 0;
  Brightness? _lastBrightness;
  final ScrollController _daySpecialistsScrollController = ScrollController();
  final ScrollController _dayCalendarScrollController = ScrollController();
  bool _syncingDayHorizontalScroll = false;
  int? _dayViewSingleWorkerId;

  bool _initialOfflineSyncScheduled = false;

  @override
  void initState() {
    super.initState();
    _syncToNow();
    _daySpecialistsScrollController.addListener(_onSpecialistsScrolled);
    _dayCalendarScrollController.addListener(_onCalendarScrolled);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(ref.read(organizationSettingsProvider.future));
      unawaited(_restoreSelectedSpecialistFromStorage());
    });
  }

  Future<void> _restoreSelectedSpecialistFromStorage() async {
    if (ref.read(restoredSpecialistSelectionProvider)) return;
    final storage = ref.read(localStorageProvider);
    final idStr = await storage.getString(selectedSpecialistIdStorageKey);
    final id = int.tryParse(idStr ?? '');
    if (id != null && id > 0 && mounted) {
      ref.read(selectedSpecialistIdProvider.notifier).state = id;
      _dayViewSingleWorkerId = id;
    }
    if (mounted) {
      ref.read(restoredSpecialistSelectionProvider.notifier).state = true;
    }
  }

  @override
  void dispose() {
    _daySpecialistsScrollController.removeListener(_onSpecialistsScrolled);
    _dayCalendarScrollController.removeListener(_onCalendarScrolled);
    _daySpecialistsScrollController.dispose();
    _dayCalendarScrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentBrightness = Theme.of(context).brightness;
    if (_lastBrightness == null) {
      _lastBrightness = currentBrightness;
      return;
    }
    if (_lastBrightness != currentBrightness) {
      _lastBrightness = currentBrightness;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _forceRefreshScheduleScreen();
      });
    }
  }

  void _onSpecialistsScrolled() {
    if (_syncingDayHorizontalScroll ||
        !_dayCalendarScrollController.hasClients) {
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
    if (_syncingDayHorizontalScroll ||
        !_daySpecialistsScrollController.hasClients) {
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

  void _bumpScheduleUiVersion() {
    if (!mounted) return;
    setState(() => _refreshVersion++);
  }

  static List<SpecialistItem> _allWorkersToSpecialists(
    List<WorkerApi> allWorkers,
    WorkerEntityLabels labels,
  ) {
    return [
      for (final worker in allWorkers)
        SpecialistItem(
          name: labels.personDisplayName(
            '${worker.firstName ?? ''} ${worker.lastName ?? ''}'.trim(),
          ),
          role: worker.specialization ?? '',
          id: worker.id,
          pictureUrl: worker.pictureThumbnail ?? worker.picture,
        ),
    ];
  }

  /// В оффлайне оставляем состав списка, но берём локальные аватарки из кэша.
  static List<SpecialistItem> _withOfflineLocalPictures(
    List<SpecialistItem> specialists,
    List<SpecialistItem>? cachedSpecialists,
  ) {
    if (specialists.isEmpty ||
        cachedSpecialists == null ||
        cachedSpecialists.isEmpty) {
      return specialists;
    }
    final localById = <int, String>{};
    for (final item in cachedSpecialists) {
      final id = item.id;
      final url = item.pictureUrl?.trim();
      if (id == null || id <= 0 || url == null || url.isEmpty) continue;
      localById[id] = url;
    }
    if (localById.isEmpty) return specialists;
    return [
      for (final item in specialists)
        SpecialistItem(
          name: item.name,
          role: item.role,
          id: item.id,
          pictureUrl: (item.id != null ? localById[item.id!] : null) ??
              item.pictureUrl,
        ),
    ];
  }

  static SpecialistItem? _specialistById(
    int? workerId,
    List<WorkerApi> allWorkers,
    WorkerEntityLabels labels,
  ) {
    if (workerId == null || workerId <= 0) return null;
    for (final worker in allWorkers) {
      if (worker.id == workerId) {
        return SpecialistItem(
          name: labels.personDisplayName(
            '${worker.firstName ?? ''} ${worker.lastName ?? ''}'.trim(),
          ),
          role: worker.specialization ?? '',
          id: worker.id,
          pictureUrl: worker.pictureThumbnail ?? worker.picture,
        );
      }
    }
    return null;
  }

  /// Работает ли филиал в день: дневная запись `/schedules/`, иначе шаблон недели.
  static bool _isBranchWorkingOnDate(
    DateTime date,
    List<SchedulePattern> patterns,
    List<ScheduleItemApi> daySchedules,
  ) {
    final daily = pickPreferredDailySchedule(
      daySchedules.where((s) => s.workerId == null),
      date,
    );
    if (daily != null) {
      return daily.active;
    }
    final day = _weekdayKey(date);
    for (final item in patterns) {
      final patternDay = (item.day ?? '').toLowerCase();
      final isSameDay =
          patternDay == day || (day == 'wen' && patternDay == 'wed');
      if (isSameDay) return item.active ?? false;
    }
    return false;
  }

  /// Кто работает в выбранный день — та же логика, что штриховка в «Неделя».
  static List<SpecialistItem> _daySpecialistsFromSchedule({
    required DateTime date,
    required List<WorkerApi> allWorkers,
    required Map<int, Set<int>> workerWeekdaysById,
    required Map<int, WorkerScheduleTemplate> templates,
    required List<ScheduleItemApi> daySchedules,
    required List<SchedulePattern> branchPatterns,
    required WorkerEntityLabels labels,
    required bool scheduleReady,
  }) {
    if (!scheduleReady) return const [];
    if (!_isBranchWorkingOnDate(date, branchPatterns, daySchedules)) {
      return const [];
    }

    final specialists = <SpecialistItem>[];
    for (final worker in allWorkers) {
      final workerId = worker.id;
      final daily = pickPreferredDailySchedule(
        daySchedules.where((s) => s.workerId == workerId),
        date,
      );
      if (!isWorkerWorkingOnDate(
        date: date,
        workingWeekdays: workerWeekdaysById[workerId] ?? const {},
        daily: daily,
        shiftConfig: templates[workerId]?.shiftConfig,
      )) {
        continue;
      }
      specialists.add(
        SpecialistItem(
          name: labels.personDisplayName(
            '${worker.firstName ?? ''} ${worker.lastName ?? ''}'.trim(),
          ),
          role: worker.specialization ?? '',
          id: workerId,
          pictureUrl: worker.pictureThumbnail ?? worker.picture,
        ),
      );
    }
    return specialists;
  }

  void _syncToNow() {
    final now = DateTime.now();
    _weekStart = _mondayOf(now);
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
    if (viewMode == ViewMode.day) {
      final selected = ref.read(selectedScheduleDateProvider);
      final monday = _mondayOf(selected);
      if (_mondayOf(_weekStart) != monday) {
        setState(() => _weekStart = monday);
      }
    }
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

  void _switchToDayMode(DateTime date) {
    final normalized = _toDateOnly(date);
    setState(() {
      _viewMode = ViewMode.day;
      _weekStart = _mondayOf(normalized);
      _monthStart = DateTime(normalized.year, normalized.month, 1);
    });
    ref.read(selectedScheduleDateProvider.notifier).state = normalized;
  }

  static DateTime _toDateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  static DateTime _mondayOf(DateTime date) {
    final normalized = _toDateOnly(date);
    return normalized.subtract(Duration(days: normalized.weekday - 1));
  }

  static ({DateTime start, DateTime end}) _scheduleRangeBounds({
    required ViewMode viewMode,
    required DateTime weekStart,
    required DateTime monthStart,
  }) {
    if (viewMode == ViewMode.month) {
      final start = DateTime(monthStart.year, monthStart.month, 1);
      final end = DateTime(monthStart.year, monthStart.month + 1, 0);
      return (start: start, end: end);
    }
    final monday = _toDateOnly(weekStart);
    return (start: monday, end: monday.add(const Duration(days: 6)));
  }

  /// После создания/редактирования записи — только записи и статистика.
  void _refreshScheduleAppointmentsOnly() {
    ref.invalidate(scheduleAppointmentsProvider);
    ref.invalidate(scheduleStatisticsForWeekProvider);
    ref.invalidate(scheduleStatisticsForMonthProvider);
    _bumpScheduleUiVersion();
  }

  void _deferForceRefreshScheduleScreen() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _forceRefreshScheduleScreen();
    });
  }

  void _forceRefreshScheduleScreen() {
    final selectedDate = ref.read(selectedScheduleDateProvider);
    ref.invalidate(workerEntityLabelsProvider);
    ref.invalidate(scheduleAppointmentsProvider);
    final weekAnchor = _toDateOnly(
      _viewMode == ViewMode.day ? _mondayOf(selectedDate) : _weekStart,
    );
    final monday =
        weekAnchor.subtract(Duration(days: weekAnchor.weekday - 1));
    for (var i = 0; i < 7; i++) {
      ref.invalidate(
        availableWorkersForDateProvider(
          monday.add(Duration(days: i)),
        ),
      );
    }
  ref.invalidate(scheduleStatisticsForWeekProvider);
  ref.invalidate(scheduleStatisticsForMonthProvider);
  ref.invalidate(scheduleWorkerScheduleRowsProvider);
  ref.invalidate(scheduleWorkersProvider);
    ref.invalidate(workerScheduleTemplatesByIdProvider);
    ref.invalidate(workerWeekdaysByIdProvider);
    ref.invalidate(workerSchedulesRangeProvider);
    ref.invalidate(scheduleForDateProvider);

    _bumpScheduleUiVersion();
  }

  Future<void> _onPullToRefresh() async {
    final recovered = await tryRecoverScheduleNetwork(ref);
    if (!recovered) return;

    await ref.read(scheduleOfflineSyncServiceProvider).syncIfOnline();
    _forceRefreshScheduleScreen();
    final selectedDate = ref.read(selectedScheduleDateProvider);
    final normalizedDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    final specialistId = ref.read(selectedSpecialistIdProvider);
    final range = _scheduleRangeBounds(
      viewMode: _viewMode,
      weekStart: _weekStart,
      monthStart: _monthStart,
    );

    final reloads = <Future<Object?>>[
      ref.read(scheduleWorkersProvider.future),
      ref.read(availableWorkersForDateProvider(normalizedDate).future),
      ref.read(scheduleForDateProvider(scheduleDateKey(normalizedDate)).future),
      ref.read(
        scheduleStatisticsForWeekProvider(
          ScheduleStatisticsQuery(periodKey: scheduleWeekKey(normalizedDate)),
        ).future,
      ),
    ];

    if (specialistId != null && specialistId > 0) {
      reloads.add(
        ref.read(
          workerSchedulesRangeProvider(
            WorkerSchedulesRangeQuery(
              workerId: specialistId,
              rangeStart: range.start,
              rangeEnd: range.end,
            ),
          ).future,
        ),
      );
    }

    if (_viewMode == ViewMode.day) {
      final dayStart = normalizedDate;
      final dayEnd = dayStart
          .add(const Duration(days: 1))
          .subtract(const Duration(milliseconds: 1));
      if (specialistId != null && specialistId > 0) {
        reloads.add(
          ref.read(
            scheduleAppointmentsProvider(
              AppointmentsQuery(
                workerId: specialistId,
                dateTimeGte: dayStart,
                dateTimeLte: dayEnd,
              ),
            ).future,
          ),
        );
      }
    }

    try {
      await Future.wait(reloads);
    } catch (_) {}
    if (mounted) _bumpScheduleUiVersion();
  }

  /// После экрана записи: обновление уже сделано при сохранении/удалении (pop true).
  void _onReturnFromAddEntryPage(bool? changed) {
    if (!mounted) return;
    if (changed != true) {
      _refreshScheduleAppointmentsOnly();
    }
  }

  Future<void> _openAddEntryFromEmptySlot({
    required AddNewEntryInitialData extra,
  }) async {
    final changed = await context.pushNamed<bool>(
      AddNewEntryPage.name,
      extra: extra,
    );
    _onReturnFromAddEntryPage(changed);
  }

  void _tryOpenEmptySlot({
    required bool scheduleReadOnly,
    required bool canCreateSchedule,
    required bool allowBackdatedAppointments,
    required AddNewEntryInitialData extra,
  }) {
    if (scheduleReadOnly || !canCreateSchedule) return;
    final startDateTime = extra.startDateTime;
    if (startDateTime != null &&
        !canCreateAppointmentAtSlot(
          dateTime: startDateTime,
          allowBackdatedAppointments: allowBackdatedAppointments,
        )) {
      return;
    }
    unawaited(_openAddEntryFromEmptySlot(extra: extra));
  }

  bool _canTapEmptySlot({
    required bool scheduleReadOnly,
    required bool canCreateSchedule,
    required bool allowBackdatedAppointments,
    required DateTime dateTime,
  }) {
    if (scheduleReadOnly || !canCreateSchedule) return false;
    return canCreateAppointmentAtSlot(
      dateTime: dateTime,
      allowBackdatedAppointments: allowBackdatedAppointments,
    );
  }

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

  static String _appointmentNotes(AppointmentApi appointment) {
    return appointment.client?.fullName.isNotEmpty == true
        ? appointment.client!.fullName
        : '${appointment.worker?.firstName ?? ''} ${appointment.worker?.lastName ?? ''}'
              .trim();
  }

  static ScheduleAppointmentItem _mapAppointmentToItem(
    AppointmentApi appointment,
  ) {
    final range = appointment.mergedScheduleRangeLocal();
    final serviceNames = appointment.services
        .map((s) => (s.name ?? '').trim())
        .where((name) => name.isNotEmpty)
        .toList();
    final subject = serviceNames.isEmpty ? 'Услуга' : serviceNames.join(', ');
    final colors = _colorsForAppointmentStatus(appointment.status);

    return ScheduleAppointmentItem(
      id: appointment.id,
      source: appointment,
      startTime: range.start,
      endTime: range.end,
      subject: subject,
      notes: _appointmentNotes(appointment),
      backgroundColor: colors.backgroundColor,
      accentColor: colors.accentColor,
      leftBorderColor: appointment.isUnpaidClientArrived
          ? AppColors.yel
          : colors.accentColor,
      hasComment: appointment.hasComment,
      hasInventory: appointment.hasServiceInventory,
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
      if (!appointment.overlapsScheduleDateRange(startDate, endDate)) continue;
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

  /// Часы филиала на дату: дневная запись `/schedules/`, иначе шаблон недели.
  static ({double startHour, double endHour}) _branchWorkHoursForDate({
    required DateTime date,
    required List<SchedulePattern> patterns,
    required List<ScheduleItemApi> daySchedules,
  }) {
    final daily = pickPreferredDailySchedule(
      daySchedules.where((s) => s.workerId == null),
      date,
    );
    if (daily != null && daily.active) {
      final start = _timeToHour(daily.timeStartShort);
      final end = _timeToHour(daily.timeEndShort);
      if (start > 0 && end > start) {
        return (startHour: start, endHour: end);
      }
    }
    return _workHoursForDate(date, patterns);
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

  /// Перерывы по дням недели из дневного графика (не дублировать на все 7 дней).
  static Map<DateTime, ({String? breakStart, String? breakEnd})> _breaksByDayForWeek({
    required DateTime weekStart,
    required WorkerSchedulesRangeData? schedules,
    DateTime? selectedDate,
    ({String? breakStart, String? breakEnd})? selectedDayBreak,
  }) {
    final normalizedWeekStart = _toDateOnly(weekStart);
    final selectedDay =
        selectedDate == null ? null : _toDateOnly(selectedDate);
    final result = <DateTime, ({String? breakStart, String? breakEnd})>{};

    for (var i = 0; i < 7; i++) {
      final day = normalizedWeekStart.add(Duration(days: i));
      final daily = schedules?.scheduleOn(day);
      if (daily != null && daily.active) {
        result[day] = resolveWorkerBreakForDate(
          daily: daily,
          fallbackBreakStart: null,
          fallbackBreakEnd: null,
        );
        continue;
      }
      if (selectedDay != null &&
          day == selectedDay &&
          selectedDayBreak != null &&
          selectedDayBreak.breakStart != null &&
          selectedDayBreak.breakStart!.isNotEmpty &&
          selectedDayBreak.breakEnd != null &&
          selectedDayBreak.breakEnd!.isNotEmpty) {
        result[day] = selectedDayBreak;
      }
    }
    return result;
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

  static ({String? breakStart, String? breakEnd}) _breakForDate({
    required ScheduleItemApi? daily,
    required List<AvailableWorkerShift> shifts,
    int? specialistId,
  }) {
    final fallback = _breakForSpecialist(shifts, specialistId);
    return resolveWorkerBreakForDate(
      daily: daily,
      fallbackBreakStart: fallback.breakStart,
      fallbackBreakEnd: fallback.breakEnd,
    );
  }

  static ({double? start, double? end}) _workerShiftHoursForId(
    List<AvailableWorkerShift> shifts,
    int workerId, {
    ({double startHour, double endHour})? branchHours,
  }) {
    for (final s in shifts) {
      if (s.worker.id != workerId) continue;
      if (s.timeStart.isEmpty || s.timeEnd.isEmpty) {
        return (start: null, end: null);
      }
      final start = _timeToHour(s.timeStart);
      final end = _timeToHour(s.timeEnd);
      if (end <= start) return (start: null, end: null);
      if (branchHours != null) {
        final clamped = intersectWorkerShiftHoursWithBranch(
          workerStart: start,
          workerEnd: end,
          branchStart: branchHours.startHour,
          branchEnd: branchHours.endHour,
        );
        if (clamped == null) return (start: null, end: null);
        return (start: clamped.start, end: clamped.end);
      }
      return (start: start, end: end);
    }
    return (start: null, end: null);
  }

  /// День «все мастера»: сначала смена из available_workers, затем `/schedules/`.
  static ({double? start, double? end}) _adminMultiColumnWorkerHours({
    required int workerId,
    required List<AvailableWorkerShift> shifts,
    required DateTime date,
    required Set<int> workingWeekdays,
    ScheduleItemApi? daily,
    Map<String, dynamic>? shiftConfig,
    required ({double startHour, double endHour}) branchHours,
  }) {
    final byShift = _workerShiftHoursForId(
      shifts,
      workerId,
      branchHours: branchHours,
    );
    if (byShift.start != null && byShift.end != null) return byShift;

    return workerShiftHoursForDate(
      date: date,
      workingWeekdays: workingWeekdays,
      daily: daily,
      shiftConfig: shiftConfig,
      branchStartHour: branchHours.startHour,
      branchEndHour: branchHours.endHour,
    );
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

  /// Количество активных записей по дням месяца (как в дневном/недельном виде).
  static Map<int, int> _slotsByDayFromActiveAppointments(
    List<AppointmentApi> appointments,
    DateTime month, {
    bool Function(DateTime date)? isNonWorkingDay,
  }) {
    final result = <int, int>{};
    final year = month.year;
    final monthNum = month.month;
    for (final appointment in appointments) {
      if (!appointment.isActive) continue;
      final primary = appointment.schedulePrimaryDateTimeLocal;
      final dateOnly = _toDateOnly(
        primary ?? _safeParseToLocal(appointment.datetime, month),
      );
      if (dateOnly.year != year || dateOnly.month != monthNum) continue;
      if (isNonWorkingDay != null && isNonWorkingDay(dateOnly)) continue;
      result[dateOnly.day] = (result[dateOnly.day] ?? 0) + 1;
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenBackground = isDark
        ? AppColors.secondaryDarkLight
        : AppColors.tabBarScreenBackground;
    final isScheduleOffline = ref.watch(scheduleOfflineModeProvider);
    final branchesAsync = ref.watch(branchesProvider);
    final workersAsync = ref.watch(scheduleWorkersProvider);
    final offlineSpecialistsAsync = ref.watch(scheduleOfflineSpecialistsProvider);
    final roleId = ref.watch(roleProvider);
    final isWorkerRole = roleId == UserRole.worker.value;
    final workerPermissions = ref.watch(workerPermissionsProvider).maybeWhen(
          data: (v) => v,
          orElse: () => null,
        );
    final canCreateSchedule = workerPermissions?.createSchedule ?? true;
    final allowBackdatedAppointments = ref.watch(allowBackdatedAppointmentsProvider);
    final scheduleReadOnly = isScheduleOffline;
    bool canTapEmptySlot(DateTime dateTime) => _canTapEmptySlot(
          scheduleReadOnly: scheduleReadOnly,
          canCreateSchedule: canCreateSchedule,
          allowBackdatedAppointments: allowBackdatedAppointments,
          dateTime: dateTime,
        );

    if (!_initialOfflineSyncScheduled) {
      _initialOfflineSyncScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        unawaited(ref.read(scheduleOfflineSyncServiceProvider).syncIfOnline());
      });
    }
    final currentWorkerIdAsync = ref.watch(currentWorkerIdProvider);
    final currentWorkerId = currentWorkerIdAsync.value;
    final currentBranch = ref.watch(currentBranchProvider);
    final scheduleCellIntervalMinutes = ref.watch(
      scheduleCellIntervalMinutesProvider,
    );
    final selectedDate = ref.watch(selectedScheduleDateProvider);
    final normalizedSelectedDate = dateOnly(selectedDate);
    final workerWeekdaysAsync = ref.watch(workerWeekdaysByIdProvider);
    final workerWeekdaysById = workerWeekdaysAsync.hasValue
        ? workerWeekdaysAsync.requireValue
        : const <int, Set<int>>{};
    final workerTemplatesAsync = ref.watch(workerScheduleTemplatesByIdProvider);
    final workerScheduleTemplatesById = workerTemplatesAsync.hasValue
        ? workerTemplatesAsync.requireValue
        : const <int, WorkerScheduleTemplate>{};
    final availableWorkersAsync = ref.watch(
      availableWorkersForDateProvider(normalizedSelectedDate),
    );
    final scheduleForDayAsync = ref.watch(
      scheduleForDateProvider(scheduleDateKey(normalizedSelectedDate)),
    );
    final dayBranchSchedules =
        scheduleForDayAsync.value?.results ?? const <ScheduleItemApi>[];
    final branchPatterns = currentBranch?.schedulePatterns ?? const [];
    final dayScheduleReady = workerWeekdaysAsync.hasValue &&
        workerTemplatesAsync.hasValue &&
        scheduleForDayAsync.hasValue;
    final isAdminDayView = !isWorkerRole && _viewMode == ViewMode.day;
    final dayViewDetailsLoading =
        !isScheduleOffline && isAdminDayView && !dayScheduleReady;
    final weekKey = scheduleWeekKey(
      _viewMode == ViewMode.day ? selectedDate : _weekStart,
    );
    final monthKey = scheduleMonthKey(_monthStart);
    final workerLabels =
        ref.watch(workerEntityLabelsProvider).value ??
        WorkerEntityLabels.defaults;
    final allWorkers = workersAsync.value?.results ?? const <WorkerApi>[];
    final specialistsOnSelectedDate = _viewMode == ViewMode.day
        ? _daySpecialistsFromSchedule(
            date: normalizedSelectedDate,
            allWorkers: allWorkers,
            workerWeekdaysById: workerWeekdaysById,
            templates: workerScheduleTemplatesById,
            daySchedules: dayBranchSchedules,
            branchPatterns: branchPatterns,
            labels: workerLabels,
            scheduleReady: dayScheduleReady,
          )
        : const <SpecialistItem>[];
    final allBranchSpecialists =
        _allWorkersToSpecialists(allWorkers, workerLabels);
    final savedSelectedId = ref.watch(selectedSpecialistIdProvider);
    var specialists = isWorkerRole
        ? specialistsOnSelectedDate
            .where((s) => s.id == currentWorkerId)
            .toList()
        : isAdminDayView
        ? specialistsOnSelectedDate
        : allBranchSpecialists;
    // Один мастер в «День»: на выходной сохраняем контекст только онлайн после загрузки дня.
    if (!isScheduleOffline &&
        isAdminDayView &&
        specialistsOnSelectedDate.length <= 1 &&
        dayScheduleReady &&
        specialistsOnSelectedDate.isEmpty) {
      final persistId = _dayViewSingleWorkerId ?? savedSelectedId;
      if (persistId != null && persistId > 0) {
        final saved = _specialistById(
          persistId,
          allWorkers,
          workerLabels,
        );
        if (saved != null && !specialists.any((s) => s.id == persistId)) {
          specialists = [saved, ...specialists];
        }
      }
    }
    if (isScheduleOffline) {
      if (isWorkerRole) {
        final workerFilterId = currentWorkerId ?? savedSelectedId;
        if (workerFilterId != null) {
          specialists = allBranchSpecialists
              .where((s) => s.id == workerFilterId)
              .toList();
        }
      } else if (!isAdminDayView && specialists.isEmpty) {
        // Неделя/месяц: список мастеров из кэша для выбора.
        // День: только работающие по шаблону (_daySpecialistsFromSchedule).
        final fromCache = offlineSpecialistsAsync.value;
        if (fromCache != null && fromCache.isNotEmpty) {
          specialists = fromCache;
        }
      }
      // Оффлайн: https-аватарки не грузятся — подставляем file:// из кэша.
      specialists = _withOfflineLocalPictures(
        specialists,
        offlineSpecialistsAsync.value,
      );
    }
    // День: колонки только у мастеров, работающих в выбранную дату.
    final isAdminMultiDayView =
        isAdminDayView && specialistsOnSelectedDate.length > 1;
    SpecialistItem? initialSelected;
    if (isAdminDayView) {
      if (savedSelectedId != null &&
          specialists.any((s) => s.id == savedSelectedId)) {
        initialSelected =
            specialists.firstWhere((s) => s.id == savedSelectedId);
      } else {
        initialSelected = specialists.isNotEmpty ? specialists.first : null;
      }
    } else if (savedSelectedId != null && savedSelectedId > 0) {
      initialSelected = _specialistById(
        savedSelectedId,
        allWorkers,
        workerLabels,
      );
      if (initialSelected != null &&
          !specialists.any((s) => s.id == savedSelectedId)) {
        specialists = [initialSelected, ...specialists];
      }
    }
    initialSelected ??=
        specialists.isNotEmpty ? specialists.first : null;
    if (!isScheduleOffline &&
        isAdminDayView &&
        !isAdminMultiDayView &&
        dayScheduleReady) {
      final candidate = initialSelected?.id ??
          (savedSelectedId != null && savedSelectedId > 0
              ? savedSelectedId
              : null);
      if (candidate != null) {
        _dayViewSingleWorkerId = candidate;
      }
    }
    final dayWorkHours = dayScheduleReady
        ? _branchWorkHoursForDate(
            date: selectedDate,
            patterns: branchPatterns,
            daySchedules: dayBranchSchedules,
          )
        : _workHoursForDate(selectedDate, branchPatterns);
    final selectedSpecialistId = initialSelected?.id;
    /// Id для графика/загруженности.
    final specialistIdForData = isWorkerRole
        ? (currentWorkerId != null && currentWorkerId > 0 ? currentWorkerId : null)
        : isAdminDayView
        ? (dayViewDetailsLoading
              ? null
              : (isAdminMultiDayView
                    ? initialSelected?.id
                    : (_dayViewSingleWorkerId ??
                        initialSelected?.id ??
                        (savedSelectedId != null && savedSelectedId > 0
                            ? savedSelectedId
                            : null))))
        : (savedSelectedId != null && savedSelectedId > 0
              ? savedSelectedId
              : selectedSpecialistId);
    final workerIdMissing = !isScheduleOffline &&
        isWorkerRole &&
        !currentWorkerIdAsync.isLoading &&
        specialistIdForData == null;
    final specialistStatisticsWorkerId =
        specialistIdForData != null && specialistIdForData > 0
            ? specialistIdForData
            : null;
    /// День: owner — загруженность филиала; мастер — своя.
    final dayStatisticsWorkerId =
        isWorkerRole ? specialistStatisticsWorkerId : null;
    final dayHeaderWeekStart =
        _viewMode == ViewMode.day ? _weekStart : selectedDate;
    final dayHeaderWeekKey = scheduleWeekKey(dayHeaderWeekStart);
    final dayHeaderStatisticsAsync = ref.watch(
      scheduleStatisticsForWeekProvider(
        ScheduleStatisticsQuery(
          periodKey: dayHeaderWeekKey,
          workerId: dayStatisticsWorkerId,
        ),
      ),
    );
    final dayOccupancyByDay =
        dayHeaderStatisticsAsync.value?.occupancyByDay ?? [];
    final workerWeekStatisticsQuery = ScheduleStatisticsQuery(
      periodKey: weekKey,
      workerId: specialistStatisticsWorkerId,
    );
    final monthStatisticsQuery = ScheduleStatisticsQuery(
      periodKey: monthKey,
      workerId: specialistStatisticsWorkerId,
    );
    final weekStatisticsAsync = ref.watch(
      scheduleStatisticsForWeekProvider(workerWeekStatisticsQuery),
    );
    final weekOccupancyByDay = weekStatisticsAsync.value?.occupancyByDay ?? [];
    final weekStatisticsLoading = weekStatisticsAsync.isLoading;
    final monthStatisticsAsync = ref.watch(
      scheduleStatisticsForMonthProvider(monthStatisticsQuery),
    );
    final monthOccupancyByDay =
        monthStatisticsAsync.value?.occupancyByDay ?? [];
    final monthStatisticsLoading = monthStatisticsAsync.isLoading;
    final AsyncValue<List<AppointmentApi>> monthAppointmentsAsync;
    if (_viewMode == ViewMode.month) {
      final monthEndDate = DateTime(
        _monthStart.year,
        _monthStart.month + 1,
        0,
        23,
        59,
        59,
        999,
      );
      monthAppointmentsAsync = ref.watch(
        scheduleAppointmentsProvider(
          AppointmentsQuery(
            workerId: specialistIdForData,
            dateTimeGte: _monthStart,
            dateTimeLte: monthEndDate,
          ),
        ),
      );
    } else {
      monthAppointmentsAsync = const AsyncValue.data(<AppointmentApi>[]);
    }
    final monthAppointmentsLoading =
        _viewMode == ViewMode.month && monthAppointmentsAsync.isLoading;
    final scheduleRangeBounds = _scheduleRangeBounds(
      viewMode: _viewMode,
      weekStart: _weekStart,
      monthStart: _monthStart,
    );
    final workerSchedulesAsync = specialistIdForData != null &&
            specialistIdForData > 0
        ? ref.watch(
            workerSchedulesRangeProvider(
              WorkerSchedulesRangeQuery(
                workerId: specialistIdForData,
                rangeStart: scheduleRangeBounds.start,
                rangeEnd: scheduleRangeBounds.end,
              ),
            ),
          )
        : null;
    final workerSchedulesData = workerSchedulesAsync?.asData?.value;
    final workerWeekdaysForSpecialist = specialistIdForData != null
        ? (workerWeekdaysById[specialistIdForData] ?? const <int>{})
        : const <int>{};
    final workerShiftConfigForSpecialist = specialistIdForData != null
        ? (workerSchedulesData?.shiftConfig ??
            workerScheduleTemplatesById[specialistIdForData]?.shiftConfig)
        : null;
    bool resolveWorkerNonWorkingDay(DateTime date) {
      if (specialistIdForData == null) return false;
      if (workerSchedulesAsync != null && workerSchedulesAsync.isLoading) {
        return false;
      }
      return isWorkerNonWorkingDayForCalendar(
        date: date,
        workingWeekdays: workerWeekdaysForSpecialist,
        daily: workerSchedulesData?.scheduleOn(date),
        shiftConfig: workerShiftConfigForSpecialist,
      );
    }
    bool resolveBranchNonWorkingDay(DateTime date) {
      final normalized = _toDateOnly(date);
      final daySchedules = isSameCalendarDay(normalized, normalizedSelectedDate)
          ? dayBranchSchedules
          : const <ScheduleItemApi>[];
      return !_isBranchWorkingOnDate(
        normalized,
        branchPatterns,
        daySchedules,
      );
    }
    /// Полоска дат в «День»: owner — выходные филиала; мастер — свои.
    final dayHeaderResolveNonWorkingDay = isWorkerRole
        ? (specialistIdForData != null ? resolveWorkerNonWorkingDay : null)
        : (isAdminDayView && !isAdminMultiDayView && dayScheduleReady
              ? resolveBranchNonWorkingDay
              : null);
    final slotsByDay = _slotsByDayFromActiveAppointments(
      monthAppointmentsAsync.value ?? const [],
      _monthStart,
      isNonWorkingDay: specialistIdForData != null
          ? resolveWorkerNonWorkingDay
          : null,
    );

    final selectedBreak = _breakForDate(
      daily: workerSchedulesData?.scheduleOn(selectedDate),
      shifts: availableWorkersAsync.value ?? const [],
      specialistId: specialistIdForData,
    );
    final weekBreaksByDay = _breaksByDayForWeek(
      weekStart: _weekStart,
      schedules: workerSchedulesData,
      selectedDate: selectedDate,
      selectedDayBreak: selectedBreak,
    );
    final selectedWorkerHours = specialistIdForData != null
        ? (() {
            if (isScheduleOffline && isAdminDayView) {
              return (
                start: dayWorkHours.startHour,
                end: dayWorkHours.endHour,
              );
            }
            final byShift = _workerShiftHoursForId(
              availableWorkersAsync.value ?? const [],
              specialistIdForData,
              branchHours: dayWorkHours,
            );
            if (byShift.start != null && byShift.end != null) return byShift;
            return workerShiftHoursForDate(
              date: selectedDate,
              workingWeekdays: workerWeekdaysForSpecialist,
              daily: workerSchedulesData?.scheduleOn(selectedDate),
              shiftConfig: workerSchedulesData?.shiftConfig ??
                  workerShiftConfigForSpecialist,
              branchStartHour: dayWorkHours.startHour,
              branchEndHour: dayWorkHours.endHour,
            );
          })()
        : (start: null, end: null);
    final weekWorkHours = _workHoursForWeek(
      currentBranch?.schedulePatterns ?? const [],
    );
    final weekWorkHoursByWeekday = _workHoursByWeekday(
      currentBranch?.schedulePatterns ?? const [],
    );
    final weekWorkerHoursByDay = specialistIdForData != null &&
            workerSchedulesData != null
        ? workerWorkHoursByDayForRange(
            rangeStart: scheduleRangeBounds.start,
            rangeEnd: scheduleRangeBounds.end,
            schedulesByDate: workerSchedulesData.schedulesByDate,
          )
        : const <DateTime, ({double startHour, double endHour})>{};
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
    final multiDayColumns = isAdminMultiDayView;
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
                workerId: specialistIdForData,
                dateTimeGte: dayStart,
                dateTimeLte: dayEnd,
              ),
            ),
          );
    final weekAppointmentsAsync = ref.watch(
      scheduleAppointmentsProvider(
        AppointmentsQuery(
          workerId: specialistIdForData,
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
    final dayAppointmentsLoading = !isScheduleOffline &&
        (multiDayColumns
            ? dayAppsBySpecialistIndex.any((a) => a.isLoading)
            : dayAppointmentsSingleAsync.isLoading);
    final workerHoursPending = !isScheduleOffline &&
        _viewMode == ViewMode.day &&
        specialistIdForData != null &&
        (availableWorkersAsync.isLoading ||
            workerSchedulesAsync?.isLoading == true);
    final dayViewContentLoading = dayViewDetailsLoading ||
        workerHoursPending ||
        dayAppointmentsLoading;
    final weekViewContentLoading = !isScheduleOffline &&
        _viewMode == ViewMode.week &&
        (weekStatisticsLoading ||
            weekAppointmentsAsync.isLoading ||
            (specialistIdForData != null &&
                (workerSchedulesAsync?.isLoading == true ||
                    workerWeekdaysAsync.isLoading)));
    final monthViewContentLoading = !isScheduleOffline &&
        _viewMode == ViewMode.month &&
        (monthStatisticsLoading ||
            monthAppointmentsLoading ||
            (specialistIdForData != null &&
                (workerSchedulesAsync?.isLoading == true ||
                    workerWeekdaysAsync.isLoading)));
    final scheduleViewContentLoading = !isScheduleOffline &&
        (branchesAsync.isLoading ||
            workersAsync.isLoading ||
            (isWorkerRole && currentWorkerIdAsync.isLoading) ||
            dayViewContentLoading ||
            weekViewContentLoading ||
            monthViewContentLoading);
    final Set<int>? workingWeekdaysForWeekCalendar =
        specialistIdForData == null
        ? null
        : (!workerWeekdaysAsync.hasValue
              ? null
              : (workerWeekdaysById[specialistIdForData] ?? const <int>{}));
    final workerSchedulesReady =
        specialistIdForData == null || (workerSchedulesAsync?.hasValue ?? false);
    final weekCalendarWorkingWeekdays = workerSchedulesReady
        ? null
        : workingWeekdaysForWeekCalendar;
    final weekCalendarResolveNonWorkingDay =
        specialistIdForData != null && workerSchedulesReady
        ? resolveWorkerNonWorkingDay
        : null;

    ref.listen(scheduleWorkersProvider, (prev, next) {
      next.whenData((_) async {
        if (ref.read(restoredSpecialistSelectionProvider)) return;
        await _restoreSelectedSpecialistFromStorage();
      });
    });
    ref.listen<int>(workScheduleReloadTokenProvider, (previous, next) {
      if (previous == null || previous == next) return;
      _deferForceRefreshScheduleScreen();
    });
    ref.listen<DateTime?>(openScheduleOnDayProvider, (previous, next) {
      if (next == null) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _switchToDayMode(next);
        ref.read(openScheduleOnDayProvider.notifier).state = null;
      });
    });
    ref.listen<bool>(scheduleOfflineModeProvider, (previous, next) {
      if (next == true && previous != true) {
        unawaited(() async {
          final storage = ref.read(localStorageProvider);
          final idStr = await storage.getString(selectedSpecialistIdStorageKey);
          final id = int.tryParse(idStr ?? '');
          if (id != null && id > 0) {
            ref.read(selectedSpecialistIdProvider.notifier).state = id;
          }
        }());
      }
      if (previous == true && next == false) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          try {
            ref.read(scheduleServerReachableProvider.notifier).state = true;
          } catch (_) {}
          unawaited(
            ref.read(scheduleOfflineSyncServiceProvider).syncIfOnline(),
          );
          ref.invalidate(scheduleAppointmentsProvider);
          _forceRefreshScheduleScreen();
        });
      }
    });
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        unawaited(handleAndroidBackButton(context));
      },
      child: Scaffold(
      backgroundColor: screenBackground,
      body: Stack(
        children: [
          Column(
            children: [
              TopPanel(
                title: 'Расписание',
                showViewModeSwitcher: true,
                showSpecialistSelector: !isWorkerRole,
                viewMode: _viewMode,
                onScheduleStateChanged: _onScheduleStateChanged,
                specialists: scheduleViewContentLoading ? const [] : specialists,
                initialSelectedSpecialist:
                    scheduleViewContentLoading ? null : initialSelected,
                onSpecialistSelected: isWorkerRole
                    ? null
                    : (s) async {
                        ref.read(selectedSpecialistIdProvider.notifier).state =
                            s.id;
                        final storage = ref.read(localStorageProvider);
                        await storage.saveString(
                          selectedSpecialistIdStorageKey,
                          s.id.toString(),
                        );
                      },
                scheduleSelectedDate: selectedDate,
                weekStart: _weekStart,
                occupancyByDay: dayOccupancyByDay,
                resolveScheduleNonWorkingDay: dayHeaderResolveNonWorkingDay,
                onScheduleDateSelected: (date) {
                  final normalized = _toDateOnly(date);
                  final monday = _mondayOf(normalized);
                  if (!isSameCalendarDay(monday, _weekStart)) {
                    setState(() => _weekStart = monday);
                  }
                  ref.read(selectedScheduleDateProvider.notifier).state =
                      normalized;
                },
                scheduleCellIntervalMinutes: scheduleCellIntervalMinutes,
                onScheduleCellIntervalChanged: scheduleReadOnly
                    ? null
                    : (value) {
                        ref.read(
                          scheduleCellIntervalMinutesProvider.notifier,
                        ).state = value;
                      },
              ),
              if (isScheduleOffline) const ScheduleOfflineBanner(),
              Expanded(
                child: Stack(
                  children: [
                    AppRefreshable(
                  onRefresh: _onPullToRefresh,
                  hasScrollBody: true,
                  child: (!isScheduleOffline && workersAsync.hasError)
                      ? Center(
                          child: Padding(
                            padding: AppDecoration.padding16,
                            child: Text(
                              workerLabels.failedLoadWorkersList,
                              style: TextStyle(color: AppColors.grey),
                            ),
                          ),
                        )
                      : _viewMode == ViewMode.day
                      ? (workerIdMissing
                          ? Center(
                              child: Padding(
                                padding: AppDecoration.padding16,
                                child: Text(
                                  'Не удалось определить сотрудника для расписания',
                                  style: TextStyle(color: AppColors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (multiDayColumns && !dayViewContentLoading)
                                  Padding(
                                    padding: AppDecoration.padding16,
                                    child: SpecialistListView(
                                      specialists: specialists,
                                      scrollController:
                                          _daySpecialistsScrollController,
                                      itemWidth:
                                          scheduleDaySpecialistColumnWidth,
                                      leadingInset:
                                          scheduleDaySpecialistLeadingInset(
                                        rowHorizontalPadding:
                                            scheduleDaySpecialistRowHorizontalPadding,
                                      ),
                                    ),
                                  ),
                                Expanded(
                                  child: multiDayColumns
                                      ? ScheduleCalendarDayMultiColumn(
                                          key: ValueKey(
                                            'schedule_day_multi_$_refreshVersion',
                                          ),
                                          date: selectedDate,
                                          branchStartHour: dayWorkHours.startHour,
                                          branchEndHour: dayWorkHours.endHour,
                                          horizontalScrollController:
                                              _dayCalendarScrollController,
                                          columnWidth:
                                              scheduleDaySpecialistColumnWidth,
                                          timeIntervalMinutes:
                                              scheduleCellIntervalMinutes,
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
                                                () {
                                                  final workerId =
                                                      specialists[i].id!;
                                                  final weekdays =
                                                      workerWeekdaysById[
                                                              workerId] ??
                                                      const <int>{};
                                                  final dailyForWorker =
                                                      pickPreferredDailySchedule(
                                                    dayBranchSchedules.where(
                                                      (s) =>
                                                          s.workerId ==
                                                          workerId,
                                                    ),
                                                    selectedDate,
                                                  );
                                                  final effectiveHours =
                                                      isScheduleOffline
                                                      ? (
                                                          start: dayWorkHours
                                                              .startHour,
                                                          end: dayWorkHours
                                                              .endHour,
                                                        )
                                                      : _adminMultiColumnWorkerHours(
                                                    workerId: workerId,
                                                    shifts: shifts,
                                                    date: selectedDate,
                                                    workingWeekdays: weekdays,
                                                    daily: dailyForWorker,
                                                    shiftConfig:
                                                        workerScheduleTemplatesById[workerId]
                                                            ?.shiftConfig,
                                                    branchHours: dayWorkHours,
                                                  );

                                                  return ScheduleCalendarDayColumn(
                                                    workerId: workerId,
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
                                                        effectiveHours.start,
                                                    workerEndHour: effectiveHours.end,
                                                  );
                                                }(),
                                            ];
                                          }(),
                                          onAppointmentTap: (item) async {
                                            final appointment = item.source;
                                            if (appointment == null) return;
                                            final changed = await context
                                                .pushNamed<bool>(
                                                  AddNewEntryPage.name,
                                                  extra: appointment,
                                                );
                                            _onReturnFromAddEntryPage(changed);
                                          },
                                          onEmptySlotTap: (workerId, dateTime) {
                                            _tryOpenEmptySlot(
                                              scheduleReadOnly: scheduleReadOnly,
                                              canCreateSchedule: canCreateSchedule,
                                              allowBackdatedAppointments:
                                                  allowBackdatedAppointments,
                                              extra: AddNewEntryInitialData(
                                                workerId: workerId,
                                                startDateTime: dateTime,
                                                limitSpecialistsToWorkingDay: true,
                                              ),
                                            );
                                          },
                                          canTapEmptySlot: canTapEmptySlot,
                                        )
                                      : ScheduleCalendarOneUserWidget(
                                          key: ValueKey(
                                            'schedule_day_${scheduleDateKey(selectedDate)}_'
                                            '${specialistIdForData ?? 0}_$_refreshVersion',
                                          ),
                                          date: selectedDate,
                                          items: dayItems,
                                          viewMode: ViewMode.day,
                                          timeIntervalMinutes:
                                              scheduleCellIntervalMinutes,
                                          startHour: dayWorkHours.startHour,
                                          endHour: dayWorkHours.endHour,
                                          breakStart: selectedBreak.breakStart,
                                          breakEnd: selectedBreak.breakEnd,
                                          workerStartHour:
                                              selectedWorkerHours.start,
                                          workerEndHour: selectedWorkerHours.end,
                                          workerHoursPending: workerHoursPending,
                                          onAppointmentTap: (item) async {
                                            final appointment = item.source;
                                            if (appointment == null) return;
                                            final changed = await context
                                                .pushNamed<bool>(
                                                  AddNewEntryPage.name,
                                                  extra: appointment,
                                                );
                                            _onReturnFromAddEntryPage(changed);
                                          },
                                          onEmptySlotTap: (dateTime) {
                                            if (specialistIdForData == null) {
                                              return;
                                            }
                                            _tryOpenEmptySlot(
                                              scheduleReadOnly: scheduleReadOnly,
                                              canCreateSchedule: canCreateSchedule,
                                              allowBackdatedAppointments:
                                                  allowBackdatedAppointments,
                                              extra: AddNewEntryInitialData(
                                                workerId: specialistIdForData,
                                                startDateTime: dateTime,
                                                limitSpecialistsToWorkingDay: true,
                                              ),
                                            );
                                          },
                                          canTapEmptySlot: canTapEmptySlot,
                                        ),
                                ),
                              ],
                            ))
                      
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_viewMode == ViewMode.week) ...[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 20,
                                        left: ScheduleCalendarOneUserWidget
                                            .kDefaultTimeRulerSize,
                                      ),
                                      child: DateStrip(
                                        key: ValueKey(
                                          'week_strip_${weekKey}_'
                                          'w${specialistStatisticsWorkerId ?? 0}_'
                                          '${Object.hashAll(workingWeekdaysForWeekCalendar ?? const <int>{})}_'
                                          '$_refreshVersion',
                                        ),
                                        initialDate: _weekStart,
                                        selectedDate: selectedDate,
                                        visibleWeekStart: _weekStart,
                                        onDateSelected: _switchToDayMode,
                                        showFullDateLabel: false,
                                        useGreyCircles: true,
                                        useMonthCalendarCircleFill: true,
                                        occupancyByDay: weekOccupancyByDay,
                                        workingWeekdays:
                                            weekCalendarWorkingWeekdays,
                                        resolveNonWorkingDay:
                                            weekCalendarResolveNonWorkingDay,
                                      ),
                                    ),
                                    Expanded(
                                      child: ScheduleCalendarOneUserWidget(
                                        key: ValueKey(
                                          'schedule_week_${weekKey}_'
                                          '${specialistIdForData ?? 0}_'
                                          '${workerSchedulesData?.schedulesByDate.length ?? 0}_'
                                          '$_refreshVersion',
                                        ),
                                        date: _weekStart,
                                        items: weekItems,
                                        viewMode: ViewMode.week,
                                        timeIntervalMinutes:
                                            scheduleCellIntervalMinutes,
                                        startHour: weekWorkHours.startHour,
                                        endHour: weekWorkHours.endHour,
                                        weekWorkHoursByWeekday:
                                            weekWorkHoursByWeekday,
                                        weekWorkerHoursByDay:
                                            weekWorkerHoursByDay,
                                        workingWeekdays:
                                            weekCalendarWorkingWeekdays,
                                        resolveNonWorkingDay:
                                            weekCalendarResolveNonWorkingDay,
                                        breaksByDay: weekBreaksByDay,
                                        onAppointmentTap: (item) async {
                                          final appointment = item.source;
                                          if (appointment == null) return;
                                          final changed = await context
                                              .pushNamed<bool>(
                                                AddNewEntryPage.name,
                                                extra: appointment,
                                              );
                                          _onReturnFromAddEntryPage(changed);
                                        },
                                        onEmptySlotTap: (dateTime) {
                                          if (specialistIdForData == null) {
                                            return;
                                          }
                                          _tryOpenEmptySlot(
                                            scheduleReadOnly: scheduleReadOnly,
                                            canCreateSchedule: canCreateSchedule,
                                            allowBackdatedAppointments:
                                                allowBackdatedAppointments,
                                            extra: AddNewEntryInitialData(
                                              workerId: specialistIdForData,
                                              startDateTime: dateTime,
                                              limitSpecialistsToWorkingDay: true,
                                            ),
                                          );
                                        },
                                        canTapEmptySlot: canTapEmptySlot,
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
                                      key: ValueKey(
                                        'month_${monthKey}_'
                                        'w${specialistStatisticsWorkerId ?? 0}_'
                                        '${Object.hashAll(workingWeekdaysForWeekCalendar ?? const <int>{})}_'
                                        '$_refreshVersion',
                                      ),
                                      month: _monthStart,
                                      slotsByDay: slotsByDay,
                                      occupancyByDay: monthOccupancyByDay,
                                      workingWeekdays:
                                          workingWeekdaysForWeekCalendar,
                                      resolveNonWorkingDay:
                                          specialistIdForData != null
                                          ? resolveWorkerNonWorkingDay
                                          : null,
                                      onDayTap: _switchToDayMode,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (scheduleViewContentLoading)
            Positioned.fill(
              child: ColoredBox(
                color: screenBackground,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    ),
    );
  }
}
