import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/loading_widget.dart';
import 'package:rient_app/core/widgets/top_panel.dart';
import 'package:rient_app/features/schedule/view/components/work_schedule_mock_data.dart';
import 'package:rient_app/features/schedule/view/components/work_schedule_month_grid.dart';
import 'package:rient_app/features/schedule/view/providers/work_schedule_provider.dart';
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

  WorkScheduleMonthQuery get _monthQuery =>
      WorkScheduleMonthQuery(monthStart: _monthStart);

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

  void _invalidateMonth() {
    ref.invalidate(workScheduleMonthProvider(_monthQuery));
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
    _invalidateMonth();
    _requestScrollToSelectedDate();
  }

  Future<void> _onEmployeeMoreTap(WorkScheduleEmployeeRow employee) async {
    await context.pushNamed(
      SpecialistSchedulePage.name,
      extra: SpecialistSchedulePageArgs(
        employeeId: employee.id,
        employeeName: employee.name,
        pictureUrl: employee.pictureUrl,
      ),
    );
    _invalidateMonth();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenBackground = isDark
        ? AppColors.secondaryDarkLight
        : AppColors.tabBarScreenBackground;
    final employeesAsync = ref.watch(workScheduleMonthProvider(_monthQuery));

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
            child: employeesAsync.when(
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
                return WorkScheduleMonthGrid(
                  month: _monthStart,
                  employees: employees,
                  selectedDate: _today,
                  horizontalScrollController: _gridHorizontalScroll,
                  onEmployeeMoreTap: _onEmployeeMoreTap,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
