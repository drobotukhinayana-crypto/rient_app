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

const _rowHeight = 72.0;
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sidebarColor = isDark ? AppColors.primaryWhiteDark : Colors.white;
    final monthDays = _monthDays;
    final tableWidth = monthDays.length * workScheduleDayColumnWidth +
        (monthDays.length - 1) * workScheduleDayCellGap;

    return Padding(
      padding: AppDecoration.padding16.copyWith(top: 12, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: workScheduleEmployeeColumnWidth,
            child: Container(
            decoration: BoxDecoration(
              color: sidebarColor,
              borderRadius: BorderRadius.circular(_sidebarRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: isDark ? 0.25 : 0.06,
                  ),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_sidebarRadius),
              child: ListView.builder(
                controller: _employeeVerticalController,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: widget.employees.length,
                itemBuilder: (context, index) {
                  final employee = widget.employees[index];
                  return SizedBox(
                    height: _rowHeight,
                    child: _EmployeeColumn(
                      name: employee.name,
                      pictureUrl: employee.pictureUrl,
                      onMoreTap: widget.onEmployeeMoreTap == null
                          ? null
                          : () => widget.onEmployeeMoreTap!(employee),
                    ),
                  );
                },
              ),
            ),
            ),
          ),
          const Gap(workScheduleEmployeeToGridGap),
          Expanded(
            child: SingleChildScrollView(
              controller: _gridVerticalController,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: widget.horizontalScrollController,
                child: SizedBox(
                  width: tableWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final employee in widget.employees)
                        Padding(
                          padding:
                              const EdgeInsets.only(bottom: workScheduleDayCellGap),
                          child: SizedBox(
                            height: _rowHeight,
                            child: Row(
                              children: [
                                for (var i = 0; i < monthDays.length; i++) ...[
                                  if (i > 0) const Gap(workScheduleDayCellGap),
                                  SizedBox(
                                    width: workScheduleDayColumnWidth,
                                    child: _DayCell(
                                      cell: employee.monthCells[i],
                                      onTap: widget.onCellTap == null
                                          ? null
                                          : () => widget.onCellTap!(
                                              employee,
                                              monthDays[i],
                                            ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          if (onMoreTap != null)
            GestureDetector(
              onTap: onMoreTap,
              behavior: HitTestBehavior.opaque,
              child: Icon(
                Icons.more_horiz_rounded,
                size: 16,
                color: accent.withValues(alpha: 0.7),
              ),
            ),
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

class _DayCell extends StatelessWidget {
  const _DayCell({required this.cell, this.onTap});

  final WorkScheduleDayCell cell;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.themeAccent(context);

    if (cell.kind == WorkScheduleCellKind.dayOff) {
      return _CellContainer(
        isSelected: false,
        accent: accent,
        backgroundColor: WorkScheduleCellColors.dayOff,
        onTap: onTap,
        child: const Text('😴', style: TextStyle(fontSize: 16)),
      );
    }

    final colors = shiftColors(cell.tone);
    return _CellContainer(
      isSelected: cell.isSelected,
      accent: accent,
      backgroundColor: colors.background,
      onTap: onTap,
      child: Text(
        '${cell.timeStart}\n${cell.timeEnd}',
        style: AppFonts.c2Tabbar.copyWith(
          color: colors.text,
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
