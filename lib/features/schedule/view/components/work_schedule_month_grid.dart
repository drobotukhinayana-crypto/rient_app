import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/features/schedule/view/components/work_schedule_mock_data.dart';

const workScheduleEmployeeColumnWidth = 58.0;
const workScheduleEmployeeToGridGap = 6.0;
const workScheduleDayColumnWidth = 44.0;
const workScheduleDayCellGap = 4.0;
const workScheduleInactiveDayFill = Color(0xFFECEEF2);

double workScheduleHorizontalOffsetForDayIndex(int dayIndex) {
  return dayIndex * (workScheduleDayColumnWidth + workScheduleDayCellGap);
}

int workScheduleDayIndexInMonth(DateTime month, DateTime day) {
  final days = daysOfMonth(month);
  return days.indexWhere(
    (d) => d.year == day.year && d.month == day.month && d.day == day.day,
  );
}

const _rowHeight = 80.0;
const _sidebarRadius = 20.0;

class WorkScheduleMonthGrid extends StatefulWidget {
  const WorkScheduleMonthGrid({
    super.key,
    required this.month,
    required this.employees,
    required this.selectedDate,
    required this.horizontalScrollController,
    this.onCellTap,
    this.onEmployeeMoreTap,
  });

  final DateTime month;
  final List<WorkScheduleEmployeeRow> employees;
  final DateTime selectedDate;
  final ScrollController horizontalScrollController;
  final void Function(WorkScheduleEmployeeRow employee, DateTime date)? onCellTap;
  final void Function(WorkScheduleEmployeeRow employee)? onEmployeeMoreTap;

  @override
  State<WorkScheduleMonthGrid> createState() => _WorkScheduleMonthGridState();
}

class _WorkScheduleMonthGridState extends State<WorkScheduleMonthGrid> {
  final ScrollController _employeeVerticalController = ScrollController();
  final ScrollController _gridVerticalController = ScrollController();
  bool _syncingVerticalScroll = false;

  List<DateTime> get _monthDays => daysOfMonth(widget.month);

