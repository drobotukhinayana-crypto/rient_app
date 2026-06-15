import 'package:flutter/material.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/features/schedule/view/components/schedule_calendar_one_user_widget.dart';
import 'package:rient_app/features/schedule/view/components/schedule_day_horizontal_drag_scroll.dart';
import 'package:rient_app/features/schedule/view/components/specialist_list_view.dart';
import 'package:rient_app/features/schedule/view/components/view_mode_segmented_control.dart';

/// Ширина шкалы времени в дневном режиме «все мастера».
const scheduleDayTimeRulerWidth = 50.0;

/// Разделитель между колонками мастеров (должен совпадать в шапке и в сетке).
const scheduleDayColumnSeparatorWidth = 1.0;

const scheduleDaySpecialistColumnWidth = 114.0;

/// Горизонтальный padding строки [SpecialistListView] над сеткой.
const scheduleDaySpecialistRowHorizontalPadding = 16.0;

/// Отступ слева в шапке мастеров, чтобы колонки совпали с сеткой (шкала + разделитель − padding).
double scheduleDaySpecialistLeadingInset({
  double rowHorizontalPadding = scheduleDaySpecialistRowHorizontalPadding,
}) =>
    scheduleDayTimeRulerWidth +
    scheduleDayColumnSeparatorWidth -
    rowHorizontalPadding;

/// [scheduleDaySpecialistLeadingInset] при [scheduleDaySpecialistRowHorizontalPadding].
const scheduleDaySpecialistLeadingInsetDefault = 35.0;

int scheduleDayColumnItemsKey(List<ScheduleAppointmentItem> items) {
  if (items.isEmpty) return 0;
  return Object.hash(
    items.length,
    Object.hashAll(
      items.map((e) => Object.hash(e.startTime, e.endTime, e.subject)),
    ),
  );
}

/// Одна колонка дня: записи мастера с учётом смены и перерыва.
class ScheduleCalendarDayColumn {
  const ScheduleCalendarDayColumn({
    required this.workerId,
    required this.name,
    required this.items,
    this.breakStart,
    this.breakEnd,
    this.workerStartHour,
    this.workerEndHour,
  });

  final int workerId;
  final String name;
  final List<ScheduleAppointmentItem> items;
  final String? breakStart;
  final String? breakEnd;
  final double? workerStartHour;
  final double? workerEndHour;
}

/// До трёх колонок на день: одна вертикальная прокрутка времени (синхронная).
class ScheduleCalendarDayMultiColumn extends StatefulWidget {
  const ScheduleCalendarDayMultiColumn({
    super.key,
    required this.date,
    required this.branchStartHour,
    required this.branchEndHour,
    required this.columns,
    this.horizontalScrollController,
    this.columnWidth = 260,
    this.timeIntervalMinutes = 10,
    this.onAppointmentTap,
    this.onEmptySlotTap,
    this.canTapEmptySlot,
  });

  final DateTime date;
  final double branchStartHour;
  final double branchEndHour;
  final List<ScheduleCalendarDayColumn> columns;
  final ScrollController? horizontalScrollController;
  final double columnWidth;
  final int timeIntervalMinutes;
  final ValueChanged<ScheduleAppointmentItem>? onAppointmentTap;
  final void Function(int workerId, DateTime dateTime)? onEmptySlotTap;
  final bool Function(DateTime dateTime)? canTapEmptySlot;

  @override
  State<ScheduleCalendarDayMultiColumn> createState() =>
      _ScheduleCalendarDayMultiColumnState();
}

