import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/keys/app_shell_scaffold_key.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/default_container.dart';
import 'package:rient_app/features/home/data/models/statistics/statistics.dart';
import 'package:rient_app/features/home/view/components/entity_selector_pill.dart';
import 'package:rient_app/features/schedule/view/components/date_range_navigator.dart';
import 'package:rient_app/features/schedule/view/components/date_strip.dart';
import 'package:rient_app/features/schedule/view/components/specialist_select_dialog.dart';
import 'package:rient_app/features/schedule/view/components/specialist_selector_pill.dart';
import 'package:rient_app/features/schedule/view/components/view_mode_segmented_control.dart';
import 'package:rient_app/features/schedule/view/components/work_schedule_month_date_strip.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_cell_interval_provider.dart';
import 'package:rient_app/resources/resources.dart';

/// Callback: (viewMode, weekStart, monthStart) — для отображения полоски недели
/// и календаря месяца вне панели (на странице).
typedef ScheduleStateCallback =
    void Function(ViewMode viewMode, DateTime weekStart, DateTime monthStart);

class TopPanel extends StatefulWidget {
  const TopPanel({
    super.key,

    required this.title,
    this.occupancyByDay,
    this.showViewModeSwitcher = true,
    /// В расписании: скрыть выбор специалиста (например, вход под одним воркером).
    this.showSpecialistSelector = true,
    this.onScheduleStateChanged,
    this.specialists,
    this.initialSelectedSpecialist,
    this.onSpecialistSelected,
    this.scheduleSelectedDate,
    this.resolveScheduleNonWorkingDay,
    this.onScheduleDateSelected,
    this.scheduleOccupancyLoading = false,
    this.scheduleCellIntervalMinutes,
    this.onScheduleCellIntervalChanged,
    this.selectedDate,
    this.onDateSelected,
    this.showFullDateLabel = true,
    this.viewMode,
    /// Заголовок как у расписания в режиме «День» без переключателя День/Неделя/Месяц и интервала.
    this.scheduleDayHeaderOnly = false,
    /// Заголовок недели: полоска дат + навигатор месяца, без переключателя режимов.
    this.scheduleWeekHeaderOnly = false,
    /// Заголовок графика работы: только навигатор месяца.
    this.scheduleMonthHeaderOnly = false,
    this.weekStart,
    this.onWeekStartChanged,
    this.monthStart,
    this.onMonthStartChanged,
    this.workScheduleDatesScrollController,
    /// Кнопка «назад» вместо бургер-меню (для вложенных экранов).
    this.showBackButton = false,
  });

  final String title;

  /// Показывать переключатель День/Неделя/Месяц и навигатор по датам.
  /// На главной странице передают [false].
  final bool showViewModeSwitcher;

  /// Показывать [SpecialistSelectorPill] в расписании. Для аккаунта сотрудника обычно [false].
  final bool showSpecialistSelector;

  /// Список специалистов для страницы расписания. В режиме «День» пилюля
  /// показывается только при одном мастере; при двух и более — карточки в сетке.
  final List<SpecialistItem>? specialists;

  /// Выбранный по умолчанию специалист (например первый из списка). Если не передан, пилюля выберет первого из [specialists].
  final SpecialistItem? initialSelectedSpecialist;

  /// Callback при выборе специалиста в диалоге (чтобы сохранить выбор снаружи).
  final ValueChanged<SpecialistItem>? onSpecialistSelected;

  /// Выбранная дата в режиме «День» (для полоски дат и фильтра специалистов).
  final DateTime? scheduleSelectedDate;

  /// Выходные по ручному графику (штриховка в полоске дат).
  final bool Function(DateTime date)? resolveScheduleNonWorkingDay;

  /// Callback при выборе даты в полоске в режиме «День».
  final ValueChanged<DateTime>? onScheduleDateSelected;

  /// Загруженность в полоске дат режима «День» ещё грузится.
  final bool scheduleOccupancyLoading;

  /// Интервал одной ячейки расписания (в минутах).
  final int? scheduleCellIntervalMinutes;

  /// Callback при смене интервала ячейки расписания.
  final ValueChanged<int>? onScheduleCellIntervalChanged;

