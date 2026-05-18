import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/widgets/top_panel.dart';
import 'package:rient_app/features/schedule/view/components/work_schedule_mock_data.dart';
import 'package:rient_app/features/schedule/view/components/work_schedule_month_grid.dart';
import 'package:rient_app/features/schedule/view/providers/workers_provider.dart';
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
  late DateTime _selectedDate;
  DateTime? _highlightedCellDate;
  late List<WorkScheduleEmployeeRow> _employees;
  late ScrollController _datesHeaderScroll;
  late ScrollController _gridHorizontalScroll;
  bool _syncingHorizontalScroll = false;

  @override
  void initState() {
    super.initState();
    _datesHeaderScroll = ScrollController();
    _gridHorizontalScroll = ScrollController();
    _datesHeaderScroll.addListener(_onDatesHeaderScrolled);
    _gridHorizontalScroll.addListener(_onGridHorizontalScrolled);
    _syncToNow();
    _employees = mockWorkScheduleEmployeesForMonth(_monthStart);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToInitialDay();
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
    _selectedDate = DateTime(now.year, now.month, now.day);
    _monthStart = DateTime(now.year, now.month, 1);
  }

  void _reloadEmployees() {
    _employees = mockWorkScheduleEmployeesForMonth(
      _monthStart,
      highlightedCellDate: _highlightedCellDate,
    );
  }

  DateTime _initialScrollDate() {
    final now = DateTime.now();
    if (now.year == _monthStart.year && now.month == _monthStart.month) {
      return DateTime(now.year, now.month, now.day);
    }
    if (_selectedDate.year == _monthStart.year &&
        _selectedDate.month == _monthStart.month) {
      return _selectedDate;
    }
    return DateTime(_monthStart.year, _monthStart.month, 1);
  }

  void _scrollToInitialDay() {
    final days = daysOfMonth(_monthStart);
    final target = _initialScrollDate();
    final index = days.indexWhere(
      (d) =>
          d.year == target.year &&
          d.month == target.month &&
          d.day == target.day,
    );
    if (index < 0) return;

    final offset = index * (workScheduleDayColumnWidth + workScheduleDayCellGap);

    void applyScroll() {
      for (final controller in [_datesHeaderScroll, _gridHorizontalScroll]) {
        if (!controller.hasClients) continue;
        final position = controller.position;
        final clamped = offset.clamp(0.0, position.maxScrollExtent);
        if ((position.pixels - clamped).abs() > 0.5) {
          controller.jumpTo(clamped);
        }
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      applyScroll();
      if (!_datesHeaderScroll.hasClients || !_gridHorizontalScroll.hasClients) {
        WidgetsBinding.instance.addPostFrameCallback((_) => applyScroll());
      }
    });
  }

  void _onMonthStartChanged(DateTime monthStart) {
    setState(() {
      _highlightedCellDate = null;
      _monthStart = DateTime(monthStart.year, monthStart.month, 1);
      final lastDay = daysInMonth(_monthStart);
      if (_selectedDate.year != _monthStart.year ||
          _selectedDate.month != _monthStart.month) {
        final day = _selectedDate.day.clamp(1, lastDay);
        _selectedDate = DateTime(_monthStart.year, _monthStart.month, day);
      } else if (_selectedDate.day > lastDay) {
        _selectedDate = DateTime(
          _monthStart.year,
          _monthStart.month,
          lastDay,
        );
      }
      _reloadEmployees();
    });
    ref.read(selectedScheduleDateProvider.notifier).state = _selectedDate;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToInitialDay();
    });
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = DateTime(date.year, date.month, date.day);
      _reloadEmployees();
    });
    ref.read(selectedScheduleDateProvider.notifier).state = _selectedDate;
  }

  void _onEmployeeMoreTap(WorkScheduleEmployeeRow employee) {
    context.pushNamed(
      SpecialistSchedulePage.name,
      extra: SpecialistSchedulePageArgs(
        employeeId: employee.id,
        employeeName: employee.name,
        pictureUrl: employee.pictureUrl,
      ),
    );
  }

  void _onCellTap(WorkScheduleEmployeeRow employee, DateTime date) {
    setState(() {
      _selectedDate = DateTime(date.year, date.month, date.day);
      _highlightedCellDate = _selectedDate;
      _reloadEmployees();
    });
    ref.read(selectedScheduleDateProvider.notifier).state = _selectedDate;
  }

  @override
  Widget build(BuildContext context) {
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
            scheduleSelectedDate: _selectedDate,
            onScheduleDateSelected: _onDateSelected,
            workScheduleDatesScrollController: _datesHeaderScroll,
          ),
          Expanded(
            child: WorkScheduleMonthGrid(
              month: _monthStart,
              employees: _employees,
              selectedDate: _selectedDate,
              horizontalScrollController: _gridHorizontalScroll,
              onCellTap: _onCellTap,
              onEmployeeMoreTap: _onEmployeeMoreTap,
            ),
          ),
        ],
      ),
    );
  }
}
