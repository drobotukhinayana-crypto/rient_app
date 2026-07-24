import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/worker_avatar_image.dart';
import 'package:rient_app/features/schedule/view/components/work_schedule_mock_data.dart';
import 'package:rient_app/resources/resources.dart';

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
    required     this.horizontalScrollController,
    this.savingEmployeeId,
    this.savingDate,
    this.loadingEmployeeId,
    this.loadingDate,
    this.onCellTap,
    this.onEmployeeMoreTap,
    this.hideBranchMoreButton = false,
  });

  final DateTime month;
  final List<WorkScheduleEmployeeRow> employees;
  final DateTime selectedDate;
  final ScrollController horizontalScrollController;
  final String? savingEmployeeId;
  final DateTime? savingDate;
  final String? loadingEmployeeId;
  final DateTime? loadingDate;
  final void Function(WorkScheduleEmployeeRow employee, DateTime date)?
  onCellTap;
  final void Function(WorkScheduleEmployeeRow employee)? onEmployeeMoreTap;
  final bool hideBranchMoreButton;

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
          isBranchRow: employee.isBranchRow,
          onMoreTap: _employeeMoreTap(employee),
        ),
      ),
    );
  }

  VoidCallback? _employeeMoreTap(WorkScheduleEmployeeRow employee) {
    if (widget.onEmployeeMoreTap == null) return null;
    if (widget.hideBranchMoreButton && employee.isBranchRow) return null;
    return () => widget.onEmployeeMoreTap!(employee);
  }

  WorkScheduleDayCell _cellAt(WorkScheduleEmployeeRow employee, int index) {
    if (index < 0 || index >= employee.monthCells.length) {
      return const WorkScheduleDayCell.dayOff();
    }
    return employee.monthCells[index];
  }

  Widget _scheduleRow(int rowIndex, List<DateTime> monthDays) {
    final employee = widget.employees[rowIndex];
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
                  cell: _cellAt(employee, j),
                  isSaving: _isBusyCell(employee.id, monthDays[j]),
                  onTap: widget.onCellTap == null
                      ? null
                      : () => widget.onCellTap!(employee, monthDays[j]),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  bool _isBusyCell(String employeeId, DateTime date) {
    return _matchesCellState(
          employeeId: employeeId,
          date: date,
          stateEmployeeId: widget.savingEmployeeId,
          stateDate: widget.savingDate,
        ) ||
        _matchesCellState(
          employeeId: employeeId,
          date: date,
          stateEmployeeId: widget.loadingEmployeeId,
          stateDate: widget.loadingDate,
        );
  }

  bool _matchesCellState({
    required String employeeId,
    required DateTime date,
    required String? stateEmployeeId,
    required DateTime? stateDate,
  }) {
    if (stateEmployeeId != employeeId || stateDate == null) return false;
    return stateDate.year == date.year &&
        stateDate.month == date.month &&
        stateDate.day == date.day;
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
      child: Container(decoration: _sidebarDecoration(isDark), child: clip),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final monthDays = _monthDays;
    final tableWidth =
        monthDays.length * workScheduleDayColumnWidth +
        (monthDays.length - 1) * workScheduleDayCellGap;
    final bottomScrollPadding = _bottomScrollPadding(context);

    return Padding(
      padding: AppDecoration.padding16.copyWith(top: 12, bottom: 12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxHeight = constraints.maxHeight;
          final compactHeight = _gridContentHeight(widget.employees.length);
          final scrollVertically = compactHeight > maxHeight;
          final gridHeight = scrollVertically ? maxHeight : compactHeight;
          final bottomInset = scrollVertically ? bottomScrollPadding : 0.0;

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
    this.isBranchRow = false,
    this.onMoreTap,
  });

  final String name;
  final String? pictureUrl;
  final bool isBranchRow;
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
              _Avatar(
                name: name,
                pictureUrl: pictureUrl,
                isBranchRow: isBranchRow,
              ),
              const Gap(4),
              Text(
                isBranchRow ? _branchLabel(name) : _shortName(name),
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
          if (onMoreTap != null) _EmployeeMoreButton(onTap: onMoreTap),
        ],
      ),
    );
  }

  static String _branchLabel(String name) {
    final trimmed = name.trim();
    if (trimmed.length <= 8) return trimmed;
    return '${trimmed.substring(0, 7)}…';
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
        child: Icon(Icons.more_horiz_rounded, size: 16, color: accent),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.name,
    this.pictureUrl,
    this.isBranchRow = false,
  });

  final String name;
  final String? pictureUrl;
  final bool isBranchRow;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (isBranchRow) {
      return Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.secondaryDarkLight
              : AppColors.secondaryDark,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: _branchIcon(isDark),
      );
    }
    return WorkerAvatarImage(
      pictureUrl: pictureUrl,
      name: name,
      size: 32,
      placeholder: _placeholder(isDark),
    );
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

  /// Иконка филиала как на экране выбора при входе ([AuthBranchListView]).
  static Widget _branchIcon(bool isDark) {
    if (isDark) {
      return ColorFiltered(
        colorFilter: const ColorFilter.mode(
          AppColors.primaryWhite,
          BlendMode.srcIn,
        ),
        child: Image.asset(
          AppImages.branch,
          width: 22,
          height: 22,
          fit: BoxFit.contain,
        ),
      );
    }
    return Image.asset(
      AppImages.branch,
      width: 22,
      height: 22,
      fit: BoxFit.contain,
    );
  }
}