  /// Когда задан и [showViewModeSwitcher] true — полоска недели и календарь месяца
  /// не рисуются в панели; вызывается этот callback, контент рисуют на странице.
  final ScheduleStateCallback? onScheduleStateChanged;

  /// Выбранная дата для DateStrip (используется когда showViewModeSwitcher = false).
  final DateTime? selectedDate;

  /// Callback при выборе даты в DateStrip.
  final ValueChanged<DateTime>? onDateSelected;

  /// Показывать подпись с датой под DateStrip.
  final bool showFullDateLabel;

  /// От 0 до 100
  final List<OccupancyByDay>? occupancyByDay;

  /// Управляемый извне режим расписания (для синхронизации с родителем).
  final ViewMode? viewMode;

  final bool scheduleDayHeaderOnly;

  final bool scheduleWeekHeaderOnly;

  final bool scheduleMonthHeaderOnly;

  /// Понедельник видимой недели (для [scheduleWeekHeaderOnly]).
  final DateTime? weekStart;

  final ValueChanged<DateTime>? onWeekStartChanged;

  final DateTime? monthStart;

  final ValueChanged<DateTime>? onMonthStartChanged;

  final ScrollController? workScheduleDatesScrollController;

  final bool showBackButton;

  @override
  State<TopPanel> createState() => _TopPanelState();
}

class _TopPanelState extends State<TopPanel> {
  ViewMode _viewMode = ViewMode.day;
  late DateTime _weekStart;
  late DateTime _monthStart;

