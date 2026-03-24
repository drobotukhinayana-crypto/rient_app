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
  });

  final DateTime date;
  final double branchStartHour;
  final double branchEndHour;
  final List<ScheduleCalendarDayColumn> columns;

  @override
  State<ScheduleCalendarDayMultiColumn> createState() =>
      _ScheduleCalendarDayMultiColumnState();
}

class _ScheduleCalendarDayMultiColumnState
    extends State<ScheduleCalendarDayMultiColumn> {
  static const _ruler = 50.0;
  static const _colCount = 3;

  final List<ScrollPosition?> _positions = List<ScrollPosition?>.filled(
    _colCount,
    null,
  );
  final List<VoidCallback?> _listeners = List<VoidCallback?>.filled(
    _colCount,
    null,
  );
  bool _syncing = false;

  void _onScrollReady(int index, ScrollPosition position) {
    if (index < 0 || index >= _colCount) return;
    if (_positions[index] != null) return;

    _positions[index] = position;
    void listener() {
      if (_syncing) return;
      final source = _positions[index];
      if (source == null || !source.hasPixels) return;
      final px = source.pixels;
      _syncing = true;
      for (var j = 0; j < _colCount; j++) {
        if (j == index) continue;
        final other = _positions[j];
        if (other != null && other.hasPixels) {
          final target = px.clamp(other.minScrollExtent, other.maxScrollExtent);
          if ((other.pixels - target).abs() > 0.5) {
            other.jumpTo(target);
          }
        }
      }
      _syncing = false;
    }

    _listeners[index] = listener;
    position.addListener(listener);
  }

  @override
  void dispose() {
    for (var i = 0; i < _colCount; i++) {
      final p = _positions[i];
      final l = _listeners[i];
      if (p != null && l != null) {
        p.removeListener(l);
      }
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
      timeRulerSize: i == 0 ? _ruler : 0,
      onScrollPositionReady: (pos) => _onScrollReady(i, pos),
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
    final lastIndex = widget.columns.length - 1;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < widget.columns.length; i++) ...[
          if (i > 0)
            Container(width: 1, color: AppColors.grey.withValues(alpha: 0.25)),
          Expanded(
            // Первая колонка: слева шкала времени, под сетку остаётся уже 2–3-й; чуть больший flex выравнивает ширину ячеек.
            flex: i == 0 ? 5 : 4,
            child: Theme(
              data: i == lastIndex ? theme : themeWithoutScrollbar,
              child: _calendar(i, dateKey),
            ),
          ),
        ],
      ],
    );
  }
}