class _ScheduleCalendarDayMultiColumnState
    extends State<ScheduleCalendarDayMultiColumn> {
  static const _ruler = scheduleDayTimeRulerWidth;
  static const _masterScrollIndex = -1; // Левый столбик времени — мастер.
  final Map<int, ScrollPosition> _positions = <int, ScrollPosition>{};
  final Map<int, VoidCallback> _listeners = <int, VoidCallback>{};
  bool _syncing = false;
  bool _scrollToTopPending = true;

  void _syncAllTo(double px) {
    if (_positions.isEmpty) return;
    _syncing = true;
    for (final entry in _positions.entries) {
      final pos = entry.value;
      if (!pos.hasPixels) continue;
      final target = px.clamp(pos.minScrollExtent, pos.maxScrollExtent);
      if ((pos.pixels - target).abs() > 0.5) {
        pos.jumpTo(target);
      }
    }
    _syncing = false;
  }

  void _resetScrollToTopIfNeeded() {
    final master = _positions[_masterScrollIndex];
    if (master == null || !master.hasPixels) return;
    _syncAllTo(0);
    _scrollToTopPending = false;
  }

  void _detachIndex(int index) {
    final existingPosition = _positions.remove(index);
    final existingListener = _listeners.remove(index);
    if (existingPosition != null && existingListener != null) {
      existingPosition.removeListener(existingListener);
    }
  }

  void _onScrollReady(int index, ScrollPosition position) {
    final existing = _positions[index];
    if (identical(existing, position)) {
      _applyScrollAlignmentAfterRegister(index);
      return;
    }
    if (existing != null) {
      _detachIndex(index);
    }

    _positions[index] = position;
    void listener() {
      if (_syncing) return;
      final source = _positions[index];
      if (source == null || !source.hasPixels) return;
      _syncAllTo(source.pixels);
    }

    _listeners[index] = listener;
    position.addListener(listener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _applyScrollAlignmentAfterRegister(index);
    });
  }

  void _applyScrollAlignmentAfterRegister(int index) {
    final master = _positions[_masterScrollIndex];
    if (index == _masterScrollIndex) {
      if (_scrollToTopPending) {
        _resetScrollToTopIfNeeded();
      }
      return;
    }
    // Колонка могла смонтироваться со смещением к записям — выравниваем по шкале.
    if (master != null && master.hasPixels) {
      _syncAllTo(master.pixels);
    } else if (_scrollToTopPending) {
      _syncAllTo(0);
    }
  }

  void _scheduleAlignAllToMaster() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final master = _positions[_masterScrollIndex];
      if (master != null && master.hasPixels) {
        _syncAllTo(master.pixels);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _scheduleAlignAllToMaster();
  }

  @override
  void didUpdateWidget(covariant ScheduleCalendarDayMultiColumn oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Полный сброс только когда реально меняется набор/дата колонок.
    if (oldWidget.date != widget.date ||
        oldWidget.columns.length != widget.columns.length ||
        oldWidget.branchStartHour != widget.branchStartHour ||
        oldWidget.branchEndHour != widget.branchEndHour) {
      for (final index in _positions.keys.toList()) {
        _detachIndex(index);
      }
      _scrollToTopPending = true;
      _scheduleAlignAllToMaster();
      return;
    }
    _scheduleAlignAllToMaster();
  }

  @override
  void dispose() {
    for (final index in _positions.keys.toList()) {
      _detachIndex(index);
    }
    super.dispose();
  }

  Widget _calendar(int i) {
    return ScheduleCalendarOneUserWidget(
      key: ValueKey('day_col_${widget.columns[i].workerId}'),
      date: widget.date,
      items: widget.columns[i].items,
      viewMode: ViewMode.day,
      startHour: widget.branchStartHour,
      endHour: widget.branchEndHour,
      breakStart: widget.columns[i].breakStart,
      breakEnd: widget.columns[i].breakEnd,
      workerStartHour: widget.columns[i].workerStartHour,
      workerEndHour: widget.columns[i].workerEndHour,
      timeRulerSize: 0,
      timeIntervalMinutes: widget.timeIntervalMinutes,
      onScrollPositionReady: (pos) => _onScrollReady(i, pos),
      onAppointmentTap: widget.onAppointmentTap,
      canTapEmptySlot: widget.canTapEmptySlot,
      onEmptySlotTap: (dateTime) {
        widget.onEmptySlotTap?.call(widget.columns[i].workerId, dateTime);
      },
    );
  }

  Widget _timeRulerCalendar() {
    return ScheduleCalendarOneUserWidget(
      key: const ValueKey('day_time_ruler'),
      date: widget.date,
      items: const [],
      viewMode: ViewMode.day,
      startHour: widget.branchStartHour,
      endHour: widget.branchEndHour,
      timeRulerSize: _ruler,
      timeIntervalMinutes: widget.timeIntervalMinutes,
      onScrollPositionReady: (pos) => _onScrollReady(-1, pos),
      canTapEmptySlot: widget.canTapEmptySlot,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Syncfusion вставляет свой [Scrollbar] с явным controller — [ScrollConfiguration] на него не действует.
    // Через [ScrollbarTheme] обнуляем толщину/трек у левых колонок; у правой оставляем исходную тему.
    final scrollbarHidden = theme.scrollbarTheme.copyWith(
      thickness: WidgetStateProperty.all(0),
      thumbVisibility: WidgetStateProperty.all(false),
      trackVisibility: WidgetStateProperty.all(false),
      crossAxisMargin: 0,
      mainAxisMargin: 0,
      interactive: false,
    );
    final themeWithoutScrollbar = theme.copyWith(
      scrollbarTheme: scrollbarHidden,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: _ruler,
          child: Theme(
            data: themeWithoutScrollbar,
            child: _timeRulerCalendar(),
          ),
        ),
        Container(width: 1, color: AppColors.grey.withValues(alpha: 0.25)),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final columnsCount = widget.columns.length;
              final separatorsTotalWidth = columnsCount > 1
                  ? (columnsCount - 1) * scheduleDayColumnSeparatorWidth
                  : 0.0;
              final availableWidth = constraints.maxWidth;
              final requestedContentWidth =
                  (columnsCount * widget.columnWidth) + separatorsTotalWidth;
              final effectiveColumnWidth =
                  SpecialistListView.effectiveItemWidth(
                count: columnsCount,
                availableWidth: availableWidth,
                itemWidth: widget.columnWidth,
                columnSeparatorWidth: scheduleDayColumnSeparatorWidth,
              );
              final contentWidth = requestedContentWidth < availableWidth
                  ? availableWidth
                  : requestedContentWidth.toDouble();

              final scrollView = SingleChildScrollView(
                controller: widget.horizontalScrollController,
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: scheduleDaySpecialistRowHorizontalPadding,
                  ),
                  child: SizedBox(
                    width: contentWidth,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (var i = 0; i < widget.columns.length; i++) ...[
                          if (i > 0)
                            Container(
                              width: 1,
                              color: AppColors.grey.withValues(alpha: 0.25),
                            ),
                          SizedBox(
                            width: effectiveColumnWidth,
                            child: Theme(
                              data: i == widget.columns.length - 1
                                  ? theme
                                  : themeWithoutScrollbar,
                              child: _calendar(i),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );

              final controller = widget.horizontalScrollController;
              if (controller == null) return scrollView;

              return ScheduleDayHorizontalDragScroll(
                controller: controller,
                child: scrollView,
              );
            },
          ),
        ),
      ],
    );
  }
}