  @override
  void initState() {
    super.initState();
    if (widget.viewMode != null) {
      _viewMode = widget.viewMode!;
    }
    if (widget.monthStart != null) {
      _monthStart = DateTime(
        widget.monthStart!.year,
        widget.monthStart!.month,
        1,
      );
    }
    if (widget.weekStart != null) {
      _applyWeekStart(widget.weekStart!);
    } else if (widget.monthStart == null) {
      _syncToToday();
    } else {
      _weekStart = _monthStart;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onScheduleStateChanged?.call(_viewMode, _weekStart, _monthStart);
    });
  }

  @override
  void didUpdateWidget(covariant TopPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.viewMode != null && widget.viewMode != _viewMode) {
      _viewMode = widget.viewMode!;
    }
    if (widget.weekStart != null && widget.weekStart != oldWidget.weekStart) {
      _applyWeekStart(widget.weekStart!);
    }
    if (widget.monthStart != null && widget.monthStart != oldWidget.monthStart) {
      _monthStart = DateTime(
        widget.monthStart!.year,
        widget.monthStart!.month,
        1,
      );
    }
  }

  void _applyWeekStart(DateTime weekStart) {
    _weekStart = DateTime(weekStart.year, weekStart.month, weekStart.day);
    _monthStart = DateTime(_weekStart.year, _weekStart.month, 1);
  }

  void _syncToToday() {
    final now = DateTime.now();
    final weekday = now.weekday;
    _applyWeekStart(now.subtract(Duration(days: weekday - 1)));
  }

  void _shiftWeek(int days) {
    setState(() {
      _applyWeekStart(_weekStart.add(Duration(days: days)));
    });
    widget.onWeekStartChanged?.call(_weekStart);
    widget.onScheduleStateChanged?.call(_viewMode, _weekStart, _monthStart);
  }

  void _shiftMonth(int delta) {
    setState(() {
      _monthStart = DateTime(_monthStart.year, _monthStart.month + delta, 1);
    });
    widget.onMonthStartChanged?.call(_monthStart);
    widget.onScheduleStateChanged?.call(_viewMode, _weekStart, _monthStart);
  }

  void _goPrevious() {
    if (widget.scheduleMonthHeaderOnly) {
      _shiftMonth(-1);
      return;
    }
    if (widget.scheduleWeekHeaderOnly) {
      _shiftWeek(-7);
      return;
    }
    setState(() {
      if (_viewMode == ViewMode.week) {
        _weekStart = _weekStart.subtract(const Duration(days: 7));
      } else {
        _monthStart = DateTime(_monthStart.year, _monthStart.month - 1, 1);
      }
      widget.onScheduleStateChanged?.call(_viewMode, _weekStart, _monthStart);
    });
  }

  void _goNext() {
    if (widget.scheduleMonthHeaderOnly) {
      _shiftMonth(1);
      return;
    }
    if (widget.scheduleWeekHeaderOnly) {
      _shiftWeek(7);
      return;
    }
    setState(() {
      if (_viewMode == ViewMode.week) {
        _weekStart = _weekStart.add(const Duration(days: 7));
      } else {
        _monthStart = DateTime(_monthStart.year, _monthStart.month + 1, 1);
      }
      widget.onScheduleStateChanged?.call(_viewMode, _weekStart, _monthStart);
    });
  }

  void _onViewModeChanged(ViewMode mode) {
    setState(() => _viewMode = mode);
    widget.onScheduleStateChanged?.call(_viewMode, _weekStart, _monthStart);
  }

  Widget _buildDayDateStrip() {
    final weekStart = widget.weekStart;
    final occupancy = widget.occupancyByDay;
    final occupancyKey = occupancy == null || occupancy.isEmpty
        ? 0
        : Object.hashAll(occupancy.map((e) => e.occupancy));
    return DateStrip(
      key: weekStart != null
          ? ValueKey(
              'day_strip_${weekStart.year}_${weekStart.month}_${weekStart.day}_$occupancyKey',
            )
          : null,
      initialDate: widget.scheduleSelectedDate ?? DateTime.now(),
      selectedDate: widget.scheduleSelectedDate,
      visibleWeekStart: weekStart,
      onDateSelected: widget.onScheduleDateSelected,
      useGreyCircles: true,
      occupancyByDay: widget.occupancyByDay,
      occupancyLoading: widget.scheduleOccupancyLoading,
      showFullDateLabel: widget.showFullDateLabel,
      resolveNonWorkingDay: widget.resolveScheduleNonWorkingDay,
    );
  }

  Widget? _buildDaySpecialistSelector() {
    if (!widget.showSpecialistSelector ||
        widget.specialists == null ||
        widget.specialists!.isEmpty ||
        widget.specialists!.length >= 2) {
      return null;
    }
    return SpecialistSelectorPill(
      specialists: widget.specialists!,
      initialSelected:
          widget.initialSelectedSpecialist ?? widget.specialists!.first,
      onSelected: widget.onSpecialistSelected,
    );
  }

  bool get _showScheduleIntervalPicker =>
      widget.scheduleCellIntervalMinutes != null &&
      widget.onScheduleCellIntervalChanged != null;

  Widget _buildScheduleIntervalPicker(bool isDark) {
    return PopupMenuButton<int>(
      onSelected: widget.onScheduleCellIntervalChanged,
      tooltip: 'Интервал ячейки',
      itemBuilder: (context) => [
        for (final value in scheduleCellIntervalOptions)
          PopupMenuItem<int>(
            value: value,
            child: Text('$value мин', style: AppFonts.b2Regular),
          ),
      ],
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(300),
          color: isDark ? AppColors.secondaryDarkDark : AppColors.primaryWhite,
          border: Border.all(
            color: isDark
                ? AppColors.secondaryDark
                : AppColors.grey.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${widget.scheduleCellIntervalMinutes} мин',
              style: AppFonts.c1Medium.copyWith(
                color: isDark ? AppColors.primaryWhite : AppColors.primaryDark,
              ),
            ),
            const Gap(2),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: isDark ? AppColors.primaryWhite : AppColors.primaryDark,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dayHeaderOnly = widget.scheduleDayHeaderOnly;
    final weekHeaderOnly = widget.scheduleWeekHeaderOnly;
    final monthHeaderOnly = widget.scheduleMonthHeaderOnly;
    final showScheduleControls = widget.showViewModeSwitcher &&
        !dayHeaderOnly &&
        !weekHeaderOnly &&
        !monthHeaderOnly;
    final daySpecialistSelector = _buildDaySpecialistSelector();
    final topInset = MediaQuery.paddingOf(context).top;
    return DefaultContainerWidget(
      borderRadius: BorderRadius.circular(24),
      hasShadow: false,
      padding: EdgeInsets.only(
        top: topInset + 8,
        bottom: 12,
        left: 16,
        right: 16,
      ),
      color: isDark ? AppColors.primaryWhiteDark : Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (widget.showBackButton) {
                    final router = GoRouter.maybeOf(context);
                    if (router != null && router.canPop()) {
                      router.pop();
                      return;
                    }
                    final rootNav = Navigator.of(context, rootNavigator: true);
                    if (rootNav.canPop()) {
                      rootNav.pop();
                    }
                  } else {
                    appShellScaffoldKey.currentState?.openDrawer();
                  }
                },
                child: widget.showBackButton
                    ? Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 20,
                        color: isDark
                            ? AppColors.primaryWhite
                            : AppColors.primaryDark,
                      )
                    : Image.asset(
                        isDark ? AppImages.burgerDark : AppImages.burger,
                      ),
              ),
              Gap(12),
              Expanded(
                child: Text(
                  widget.title,
                  style: AppFonts.h3Medium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Flexible(child: ProfileSelectorPill()),
            ],
          ),
          if (dayHeaderOnly) ...[
            const Gap(12),
            _buildDayDateStrip(),
            if (daySpecialistSelector != null) ...[
              const Gap(12),
              daySpecialistSelector,
            ],
          ] else if (weekHeaderOnly) ...[
            const Gap(12),
            DateStrip(
              initialDate: widget.scheduleSelectedDate ?? DateTime.now(),
              selectedDate: widget.scheduleSelectedDate,
              visibleWeekStart: _weekStart,
              onDateSelected: widget.onScheduleDateSelected,
              showFullDateLabel: false,
              workScheduleWeekDates: true,
            ),
            const Gap(8),
            DateRangeNavigator(
              mode: DateNavigatorMode.week,
              weekStart: _weekStart,
              month: _monthStart,
              onPrevious: _goPrevious,
              onNext: _goNext,
            ),
          ] else if (monthHeaderOnly) ...[
            const Gap(12),
            if (widget.workScheduleDatesScrollController != null &&
                widget.monthStart != null &&
                widget.scheduleSelectedDate != null)
              WorkScheduleMonthDateStrip(
                month: widget.monthStart!,
                selectedDate: widget.scheduleSelectedDate!,
                scrollController: widget.workScheduleDatesScrollController!,
                onDateSelected: widget.onScheduleDateSelected,
              ),
            const Gap(8),
            DateRangeNavigator(
              mode: DateNavigatorMode.month,
              weekStart: _weekStart,
              month: _monthStart,
              onPrevious: _goPrevious,
              onNext: _goNext,
            ),
          ] else if (showScheduleControls) ...[
            Gap(12),
            Row(
              children: [
                Expanded(
                  child: ViewModeSegmentedControl(
                    value: _viewMode,
                    onChanged: _onViewModeChanged,
                  ),
                ),
                if (_viewMode != ViewMode.month && _showScheduleIntervalPicker) ...[
                  const Gap(8),
                  _buildScheduleIntervalPicker(isDark),
                ],
              ],
            ),
            if (widget.showSpecialistSelector &&
                _viewMode != ViewMode.day &&
                widget.specialists != null &&
                widget.specialists!.isNotEmpty) ...[
              Gap(12),
              SpecialistSelectorPill(
                specialists: widget.specialists!,
                initialSelected:
                    widget.initialSelectedSpecialist ??
                    widget.specialists!.first,
                onSelected: widget.onSpecialistSelected,
              ),
            ],
            Gap(12),
            if (_viewMode == ViewMode.week || _viewMode == ViewMode.month)
              DateRangeNavigator(
                mode: _viewMode == ViewMode.week
                    ? DateNavigatorMode.week
                    : DateNavigatorMode.month,
                weekStart: _weekStart,
                month: _monthStart,
                onPrevious: _goPrevious,
                onNext: _goNext,
              ),
            if (_viewMode == ViewMode.week || _viewMode == ViewMode.month)
              Gap(8),
            if (_viewMode == ViewMode.day) ...[
              _buildDayDateStrip(),
              if (daySpecialistSelector != null) ...[
                const Gap(12),
                daySpecialistSelector,
              ],
            ],
          ] else ...[
            Gap(12),
            // На главной (без переключателя) — полоска с текущей датой в панели
            DateStrip(
              initialDate: DateTime.now(),
              selectedDate: widget.selectedDate,
              onDateSelected: widget.onDateSelected,
              showFullDateLabel: widget.showFullDateLabel,
              useGreyCircles: true,
              occupancyByDay: widget.occupancyByDay,
            ),
          ],
        ],
      ),
    );
  }
}
