import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/services/local_storage.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/widgets/app_refresh_indicator.dart';
import 'package:rient_app/core/widgets/top_panel.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/create/view/add_new_entry_page.dart';
import 'package:rient_app/features/home/data/models/branches_api/branches_api.dart';
import 'package:rient_app/features/home/data/models/statistics/statistics.dart';
import 'package:rient_app/features/home/view/providers/current_worker_id_provider.dart';
import 'package:rient_app/features/home/view/providers/worker_permissions_provider.dart';
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
import 'package:rient_app/features/schedule/view/providers/schedule_cell_interval_provider.dart';
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
  int _refreshVersion = 0;
  Brightness? _lastBrightness;
  final ScrollController _daySpecialistsScrollController = ScrollController();
  final ScrollController _dayCalendarScrollController = ScrollController();
  bool _syncingDayHorizontalScroll = false;
  WebSocket? _notificationsSocket;
  Timer? _wsReconnectTimer;
  Timer? _wsDebounceRefreshTimer;
  bool _wsEnabled = true;

  @override
  void initState() {
    super.initState();
    _syncToNow();
    _daySpecialistsScrollController.addListener(_onSpecialistsScrolled);
    _dayCalendarScrollController.addListener(_onCalendarScrolled);
    unawaited(_connectNotificationsSocket());
  }

  @override
  void dispose() {
    _wsEnabled = false;
    _wsDebounceRefreshTimer?.cancel();
    _wsReconnectTimer?.cancel();
    unawaited(_notificationsSocket?.close());
    _notificationsSocket = null;
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

  Future<void> _connectNotificationsSocket() async {
    if (!_wsEnabled) return;
    _wsReconnectTimer?.cancel();
    final organizationId = ref.read(organizationIdProvider);
    final token = ref.read(tokenProvider);
    if (organizationId <= 0 || token == null || token.isEmpty) return;

    try {
      await _notificationsSocket?.close();
      final socket = await WebSocket.connect(
        'wss://apitest.triobot.ru/ws/notifications/$organizationId/?token=$token',
      ).timeout(const Duration(seconds: 8));
      if (!mounted) {
        await socket.close();
        return;
      }
      _notificationsSocket = socket;
      socket.listen(
        _onSocketMessage,
        onError: (_) => _scheduleWsReconnect(),
        onDone: _scheduleWsReconnect,
        cancelOnError: true,
      );
    } catch (_) {
      _scheduleWsReconnect();
    }
  }

  void _scheduleWsReconnect() {
    if (!mounted || !_wsEnabled) return;
    _wsReconnectTimer?.cancel();
    _wsReconnectTimer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      unawaited(_connectNotificationsSocket());
    });
  }

  void _onSocketMessage(dynamic raw) {
    if (!_wsEnabled) return;
    if (!_isAppointmentNotification(raw)) return;
    _wsDebounceRefreshTimer?.cancel();
    _wsDebounceRefreshTimer = Timer(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      _forceRefreshScheduleScreen();
    });
  }

  bool _isAppointmentNotification(dynamic raw) {
    dynamic payload = raw;
    if (raw is String) {
      try {
        payload = jsonDecode(raw);
      } catch (_) {
        final normalized = raw.toLowerCase();
        return normalized.contains('appointment');
      }
    }

    bool hasAppointmentTopic(Map<dynamic, dynamic> map) {
      const topicKeys = {'topic', 'theme', 'type', 'channel', 'event'};
      for (final entry in map.entries) {
        final key = entry.key.toString().toLowerCase();
        final value = entry.value?.toString().toLowerCase() ?? '';
        if (topicKeys.contains(key) && value == 'appointment') {
          return true;
        }
      }
      return false;
    }

    if (payload is Map) {
      if (hasAppointmentTopic(payload)) return true;
      final normalized = payload.toString().toLowerCase();
      return normalized.contains('appointment');
    }
    if (payload is List) {
      for (final item in payload) {
        if (_isAppointmentNotification(item)) return true;
      }
    }
    return false;
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

  static List<SpecialistItem> _allWorkersToSpecialists(
    List<WorkerApi> allWorkers,
  ) {
    return [
      for (final worker in allWorkers)
        SpecialistItem(
          name:
              '${worker.firstName ?? ''} ${worker.lastName ?? ''}'.trim().isEmpty
              ? 'Специалист'
              : '${worker.firstName ?? ''} ${worker.lastName ?? ''}'.trim(),
          role: worker.specialization ?? '',
          id: worker.id,
          pictureUrl: worker.pictureThumbnail ?? worker.picture,
        ),
    ];
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

  void _switchToDayMode(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    setState(() {
      _viewMode = ViewMode.day;
      _weekStart = normalized.subtract(Duration(days: normalized.weekday - 1));
      _monthStart = DateTime(normalized.year, normalized.month, 1);
    });
    ref.read(selectedScheduleDateProvider.notifier).state = normalized;
  }

  static DateTime _toDateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  void _forceRefreshScheduleScreen() {
    final selectedDate = ref.read(selectedScheduleDateProvider);
    final weekKey = scheduleWeekKey(
      _viewMode == ViewMode.day ? selectedDate : _weekStart,
    );
    final monthKey = scheduleMonthKey(_monthStart);

    ref.invalidate(scheduleAppointmentsProvider);
    final weekAnchor = _toDateOnly(
      _viewMode == ViewMode.day ? selectedDate : _weekStart,
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
    ref.invalidate(scheduleStatisticsForWeekProvider(weekKey));
    ref.invalidate(scheduleStatisticsForMonthProvider(monthKey));
    ref.invalidate(scheduleWorkersProvider);

    if (!mounted) return;
    setState(() {
      _refreshVersion++;
    });
  }

  Future<void> _onPullToRefresh() async {
    _forceRefreshScheduleScreen();
    try {
      await ref.read(scheduleWorkersProvider.future);
    } catch (_) {}
  }

  Future<void> _openAddEntryFromEmptySlot({
    required AddNewEntryInitialData extra,
  }) async {
    try {
      await context.pushNamed<bool>(
        AddNewEntryPage.name,
        extra: extra,
      );
    } finally {
      if (mounted) {
        // Всегда обновляем экран после закрытия карточки (в т.ч. системная
        // «Назад» и pop без результата), иначе загруженность может остаться старой.
        _forceRefreshScheduleScreen();
      }
    }
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isWideScreen = MediaQuery.sizeOf(context).width >= 900;
    final screenBackground = isDark
        ? AppColors.secondaryDarkLight
        : AppColors.tabBarScreenBackground;
    final workersAsync = ref.watch(scheduleWorkersProvider);
    final roleId = ref.watch(roleProvider);
    final isWorkerRole = roleId == UserRole.worker.value;
    final workerPermissions = ref.watch(workerPermissionsProvider).maybeWhen(
          data: (v) => v,
          orElse: () => null,
        );
    final canCreateSchedule = workerPermissions?.createSchedule ?? true;
    final currentWorkerIdAsync = ref.watch(currentWorkerIdProvider);
    final currentWorkerId = currentWorkerIdAsync.value;
    final currentBranch = ref.watch(currentBranchProvider);
    final scheduleCellIntervalMinutes = ref.watch(
      scheduleCellIntervalMinutesProvider,
    );
    final selectedDate = ref.watch(selectedScheduleDateProvider);
    final workerIdMissing =
        isWorkerRole && !currentWorkerIdAsync.isLoading && currentWorkerId == null;
    final workerWeekdaysAsync = ref.watch(workerWeekdaysByIdProvider);
    final workerWeekdaysById = workerWeekdaysAsync.hasValue
        ? workerWeekdaysAsync.requireValue
        : const <int, Set<int>>{};
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
    final allSpecialists = availableWorkersAsync.maybeWhen(
      data: (available) {
        if (available.isEmpty) {
          final allWorkers = workersAsync.value?.results ?? const <WorkerApi>[];
          return _allWorkersToSpecialists(allWorkers);
        }
        return _availableToSpecialists(
          available,
          workersAsync.value?.results ?? const [],
        );
      },
      orElse: () => <SpecialistItem>[],
    );
    final specialists = isWorkerRole
        ? allSpecialists.where((s) => s.id == currentWorkerId).toList()
        : allSpecialists;
    final savedSelectedId = ref.watch(selectedSpecialistIdProvider);
    SpecialistItem? initialSelected;
    if (specialists.isNotEmpty) {
      if (savedSelectedId != null) {
        for (final specialist in specialists) {
          if (specialist.id == savedSelectedId) {
            initialSelected = specialist;
            break;
          }
        }
      }
      initialSelected ??= specialists[0];
    }
    final dayWorkHours = _workHoursForDate(
      selectedDate,
      currentBranch?.schedulePatterns ?? const [],
    );
    final selectedSpecialistId = initialSelected?.id;
    /// Пока нет списка доступных на дату, у воркера всё равно известен id из профиля.
    final specialistIdForData = selectedSpecialistId ??
        (isWorkerRole && currentWorkerId != null && currentWorkerId > 0
            ? currentWorkerId
            : null);
    final selectedBreak = _breakForSpecialist(
      availableWorkersAsync.value ?? const [],
      specialistIdForData,
    );
    final selectedWorkerHours = specialistIdForData != null
        ? (() {
            final hasWorkerInBranch = workerWeekdaysById.containsKey(
              specialistIdForData,
            );
            if (!hasWorkerInBranch) {
              return (start: null, end: null);
            }
            final byShift = _workerShiftHoursForId(
              availableWorkersAsync.value ?? const [],
              specialistIdForData,
            );
            if (byShift.start != null && byShift.end != null) return byShift;
            final weekdays = workerWeekdaysById[specialistIdForData] ?? const <int>{};
            final isWorkingWeekday = weekdays.contains(selectedDate.weekday);
            if (isWorkingWeekday) {
              return (
                start: dayWorkHours.startHour,
                end: dayWorkHours.endHour,
              );
            }
            return (start: null, end: null);
          })()
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
        !isWorkerRole &&
        _viewMode == ViewMode.day &&
        specialists.length > 1;
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
    final dayAppointmentsLoading = multiDayColumns
        ? dayAppsBySpecialistIndex.any((a) => a.isLoading)
        : dayAppointmentsSingleAsync.isLoading;
    final Set<int>? workingWeekdaysForWeekCalendar =
        specialistIdForData == null
        ? null
        : (!workerWeekdaysAsync.hasValue
              ? null
              : (workerWeekdaysById[specialistIdForData] ?? const <int>{}));

    final showGlobalLoader =
        (isWorkerRole && currentWorkerIdAsync.isLoading) ||
        availableWorkersLoading ||
        (_viewMode == ViewMode.day && dayAppointmentsLoading) ||
        (_viewMode == ViewMode.week && weekAppointmentsAsync.isLoading) ||
        (_viewMode == ViewMode.week && weekStatisticsLoading) ||
        (_viewMode == ViewMode.month && monthStatisticsLoading);

    void refreshScheduleAfterMutation(AppointmentApi mutatedAppointment) {
      final mutatedWorkerId = mutatedAppointment.worker?.id;
      if (_viewMode == ViewMode.day) {
        if (specialists.isNotEmpty) {
          for (final specialist in specialists) {
            final id = specialist.id;
            if (id == null) continue;
            ref.invalidate(
              scheduleAppointmentsProvider(
                AppointmentsQuery(
                  workerId: id,
                  dateTimeGte: dayStart,
                  dateTimeLte: dayEnd,
                ),
              ),
            );
          }
        } else {
          ref.invalidate(
            scheduleAppointmentsProvider(
              AppointmentsQuery(
                workerId: specialistIdForData,
                dateTimeGte: dayStart,
                dateTimeLte: dayEnd,
              ),
            ),
          );
        }
      }

      ref.invalidate(
        scheduleAppointmentsProvider(
          AppointmentsQuery(
            workerId: specialistIdForData,
            dateTimeGte: weekStartDate,
            dateTimeLte: weekEndDate,
          ),
        ),
      );
      if (mutatedWorkerId != null && mutatedWorkerId != specialistIdForData) {
        ref.invalidate(
          scheduleAppointmentsProvider(
            AppointmentsQuery(
              workerId: mutatedWorkerId,
              dateTimeGte: weekStartDate,
              dateTimeLte: weekEndDate,
            ),
          ),
        );
      }
      // Fallback: сбрасываем кеш всех family-инстансов записей.
      ref.invalidate(scheduleAppointmentsProvider);
      ref.invalidate(availableWorkersForDateProvider(selectedDate));
      ref.invalidate(scheduleStatisticsForWeekProvider(weekKey));
      ref.invalidate(scheduleStatisticsForMonthProvider(monthKey));
    }

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
                specialists: specialists,
                initialSelectedSpecialist: initialSelected,
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
                occupancyByDay: occupancyByDay,
                onScheduleDateSelected: (date) {
                  ref.read(selectedScheduleDateProvider.notifier).state =
                      DateTime(date.year, date.month, date.day);
                },
                scheduleCellIntervalMinutes: scheduleCellIntervalMinutes,
                onScheduleCellIntervalChanged: (value) {
                  ref.read(scheduleCellIntervalMinutesProvider.notifier).state =
                      value;
                },
              ),
              Expanded(
                child: AppRefreshable(
                  onRefresh: _onPullToRefresh,
                  hasScrollBody: true,
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
                                if (multiDayColumns)
                                  Padding(
                                    padding: AppDecoration.padding16,
                                    child: SpecialistListView(
                                      specialists: specialists,
                                      scrollController:
                                          _daySpecialistsScrollController,
                                      itemWidth: 114,
                                      leadingInset: isWideScreen ? 51 : 28,
                                    ),
                                  ),
                                Expanded(
                                  child: multiDayColumns
                                      ? ScheduleCalendarDayMultiColumn(
                                          key: ValueKey(
                                            'schedule_day_multi_${scheduleDateKey(selectedDate)}_$_refreshVersion',
                                          ),
                                          date: selectedDate,
                                          branchStartHour: dayWorkHours.startHour,
                                          branchEndHour: dayWorkHours.endHour,
                                          horizontalScrollController:
                                              _dayCalendarScrollController,
                                          columnWidth: 114,
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
                                                  final hasWorkerInBranch =
                                                      workerWeekdaysById.containsKey(
                                                        workerId,
                                                      );
                                                  if (!hasWorkerInBranch) {
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
                                                      breakStart: null,
                                                      breakEnd: null,
                                                      workerStartHour: null,
                                                      workerEndHour: null,
                                                    );
                                                  }
                                                  final byShift =
                                                      _workerShiftHoursForId(
                                                        shifts,
                                                        workerId,
                                                      );
                                                  final weekdays =
                                                      workerWeekdaysById[workerId] ??
                                                      const <int>{};
                                                  final byWeekday =
                                                      weekdays.contains(
                                                        selectedDate.weekday,
                                                      )
                                                      ? (
                                                          start:
                                                              dayWorkHours.startHour,
                                                          end:
                                                              dayWorkHours.endHour,
                                                        )
                                                      : (start: null, end: null);
                                                  final effectiveHours =
                                                      (byShift.start != null &&
                                                          byShift.end != null)
                                                      ? byShift
                                                      : byWeekday;

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
                                            final wasDeleted = await context
                                                .pushNamed<bool>(
                                                  AddNewEntryPage.name,
                                                  extra: appointment,
                                                );
                                            if (!mounted) return;
                                            if (wasDeleted == true) {
                                              refreshScheduleAfterMutation(
                                                appointment,
                                              );
                                            }
                                            // Всегда после закрытия карточки: pop(true) с root-навигатором
                                            // не всегда доходит до await, а загруженность должна обновиться.
                                            _forceRefreshScheduleScreen();
                                          },
                                          onEmptySlotTap: (workerId, dateTime) {
                                            if (!canCreateSchedule) return;
                                            unawaited(
                                              _openAddEntryFromEmptySlot(
                                                extra: AddNewEntryInitialData(
                                                  workerId: workerId,
                                                  startDateTime: dateTime,
                                                ),
                                              ),
                                            );
                                          },
                                        )
                                      : ScheduleCalendarOneUserWidget(
                                          key: ValueKey(
                                            'schedule_day_${scheduleDateKey(selectedDate)}_$_refreshVersion',
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
                                          onAppointmentTap: (item) async {
                                            final appointment = item.source;
                                            if (appointment == null) return;
                                            final wasDeleted = await context
                                                .pushNamed<bool>(
                                                  AddNewEntryPage.name,
                                                  extra: appointment,
                                                );
                                            if (!mounted) return;
                                            if (wasDeleted == true) {
                                              refreshScheduleAfterMutation(
                                                appointment,
                                              );
                                            }
                                            _forceRefreshScheduleScreen();
                                          },
                                          onEmptySlotTap: (dateTime) {
                                            if (!canCreateSchedule) return;
                                            if (specialistIdForData == null) {
                                              return;
                                            }
                                            unawaited(
                                              _openAddEntryFromEmptySlot(
                                                extra: AddNewEntryInitialData(
                                                  workerId: specialistIdForData,
                                                  startDateTime: dateTime,
                                                ),
                                              ),
                                            );
                                          },
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
                                      padding: AppDecoration.padding16.copyWith(
                                        top: 20,
                                        left: 40,
                                      ),
                                      child: DateStrip(
                                        key: ValueKey(
                                          'week_strip_${weekKey}_'
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
                                        occupancyByDay: occupancyByDay,
                                        workingWeekdays:
                                            workingWeekdaysForWeekCalendar,
                                      ),
                                    ),
                                    Expanded(
                                      child: ScheduleCalendarOneUserWidget(
                                        key: ValueKey(
                                          'schedule_week_${weekKey}_'
                                          '${specialistIdForData ?? 0}_'
                                          '${workerWeekdaysAsync.hasValue}_'
                                          '${Object.hashAll(workingWeekdaysForWeekCalendar ?? const <int>{})}_'
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
                                        workingWeekdays:
                                            workingWeekdaysForWeekCalendar,
                                        breakStart: selectedBreak.breakStart,
                                        breakEnd: selectedBreak.breakEnd,
                                        onAppointmentTap: (item) async {
                                          final appointment = item.source;
                                          if (appointment == null) return;
                                          final wasDeleted = await context
                                              .pushNamed<bool>(
                                                AddNewEntryPage.name,
                                                extra: appointment,
                                              );
                                          if (!mounted) return;
                                          if (wasDeleted == true) {
                                            refreshScheduleAfterMutation(
                                              appointment,
                                            );
                                          }
                                          _forceRefreshScheduleScreen();
                                        },
                                        onEmptySlotTap: (dateTime) {
                                          if (!canCreateSchedule) return;
                                          if (specialistIdForData == null) {
                                            return;
                                          }
                                          unawaited(
                                            _openAddEntryFromEmptySlot(
                                              extra: AddNewEntryInitialData(
                                                workerId: specialistIdForData,
                                                startDateTime: dateTime,
                                              ),
                                            ),
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
                                      key: ValueKey(
                                        'month_${monthKey}_'
                                        '${Object.hashAll(workingWeekdaysForWeekCalendar ?? const <int>{})}_'
                                        '$_refreshVersion',
                                      ),
                                      month: _monthStart,
                                      slotsByDay: slotsByDay,
                                      occupancyByDay: monthOccupancyByDay,
                                      workingWeekdays:
                                          workingWeekdaysForWeekCalendar,
                                      onDayTap: _switchToDayMode,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                ),
              ),
            ),
            ],
          ),
          if (showGlobalLoader)
            Positioned.fill(
              child: Container(
                color: screenBackground.withValues(alpha: 0.35),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}
