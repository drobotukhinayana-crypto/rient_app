import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/date_range_navigator.dart';
import 'package:rient_app/core/widgets/date_strip.dart';
import 'package:rient_app/core/widgets/default_container.dart';
import 'package:rient_app/core/widgets/view_mode_segmented_control.dart';
import 'package:rient_app/features/home/view/components/entity_selector_pill.dart';
import 'package:rient_app/resources/resources.dart';

class TopPanel extends StatefulWidget {
  const TopPanel({
    super.key,
    required this.title,
    this.showViewModeSwitcher = true,
  });

  final String title;

  /// Показывать переключатель День/Неделя/Месяц и навигатор по датам.
  /// На главной странице передают [false].
  final bool showViewModeSwitcher;

  @override
  State<TopPanel> createState() => _TopPanelState();
}

class _TopPanelState extends State<TopPanel> {
  ViewMode _viewMode = ViewMode.week;
  late DateTime _weekStart;
  late DateTime _monthStart;

  @override
  void initState() {
    super.initState();
    _syncToToday();
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
    });
  }

  void _goNext() {
    setState(() {
      if (_viewMode == ViewMode.week) {
        _weekStart = _weekStart.add(const Duration(days: 7));
      } else {
        _monthStart = DateTime(_monthStart.year, _monthStart.month + 1, 1);
      }
    });
  }

  DateTime get _initialDateForStrip {
    switch (_viewMode) {
      case ViewMode.day:
        return DateTime.now();
      case ViewMode.week:
        return _weekStart;
      case ViewMode.month:
        return _monthStart;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultContainerWidget(
      borderRadius: BorderRadius.circular(24),
      hasShadow: false,
      padding: const EdgeInsets.only(top: 52, bottom: 16, left: 16, right: 16),
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
              onChanged: (mode) => setState(() => _viewMode = mode),
            ),
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
              Gap(12),
          ] else
            Gap(12),
          DateStrip(
            initialDate: widget.showViewModeSwitcher
                ? _initialDateForStrip
                : DateTime.now(),
          ),
        ],
      ),
    );
  }
}
