import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/default_container.dart';
import 'package:rient_app/core/widgets/loading_widget.dart';
import 'package:rient_app/features/analytics/view/providers/analytics_statistics_provider.dart';
import 'package:rient_app/features/analytics/view/components/analytics_day_load_circle.dart';
import 'package:rient_app/features/schedule/view/components/date_strip.dart';
import 'package:rient_app/features/chat/view/components/messages_date_range_dialog.dart';
import 'package:rient_app/features/home/data/models/statistics/statistics.dart';
import 'package:rient_app/features/home/view/components/entity_selector_pill.dart';
import 'package:rient_app/resources/resources.dart';

const _monthNominative = [
  'Январь',
  'Февраль',
  'Март',
  'Апрель',
  'Май',
  'Июнь',
  'Июль',
  'Август',
  'Сентябрь',
  'Октябрь',
  'Ноябрь',
  'Декабрь',
];

enum _AnalyticsFilterMode { month, singleDay, dateRange }

class AnalyticsPage extends ConsumerStatefulWidget {
  const AnalyticsPage({super.key});

  static const name = 'analytics_page';
  static const path = 'analytics';

  @override
  ConsumerState<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends ConsumerState<AnalyticsPage> {
  _AnalyticsFilterMode _filterMode = _AnalyticsFilterMode.month;
  late DateTime _focusedMonth;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  bool _generalExpanded = true;
  bool _workloadExpanded = true;
  bool _clientsExpanded = true;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month, 1);
  }

  /// С текущего месяца вперёд; если выбран прошлый месяц (календарь) — с него до +24 мес.
  List<DateTime> get _visibleMonths {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month, 1);
    final focused = DateTime(_focusedMonth.year, _focusedMonth.month, 1);

    if (focused.isBefore(currentMonth)) {
      final monthsUntilCurrent =
          (currentMonth.year - focused.year) * 12 +
          (currentMonth.month - focused.month);
      final total = monthsUntilCurrent + 24;
      return List.generate(total, (i) {
        return DateTime(focused.year, focused.month + i, 1);
      });
    }

    return List.generate(24, (i) {
      return DateTime(currentMonth.year, currentMonth.month + i, 1);
    });
  }

  (DateTime start, DateTime end) get _queryRange {
    switch (_filterMode) {
      case _AnalyticsFilterMode.month:
        final last = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0);
        return (_focusedMonth, last);
      case _AnalyticsFilterMode.singleDay:
        final d = _rangeStart ?? DateTime.now();
        final day = DateTime(d.year, d.month, d.day);
        return (day, day);
      case _AnalyticsFilterMode.dateRange:
        final start = _rangeStart ?? DateTime.now();
        final end = _rangeEnd ?? start;
        final s = DateTime(start.year, start.month, start.day);
        final e = DateTime(end.year, end.month, end.day);
        return s.isBefore(e) ? (s, e) : (e, s);
    }
  }

  String _formatChipDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';

  String _formatMoney(double value) {
    final n = value.round();
    final chars = n.abs().toString().split('').reversed.toList();
    final buf = StringBuffer();
    for (var i = 0; i < chars.length; i++) {
      if (i > 0 && i % 3 == 0) buf.write(' ');
      buf.write(chars[i]);
    }
    final formatted = buf.toString().split('').reversed.join();
    return '${n < 0 ? '-' : ''}$formatted ₽';
  }

  Future<void> _openCalendar() async {
    final range = await MessagesDateRangeDialog.show(
      context,
      initialStart: _rangeStart ?? _focusedMonth,
      initialEnd: _rangeEnd ?? _rangeStart,
    );
    if (!mounted || range == null) return;
    setState(() {
      if (range.start == null) return;
      final start = range.start!;
      final end = range.end ?? start;
      if (_isSameDay(start, end)) {
        _filterMode = _AnalyticsFilterMode.singleDay;
        _rangeStart = start;
        _rangeEnd = null;
        _focusedMonth = DateTime(start.year, start.month, 1);
      } else {
        _filterMode = _AnalyticsFilterMode.dateRange;
        _rangeStart = start;
        _rangeEnd = end;
        _focusedMonth = DateTime(start.year, start.month, 1);
      }
    });
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  void _clearDateFilter() {
    setState(() {
      _filterMode = _AnalyticsFilterMode.month;
      _rangeStart = null;
      _rangeEnd = null;
      final now = DateTime.now();
      _focusedMonth = DateTime(now.year, now.month, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenBg = isDark
        ? AppColors.secondaryDarkLight
        : AppColors.tabBarScreenBackground;
    final (start, end) = _queryRange;
    final statsAsync = ref.watch(
      analyticsStatisticsProvider(AnalyticsQuery(start: start, end: end)),
    );

    return Scaffold(
      backgroundColor: screenBg,
      body: Column(
        children: [
          _AnalyticsHeader(
            isDark: isDark,
            onBack: () => context.pop(),
            filterMode: _filterMode,
            focusedMonth: _focusedMonth,
            rangeStart: _rangeStart,
            rangeEnd: _rangeEnd,
            visibleMonths: _visibleMonths,
            formatChipDate: _formatChipDate,
            formatMonthLabel: (m) =>
                '${_monthNominative[m.month - 1]}, ${m.year}',
            onMonthSelected: (m) {
              setState(() {
                _filterMode = _AnalyticsFilterMode.month;
                _focusedMonth = m;
                _rangeStart = null;
                _rangeEnd = null;
              });
            },
            onCalendarTap: _openCalendar,
            onClearFilter: _clearDateFilter,
          ),
          Expanded(
            child: statsAsync.when(
              loading: () => const Center(child: LoadingWidget()),
              error: (_, __) => _AnalyticsContent(
                isDark: isDark,
                data: _AnalyticsViewData.mock(_filterMode, start, end),
                generalExpanded: _generalExpanded,
                workloadExpanded: _workloadExpanded,
                clientsExpanded: _clientsExpanded,
                formatMoney: _formatMoney,
                onGeneralToggle: () =>
                    setState(() => _generalExpanded = !_generalExpanded),
                onWorkloadToggle: () =>
                    setState(() => _workloadExpanded = !_workloadExpanded),
                onClientsToggle: () =>
                    setState(() => _clientsExpanded = !_clientsExpanded),
              ),
              data: (stats) => _AnalyticsContent(
                isDark: isDark,
                data: _AnalyticsViewData.fromStatistics(
                  stats,
                  filterMode: _filterMode,
                  start: start,
                  end: end,
                ),
                generalExpanded: _generalExpanded,
                workloadExpanded: _workloadExpanded,
                clientsExpanded: _clientsExpanded,
                formatMoney: _formatMoney,
                onGeneralToggle: () =>
                    setState(() => _generalExpanded = !_generalExpanded),
                onWorkloadToggle: () =>
                    setState(() => _workloadExpanded = !_workloadExpanded),
                onClientsToggle: () =>
                    setState(() => _clientsExpanded = !_clientsExpanded),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalyticsViewData {
  const _AnalyticsViewData({
    required this.fillRatePercent,
    required this.productivityPercent,
    required this.clientsServed,
    required this.income,
    required this.payDue,
    required this.newClients,
    required this.averageCheck,
    required this.weekDays,
    required this.weekStart,
    required this.occupancyByDay,
    required this.stripSelectedDate,
    required this.singleDayLoad,
    required this.singleDayLabel,
  });

  final int fillRatePercent;
  final int productivityPercent;
  final int clientsServed;
  final double income;
  final double payDue;
  final int newClients;
  final double averageCheck;
  final List<({DateTime date, double occupancy})> weekDays;
  final DateTime weekStart;
  final List<OccupancyByDay> occupancyByDay;
  final DateTime? stripSelectedDate;
  final double? singleDayLoad;
  final String? singleDayLabel;

  static DateTime _weekMonday(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return d.subtract(Duration(days: d.weekday - 1));
  }

  static DateTime? _stripSelectedDate(DateTime weekStart) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sunday = weekStart.add(const Duration(days: 6));
    if (!today.isBefore(weekStart) && !today.isAfter(sunday)) return today;
    return weekStart;
  }

  factory _AnalyticsViewData.fromStatistics(
    Statistics stats, {
    required _AnalyticsFilterMode filterMode,
    required DateTime start,
    required DateTime end,
  }) {
    final days = <DateTime>[];
    for (var d = start; !d.isAfter(end); d = d.add(const Duration(days: 1))) {
      days.add(DateTime(d.year, d.month, d.day));
    }

    final occupancyInRange = stats.occupancyByDay.where((e) {
      final d = DateTime(e.date.year, e.date.month, e.date.day);
      return !d.isBefore(start) && !d.isAfter(end);
    }).toList();

    final fillRate = occupancyInRange.isNotEmpty
        ? (occupancyInRange.map((e) => e.occupancy).average * 100).round()
        : (stats.occupancy * 100).round();

    var served = 0;
    for (final item in stats.appointmentsByDay) {
      final parts = item.date.split('-');
      if (parts.length < 3) continue;
      final d = DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
      if (!d.isBefore(start) && !d.isAfter(end)) {
        served += item.appointments.total;
      }
    }
    if (served == 0) served = stats.appointments.total;

    var income = 0.0;
    var payDue = 0.0;
    for (final item in stats.incomeByDay ?? const <IncomeByDay>[]) {
      final d = DateTime(item.date.year, item.date.month, item.date.day);
      if (!d.isBefore(start) && !d.isAfter(end)) {
        income += item.income;
        payDue += item.payDue;
      }
    }

    final avgCheck = served > 0 ? income / served : 0.0;

    List<({DateTime date, double occupancy})> weekDays;
    if (filterMode == _AnalyticsFilterMode.dateRange) {
      weekDays = days
          .map(
            (d) => (
              date: d,
              occupancy:
                  stats.occupancyByDay
                      .firstWhereOrNull(
                        (e) =>
                            e.date.year == d.year &&
                            e.date.month == d.month &&
                            e.date.day == d.day,
                      )
                      ?.occupancy ??
                  0,
            ),
          )
          .toList();
    } else if (filterMode == _AnalyticsFilterMode.month) {
      final monday = start.subtract(Duration(days: start.weekday - 1));
      weekDays = List.generate(7, (i) {
        final d = monday.add(Duration(days: i));
        final occ =
            stats.occupancyByDay
                .firstWhereOrNull(
                  (e) =>
                      e.date.year == d.year &&
                      e.date.month == d.month &&
                      e.date.day == d.day,
                )
                ?.occupancy ??
            0;
        return (date: d, occupancy: occ);
      });
    } else {
      weekDays = [
        (
          date: start,
          occupancy:
              stats.occupancyByDay
                  .firstWhereOrNull(
                    (e) =>
                        e.date.year == start.year &&
                        e.date.month == start.month &&
                        e.date.day == start.day,
                  )
                  ?.occupancy ??
              stats.occupancy,
        ),
      ];
    }

    final weekStart = _weekMonday(start);

    return _AnalyticsViewData(
      fillRatePercent: fillRate.clamp(0, 100),
      productivityPercent: (fillRate * 1.1).round().clamp(0, 100),
      clientsServed: served,
      income: income,
      payDue: payDue,
      newClients: stats.appointments.newCount,
      averageCheck: avgCheck,
      weekDays: weekDays,
      weekStart: weekStart,
      occupancyByDay: stats.occupancyByDay,
      stripSelectedDate: _stripSelectedDate(weekStart),
      singleDayLoad: filterMode == _AnalyticsFilterMode.singleDay
          ? weekDays.first.occupancy * 100
          : null,
      singleDayLabel: filterMode == _AnalyticsFilterMode.singleDay
          ? 'Загруженность ${_formatDayLabel(start)}'
          : null,
    );
  }

  static String _formatDayLabel(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';

  factory _AnalyticsViewData.mock(
    _AnalyticsFilterMode mode,
    DateTime start,
    DateTime end,
  ) {
    final weekDays = mode == _AnalyticsFilterMode.dateRange
        ? List.generate(end.difference(start).inDays + 1, (i) {
            final d = start.add(Duration(days: i));
            return (date: d, occupancy: 0.45 + (i % 3) * 0.15);
          })
        : List.generate(7, (i) {
            final d = start.add(Duration(days: i));
            return (date: d, occupancy: 0.35 + (i % 4) * 0.12);
          });

    final weekStart = _weekMonday(start);
    final occupancyByDay = List.generate(7, (i) {
      final d = weekStart.add(Duration(days: i));
      final occ = weekDays
          .firstWhereOrNull(
            (e) =>
                e.date.year == d.year &&
                e.date.month == d.month &&
                e.date.day == d.day,
          )
          ?.occupancy;
      return OccupancyByDay(date: d, occupancy: occ ?? 0);
    });

    return _AnalyticsViewData(
      fillRatePercent: mode == _AnalyticsFilterMode.singleDay ? 55 : 77,
      productivityPercent: mode == _AnalyticsFilterMode.singleDay ? 75 : 98,
      clientsServed: mode == _AnalyticsFilterMode.singleDay ? 10 : 120,
      income: mode == _AnalyticsFilterMode.singleDay ? 14300 : 44300,
      payDue: mode == _AnalyticsFilterMode.singleDay ? 2300 : 11300,
      newClients: mode == _AnalyticsFilterMode.singleDay ? 12 : 123,
      averageCheck: 3300,
      weekDays: weekDays,
      weekStart: weekStart,
      occupancyByDay: occupancyByDay,
      stripSelectedDate: _stripSelectedDate(weekStart),
      singleDayLoad: mode == _AnalyticsFilterMode.singleDay ? 62 : null,
      singleDayLabel: mode == _AnalyticsFilterMode.singleDay
          ? 'Загруженность ${_formatDayLabel(start)}'
          : null,
    );
  }
}

class _AnalyticsHeader extends StatelessWidget {
  const _AnalyticsHeader({
    required this.isDark,
    required this.onBack,
    required this.filterMode,
    required this.focusedMonth,
    required this.rangeStart,
    required this.rangeEnd,
    required this.visibleMonths,
    required this.formatChipDate,
    required this.formatMonthLabel,
    required this.onMonthSelected,
    required this.onCalendarTap,
    required this.onClearFilter,
  });

  final bool isDark;
  final VoidCallback onBack;
  final _AnalyticsFilterMode filterMode;
  final DateTime focusedMonth;
  final DateTime? rangeStart;
  final DateTime? rangeEnd;
  final List<DateTime> visibleMonths;
  final String Function(DateTime) formatChipDate;
  final String Function(DateTime) formatMonthLabel;
  final ValueChanged<DateTime> onMonthSelected;
  final VoidCallback onCalendarTap;
  final VoidCallback onClearFilter;

  static const _monthSelectedText = Color(0xFF0048B5);
  static const _monthInactiveText = Color(0xFF9EC0F5);

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.themeAccent(context);
    final circleColor = isDark
        ? AppColors.secondaryDarkLight
        : AppColors.secondaryLight;
    final iconColor = isDark ? AppColors.primaryWhite : AppColors.primaryDark;
    final pillFill = isDark
        ? AppColors.secondaryDarkLight
        : AppColors.secondaryLight;
    final selectedMonthColor = isDark ? accent : _monthSelectedText;
    final inactiveMonthColor = isDark
        ? accent.withValues(alpha: 0.45)
        : _monthInactiveText;

    return DefaultContainerWidget(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(24),
        bottomRight: Radius.circular(24),
      ),
      hasShadow: false,
      padding: EdgeInsets.only(
        top: MediaQuery.paddingOf(context).top + 8,
        bottom: 14,
        left: 16,
        right: 16,
      ),
      color: isDark ? AppColors.primaryWhiteDark : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onBack,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: circleColor,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: iconColor,
                  ),
                ),
              ),
              const Gap(12),
              Expanded(
                child: Text(
                  'Аналитика',
                  style: AppFonts.h3Medium.copyWith(
                    color: isDark
                        ? AppColors.primaryWhite
                        : AppColors.primaryDark,
                  ),
                ),
              ),
              const ProfileSelectorPill(),
            ],
          ),
          const Gap(12),
          Row(
            children: [
              Expanded(
                child: filterMode == _AnalyticsFilterMode.month
                    ? Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: pillFill,
                          borderRadius: BorderRadius.circular(300),
                        ),
                        alignment: Alignment.center,
                        child: _MonthStrip(
                          months: visibleMonths,
                          focusedMonth: focusedMonth,
                          formatMonthLabel: formatMonthLabel,
                          selectedColor: selectedMonthColor,
                          inactiveColor: inactiveMonthColor,
                          onMonthSelected: onMonthSelected,
                        ),
                      )
                    : Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: pillFill,
                          borderRadius: BorderRadius.circular(300),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  _DateChip(
                                    label: formatChipDate(rangeStart!),
                                    accent: selectedMonthColor,
                                  ),
                                  if (filterMode ==
                                          _AnalyticsFilterMode.dateRange &&
                                      rangeEnd != null) ...[
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        '—',
                                        style: AppFonts.b2Regular.copyWith(
                                          color: inactiveMonthColor,
                                        ),
                                      ),
                                    ),
                                    _DateChip(
                                      label: formatChipDate(rangeEnd!),
                                      accent: selectedMonthColor,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: onClearFilter,
                              behavior: HitTestBehavior.opaque,
                              child: Icon(
                                Icons.close,
                                size: 18,
                                color: AppColors.tabbarGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              const Gap(8),
              GestureDetector(
                onTap: onCalendarTap,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: pillFill,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.calendar_today_outlined,
                    size: 18,
                    color: accent,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MonthStrip extends StatefulWidget {
  const _MonthStrip({
    required this.months,
    required this.focusedMonth,
    required this.formatMonthLabel,
    required this.selectedColor,
    required this.inactiveColor,
    required this.onMonthSelected,
  });

  final List<DateTime> months;
  final DateTime focusedMonth;
  final String Function(DateTime) formatMonthLabel;
  final Color selectedColor;
  final Color inactiveColor;
  final ValueChanged<DateTime> onMonthSelected;

  @override
  State<_MonthStrip> createState() => _MonthStripState();
}

class _MonthStripState extends State<_MonthStrip> {
  late final ScrollController _scrollController;
  late List<GlobalKey> _itemKeys;

  @override
  void initState() {
    super.initState();
    _itemKeys = _keysFor(widget.months.length);
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToFocused());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _MonthStrip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.months.length != widget.months.length) {
      _itemKeys = _keysFor(widget.months.length);
    }
    if (oldWidget.focusedMonth != widget.focusedMonth ||
        oldWidget.months.length != widget.months.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToFocused());
    }
  }

  List<GlobalKey> _keysFor(int length) =>
      List.generate(length, (_) => GlobalKey());

  int get _focusedIndex => widget.months.indexWhere(
    (m) =>
        m.year == widget.focusedMonth.year &&
        m.month == widget.focusedMonth.month,
  );

  void _scrollToFocused({int attempt = 0}) {
    if (!mounted || attempt > 8) return;

    final index = _focusedIndex;
    if (index < 0) return;

    if (!_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollToFocused(attempt: attempt + 1),
      );
      return;
    }

    if (index == 0) {
      _scrollController.jumpTo(0);
      return;
    }

    if (index >= _itemKeys.length) return;
    final itemContext = _itemKeys[index].currentContext;
    if (itemContext == null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollToFocused(attempt: attempt + 1),
      );
      return;
    }

    final renderObject = itemContext.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollToFocused(attempt: attempt + 1),
      );
      return;
    }

    final viewport = RenderAbstractViewport.of(renderObject);
    final target = viewport.getOffsetToReveal(renderObject, 0);
    final position = _scrollController.position;
    _scrollController.jumpTo(
      target.offset.clamp(position.minScrollExtent, position.maxScrollExtent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: widget.months.length,
      separatorBuilder: (_, __) => const Gap(20),
      itemBuilder: (context, index) {
        final month = widget.months[index];
        final selected = index == _focusedIndex;
        return KeyedSubtree(
          key: _itemKeys[index],
          child: GestureDetector(
            onTap: () => widget.onMonthSelected(month),
            behavior: HitTestBehavior.opaque,
            child: Center(
              child: Text(
                widget.formatMonthLabel(month),
                style: AppFonts.b2Medium.copyWith(
                  color: selected ? widget.selectedColor : widget.inactiveColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({required this.label, required this.accent});

  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Text(label, style: AppFonts.b2Medium.copyWith(color: accent));
  }
}

class _AnalyticsContent extends StatelessWidget {
  const _AnalyticsContent({
    required this.isDark,
    required this.data,
    required this.generalExpanded,
    required this.workloadExpanded,
    required this.clientsExpanded,
    required this.formatMoney,
    required this.onGeneralToggle,
    required this.onWorkloadToggle,
    required this.onClientsToggle,
  });

  final bool isDark;
  final _AnalyticsViewData data;
  final bool generalExpanded;
  final bool workloadExpanded;
  final bool clientsExpanded;
  final String Function(double) formatMoney;
  final VoidCallback onGeneralToggle;
  final VoidCallback onWorkloadToggle;
  final VoidCallback onClientsToggle;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.themeAccent(context);
    final cardColor = isDark ? AppColors.primaryWhiteDark : Colors.white;
    final labelColor = isDark ? AppColors.primaryWhite : AppColors.primaryDark;

    final showWeekStrip = data.singleDayLoad == null;
    final workloadTitle = data.singleDayLabel ?? 'Загруженность на неделю';

    return SingleChildScrollView(
      padding: AppDecoration.padding16.copyWith(top: 12, bottom: 24),
      child: Column(
        children: [
          Gap(10),
          _AnalyticsSection(
            title: 'Общая',
            expanded: generalExpanded,
            accent: accent,
            labelColor: labelColor,
            onToggle: onGeneralToggle,
            child: Column(
              children: [
                _MetricRowCard(
                  label: 'Заполняемость',
                  value: '${data.fillRatePercent}%',
                  cardColor: cardColor,
                  labelColor: labelColor,
                  accent: accent,
                ),
                const Gap(10),
                _MetricRowCard(
                  label: 'Производительность',
                  value: '${data.productivityPercent}%',
                  cardColor: cardColor,
                  labelColor: labelColor,
                  accent: accent,
                ),
                const Gap(10),
                _MetricRowCard(
                  label: 'Обслуженных клиентов',
                  value: '${data.clientsServed}',
                  cardColor: cardColor,
                  labelColor: labelColor,
                  accent: accent,
                ),
                const Gap(12),
                Row(
                  children: [
                    Expanded(
                      child: _MetricCard(
                        title: 'Доход',
                        value: formatMoney(data.income),
                        cardColor: cardColor,
                        labelColor: labelColor,
                        accent: accent,
                      ),
                    ),
                    const Gap(10),
                    Expanded(
                      child: _MetricCard(
                        title: 'К выплате',
                        value: formatMoney(data.payDue),
                        cardColor: cardColor,
                        labelColor: labelColor,
                        accent: accent,
                      ),
                    ),
                  ],
                ),
                if (data.singleDayLoad != null) ...[
                  const Gap(10),
                  DefaultContainerWidget(
                    color: cardColor,
                    hasShadow: false,
                    borderRadius: BorderRadius.circular(16),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            data.singleDayLabel!,
                            style: AppFonts.b2Medium.copyWith(
                              color: labelColor,
                            ),
                          ),
                        ),
                        AnalyticsDayLoadCircle(
                          date: data.weekDays.first.date,
                          occupancyPercent: data.singleDayLoad!,
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (showWeekStrip) ...[
            const Gap(32),
            _AnalyticsSection(
              title: workloadTitle,
              expanded: workloadExpanded,
              accent: accent,
              labelColor: labelColor,
              onToggle: onWorkloadToggle,
              child: DateStrip(
                visibleWeekStart: data.weekStart,
                initialDate: data.stripSelectedDate,
                selectedDate: data.stripSelectedDate,
                occupancyByDay: data.occupancyByDay,
                showFullDateLabel: false,
                useGreyCircles: true,
                useMonthCalendarCircleFill: true,
              ),
            ),
          ],
          const Gap(32),
          _AnalyticsSection(
            title: 'Клиенты',
            expanded: clientsExpanded,
            accent: accent,
            labelColor: labelColor,
            onToggle: onClientsToggle,
            child: Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    title: 'Новые клиенты',
                    value: '${data.newClients}',
                    cardColor: cardColor,
                    labelColor: labelColor,
                    accent: accent,
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: _MetricCard(
                    title: 'Средний чек',
                    value: formatMoney(data.averageCheck),
                    cardColor: cardColor,
                    labelColor: labelColor,
                    accent: accent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalyticsSection extends StatelessWidget {
  const _AnalyticsSection({
    required this.title,
    required this.expanded,
    required this.accent,
    required this.labelColor,
    required this.onToggle,
    required this.child,
  });

  final String title;
  final bool expanded;
  final Color accent;
  final Color labelColor;
  final VoidCallback onToggle;
  final Widget child;

  Widget _buildHeader() {
    return GestureDetector(
      onTap: onToggle,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppFonts.medium18.copyWith(color: labelColor),
            ),
          ),
          Image.asset(
            expanded ? AppImages.arrowOutlinedTop : AppImages.arrowOutlinedDown,
            color: accent,
            width: 20,
            height: 20,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!expanded) {
      return _buildHeader();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(),
        const Gap(12),
        child,
      ],
    );
  }
}

class _MetricRowCard extends StatelessWidget {
  const _MetricRowCard({
    required this.label,
    required this.value,
    required this.cardColor,
    required this.labelColor,
    required this.accent,
  });

  final String label;
  final String value;
  final Color cardColor;
  final Color labelColor;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return DefaultContainerWidget(
      color: cardColor,
      hasShadow: false,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: _MetricRow(
        label: label,
        value: value,
        labelColor: labelColor,
        accent: accent,
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.label,
    required this.value,
    required this.labelColor,
    required this.accent,
  });

  final String label;
  final String value;
  final Color labelColor;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppFonts.b2Medium.copyWith(color: labelColor),
          ),
        ),
        Text(value, style: AppFonts.b2Medium.copyWith(color: accent)),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.value,
    required this.cardColor,
    required this.labelColor,
    required this.accent,
  });

  final String title;
  final String value;
  final Color cardColor;
  final Color labelColor;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return DefaultContainerWidget(
      color: cardColor,
      hasShadow: false,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppFonts.b2Medium.copyWith(color: labelColor)),
          const Gap(8),
          Text(value, style: AppFonts.h4Medium.copyWith(color: accent)),
        ],
      ),
    );
  }
}
