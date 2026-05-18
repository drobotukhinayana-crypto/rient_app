import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/loading_widget.dart';
import 'package:rient_app/core/widgets/top_panel.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/schedule/data/models/schedules_api/create_worker_schedule_request.dart';
import 'package:rient_app/features/schedule/view/components/work_schedule_day_edit_dialog.dart';
import 'package:rient_app/features/schedule/view/components/work_schedule_mock_data.dart';
import 'package:rient_app/features/schedule/view/components/work_schedule_month_grid.dart';
import 'package:rient_app/features/schedule/view/providers/work_schedule_provider.dart';
import 'package:rient_app/features/schedule/service/schedules_service.dart';
import 'package:rient_app/features/schedule/view/specialist_schedule_page.dart';

class WorkSchedulePage extends ConsumerStatefulWidget {
  const WorkSchedulePage({super.key});

  static const name = 'work_schedule_page';
  static const path = 'work_schedule';

  @override
  ConsumerState<WorkSchedulePage> createState() => _WorkSchedulePageState();
}

class _WorkSchedulePageState extends ConsumerState<WorkSchedulePage> {
  late DateTime _monthStart;
  late ScrollController _datesHeaderScroll;
  late ScrollController _gridHorizontalScroll;
  bool _syncingHorizontalScroll = false;
  bool _pendingHorizontalScrollToSelectedDate = true;
  int _loadEpoch = 0;
  int _gridVersion = 0;
  int _fetchGeneration = 0;
  AsyncValue<List<WorkScheduleEmployeeRow>> _employees =
      const AsyncValue.loading();

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  @override
  void initState() {
    super.initState();
    _datesHeaderScroll = ScrollController();
    _gridHorizontalScroll = ScrollController();
    _datesHeaderScroll.addListener(_onDatesHeaderScrolled);
    _gridHorizontalScroll.addListener(_onGridHorizontalScrolled);
    _syncToNow();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_reloadWorkSchedule());
      _scrollToSelectedDate();
    });
  }

  @override
  void dispose() {
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

  Future<void> _reloadWorkSchedule({String? employeeId}) async {
    final generation = ++_fetchGeneration;
    final branchId = ref.read(currentBranchIdProvider);
    final workerId =
        employeeId != null ? int.tryParse(employeeId) : null;
    final nextEpoch = _loadEpoch + 1;
    final query = WorkScheduleMonthQuery(
      monthStart: _monthStart,
      loadEpoch: nextEpoch,
    );

    setState(() {
      _loadEpoch = nextEpoch;
      _gridVersion++;
      _employees = const AsyncValue.loading();
      _pendingHorizontalScrollToSelectedDate = true;
    });

    try {
      final rows = await reloadWorkScheduleMonth(
        ref,
        query,
        branchId: branchId,
        workerId: workerId,
      );
      if (!mounted || generation != _fetchGeneration) return;
      setState(() => _employees = AsyncValue.data(rows));
    } catch (error, stackTrace) {
      if (!mounted || generation != _fetchGeneration) return;
      setState(() => _employees = AsyncValue.error(error, stackTrace));
    }
  }

  void _scheduleReloadAfterReturn({String? employeeId}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(_reloadWorkSchedule(employeeId: employeeId));
    });
  }

  DateTime _scrollTargetDateInMonth() {
    if (_today.year == _monthStart.year && _today.month == _monthStart.month) {
      return _today;
    }
    return DateTime(_monthStart.year, _monthStart.month, 1);
  }

  void _requestScrollToSelectedDate() {
    _pendingHorizontalScrollToSelectedDate = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _scrollToSelectedDate();
    });
  }

  double? _horizontalOffsetForSelectedDate() {
    final target = _scrollTargetDateInMonth();
    final index = workScheduleDayIndexInMonth(_monthStart, target);
    if (index < 0) return null;
    return workScheduleHorizontalOffsetForDayIndex(index);
  }

  bool _areHorizontalScrollsAligned(double targetOffset) {
    for (final controller in [_datesHeaderScroll, _gridHorizontalScroll]) {
      if (!controller.hasClients) return false;
      final clamped =
          targetOffset.clamp(0.0, controller.position.maxScrollExtent);
      if ((controller.position.pixels - clamped).abs() > 0.5) {
        return false;
      }
    }
    return true;
  }

  void _scrollToSelectedDate({int attempt = 0}) {
    if (!_pendingHorizontalScrollToSelectedDate || attempt > 20) return;

    final offset = _horizontalOffsetForSelectedDate();
    if (offset == null) return;

    _syncingHorizontalScroll = true;
    try {
      for (final controller in [_datesHeaderScroll, _gridHorizontalScroll]) {
        if (!controller.hasClients) continue;
        final position = controller.position;
        final clamped = offset.clamp(0.0, position.maxScrollExtent);
        if ((position.pixels - clamped).abs() > 0.5) {
          controller.jumpTo(clamped);
        }
      }
    } finally {
      _syncingHorizontalScroll = false;
    }

    if (_areHorizontalScrollsAligned(offset)) {
      _pendingHorizontalScrollToSelectedDate = false;
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _scrollToSelectedDate(attempt: attempt + 1);
    });
  }

  void _onMonthStartChanged(DateTime monthStart) {
    setState(() {
      _monthStart = DateTime(monthStart.year, monthStart.month, 1);
    });
    unawaited(_reloadWorkSchedule());
    _requestScrollToSelectedDate();
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
      final message = _extractApiErrorMessage(dio.response?.data);
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
    final dateKey = SchedulesService.dateToApi(date);
    final key = CreateWorkerScheduleRequest.workerScheduleKey(workerId);
    for (final item in response.results) {
      if (item.date == dateKey &&
          item.branch == branchId &&
          item.key == key) {
        return item.id;
      }
    }
    return null;
  }

  Future<void> _saveWorkerScheduleDay({
    required int workerId,
    required int? scheduleId,
    required DateTime date,
    required int branchId,
    required CreateWorkerScheduleRequest body,
  }) async {
    final service = ref.read(schedulesServiceProvider);
    if (scheduleId != null) {
      await service.updateWorkerSchedule(
        workerId: workerId,
        scheduleId: scheduleId,
        body: body,
      );
      return;
    }

    try {
      await service.createWorkerSchedule(workerId: workerId, body: body);
    } catch (e) {
      if (!_isDuplicateScheduleDayError(e)) rethrow;
      final existingId = await _findScheduleIdForDate(
        workerId: workerId,
        date: date,
        branchId: branchId,
      );
      if (existingId == null) rethrow;
      await service.updateWorkerSchedule(
        workerId: workerId,
        scheduleId: existingId,
        body: body,
      );
    }
  }

  Future<void> _onDayCellTap(
    WorkScheduleEmployeeRow employee,
    DateTime date,
  ) async {
    final cell = _cellForDate(employee, date);
    if (cell == null) return;

    final result = await showWorkScheduleDayEditDialog(
      context,
      cell: cell,
    );
    if (result == null || !mounted) return;

    final workerId = int.tryParse(employee.id);
    final branchId = ref.read(currentBranchIdProvider);
    if (workerId == null || workerId <= 0 || branchId <= 0) return;

    final normalizedDate = DateTime(date.year, date.month, date.day);
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

    try {
      await _saveWorkerScheduleDay(
        workerId: workerId,
        scheduleId: cell.scheduleId,
        date: normalizedDate,
        branchId: branchId,
        body: body,
      );
      if (!mounted) return;
      await _reloadWorkSchedule(employeeId: employee.id);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_saveDayErrorMessage(e))),
      );
    }
  }

  Future<void> _onEmployeeMoreTap(WorkScheduleEmployeeRow employee) async {
    try {
      await context.pushNamed<bool>(
        SpecialistSchedulePage.name,
        extra: SpecialistSchedulePageArgs(
          employeeId: employee.id,
          employeeName: employee.name,
          pictureUrl: employee.pictureUrl,
        ),
      );
    } finally {
      if (mounted) {
        _scheduleReloadAfterReturn(employeeId: employee.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final branchId = ref.watch(currentBranchIdProvider);

    ref.listen<int>(currentBranchIdProvider, (previous, next) {
      if (previous == null || previous == next || next <= 0) return;
      unawaited(_reloadWorkSchedule());
    });

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenBackground = isDark
        ? AppColors.secondaryDarkLight
        : AppColors.tabBarScreenBackground;

    return Scaffold(
      backgroundColor: screenBackground,
      body: Column(
        children: [
          TopPanel(
            title: 'График работы',
            showBackButton: true,
            scheduleMonthHeaderOnly: true,
            monthStart: _monthStart,
            onMonthStartChanged: _onMonthStartChanged,
            scheduleSelectedDate: _today,
            workScheduleDatesScrollController: _datesHeaderScroll,
          ),
          Expanded(
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
                if (_pendingHorizontalScrollToSelectedDate) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) _scrollToSelectedDate();
                  });
                }
                return Align(
                  alignment: Alignment.topCenter,
                  child: WorkScheduleMonthGrid(
                    key: ValueKey('work_grid_${branchId}_$_gridVersion'),
                    month: _monthStart,
                    employees: employees,
                    selectedDate: _today,
                    horizontalScrollController: _gridHorizontalScroll,
                    onEmployeeMoreTap: _onEmployeeMoreTap,
                    onCellTap: _onDayCellTap,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