Color _shiftBackground(WorkScheduleDayCell cell, bool isPast) {
  if (cell.isManuallyEdited) {
    return isPast
        ? WorkScheduleCellColors.manualEditPast
        : WorkScheduleCellColors.manualEdit;
  }
  return isPast
      ? WorkScheduleCellColors.shiftPast
      : WorkScheduleCellColors.shift;
}

Color _dayOffBackground(WorkScheduleDayCell cell, bool isPast) {
  if (cell.isManuallyEdited) {
    return isPast
        ? WorkScheduleCellColors.manualEditPast
        : WorkScheduleCellColors.manualEdit;
  }
  return isPast
      ? WorkScheduleCellColors.dayOffPast
      : WorkScheduleCellColors.dayOff;
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.cell,
    this.isSaving = false,
    this.onTap,
  });

  final DateTime date;
  final WorkScheduleDayCell cell;
  final bool isSaving;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.themeAccent(context);
    final isPast = isPastWorkScheduleDate(date);

    final effectiveOnTap = isPast || isSaving ? null : onTap;

    Widget cellContent;
    if (cell.kind == WorkScheduleCellKind.dayOff) {
      cellContent = _CellContainer(
        isSelected: false,
        accent: accent,
        backgroundColor: _dayOffBackground(cell, isPast),
        onTap: effectiveOnTap,
        child: const Center(child: Text('😴', style: TextStyle(fontSize: 16))),
      );
    } else {
      cellContent = _CellContainer(
        isSelected: cell.isSelected,
        accent: accent,
        backgroundColor: _shiftBackground(cell, isPast),
        onTap: effectiveOnTap,
        child: _ShiftCellContent(cell: cell),
      );
    }

    if (isSaving) {
      return Stack(
      fit: StackFit.expand,
      children: [
        cellContent,
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.28),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
    }

    return cellContent;
  }
}

class _ShiftCellContent extends StatelessWidget {
  const _ShiftCellContent({required this.cell});

  final WorkScheduleDayCell cell;

  @override
  Widget build(BuildContext context) {
    final timeStyle = AppFonts.c2Tabbar.copyWith(
      color: Colors.white,
      height: 1.1,
      fontSize: 9,
      fontWeight: FontWeight.w500,
    );

    if (!cell.hasBreak) {
      return Center(
        child: Text(
          '${cell.timeStart}\n${cell.timeEnd}',
          style: timeStyle,
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              '${cell.timeStart}\n${cell.timeEnd}',
              style: timeStyle,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Icon(
              Icons.local_cafe_rounded,
              size: 12,
              color: Colors.white.withValues(alpha: 0.92),
            ),
          ),
        ),
      ],
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
            border: isSelected ? Border.all(color: accent, width: 2) : null,
          ),
          child: SizedBox.expand(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
