import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/default_container.dart';
import 'package:rient_app/features/home/data/models/statistics/statistics.dart';
import 'package:rient_app/features/home/view/components/entity_selector_pill.dart';
import 'package:rient_app/features/schedule/view/components/date_range_navigator.dart';
import 'package:rient_app/features/schedule/view/components/date_strip.dart';
import 'package:rient_app/features/schedule/view/components/specialist_select_dialog.dart';
import 'package:rient_app/features/schedule/view/components/specialist_selector_pill.dart';
import 'package:rient_app/features/schedule/view/components/view_mode_segmented_control.dart';
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
    this.onScheduleStateChanged,
    this.specialists,
    this.initialSelectedSpecialist,
    this.onSpecialistSelected,
    this.selectedDate,
    this.onDateSelected,
    this.showFullDateLabel = true,
  });

  final String title;

  /// Показывать переключатель День/Неделя/Месяц и навигатор по датам.
  /// На главной странице передают [false].
  final bool showViewModeSwitcher;

  /// Список специалистов для страницы расписания. Если передан и длина < 3, в режиме «День» в панели показывается [SpecialistSelectorPill].
  final List<SpecialistItem>? specialists;

  /// Выбранный по умолчанию специалист (например первый из списка). Если не передан, пилюля выберет первого из [specialists].
  final SpecialistItem? initialSelectedSpecialist;

  /// Callback при выборе специалиста в диалоге (чтобы сохранить выбор снаружи).
  final ValueChanged<SpecialistItem>? onSpecialistSelected;

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
    _syncToToday();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onScheduleStateChanged?.call(_viewMode, _weekStart, _monthStart);
    });
  }

  void _syncToToday() {
    final now = DateTime.now();
    final weekday = now.weekday;
    _weekStart = now.subtract(Duration(days: weekday - 1));
    _monthStart = DateTime(now.year, now.month, 1);
  }

  void _goPrevious() {
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

  @override
  Widget build(BuildContext context) {
    return DefaultContainerWidget(
      borderRadius: BorderRadius.circular(24),
      hasShadow: false,
      padding: const EdgeInsets.only(top: 52, bottom: 8, left: 16, right: 16),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Image.asset(AppImages.burger),
              ),
              Gap(12),
              Text(widget.title, style: AppFonts.h3Medium),
              const Spacer(),
              const ProfileSelectorPill(),
            ],
          ),
          if (widget.showViewModeSwitcher) ...[
            Gap(12),
            ViewModeSegmentedControl(
              value: _viewMode,
              onChanged: _onViewModeChanged,
            ),
            if (_viewMode != ViewMode.day &&
                widget.specialists != null &&
                widget.specialists!.isNotEmpty) ...[
              Gap(12),
              SpecialistSelectorPill(
                specialists: widget.specialists!,
                initialSelected: widget.initialSelectedSpecialist ??
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
              DateStrip(initialDate: DateTime.now(), useGreyCircles: true),
              if (widget.specialists != null &&
                  widget.specialists!.length < 3) ...[
                Gap(12),
                SpecialistSelectorPill(
                  specialists: widget.specialists!,
                  initialSelected: widget.initialSelectedSpecialist ??
                      (widget.specialists!.isNotEmpty
                          ? widget.specialists!.first
                          : null),
                  onSelected: widget.onSpecialistSelected,
                ),
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
