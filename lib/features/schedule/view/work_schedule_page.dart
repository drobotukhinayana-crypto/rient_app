import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/models/worker_entity_labels.dart';
import 'package:rient_app/core/providers/worker_entity_labels_provider.dart';
import 'package:rient_app/core/routes/route_notifier.dart' show rootNavigatorKey;
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/app_refresh_indicator.dart';
import 'package:rient_app/core/widgets/app_service_message.dart';
import 'package:rient_app/core/widgets/loading_widget.dart';
import 'package:rient_app/core/widgets/top_panel.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/schedule/data/models/schedule_patterns_branch_api/schedule_patterns_branch_api.dart';
import 'package:rient_app/features/schedule/data/models/schedule_patterns_branch_api/update_branch_schedule_patterns_request.dart';
import 'package:rient_app/features/schedule/service/schedule_patterns_service.dart';
import 'package:rient_app/features/schedule/utils/schedule_day_key.dart';
import 'package:rient_app/features/schedule/view/components/work_schedule_mapper.dart';
import 'package:rient_app/features/schedule/view/providers/branch_schedule_loader.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_patterns_branch_provider.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/home/view/providers/worker_permissions_provider.dart';
import 'package:rient_app/features/schedule/data/models/schedules_api/create_worker_schedule_request.dart';
import 'package:rient_app/features/schedule/view/components/work_schedule_day_edit_dialog.dart';
import 'package:rient_app/features/schedule/view/components/work_schedule_mock_data.dart';
import 'package:rient_app/features/schedule/view/components/work_schedule_month_grid.dart';
import 'package:rient_app/features/schedule/data/models/schedules_api/schedules_api.dart';
import 'package:rient_app/features/schedule/view/providers/work_schedule_provider.dart';
import 'package:rient_app/features/schedule/view/providers/workers_provider.dart';
import 'package:rient_app/features/schedule/service/schedules_service.dart';
import 'package:rient_app/features/schedule/utils/schedule_date_utils.dart';
import 'package:rient_app/features/schedule/utils/work_schedule_appointment_conflict.dart'
    show
        humanizeScheduleApiError,
        isWorkSchedulePermissionError,
        validateWorkScheduleDayAgainstAppointments,
        WorkScheduleDayBounds,
        workScheduleNoPermissionMessage;
import 'package:rient_app/features/schedule/view/branch_schedule_page.dart';
import 'package:rient_app/features/schedule/view/specialist_schedule_page.dart';

class WorkSchedulePage extends ConsumerStatefulWidget {
  const WorkSchedulePage({super.key});

  static const name = 'work_schedule_page';
  static const path = 'work_schedule';

  @override
  ConsumerState<WorkSchedulePage> createState() => _WorkSchedulePageState();
}