  @override
  void initState() {
    super.initState();
    _employeeVerticalController.addListener(_onEmployeeVerticalScrolled);
    _gridVerticalController.addListener(_onGridVerticalScrolled);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollGridToSelectedDate();
    });
  }

  @override
  void didUpdateWidget(WorkScheduleMonthGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.month != widget.month ||
        oldWidget.selectedDate != widget.selectedDate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollGridToSelectedDate();
      });
    }
  }

  void _scrollGridToSelectedDate({int attempt = 0}) {
    if (!mounted || attempt > 20) return;

    final index = workScheduleDayIndexInMonth(
      widget.month,
      widget.selectedDate,
    );
    if (index < 0) return;

    final targetOffset = workScheduleHorizontalOffsetForDayIndex(index);
    final controller = widget.horizontalScrollController;

    if (!controller.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollGridToSelectedDate(attempt: attempt + 1),
      );
      return;
    }

    final position = controller.position;
    final clamped = targetOffset.clamp(0.0, position.maxScrollExtent);
    if ((position.pixels - clamped).abs() > 0.5) {
      controller.jumpTo(clamped);
    }

    if (targetOffset > position.maxScrollExtent + 0.5) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollGridToSelectedDate(attempt: attempt + 1),
      );
    }
  }

  @override
  void dispose() {
    _employeeVerticalController.removeListener(_onEmployeeVerticalScrolled);
    _gridVerticalController.removeListener(_onGridVerticalScrolled);
    _employeeVerticalController.dispose();
    _gridVerticalController.dispose();
    super.dispose();
  }

  void _onEmployeeVerticalScrolled() {
    if (_syncingVerticalScroll || !_gridVerticalController.hasClients) return;
    _syncingVerticalScroll = true;
    _gridVerticalController.jumpTo(_employeeVerticalController.offset);
    _syncingVerticalScroll = false;
  }

  void _onGridVerticalScrolled() {
    if (_syncingVerticalScroll || !_employeeVerticalController.hasClients) {
      return;
    }
    _syncingVerticalScroll = true;
    _employeeVerticalController.jumpTo(_gridVerticalController.offset);
    _syncingVerticalScroll = false;
  }

  double _bottomScrollPadding(BuildContext context) {
    return MediaQuery.paddingOf(context).bottom + 24;
  }

  double _rowsHeight(int employeeCount) {
    if (employeeCount <= 0) return 0;
    return employeeCount * _rowHeight +
        (employeeCount - 1) * workScheduleDayCellGap;
  }

  /// Высота белого блока по числу строк (без лишнего запаса снизу).
  double _gridContentHeight(int employeeCount, {double extraBottom = 0}) {
    if (employeeCount <= 0) return 0;
    return 16 + _rowsHeight(employeeCount) + extraBottom;
  }

  Widget _employeeRow(int index) {
    final employee = widget.employees[index];
    final isLast = index == widget.employees.length - 1;
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : workScheduleDayCellGap),
      child: SizedBox(
        height: _rowHeight,
        child: _EmployeeColumn(
          name: employee.name,
          pictureUrl: employee.pictureUrl,
          onMoreTap: () => widget.onEmployeeMoreTap?.call(employee),
        ),
      ),
    );
  }

  Widget _scheduleRow(int rowIndex, List<DateTime> monthDays) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: rowIndex < widget.employees.length - 1
            ? workScheduleDayCellGap
            : 0,
      ),
      child: SizedBox(
        height: _rowHeight,
        child: Row(
          children: [
            for (var j = 0; j < monthDays.length; j++) ...[
              if (j > 0) const Gap(workScheduleDayCellGap),
              SizedBox(
                width: workScheduleDayColumnWidth,
                child: _DayCell(
                  date: monthDays[j],
                  cell: widget.employees[rowIndex].monthCells[j],
                  onTap: widget.onCellTap == null
                      ? null
                      : () => widget.onCellTap!(
                            widget.employees[rowIndex],
                            monthDays[j],
                          ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _scheduleTable(
    List<DateTime> monthDays,
    double tableWidth, {
    required bool scrollVertically,
    required double bottomInset,
  }) {
    final rows = [
      for (var i = 0; i < widget.employees.length; i++)
        _scheduleRow(i, monthDays),
      if (scrollVertically) SizedBox(height: 8 + bottomInset),
    ];

    final table = SizedBox(
      width: tableWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: rows,
      ),
    );

    final horizontal = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: widget.horizontalScrollController,
      child: table,
    );

    if (!scrollVertically) return horizontal;

    return SingleChildScrollView(
      controller: _gridVerticalController,
      child: horizontal,
    );
  }

  BoxDecoration _sidebarDecoration(bool isDark) {
    return BoxDecoration(
      color: isDark ? AppColors.primaryWhiteDark : Colors.white,
      borderRadius: BorderRadius.circular(_sidebarRadius),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.06),
          blurRadius: 12,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _employeeSidebar({
    required bool isDark,
    required double height,
    required bool scrollVertically,
    required double bottomInset,
  }) {
    final clip = ClipRRect(
      borderRadius: BorderRadius.circular(_sidebarRadius),
      child: scrollVertically
          ? ListView.builder(
              controller: _employeeVerticalController,
              padding: EdgeInsets.only(top: 8, bottom: 8 + bottomInset),
              itemCount: widget.employees.length,
              itemBuilder: (context, index) => _employeeRow(index),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < widget.employees.length; i++)
                    _employeeRow(i),
                ],
              ),
            ),
    );

    return SizedBox(
      width: workScheduleEmployeeColumnWidth,
      height: height,
      child: Container(
        decoration: _sidebarDecoration(isDark),
        child: clip,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final monthDays = _monthDays;
    final tableWidth = monthDays.length * workScheduleDayColumnWidth +
        (monthDays.length - 1) * workScheduleDayCellGap;
    final bottomScrollPadding = _bottomScrollPadding(context);

    return Padding(
      padding: AppDecoration.padding16.copyWith(top: 12, bottom: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxHeight = constraints.maxHeight;
          final compactHeight =
              _gridContentHeight(widget.employees.length);
          final scrollVertically = compactHeight > maxHeight;
          final gridHeight =
              scrollVertically ? maxHeight : compactHeight;
          final bottomInset =
              scrollVertically ? bottomScrollPadding : 0.0;

          return SizedBox(
            height: gridHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _employeeSidebar(
                  isDark: isDark,
                  height: gridHeight,
                  scrollVertically: scrollVertically,
                  bottomInset: bottomInset,
                ),
                const Gap(workScheduleEmployeeToGridGap),
                Expanded(
                  child: SizedBox(
                    height: gridHeight,
                    child: _scheduleTable(
                      monthDays,
                      tableWidth,
                      scrollVertically: scrollVertically,
                      bottomInset: bottomInset,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EmployeeColumn extends StatelessWidget {
  const _EmployeeColumn({
    required this.name,
    this.pictureUrl,
    this.onMoreTap,
  });

  final String name;
  final String? pictureUrl;
  final VoidCallback? onMoreTap;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.themeAccent(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _Avatar(name: name, pictureUrl: pictureUrl),
              const Gap(4),
              Text(
                _shortName(name),
                style: AppFonts.c2Tabbar.copyWith(
                  color: accent,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          _EmployeeMoreButton(onTap: onMoreTap),
        ],
      ),
    );
  }

  static String _shortName(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length <= 1) return fullName;
    final last = parts[1];
    final initial = last.isNotEmpty ? '${last[0]}.' : '';
    return '${parts[0]} $initial'.trim();
  }
}

class _EmployeeMoreButton extends StatelessWidget {
  const _EmployeeMoreButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = AppColors.themeAccent(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 40,
        height: 18,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDark ? AppColors.secondaryDarkDark : AppColors.secondaryDark,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          Icons.more_horiz_rounded,
          size: 16,
          color: accent,
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name, this.pictureUrl});

  final String name;
  final String? pictureUrl;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (pictureUrl != null && pictureUrl!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          pictureUrl!,
          width: 32,
          height: 32,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(isDark),
        ),
      );
    }
    return _placeholder(isDark);
  }

  Widget _placeholder(bool isDark) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isDark ? AppColors.forthLightDark : AppColors.forthLight,
        shape: BoxShape.circle,
      ),
    );
  }
}

Color _shiftBackground(WorkScheduleDayCell cell, bool isPast) {
  if (cell.isManuallyEdited) {
    return isPast
        ? WorkScheduleCellColors.manualEditPast
        : WorkScheduleCellColors.manualEdit;
  }
  return isPast ? WorkScheduleCellColors.shiftPast : WorkScheduleCellColors.shift;
}

Color _dayOffBackground(WorkScheduleDayCell cell, bool isPast) {
  if (cell.isManuallyEdited) {
    return isPast
        ? WorkScheduleCellColors.manualEditPast
        : WorkScheduleCellColors.manualEdit;
  }
  return isPast ? WorkScheduleCellColors.dayOffPast : WorkScheduleCellColors.dayOff;
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.cell,
    this.onTap,
  });

  final DateTime date;
  final WorkScheduleDayCell cell;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.themeAccent(context);
    final isPast = isPastWorkScheduleDate(date);

    final effectiveOnTap = isPast ? null : onTap;

    if (cell.kind == WorkScheduleCellKind.dayOff) {
      return _CellContainer(
        isSelected: false,
        accent: accent,
        backgroundColor: _dayOffBackground(cell, isPast),
        onTap: effectiveOnTap,
        child: const Text('😴', style: TextStyle(fontSize: 16)),
      );
    }

    return _CellContainer(
      isSelected: cell.isSelected,
      accent: accent,
      backgroundColor: _shiftBackground(cell, isPast),
      onTap: effectiveOnTap,
      child: Text(
        '${cell.timeStart}\n${cell.timeEnd}',
        style: AppFonts.c2Tabbar.copyWith(
          color: Colors.white,
          height: 1.1,
          fontSize: 9,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
        maxLines: 2,
      ),
    );
  }
}

class _CellContainer extends StatelessWidget {
  const _CellContainer({
    required this.isSelected,
    required this.accent,
    required this.backgroundColor,
    required this.child,
    this.onTap,
  });

  final bool isSelected;
  final Color accent;
  final Color backgroundColor;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: accent, width: 2)
                : null,
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}
