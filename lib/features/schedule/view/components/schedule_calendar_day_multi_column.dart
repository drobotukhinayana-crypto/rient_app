import 'package:flutter/material.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/features/schedule/view/components/schedule_calendar_one_user_widget.dart';
import 'package:rient_app/features/schedule/view/components/view_mode_segmented_control.dart';
import 'package:rient_app/features/schedule/view/providers/schedules_provider.dart';

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

  @override
  State<ScheduleCalendarDayMultiColumn> createState() =>
      _ScheduleCalendarDayMultiColumnState();
}

class _ScheduleCalendarDayMultiColumnState
    extends State<ScheduleCalendarDayMultiColumn> {
  static const _ruler = 50.0;
  static const _masterScrollIndex = -1; // Левый столбик времени — мастер.
  final Map<int, ScrollPosition> _positions = <int, ScrollPosition>{};
  final Map<int, VoidCallback> _listeners = <int, VoidCallback>{};
  bool _syncing = false;

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

  void _syncAllToAnchor() {
    final anchor = _positions[_masterScrollIndex] ??
        (_positions.isNotEmpty ? _positions.values.first : null);
    if (anchor == null || !anchor.hasPixels) return;
    _syncAllTo(anchor.pixels);
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
    if (identical(existing, position)) return;
    if (existing != null) {
      _detachIndex(index);
    }

    _positions[index] = position;
    void listener() {
      if (_syncing) return;
      final source = _positions[index];
      if (source == null || !source.hasPixels) return;
      final master = _positions[_masterScrollIndex];

      // Любой скролл в колонке сотрудника превращаем в скролл мастер-колонки.
      if (index != _masterScrollIndex && master != null && master.hasPixels) {
        final delta = source.pixels - master.pixels;
        final masterTarget = (master.pixels + delta).clamp(
          master.minScrollExtent,
          master.maxScrollExtent,
        );
        _syncAllTo(masterTarget);
        return;
      }

      _syncAllTo(source.pixels);
    }

    _listeners[index] = listener;
    position.addListener(listener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _syncAllToAnchor();
    });
  }

  @override
  void didUpdateWidget(covariant ScheduleCalendarDayMultiColumn oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Полный сброс только когда реально меняется набор/дата колонок.
    if (oldWidget.date != widget.date ||
        oldWidget.columns.length != widget.columns.length) {
      for (final index in _positions.keys.toList()) {
        _detachIndex(index);
      }
    }
  }

  @override
  void dispose() {
    for (final index in _positions.keys.toList()) {
      _detachIndex(index);
    }
    super.dispose();
  }

  Widget _calendar(int i, String dateKey) {
    return ScheduleCalendarOneUserWidget(
      key: ValueKey('day_col_${widget.columns[i].workerId}_$dateKey'),
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
      onEmptySlotTap: (dateTime) {
        widget.onEmptySlotTap?.call(widget.columns[i].workerId, dateTime);
      },
    );
  }

  Widget _timeRulerCalendar(String dateKey) {
    return ScheduleCalendarOneUserWidget(
      key: ValueKey('day_time_ruler_$dateKey'),
      date: widget.date,
      items: const [],
      viewMode: ViewMode.day,
      startHour: widget.branchStartHour,
      endHour: widget.branchEndHour,
      timeRulerSize: _ruler,
      timeIntervalMinutes: widget.timeIntervalMinutes,
      onScrollPositionReady: (pos) => _onScrollReady(-1, pos),
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

    final dateKey = scheduleDateKey(widget.date);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: _ruler,
          child: Theme(
            data: themeWithoutScrollbar,
            child: _timeRulerCalendar(dateKey),
          ),
        ),
        Container(width: 1, color: AppColors.grey.withValues(alpha: 0.25)),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final columnsCount = widget.columns.length;
              final separatorsTotalWidth = columnsCount > 1
                  ? (columnsCount - 1).toDouble()
                  : 0.0;
              final availableWidth = constraints.maxWidth;
              final requestedContentWidth =
                  (columnsCount * widget.columnWidth) + separatorsTotalWidth;
              final effectiveColumnWidth = requestedContentWidth < availableWidth
                  ? ((availableWidth - separatorsTotalWidth) / columnsCount)
                  : widget.columnWidth;

              return SingleChildScrollView(
                controller: widget.horizontalScrollController,
                scrollDirection: Axis.horizontal,
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
                          child: _calendar(i, dateKey),
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