class _WorkSchedulePageState extends ConsumerState<WorkSchedulePage>
    with WidgetsBindingObserver {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late DateTime _monthStart;
  late ScrollController _datesHeaderScroll;
  late ScrollController _gridHorizontalScroll;
  bool _syncingHorizontalScroll = false;
  bool _pendingHorizontalScrollToSelectedDate = true;
  int? _pendingScrollForLoadEpoch;
  int _loadEpoch = 0;
  int _gridVersion = 0;
  int _fetchGeneration = 0;
  int? _displayedBranchId;
  int? _rowsResyncForEpoch;
  String? _savingEmployeeId;
  DateTime? _savingDate;
  Map<String, SchedulePatternBranchItemApi> _branchPatternsByDay = const {};
  AsyncValue<List<WorkScheduleEmployeeRow>> _employees =
      const AsyncValue.loading();

  static const _branchWorkScheduleNoPermissionMessage =
      'Изменять график филиала могут только владелец и менеджер';

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _datesHeaderScroll = ScrollController();
    _gridHorizontalScroll = ScrollController();
    _datesHeaderScroll.addListener(_onDatesHeaderScrolled);
    _gridHorizontalScroll.addListener(_onGridHorizontalScrolled);
    _syncToNow();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      refreshWorkerPermissions(ref);
      unawaited(_reloadWorkSchedule());
    });
    ref.listenManual<int>(
      currentBranchIdProvider,
      (previous, next) {
        if (next <= 0 || previous == next) return;
        // Первый валидный филиал после загрузки списка или смена филиала.
        if (previous == null || previous <= 0 || previous != next) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            if (previous != null && previous > 0 && previous != next) {
              invalidateWorkScheduleCaches(ref, branchId: next);
            }
            unawaited(
              _reloadWorkSchedule(
                forceLoading: previous == null || previous <= 0,
              ),
            );
          });
        }
      },
    );
  }

  @override
  void activate() {
    super.activate();
    refreshWorkerPermissions(ref);
    _scheduleHorizontalScrollSync();
    if (_employees.hasError) {
      unawaited(_reloadWorkSchedule());
      return;
    }
    final branchId = ref.read(currentBranchIdProvider);
    if (branchId > 0 &&
        (_displayedBranchId == null || _displayedBranchId != branchId)) {
      unawaited(_reloadWorkSchedule(forceLoading: true));
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      refreshWorkerPermissions(ref);
      unawaited(_reloadWorkSchedule());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _datesHeaderScroll.removeListener(_onDatesHeaderScrolled);
    _gridHorizontalScroll.removeListener(_onGridHorizontalScrolled);
    _datesHeaderScroll.dispose();
    _gridHorizontalScroll.dispose();
    super.dispose();
  }

  void _onDatesHeaderScrolled() {
    if (_syncingHorizontalScroll || !_gridHorizontalScroll.hasClients) {
      return;
    }
    final source = _datesHeaderScroll.position;
    final target = _gridHorizontalScroll.position;
    final offset = source.pixels.clamp(
      target.minScrollExtent,
      target.maxScrollExtent,
    );
    if ((target.pixels - offset).abs() < 0.5) return;
    _syncingHorizontalScroll = true;
    _gridHorizontalScroll.jumpTo(offset);
    _syncingHorizontalScroll = false;
  }

  void _onGridHorizontalScrolled() {
    if (_syncingHorizontalScroll || !_datesHeaderScroll.hasClients) return;
    final source = _gridHorizontalScroll.position;
    final target = _datesHeaderScroll.position;
    final offset = source.pixels.clamp(
      target.minScrollExtent,
      target.maxScrollExtent,
    );
    if ((target.pixels - offset).abs() < 0.5) return;
    _syncingHorizontalScroll = true;
    _datesHeaderScroll.jumpTo(offset);
    _syncingHorizontalScroll = false;
  }

  void _syncToNow() {
    final now = DateTime.now();
    _monthStart = DateTime(now.year, now.month, 1);
  }

  Future<void> _reloadWorkSchedule({
    String? employeeId,
    bool forceLoading = false,
    bool invalidateBeforeLoad = false,
  }) async {
    refreshWorkerPermissions(ref);

    var branchId = ref.read(currentBranchIdProvider);
    if (branchId <= 0) {
      try {
        await ref.read(branchesProvider.future);
      } catch (_) {}
      branchId = ref.read(currentBranchIdProvider);
      if (branchId <= 0) {
        if (!mounted) return;
        setState(() {
          _employees = AsyncValue.error(
            Exception('Филиал не выбран'),
            StackTrace.current,
          );
        });
        return;
      }
    }

    final generation = ++_fetchGeneration;
    final workerId =
        employeeId != null ? int.tryParse(employeeId) : null;
    final nextEpoch = _loadEpoch + 1;
    final query = WorkScheduleMonthQuery(
      monthStart: _monthStart,
      loadEpoch: nextEpoch,
    );
    final branchChanged =
        forceLoading ||
        invalidateBeforeLoad ||
        (_displayedBranchId != null &&
            branchId > 0 &&
            _displayedBranchId != branchId);
    final keepGridVisible = _employees.hasValue && !branchChanged;
    final showErrorOnFailure = !keepGridVisible;

    setState(() {
      _loadEpoch = nextEpoch;
      _gridVersion++;
      _rowsResyncForEpoch = null;
      if (!keepGridVisible) {
        _employees = const AsyncValue.loading();
        if (branchChanged) {
          _branchPatternsByDay = const {};
        }
      }
      _pendingHorizontalScrollToSelectedDate = true;
      _pendingScrollForLoadEpoch = nextEpoch;
    });

    try {
      final rows = await reloadWorkScheduleMonth(
        ref,
        query,
        branchId: branchId,
        workerId: workerId,
        invalidateBeforeLoad: invalidateBeforeLoad || branchChanged,
      );
      final branchPatternsByDay = branchId > 0
          ? await _loadBranchPatternsByDay(branchId)
          : const <String, SchedulePatternBranchItemApi>{};
      if (!mounted || generation != _fetchGeneration) return;
      setState(() {
        _employees = AsyncValue.data(rows);
        _branchPatternsByDay = branchPatternsByDay;
        _displayedBranchId = branchId;
      });
    } catch (error, stackTrace) {
      if (!mounted || generation != _fetchGeneration) return;
      if (!showErrorOnFailure) return;
      setState(() => _employees = AsyncValue.error(error, stackTrace));
    }
  }

  void _scheduleReloadAfterReturn({
    String? employeeId,
    bool force = false,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(
        _reloadWorkSchedule(
          employeeId: employeeId,
          forceLoading: force,
          invalidateBeforeLoad: force,
        ),
      );
    });
  }

  double? _readHorizontalScrollOffset() {
    if (_gridHorizontalScroll.hasClients) return _gridHorizontalScroll.offset;
    if (_datesHeaderScroll.hasClients) return _datesHeaderScroll.offset;
    return null;
  }

  void _restoreHorizontalScrollOffset(double? offset, {int attempt = 0}) {
    if (offset == null || attempt > 8) return;

    if (!_datesHeaderScroll.hasClients || !_gridHorizontalScroll.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _restoreHorizontalScrollOffset(offset, attempt: attempt + 1);
        }
      });
      return;
    }

    _syncingHorizontalScroll = true;
    try {
      for (final controller in [_datesHeaderScroll, _gridHorizontalScroll]) {
        final clamped = offset.clamp(
          controller.position.minScrollExtent,
          controller.position.maxScrollExtent,
        );
        if ((controller.offset - clamped).abs() > 0.5) {
          controller.jumpTo(clamped);
        }
      }
    } finally {
      _syncingHorizontalScroll = false;
    }
  }

  void _setEmployeesPreservingScroll(List<WorkScheduleEmployeeRow> rows) {
    final offset = _readHorizontalScrollOffset();
    setState(() => _employees = AsyncValue.data(rows));
    _restoreHorizontalScrollOffset(offset);
  }

  DateTime _scrollTargetDateInMonth() {
    if (_today.year == _monthStart.year && _today.month == _monthStart.month) {
      return _today;
    }
    return DateTime(_monthStart.year, _monthStart.month, 1);
  }

  void _jumpHorizontalScrollToTarget() {
    final offset = _horizontalOffsetForSelectedDate();
    if (offset == null) return;

    void apply() {
      _syncingHorizontalScroll = true;
      try {
        for (final controller in [_datesHeaderScroll, _gridHorizontalScroll]) {
          if (!controller.hasClients) continue;
          final clamped = offset.clamp(
            controller.position.minScrollExtent,
            controller.position.maxScrollExtent,
          );
          if ((controller.offset - clamped).abs() > 0.5) {
            controller.jumpTo(clamped);
          }
        }
      } finally {
        _syncingHorizontalScroll = false;
      }
    }

    apply();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) apply();
    });
  }

  void _completePendingHorizontalScrollIfReady() {
    if (_pendingScrollForLoadEpoch != null &&
        _pendingScrollForLoadEpoch != _loadEpoch) {
      return;
    }
    _pendingHorizontalScrollToSelectedDate = false;
    _pendingScrollForLoadEpoch = null;
  }

  double? _horizontalOffsetForSelectedDate() {
    final target = _scrollTargetDateInMonth();
    final index = workScheduleDayIndexInMonth(_monthStart, target);
    if (index < 0) return null;
    return workScheduleHorizontalOffsetForDayIndex(index);
  }

  bool _areHorizontalScrollsAligned([double? targetOffset]) {
    if (!_datesHeaderScroll.hasClients || !_gridHorizontalScroll.hasClients) {
      return false;
    }
    final headerPx = _datesHeaderScroll.offset;
    final gridPx = _gridHorizontalScroll.offset;
    if ((headerPx - gridPx).abs() > 0.5) return false;
    if (targetOffset == null) return true;
    final headerClamped = targetOffset.clamp(
      _datesHeaderScroll.position.minScrollExtent,
      _datesHeaderScroll.position.maxScrollExtent,
    );
    return (headerPx - headerClamped).abs() < 0.5;
  }

  /// Выравнивает шапку с датами и сетку по одному offset.
  void _alignHorizontalScrolls({int attempt = 0}) {
    if (attempt > 20) return;

    if (!_datesHeaderScroll.hasClients || !_gridHorizontalScroll.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _alignHorizontalScrolls(attempt: attempt + 1);
      });
      return;
    }

    final headerPx = _datesHeaderScroll.offset;
    final gridPx = _gridHorizontalScroll.offset;
    if ((headerPx - gridPx).abs() < 0.5) return;

    final source = gridPx;
    final headerTarget = source.clamp(
      _datesHeaderScroll.position.minScrollExtent,
      _datesHeaderScroll.position.maxScrollExtent,
    );
    final gridTarget = source.clamp(
      _gridHorizontalScroll.position.minScrollExtent,
      _gridHorizontalScroll.position.maxScrollExtent,
    );

    _syncingHorizontalScroll = true;
    try {
      if ((headerPx - headerTarget).abs() > 0.5) {
        _datesHeaderScroll.jumpTo(headerTarget);
      }
      if ((gridPx - gridTarget).abs() > 0.5) {
        _gridHorizontalScroll.jumpTo(gridTarget);
      }
    } finally {
      _syncingHorizontalScroll = false;
    }
  }

  void _scheduleHorizontalScrollSync() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_pendingHorizontalScrollToSelectedDate) {
        _scrollToSelectedDate();
      } else {
        _alignHorizontalScrolls();
      }
    });
  }

  void _scrollToSelectedDate({int attempt = 0}) {
    if (!_pendingHorizontalScrollToSelectedDate) return;
    if (attempt > 20) {
      _jumpHorizontalScrollToTarget();
      _completePendingHorizontalScrollIfReady();
      return;
    }

    final offset = _horizontalOffsetForSelectedDate();
    if (offset == null) return;

    if (!_datesHeaderScroll.hasClients || !_gridHorizontalScroll.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _scrollToSelectedDate(attempt: attempt + 1);
      });
      return;
    }

    _syncingHorizontalScroll = true;
    try {
      for (final controller in [_datesHeaderScroll, _gridHorizontalScroll]) {
        final position = controller.position;
        final clamped = offset.clamp(
          position.minScrollExtent,
          position.maxScrollExtent,
        );
        if ((position.pixels - clamped).abs() > 0.5) {
          controller.jumpTo(clamped);
        }
      }
    } finally {
      _syncingHorizontalScroll = false;
    }

    if (_areHorizontalScrollsAligned(offset)) {
      _completePendingHorizontalScrollIfReady();
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _scrollToSelectedDate(attempt: attempt + 1);
    });
  }

  void _onMonthStartChanged(DateTime monthStart) {
    setState(() {
      _monthStart = DateTime(monthStart.year, monthStart.month, 1);
      _pendingHorizontalScrollToSelectedDate = true;
      _employees = const AsyncValue.loading();
    });
    _jumpHorizontalScrollToTarget();
    unawaited(_reloadWorkSchedule());
  }

  WorkScheduleDayCell? _cellForDate(
    WorkScheduleEmployeeRow employee,
    DateTime date,
  ) {
    final index = workScheduleDayIndexInMonth(_monthStart, date);
    if (index < 0 || index >= employee.monthCells.length) return null;
    return employee.monthCells[index];
  }

  String? _extractApiErrorMessage(dynamic data, [String? fieldPrefix]) {
    if (data == null) return null;
    if (data is String && data.trim().isNotEmpty) {
      final text = data.trim();
      if (fieldPrefix != null) return '$fieldPrefix: $text';
      return text;
    }
    if (data is List) {
      for (final item in data) {
        final message = _extractApiErrorMessage(item, fieldPrefix);
        if (message != null) return message;
      }
      return null;
    }
    if (data is Map) {
      for (final entry in data.entries) {
        final key = entry.key.toString();
        final prefix = fieldPrefix == null ? key : '$fieldPrefix.$key';
        final message = _extractApiErrorMessage(entry.value, prefix);
        if (message != null) return message;
      }
    }
    return null;
  }

  String _saveDayErrorMessage(Object error) {
    if (error is CustomException && error.causedError is DioException) {
      final dio = error.causedError! as DioException;
      final message = humanizeScheduleApiError(
        _extractApiErrorMessage(dio.response?.data),
      );
      if (message != null) return message;
    }
    return 'Не удалось сохранить день';
  }

  bool _isDuplicateScheduleDayError(Object error) {
    if (error is! CustomException || error.causedError is! DioException) {
      return false;
    }
    final message = _extractApiErrorMessage(
      (error.causedError! as DioException).response?.data,
    );
    if (message == null) return false;
    final lower = message.toLowerCase();
    return lower.contains('уникальн') ||
        lower.contains('unique') ||
        lower.contains('key, date, branch');
  }

  bool _scheduleKeysMatch(String apiKey, String expectedKey) =>
      apiKey.toLowerCase() == expectedKey.toLowerCase();

  Future<int?> _findScheduleIdForDate({
    required int workerId,
    required DateTime date,
    required int branchId,
  }) async {
    final service = ref.read(schedulesServiceProvider);
    final response = await service.getWorkerSchedules(
      workerId: workerId,
      dateGte: date,
      dateLte: date,
    );
    final key = CreateWorkerScheduleRequest.workerScheduleKey(workerId);

    int? fallbackId;
    for (final item in response.results) {
      if (!isSameScheduleApiDate(item.date, date) ||
          !_scheduleKeysMatch(item.key, key)) {
        continue;
      }
      if (item.branch == branchId) {
        return item.id;
      }
      fallbackId ??= item.id;
    }
    return fallbackId;
  }

  Future<ScheduleItemApi> _saveWorkerScheduleDay({
    required int workerId,
    required int? scheduleId,
    required DateTime date,
    required int branchId,
    required CreateWorkerScheduleRequest body,
  }) async {
    final service = ref.read(schedulesServiceProvider);
    final existingId = await _findScheduleIdForDate(
      workerId: workerId,
      date: date,
      branchId: branchId,
    );
    final resolvedScheduleId = existingId ?? scheduleId;

    if (resolvedScheduleId != null) {
      return service.updateWorkerSchedule(
        workerId: workerId,
        scheduleId: resolvedScheduleId,
        body: body,
      );
    }

    try {
      return await service.createWorkerSchedule(workerId: workerId, body: body);
    } catch (e) {
      if (!_isDuplicateScheduleDayError(e)) rethrow;
      final duplicateId = await _findScheduleIdForDate(
        workerId: workerId,
        date: date,
        branchId: branchId,
      );
      if (duplicateId == null) rethrow;
      return service.updateWorkerSchedule(
        workerId: workerId,
        scheduleId: duplicateId,
        body: body,
      );
    }
  }

  void _applySavedDayLocally({
    required String employeeId,
    required DateTime date,
    required WorkScheduleDayCell cell,
  }) {
    final employees = _employees.value;
    if (employees == null) return;

    final dayIndex = workScheduleDayIndexInMonth(_monthStart, date);
    if (dayIndex < 0) return;

    final updatedRows = [
      for (final row in employees)
        if (row.isBranchRow || row.id != employeeId)
          row
        else if (dayIndex >= row.monthCells.length)
          row
        else
          WorkScheduleEmployeeRow(
            id: row.id,
            name: row.name,
            pictureUrl: row.pictureUrl,
            monthCells: [
              for (var i = 0; i < row.monthCells.length; i++)
                if (i != dayIndex) row.monthCells[i] else cell,
            ],
          ),
    ];

    final offset = _readHorizontalScrollOffset();
    setState(() {
      _employees = AsyncValue.data(updatedRows);
    });
    _restoreHorizontalScrollOffset(offset);
  }

  bool _workScheduleDayEditChangedSchedule({
    required WorkScheduleDayEditResult result,
    required WorkScheduleDayCell previous,
  }) {
    final wasWorking = previous.kind == WorkScheduleCellKind.shift;
    if (result.isWorkingDay != wasWorking) return true;
    if (!result.isWorkingDay) return false;
    return result.workStart != (previous.timeStart ?? '09:00') ||
        result.workEnd != (previous.timeEnd ?? '20:00');
  }

  WorkScheduleDayCell _cellFromEditResult({
    required WorkScheduleDayEditResult result,
    required WorkScheduleDayCell previous,
    int? scheduleId,
  }) {
    final isManuallyEdited = _workScheduleDayEditChangedSchedule(
      result: result,
      previous: previous,
    )
        ? true
        : previous.isManuallyEdited;

    if (!result.isWorkingDay) {
      return WorkScheduleDayCell.dayOff(
        isManuallyEdited: isManuallyEdited,
        scheduleId: scheduleId ?? previous.scheduleId,
      );
    }

    final startH = int.tryParse(result.workStart.split(':').first) ?? 9;
    final endH = int.tryParse(result.workEnd.split(':').first) ?? 20;
    return WorkScheduleDayCell.shift(
      timeStart: result.workStart,
      timeEnd: result.workEnd,
      tone: (endH - startH) >= 10
          ? WorkScheduleShiftTone.full
          : WorkScheduleShiftTone.short,
      isSelected: previous.isSelected,
      isManuallyEdited: isManuallyEdited,
      scheduleId: scheduleId ?? previous.scheduleId,
      breakStart: result.breakStart,
      breakEnd: result.breakEnd,
    );
  }

  Future<bool> _canChangeWorkSchedule() async {
    refreshWorkerPermissions(ref);
    return ref.read(canChangeWorkScheduleProvider.future);
  }

  bool _canChangeBranchWorkSchedule() {
    final roleId = ref.read(roleProvider);
    return roleId == UserRole.owner.value || roleId == UserRole.manager.value;
  }

  Future<Map<String, SchedulePatternBranchItemApi>> _loadBranchPatternsByDay(
    int branchId,
  ) async {
    final branch = ref.read(currentBranchProvider);
    try {
      final response = await ref
          .read(schedulePatternsServiceProvider)
          .getBranchSchedulePatterns(branchId: branchId);
      return branchSchedulePatternsMapFromList(
        mergeBranchSchedulePatterns(
          fromApi: response.results,
          fromBranch: branch?.schedulePatterns,
          branchId: branchId,
        ),
      );
    } catch (_) {
      return branchSchedulePatternsMapFromList(
        mergeBranchSchedulePatterns(
          fromApi: const [],
          fromBranch: branch?.schedulePatterns,
          branchId: branchId,
        ),
      );
    }
  }

  DateTime _dateForDayIndex(int dayIndex) {
    return DateTime(_monthStart.year, _monthStart.month, dayIndex + 1);
  }

  void _applySavedBranchPatternLocally({
    required int weekday,
    required WorkScheduleDayCell cell,
    required SchedulePatternBranchItemApi updatedPattern,
  }) {
    final employees = _employees.value;
    if (employees == null || employees.isEmpty) return;

    final branchRow = employees.first;
    if (!branchRow.isBranchRow) return;

    final dayCount = branchRow.monthCells.length;
    final updatedBranchPatterns = Map<String, SchedulePatternBranchItemApi>.from(
      _branchPatternsByDay,
    );
    updatedBranchPatterns[canonicalScheduleDayKey(updatedPattern.day)] =
        updatedPattern;

    final branchCell = workScheduleCellFromBranchPattern(updatedPattern);

    final updatedRows = <WorkScheduleEmployeeRow>[
      WorkScheduleEmployeeRow(
        id: branchRow.id,
        name: branchRow.name,
        isBranchRow: true,
        monthCells: [
          for (var i = 0; i < dayCount; i++)
            _dateForDayIndex(i).weekday == weekday
                ? branchCell
                : branchRow.monthCells[i],
        ],
      ),
      for (final row in employees.skip(1))
        _reclampWorkerRowForWeekday(
          row: row,
          weekday: weekday,
          branchPattern: updatedPattern,
        ),
    ];

    final offset = _readHorizontalScrollOffset();
    setState(() {
      _employees = AsyncValue.data(updatedRows);
      _branchPatternsByDay = updatedBranchPatterns;
      _gridVersion++;
    });
    _restoreHorizontalScrollOffset(offset);
  }

  WorkScheduleEmployeeRow _reclampWorkerRowForWeekday({
    required WorkScheduleEmployeeRow row,
    required int weekday,
    required SchedulePatternBranchItemApi branchPattern,
  }) {
    return WorkScheduleEmployeeRow(
      id: row.id,
      name: row.name,
      pictureUrl: row.pictureUrl,
      monthCells: [
        for (var i = 0; i < row.monthCells.length; i++)
          _dateForDayIndex(i).weekday == weekday
              ? clampWorkScheduleCellToBranchPattern(
                  row.monthCells[i],
                  branchPattern,
                )
              : row.monthCells[i],
      ],
    );
  }

  Future<void> _syncWorkersToUpdatedBranchPatterns({
    required Map<String, SchedulePatternBranchItemApi> previousPatterns,
    required Map<String, SchedulePatternBranchItemApi> nextPatterns,
  }) async {
    if (!_canChangeBranchWorkSchedule()) return;

    final branchId = ref.read(currentBranchIdProvider);
    if (branchId <= 0) return;

    final seenWeekdays = <int>{};
    for (final entry in nextPatterns.entries) {
      final weekday = scheduleDayKeyToWeekday(entry.key);
      if (weekday == null || !seenWeekdays.add(weekday)) continue;

      final previous = previousPatterns[entry.key];
      final next = entry.value;
      if (!branchPatternScheduleChanged(previous, next)) continue;

      await _syncWorkerSchedulesToBranchPatternForWeekday(
        weekday: weekday,
        branchPattern: next,
        branchId: branchId,
      );
    }
  }

  Future<void> _syncWorkerSchedulesToBranchPatternForWeekday({
    required int weekday,
    required SchedulePatternBranchItemApi branchPattern,
    required int branchId,
  }) async {
    final employees = _employees.value;
    if (employees == null) return;

    final dates = daysOfMonth(_monthStart)
        .where((date) => date.weekday == weekday)
        .toList();

    for (final row in employees) {
      if (row.isBranchRow) continue;
      final workerId = int.tryParse(row.id);
      if (workerId == null || workerId <= 0) continue;

      for (final date in dates) {
        final dayIndex = workScheduleDayIndexInMonth(_monthStart, date);
        if (dayIndex < 0 || dayIndex >= row.monthCells.length) continue;

        final cell = row.monthCells[dayIndex];
        final clamped = clampWorkScheduleCellToBranchPattern(
          cell,
          branchPattern,
        );
        if (!_workerCellNeedsBranchSync(cell, clamped)) continue;

        try {
          final saved = await _saveWorkerScheduleDay(
            workerId: workerId,
            scheduleId: cell.scheduleId,
            date: date,
            branchId: branchId,
            body: _workerScheduleBodyFromCell(
              date: date,
              workerId: workerId,
              branchId: branchId,
              cell: clamped,
              fallbackStart: cell.timeStart,
              fallbackEnd: cell.timeEnd,
            ),
          );
          if (!mounted) return;
          _applySavedDayLocally(
            employeeId: row.id,
            date: date,
            cell: _cellFromEditResult(
              result: WorkScheduleDayEditResult(
                isWorkingDay: clamped.kind == WorkScheduleCellKind.shift,
                workStart: clamped.timeStart ?? cell.timeStart ?? '09:00',
                workEnd: clamped.timeEnd ?? cell.timeEnd ?? '20:00',
                breakStart: clamped.breakStart,
                breakEnd: clamped.breakEnd,
              ),
              previous: cell,
              scheduleId: saved.id,
            ),
          );
        } catch (_) {
          // Остальные сотрудники/дни продолжаем синхронизировать.
        }
      }
    }
  }

  bool _workerCellNeedsBranchSync(
    WorkScheduleDayCell current,
    WorkScheduleDayCell clamped,
  ) {
    if (current.kind != WorkScheduleCellKind.shift &&
        clamped.kind != WorkScheduleCellKind.shift) {
      return false;
    }
    if (current.kind != clamped.kind) return true;
    return current.timeStart != clamped.timeStart ||
        current.timeEnd != clamped.timeEnd;
  }

  CreateWorkerScheduleRequest _workerScheduleBodyFromCell({
    required DateTime date,
    required int workerId,
    required int branchId,
    required WorkScheduleDayCell cell,
    String? fallbackStart,
    String? fallbackEnd,
  }) {
    final isWorking = cell.kind == WorkScheduleCellKind.shift;
    return CreateWorkerScheduleRequest.forWorker(
      date: date,
      timeStart: isWorking ? (cell.timeStart ?? fallbackStart ?? '09:00') : (fallbackStart ?? '09:00'),
      timeEnd: isWorking ? (cell.timeEnd ?? fallbackEnd ?? '20:00') : (fallbackEnd ?? '20:00'),
      active: isWorking,
      workerId: workerId,
      branchId: branchId,
      breakStart: isWorking ? cell.breakStart : null,
      breakEnd: isWorking ? cell.breakEnd : null,
      auto: true,
    );
  }

  void _applyBranchSchedulePatternsToGrid(
    List<SchedulePatternBranchItemApi> patterns,
  ) {
    final employees = _employees.value;
    if (employees == null || employees.isEmpty) return;

    final branchRow = employees.first;
    if (!branchRow.isBranchRow) return;

    final branchPatternsByDay = branchSchedulePatternsMapFromList(patterns);
    final updatedBranchRow = workScheduleBranchRow(
      monthStart: _monthStart,
      branchName: branchRow.name,
      patternsByDay: branchPatternsByDay,
    );
    final offset = _readHorizontalScrollOffset();

    setState(() {
      _branchPatternsByDay = branchPatternsByDay;
      _employees = AsyncValue.data([
        updatedBranchRow,
        for (final row in employees.skip(1))
          _reclampWorkerRowForAllBranchPatterns(
            row: row,
            patternsByDay: branchPatternsByDay,
          ),
      ]);
      _gridVersion++;
    });
    _restoreHorizontalScrollOffset(offset);
  }

  WorkScheduleEmployeeRow _reclampWorkerRowForAllBranchPatterns({
    required WorkScheduleEmployeeRow row,
    required Map<String, SchedulePatternBranchItemApi> patternsByDay,
  }) {
    return WorkScheduleEmployeeRow(
      id: row.id,
      name: row.name,
      pictureUrl: row.pictureUrl,
      monthCells: [
        for (var i = 0; i < row.monthCells.length; i++)
          clampWorkScheduleCellToBranchPattern(
            row.monthCells[i],
            branchSchedulePatternForDate(patternsByDay, _dateForDayIndex(i)),
          ),
      ],
    );
  }

  void _showWorkScheduleNoPermissionMessage() {
    if (!mounted) return;
    final hostContext = _scaffoldKey.currentContext ?? context;
    if (!hostContext.mounted) return;
    showAppServiceMessage(
      hostContext,
      message: workScheduleNoPermissionMessage,
      variant: AppServiceMessageVariant.error,
    );
  }

  void _handleWorkSchedulePermissionDenied() {
    markWorkScheduleEditBlocked(ref);
    _showWorkScheduleNoPermissionMessage();
  }

  Future<void> _onBranchDayCellTap(DateTime date) async {
    if (!_canChangeBranchWorkSchedule()) {
      if (!mounted) return;
      showAppServiceMessage(
        _scaffoldKey.currentContext ?? context,
        message: _branchWorkScheduleNoPermissionMessage,
        variant: AppServiceMessageVariant.error,
      );
      return;
    }

    final employees = _employees.value;
    if (employees == null || employees.isEmpty || !employees.first.isBranchRow) {
      return;
    }
    final cell = _cellForDate(employees.first, date);
    if (cell == null) return;

    final branchId = ref.read(currentBranchIdProvider);
    if (branchId <= 0) return;

    final pattern = branchSchedulePatternForDate(_branchPatternsByDay, date);
    if (pattern == null || pattern.id <= 0) {
      if (!mounted) return;
      showAppServiceMessage(
        _scaffoldKey.currentContext ?? context,
        message: 'Не удалось найти шаблон филиала для этого дня',
        variant: AppServiceMessageVariant.error,
      );
      return;
    }

    final normalizedDate = DateTime(date.year, date.month, date.day);
    final result = await showWorkScheduleDayEditDialog(
      rootNavigatorKey.currentContext ?? context,
      cell: cell,
    );
    if (result == null || !mounted) return;

    final fallbackStart = cell.timeStart ?? '09:00';
    final fallbackEnd = cell.timeEnd ?? '20:00';
    final batch = UpdateBranchSchedulePatternsRequest(
      patterns: [
        UpdateBranchSchedulePatternItem.fromBranchPattern(
          pattern,
          timeStart: result.isWorkingDay ? result.workStart : fallbackStart,
          timeEnd: result.isWorkingDay ? result.workEnd : fallbackEnd,
          active: result.isWorkingDay,
        ),
      ],
    );

    final snapshot = _employees.value;
    final branchPatternsSnapshot = _branchPatternsByDay;
    final optimisticCell = _cellFromEditResult(
      result: result,
      previous: cell,
    );
    final optimisticPattern = UpdateBranchSchedulePatternItem.fromBranchPattern(
      pattern,
      timeStart: result.isWorkingDay ? result.workStart : fallbackStart,
      timeEnd: result.isWorkingDay ? result.workEnd : fallbackEnd,
      active: result.isWorkingDay,
    );
    final scrollOffsetBeforeSave = _readHorizontalScrollOffset();

    setState(() {
      _savingEmployeeId = workScheduleBranchRowId;
      _savingDate = normalizedDate;
    });
    _applySavedBranchPatternLocally(
      weekday: normalizedDate.weekday,
      cell: optimisticCell,
      updatedPattern: SchedulePatternBranchItemApi(
        id: pattern.id,
        branch: pattern.branch,
        day: pattern.day,
        timeStart: optimisticPattern.timeStart,
        timeEnd: optimisticPattern.timeEnd,
        active: optimisticPattern.active,
      ),
    );

    try {
      await ref.read(schedulePatternsServiceProvider).updateBranchSchedulePatternsBatch(
        branchId: branchId,
        body: batch,
      );
      if (!mounted) return;

      final savedPattern = SchedulePatternBranchItemApi(
        id: pattern.id,
        branch: pattern.branch,
        day: pattern.day,
        timeStart: optimisticPattern.timeStart,
        timeEnd: optimisticPattern.timeEnd,
        active: optimisticPattern.active,
      );
      await _syncWorkerSchedulesToBranchPatternForWeekday(
        weekday: normalizedDate.weekday,
        branchPattern: savedPattern,
        branchId: branchId,
      );

      ref.invalidate(branchesProvider);
      try {
        await ref.read(branchesProvider.future);
      } catch (_) {}
      invalidateWorkScheduleCaches(ref, branchId: branchId);
      ref.invalidate(branchSchedulePatternsBranchProvider(branchId));
      showAppServiceMessage(
        _scaffoldKey.currentContext ?? context,
        message: 'График филиала обновлён',
      );
      _scheduleReloadAfterReturn(force: true);
    } catch (e) {
      if (!mounted) return;
      if (snapshot != null) {
        setState(() {
          _employees = AsyncValue.data(snapshot);
          _branchPatternsByDay = branchPatternsSnapshot;
        });
        _restoreHorizontalScrollOffset(scrollOffsetBeforeSave);
      }
      if (isWorkSchedulePermissionError(e)) {
        _handleWorkSchedulePermissionDenied();
        return;
      }
      showAppServiceMessage(
        _scaffoldKey.currentContext ?? context,
        message: _saveDayErrorMessage(e),
        variant: AppServiceMessageVariant.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _savingEmployeeId = null;
          _savingDate = null;
        });
        _restoreHorizontalScrollOffset(scrollOffsetBeforeSave);
      }
    }
  }

  Future<void> _onDayCellTap(
    WorkScheduleEmployeeRow employee,
    DateTime date,
  ) async {
    if (employee.isBranchRow) {
      await _onBranchDayCellTap(date);
      return;
    }

    if (!await _canChangeWorkSchedule()) {
      _showWorkScheduleNoPermissionMessage();
      return;
    }
    if (isPastWorkScheduleDate(date)) return;

    final cell = _cellForDate(employee, date);
    if (cell == null) return;

    final workerId = int.tryParse(employee.id);
    final branchId = ref.read(currentBranchIdProvider);
    if (workerId == null || workerId <= 0 || branchId <= 0) return;

    final normalizedDate = DateTime(date.year, date.month, date.day);

    final result = await showWorkScheduleDayEditDialog(
      rootNavigatorKey.currentContext ?? context,
      cell: cell,
      validateBeforeSave: (draft) => validateWorkScheduleDayAgainstAppointments(
        ref: ref,
        branchId: branchId,
        workerId: workerId,
        date: normalizedDate,
        proposed: WorkScheduleDayBounds(
          isWorkingDay: draft.isWorkingDay,
          workStart: draft.workStart,
          workEnd: draft.workEnd,
          breakStart: draft.breakStart,
          breakEnd: draft.breakEnd,
        ),
      ),
    );
    if (result == null || !mounted) return;
    final fallbackStart = cell.timeStart ?? '09:00';
    final fallbackEnd = cell.timeEnd ?? '20:00';
    final body = CreateWorkerScheduleRequest.forWorker(
      date: normalizedDate,
      timeStart: result.isWorkingDay ? result.workStart : fallbackStart,
      timeEnd: result.isWorkingDay ? result.workEnd : fallbackEnd,
      active: result.isWorkingDay,
      workerId: workerId,
      branchId: branchId,
      breakStart: result.isWorkingDay ? result.breakStart : null,
      breakEnd: result.isWorkingDay ? result.breakEnd : null,
      auto: false,
    );

    final snapshot = _employees.value;
    final optimisticCell = _cellFromEditResult(
      result: result,
      previous: cell,
    );
    final scrollOffsetBeforeSave = _readHorizontalScrollOffset();

    setState(() {
      _savingEmployeeId = employee.id;
      _savingDate = normalizedDate;
    });
    _applySavedDayLocally(
      employeeId: employee.id,
      date: normalizedDate,
      cell: optimisticCell,
    );

    try {
      final saved = await _saveWorkerScheduleDay(
        workerId: workerId,
        scheduleId: cell.scheduleId,
        date: normalizedDate,
        branchId: branchId,
        body: body,
      );
      if (!mounted) return;
      _applySavedDayLocally(
        employeeId: employee.id,
        date: normalizedDate,
        cell: _cellFromEditResult(
          result: result,
          previous: cell,
          scheduleId: saved.id,
        ),
      );
      bumpWorkScheduleReloadToken(ref);
      ref.invalidate(availableWorkersForDateProvider(normalizedDate));
    } catch (e) {
      if (!mounted) return;
      if (snapshot != null) {
        _setEmployeesPreservingScroll(snapshot);
      }
      if (isWorkSchedulePermissionError(e)) {
        _handleWorkSchedulePermissionDenied();
        return;
      }
      showAppServiceMessage(
        _scaffoldKey.currentContext ?? context,
        message: _saveDayErrorMessage(e),
        variant: AppServiceMessageVariant.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _savingEmployeeId = null;
          _savingDate = null;
        });
        _restoreHorizontalScrollOffset(scrollOffsetBeforeSave);
      }
    }
  }

  Future<void> _onEmployeeMoreTap(WorkScheduleEmployeeRow employee) async {
    final hostContext = rootNavigatorKey.currentContext ?? context;
    if (!hostContext.mounted) return;

    if (employee.isBranchRow) {
      if (!_canChangeBranchWorkSchedule()) {
        if (!mounted) return;
        showAppServiceMessage(
          hostContext,
          message: _branchWorkScheduleNoPermissionMessage,
          variant: AppServiceMessageVariant.error,
        );
        return;
      }
      final branchId = ref.read(currentBranchIdProvider);
      if (branchId <= 0) return;
      Object? saveResult;
      try {
        saveResult = await hostContext.pushNamed<Object?>(
          BranchSchedulePage.name,
          extra: BranchSchedulePageArgs(
            branchId: branchId,
            branchName: employee.name,
          ),
        );
        if (!mounted) return;
        if (saveResult is BranchScheduleSaveResult) {
          final previousPatterns =
              Map<String, SchedulePatternBranchItemApi>.from(_branchPatternsByDay);
          _applyBranchSchedulePatternsToGrid(saveResult.patterns);
          ref.invalidate(branchesProvider);
          await _syncWorkersToUpdatedBranchPatterns(
            previousPatterns: previousPatterns,
            nextPatterns: branchSchedulePatternsMapFromList(saveResult.patterns),
          );
          showAppServiceMessage(
            context,
            message: 'График филиала обновлён',
          );
        }
      } finally {
        if (mounted && saveResult is BranchScheduleSaveResult) {
          _scheduleReloadAfterReturn(force: true);
        }
      }
      return;
    }

    if (!await _canChangeWorkSchedule()) {
      _showWorkScheduleNoPermissionMessage();
      return;
    }
    try {
      final saved = await hostContext.pushNamed<bool>(
        SpecialistSchedulePage.name,
        extra: SpecialistSchedulePageArgs(
          employeeId: employee.id,
          employeeName: employee.name,
          pictureUrl: employee.pictureUrl,
        ),
      );
      if (!mounted) return;
      if (saved == true) {
        showAppServiceMessage(
          context,
          message: 'График работы филиала обновлен',
        );
      }
    } finally {
      if (mounted) {
        _scheduleReloadAfterReturn(employeeId: employee.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final branchId = ref.watch(currentBranchIdProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenBackground = isDark
        ? AppColors.secondaryDarkLight
        : AppColors.tabBarScreenBackground;
    final isWorkerRole = ref.watch(roleProvider) == UserRole.worker.value;
    final workerLabels =
        ref.watch(workerEntityLabelsProvider).value ??
        WorkerEntityLabels.defaults;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: screenBackground,
      body: Column(
        children: [
          TopPanel(
            title: workerLabels.workScheduleTitle(isWorkerRole: isWorkerRole),
            showBackButton: true,
            scheduleMonthHeaderOnly: true,
            monthStart: _monthStart,
            onMonthStartChanged: _onMonthStartChanged,
            scheduleSelectedDate: _today,
            workScheduleDatesScrollController: _datesHeaderScroll,
          ),
          Expanded(
            child: AppRefreshable(
              onRefresh: _reloadWorkSchedule,
              hasScrollBody: true,
              child: _employees.when(
              loading: () => const Center(child: LoadingWidget()),
              error: (error, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Не удалось загрузить график',
                    style: AppFonts.b1Medium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              data: (employees) {
                final dayCount = daysInMonth(_monthStart);
                final rowsReady = employees.every(
                  (row) => row.monthCells.length == dayCount,
                );
                if (!rowsReady) {
                  if (_rowsResyncForEpoch != _loadEpoch) {
                    _rowsResyncForEpoch = _loadEpoch;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!mounted || _rowsResyncForEpoch != _loadEpoch) {
                        return;
                      }
                      unawaited(_reloadWorkSchedule(forceLoading: true));
                    });
                  }
                  return const Center(child: LoadingWidget());
                }
                if (_pendingHorizontalScrollToSelectedDate) {
                  _scheduleHorizontalScrollSync();
                }
                return Align(
                  alignment: Alignment.topCenter,
                  child: WorkScheduleMonthGrid(
                    key: ValueKey('work_grid_${branchId}_$_gridVersion'),
                    month: _monthStart,
                    employees: employees,
                    selectedDate: _today,
                    horizontalScrollController: _gridHorizontalScroll,
                    savingEmployeeId: _savingEmployeeId,
                    savingDate: _savingDate,
                    onEmployeeMoreTap: _onEmployeeMoreTap,
                    onCellTap: _onDayCellTap,
                  ),
                );
              },
            ),
          ),
        ),
        ],
      ),
    );
  }
}
