import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:rient_app/core/utils/const/app_colors.dart';
import 'package:rient_app/core/utils/const/app_decoration.dart';
import 'package:rient_app/core/utils/const/app_fonts.dart';
import 'package:rient_app/core/widgets/app_refresh_indicator.dart';
import 'package:rient_app/core/widgets/default_container.dart';
import 'package:rient_app/core/widgets/loading_widget.dart';
import 'package:rient_app/features/analytics/data/models/analytics_summary/analytics_summary.dart';
import 'package:rient_app/features/analytics/view/providers/analytics_statistics_provider.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/schedule/data/models/workers_api/workers_api.dart';
import 'package:rient_app/features/schedule/view/components/date_strip.dart';
import 'package:rient_app/features/schedule/view/components/specialist_select_dialog.dart';
import 'package:rient_app/features/schedule/view/components/specialist_selector_pill.dart';
import 'package:rient_app/core/widgets/date_range_picker_dialog.dart';
import 'package:rient_app/features/home/data/models/statistics/statistics.dart'
    show OccupancyByDay;
import 'package:rient_app/features/home/view/components/entity_selector_pill.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/home/view/providers/current_worker_id_provider.dart';
import 'package:rient_app/features/schedule/view/providers/workers_provider.dart';
import 'package:rient_app/features/schedule/view/schedule_page.dart';
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

const _allSpecialistsItem = SpecialistItem(
  name: 'Все специалисты',
  role: '',
);

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
  bool _topServicesExpanded = true;
  SpecialistItem _selectedSpecialist = _allSpecialistsItem;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month, 1);
  }

  static const _monthsBeforeCurrent = 12;
  static const _monthsAfterCurrent = 24;

  static DateTime _addMonths(DateTime month, int delta) =>
      DateTime(month.year, month.month + delta, 1);

  /// 12 мес. назад от текущего, 24 вперёд; при выборе прошлого месяца — с него.
  List<DateTime> get _visibleMonths {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month, 1);
    final focused = DateTime(_focusedMonth.year, _focusedMonth.month, 1);

    var start = _addMonths(currentMonth, -_monthsBeforeCurrent);
    var end = _addMonths(currentMonth, _monthsAfterCurrent);

    if (focused.isBefore(start)) {
      start = focused;
      end = _addMonths(focused, _monthsBeforeCurrent + _monthsAfterCurrent);
    } else if (focused.isAfter(end)) {
      end = _addMonths(focused, _monthsAfterCurrent);
    }

    final count =
        (end.year - start.year) * 12 + (end.month - start.month) + 1;
    return List.generate(count, (i) => _addMonths(start, i));
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

  void _openScheduleForDay(DateTime date) {
    final day = DateTime(date.year, date.month, date.day);
    ref.read(selectedScheduleDateProvider.notifier).state = day;
    ref.read(openScheduleOnDayProvider.notifier).state = day;

    final isWorkerRole = ref.read(roleProvider) == UserRole.worker.value;
    final specialistId = _selectedSpecialist.id;
    if (!isWorkerRole && specialistId != null && specialistId > 0) {
      ref.read(selectedSpecialistIdProvider.notifier).state = specialistId;
    }

    if (context.canPop()) {
      context.pop();
    }
    context.goNamed(SchedulePage.name);
  }

  Future<void> _openCalendar() async {
    final range = await AppDateRangePickerDialog.show(
      context,
      initialStart: _rangeStart,
      initialEnd: _rangeEnd,
      summaryPrefix: 'Будет показана аналитика за ',
    );
    if (!mounted || range == null) return;
    if (range.clearFilter) {
      final now = DateTime.now();
      setState(() {
        _filterMode = _AnalyticsFilterMode.month;
        _rangeStart = null;
        _rangeEnd = null;
        _focusedMonth = DateTime(now.year, now.month, 1);
      });
      return;
    }
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

  static String _workerDisplayName(WorkerApi worker) {
    final name =
        '${worker.firstName ?? ''} ${worker.lastName ?? ''}'.trim();
    return name.isEmpty ? 'Специалист' : name;
  }

  static List<SpecialistItem> _specialistsFromWorkers(List<WorkerApi> workers) {
    return [
      _allSpecialistsItem,
      for (final worker in workers)
        SpecialistItem(
          name: _workerDisplayName(worker),
          role: worker.specialization ?? '',
          id: worker.id,
          pictureUrl: worker.pictureThumbnail ?? worker.picture,
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenBg = isDark
        ? AppColors.secondaryDarkLight
        : AppColors.tabBarScreenBackground;
    final (start, end) = _queryRange;
    final isWorkerRole = ref.watch(roleProvider) == UserRole.worker.value;
    final branch = ref.watch(currentBranchProvider);
    final branchName = branch?.name?.trim();
    final branchLabel =
        branchName != null && branchName.isNotEmpty ? 'Филиал $branchName' : '';
    final workersAsync = ref.watch(scheduleWorkersProvider);
    final specialists = workersAsync.maybeWhen(
      data: (response) => _specialistsFromWorkers(response.results),
      orElse: () => const [_allSpecialistsItem],
    );
    final comparisonType = _filterMode == _AnalyticsFilterMode.month
        ? 'month'
        : 'interval';
    final analyticsQuery = AnalyticsQuery(
      start: start,
      end: end,
      workerId: isWorkerRole ? null : _selectedSpecialist.id,
      type: comparisonType,
    );
    final statsAsync = ref.watch(analyticsSummaryProvider(analyticsQuery));
    final currentWorkerId = ref.watch(currentWorkerIdProvider).value;

    Future<void> onRefresh() async {
      ref.invalidate(analyticsSummaryProvider(analyticsQuery));
      ref.invalidate(scheduleWorkersProvider);
      try {
        await ref.read(analyticsSummaryProvider(analyticsQuery).future);
      } catch (_) {}
    }

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
            showSpecialistSelector: !isWorkerRole,
            specialists: specialists,
            selectedSpecialist: _selectedSpecialist.id != null
                ? _selectedSpecialist
                : SpecialistItem(
                    name: _selectedSpecialist.name,
                    role: branchLabel,
                  ),
            onSpecialistSelected: (selected) =>
                setState(() => _selectedSpecialist = selected),
          ),
          Expanded(
            child: AppRefreshIndicator(
              onRefresh: onRefresh,
              child: statsAsync.when(
                loading: () => ListView(
                  physics: AppRefreshIndicator.scrollPhysics,
                  children: [
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.55,
                      child: const Center(child: LoadingWidget()),
                    ),
                  ],
                ),
                error: (_, __) => ListView(
                  physics: AppRefreshIndicator.scrollPhysics,
                  children: [
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.55,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Не удалось загрузить аналитику',
                                style: AppFonts.b1Medium.copyWith(
                                  color: isDark
                                      ? AppColors.primaryWhite
                                      : AppColors.primaryDark,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const Gap(12),
                              TextButton(
                                onPressed: onRefresh,
                                child: const Text('Повторить'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                data: (summary) => _AnalyticsContent(
                isDark: isDark,
                data: _AnalyticsViewData.fromAnalyticsSummary(
                  summary,
                  filterMode: _filterMode,
                  start: start,
                  end: end,
                  filterWorkerId: isWorkerRole
                      ? (summary.workerId ?? currentWorkerId)
                      : _selectedSpecialist.id,
                ),
                generalExpanded: _generalExpanded,
                workloadExpanded: _workloadExpanded,
                clientsExpanded: _clientsExpanded,
                topServicesExpanded: _topServicesExpanded,
                formatMoney: _formatMoney,
                onGeneralToggle: () =>
                    setState(() => _generalExpanded = !_generalExpanded),
                onWorkloadToggle: () =>
                    setState(() => _workloadExpanded = !_workloadExpanded),
                onClientsToggle: () =>
                    setState(() => _clientsExpanded = !_clientsExpanded),
                onTopServicesToggle: () => setState(
                  () => _topServicesExpanded = !_topServicesExpanded,
                ),
                onOpenScheduleDay: _openScheduleForDay,
              ),
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
    required this.productivityAmount,
    required this.productivityInRubles,
    required this.clientsServed,
    required this.income,
    required this.payDue,
    required this.newClients,
    required this.averageCheck,
    required this.totalClients,
    required this.existingClients,
    required this.oneshotClients,
    required this.averageAge,
    required this.maleClients,
    required this.femaleClients,
    required this.showIncome,
    required this.showPayDue,
    required this.showAverageCheck,
    required this.weekDays,
    required this.weekStart,
    required this.occupancyByDay,
    required this.stripSelectedDate,
    required this.singleDayLoad,
    required this.singleDayLabel,
    required this.showPeriodWorkload,
    required this.topServices,
  });

  final int fillRatePercent;
  final int productivityPercent;
  final double productivityAmount;
  final bool productivityInRubles;
  final int clientsServed;
  final double income;
  final double payDue;
  final int newClients;
  final double averageCheck;
  final int? totalClients;
  final int? existingClients;
  final int? oneshotClients;
  final double? averageAge;
  final int? maleClients;
  final int? femaleClients;
  final bool showIncome;
  final bool showPayDue;
  final bool showAverageCheck;
  final List<({DateTime date, double occupancy})> weekDays;
  final DateTime weekStart;
  final List<OccupancyByDay> occupancyByDay;
  final DateTime? stripSelectedDate;
  final double? singleDayLoad;
  final String? singleDayLabel;
  final bool showPeriodWorkload;
  final List<({String name, int count})> topServices;

  static String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  static DateTime? _parseDate(String raw) {
    final parts = raw.split('-');
    if (parts.length < 3) return null;
    return DateTime(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  static int _percentFromApi(double value) =>
      value > 1 ? value.round() : (value * 100).round();

  /// API отдаёт загруженность в процентах (0–100), не в долях.
  static double _occupancyPercent(double value) =>
      value > 1 ? value : value * 100;

  static List<AnalyticsOccupancyDay> _mergedOccupancyDays(
    AnalyticsSummary summary,
  ) {
    final byDate = <String, AnalyticsOccupancyDay>{};
    for (final day in summary.summary.occupancyByDay) {
      if (day.date.isNotEmpty) byDate[day.date] = day;
    }
    for (final day in summary.occupancy) {
      if (day.date.isNotEmpty) byDate[day.date] = day;
    }
    return byDate.values.toList();
  }

  static double _occupancyForDate(
    List<AnalyticsOccupancyDay> days,
    DateTime date, {
    double fallback = 0,
  }) {
    final item = days.firstWhereOrNull((e) => e.date == _dateKey(date));
    if (item == null) return _occupancyPercent(fallback);
    return _occupancyPercent(item.occupancy);
  }

  static List<({String name, int count})> _buildTopServices(
    AnalyticsSummary summary,
  ) {
    final aggregated = <String, int>{};
    for (final service in summary.global.services) {
      final count = service.countValue;
      if (count <= 0) continue;
      aggregated[service.displayName] =
          (aggregated[service.displayName] ?? 0) + count;
    }
    final sorted = aggregated.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted
        .take(10)
        .map((e) => (name: e.key, count: e.value))
        .toList();
  }

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

  static bool _isWorkerScoped(AnalyticsSummary summary, int? filterWorkerId) {
    final id = filterWorkerId ?? summary.workerId;
    return id != null && id > 0;
  }

  static int _clientsServedCount(
    AnalyticsSummary summary, {
    int? filterWorkerId,
  }) {
    final current = summary.comparison.current;
    final appointments = summary.summary.appointments;
    if (_isWorkerScoped(summary, filterWorkerId)) {
      if (current.totalClients != null) return current.totalClients!;
      final globalTotal = summary.global.clients.total;
      if (globalTotal > 0) return globalTotal;
      return 0;
    }
    return current.totalClients ??
        current.completedAppointments ??
        appointments.total;
  }

  factory _AnalyticsViewData.fromAnalyticsSummary(
    AnalyticsSummary summary, {
    required _AnalyticsFilterMode filterMode,
    required DateTime start,
    required DateTime end,
    int? filterWorkerId,
  }) {
    final days = <DateTime>[];
    for (var d = start; !d.isAfter(end); d = d.add(const Duration(days: 1))) {
      days.add(DateTime(d.year, d.month, d.day));
    }

    final occupancyDays = _mergedOccupancyDays(summary);
    final appointments = summary.summary.appointments;
    final current = summary.comparison.current;

    final fillRate = _percentFromApi(summary.summary.occupancy);
    final productivity = current.occupancy != null
        ? _percentFromApi(current.occupancy!)
        : () {
            final total = current.totalAppointments ?? appointments.total;
            final completed = current.completedAppointments ??
                (appointments.total - appointments.cancelled)
                    .clamp(0, appointments.total);
            return total > 0 ? (completed / total * 100).round() : 0;
          }();

    final served = _clientsServedCount(summary, filterWorkerId: filterWorkerId);
    final workerScoped = _isWorkerScoped(summary, filterWorkerId);

    final showIncome = summary.meta.canSeeIncome;
    final showPayDue = summary.meta.canSeePayDue;
    final showAverageCheck = summary.meta.canSeeIncome;

    var income = 0.0;
    var payDue = 0.0;
    if (showIncome || showPayDue) {
      final incomeDays = summary.summary.incomeByDay.isNotEmpty
          ? summary.summary.incomeByDay
          : current.incomeByDay;
      for (final item in incomeDays) {
        final d = _parseDate(item.date);
        if (d == null || d.isBefore(start) || d.isAfter(end)) continue;
        if (showIncome) income += item.incomeValue;
        if (showPayDue) payDue += item.payDueValue;
      }
    }
    if (showIncome && income == 0 && current.totalIncome != null) {
      income = current.totalIncome!;
    }
    if (showPayDue && payDue == 0 && current.totalIncome != null) {
      payDue = current.totalIncome!;
    }

    var productivityAmount = payDue;
    if (workerScoped && productivityAmount == 0) {
      productivityAmount = current.averageTransactions ?? 0;
    }

    final avgCheck = current.averageTransactions ??
        (served > 0 && showAverageCheck ? income / served : 0.0);

    final globalClients = summary.global.clients;
    final totalClients = workerScoped
        ? (current.totalClients ??
            (globalClients.total > 0 ? globalClients.total : null))
        : (globalClients.total > 0
            ? globalClients.total
            : current.totalClients);
    final existingClients = current.existingClients;
    final oneshotClients = current.oneshotClients;
    final averageAge = globalClients.averageAge;
    final maleClients = globalClients.maleTotal;
    final femaleClients = globalClients.femaleTotal;
    final hasGenderStats = maleClients > 0 || femaleClients > 0;

    List<({DateTime date, double occupancy})> weekDays;
    if (filterMode == _AnalyticsFilterMode.dateRange) {
      weekDays = days
          .map(
            (d) => (
              date: d,
              occupancy: _occupancyForDate(occupancyDays, d),
            ),
          )
          .toList();
    } else if (filterMode == _AnalyticsFilterMode.month) {
      final monday = _weekMonday(DateTime.now());
      weekDays = List.generate(7, (i) {
        final d = monday.add(Duration(days: i));
        return (
          date: d,
          occupancy: _occupancyForDate(occupancyDays, d),
        );
      });
    } else {
      weekDays = [
        (
          date: start,
          occupancy: _occupancyForDate(
            occupancyDays,
            start,
            fallback: summary.summary.occupancy,
          ),
        ),
      ];
    }

    final weekStart = filterMode == _AnalyticsFilterMode.month
        ? _weekMonday(DateTime.now())
        : _weekMonday(start);
    final isDateRange = filterMode == _AnalyticsFilterMode.dateRange;
    final periodOccupancy = isDateRange
        ? weekDays
            .map((e) => OccupancyByDay(date: e.date, occupancy: e.occupancy))
            .toList()
        : [
            for (final day in occupancyDays)
              if (_parseDate(day.date) case final d?)
                OccupancyByDay(
                  date: d,
                  occupancy: _occupancyPercent(day.occupancy),
                ),
          ];

    final singleDayOccupancy = filterMode == _AnalyticsFilterMode.singleDay
        ? () {
            final selected = DateTime(start.year, start.month, start.day);
            final now = DateTime.now();
            final isToday = selected.year == now.year &&
                selected.month == now.month &&
                selected.day == now.day;
            if (isToday && summary.summary.occupancyToday != null) {
              return _percentFromApi(summary.summary.occupancyToday!).toDouble();
            }
            return _occupancyForDate(
              occupancyDays,
              selected,
              fallback: summary.summary.occupancy,
            );
          }()
        : null;

    return _AnalyticsViewData(
      fillRatePercent: fillRate.clamp(0, 100),
      productivityPercent: productivity.clamp(0, 100),
      productivityAmount: productivityAmount,
      productivityInRubles: workerScoped,
      clientsServed: served,
      income: income,
      payDue: payDue,
      newClients: current.newClients ?? appointments.newCount,
      averageCheck: avgCheck,
      totalClients: totalClients,
      existingClients: existingClients,
      oneshotClients: oneshotClients,
      averageAge: averageAge,
      maleClients: hasGenderStats ? maleClients : null,
      femaleClients: hasGenderStats ? femaleClients : null,
      showIncome: showIncome,
      showPayDue: showPayDue,
      showAverageCheck: showAverageCheck,
      weekDays: weekDays,
      weekStart: weekStart,
      occupancyByDay: periodOccupancy,
      stripSelectedDate: _stripSelectedDate(weekStart),
      singleDayLoad: singleDayOccupancy,
      singleDayLabel: filterMode == _AnalyticsFilterMode.singleDay
          ? 'Загруженность ${_formatDayLabel(start)}'
          : null,
      showPeriodWorkload: isDateRange,
      topServices: _buildTopServices(summary),
    );
  }

  static String _formatDayLabel(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
}

class _AnalyticsPeriodLoadStrip extends StatelessWidget {
  const _AnalyticsPeriodLoadStrip({
    required this.days,
    required this.onDayTap,
  });

  final List<({DateTime date, double occupancy})> days;
  final ValueChanged<DateTime> onDayTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (_, __) => const Gap(4),
        itemBuilder: (context, index) {
          final day = days[index];
          final percent = day.occupancy.clamp(0.0, 100.0);
          return GestureDetector(
            onTap: () => onDayTap(day.date),
            behavior: HitTestBehavior.opaque,
            child: ScheduleDayLoadCircle(
              date: day.date,
              occupancyPercent: percent,
            ),
          );
        },
      ),
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
    required this.showSpecialistSelector,
    required this.specialists,
    required this.selectedSpecialist,
    required this.onSpecialistSelected,
  });

  final bool isDark;
  final VoidCallback onBack;
  final bool showSpecialistSelector;
  final List<SpecialistItem> specialists;
  final SpecialistItem selectedSpecialist;
  final ValueChanged<SpecialistItem> onSpecialistSelected;
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
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              formatChipDate(rangeStart!),
                              style: AppFonts.b2Medium.copyWith(
                                color: selectedMonthColor,
                              ),
                            ),
                            if (filterMode == _AnalyticsFilterMode.dateRange &&
                                rangeEnd != null) ...[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  '—',
                                  style: AppFonts.b2Regular.copyWith(
                                    color: inactiveMonthColor,
                                  ),
                                ),
                              ),
                              Text(
                                formatChipDate(rangeEnd!),
                                style: AppFonts.b2Medium.copyWith(
                                  color: selectedMonthColor,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
              ),
              if (filterMode != _AnalyticsFilterMode.month) ...[
                const Gap(8),
                GestureDetector(
                  onTap: onClearFilter,
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
                      Icons.close,
                      size: 18,
                      color: accent,
                    ),
                  ),
                ),
              ],
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
          if (showSpecialistSelector) ...[
            const Gap(12),
            if (selectedSpecialist.id != null)
              SpecialistSelectorPill(
                key: ValueKey('worker_${selectedSpecialist.id}'),
                specialists: specialists,
                initialSelected: selectedSpecialist,
                onSelected: onSpecialistSelected,
              )
            else
              _AnalyticsAllSpecialistsSelector(
                isDark: isDark,
                title: selectedSpecialist.name,
                subtitle: selectedSpecialist.role,
                specialists: specialists,
                selectedSpecialist: _allSpecialistsItem,
                onSpecialistSelected: onSpecialistSelected,
              ),
          ],
        ],
      ),
    );
  }
}

class _AnalyticsAllSpecialistsSelector extends StatelessWidget {
  const _AnalyticsAllSpecialistsSelector({
    required this.isDark,
    required this.title,
    required this.subtitle,
    required this.specialists,
    required this.selectedSpecialist,
    required this.onSpecialistSelected,
  });

  final bool isDark;
  final String title;
  final String subtitle;
  final List<SpecialistItem> specialists;
  final SpecialistItem selectedSpecialist;
  final ValueChanged<SpecialistItem> onSpecialistSelected;

  Future<void> _openDialog(BuildContext context) async {
    if (specialists.isEmpty) return;
    await SpecialistSelectDialog.show(
      context,
      specialists: specialists,
      initialSelected: selectedSpecialist,
      onSave: onSpecialistSelected,
    );
  }

  @override
  Widget build(BuildContext context) {
    final surface =
        isDark ? AppColors.secondaryDarkLight : AppColors.secondaryLight;
    final primaryText =
        isDark ? AppColors.primaryWhite : AppColors.primaryDark;
    final secondaryText =
        isDark ? AppColors.tabbarGreyDark : AppColors.tabbarGrey;
    final accent = AppColors.themeAccent(context);

    return Material(
      color: surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () => _openDialog(context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppFonts.b2Medium.copyWith(color: primaryText),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const Gap(2),
                      Text(
                        subtitle,
                        style: AppFonts.c2Tabbar.copyWith(color: secondaryText),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.keyboard_arrow_down_rounded, color: accent, size: 24),
            ],
          ),
        ),
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
  static const _separatorWidth = 20.0;
  static const _horizontalPadding = 16.0;
  /// Приблизительная ширина «Сентябрь, 2026» — для начального offset до layout.
  static const _estimatedMonthItemWidth = 92.0;

  late final ScrollController _scrollController;
  late List<GlobalKey> _itemKeys;

  @override
  void initState() {
    super.initState();
    _itemKeys = _keysFor(widget.months.length);
    final index = _focusedIndex;
    final initialOffset = index > 0
        ? index * (_estimatedMonthItemWidth + _separatorWidth)
        : 0.0;
    _scrollController = ScrollController(initialScrollOffset: initialOffset);
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
    return SingleChildScrollView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
      child: Row(
        children: [
          for (var index = 0; index < widget.months.length; index++) ...[
            if (index > 0) const Gap(_separatorWidth),
            KeyedSubtree(
              key: _itemKeys[index],
              child: GestureDetector(
                onTap: () => widget.onMonthSelected(widget.months[index]),
                behavior: HitTestBehavior.opaque,
                child: Text(
                  widget.formatMonthLabel(widget.months[index]),
                  style: AppFonts.b2Medium.copyWith(
                    color: index == _focusedIndex
                        ? widget.selectedColor
                        : widget.inactiveColor,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AnalyticsContent extends StatelessWidget {
  const _AnalyticsContent({
    required this.isDark,
    required this.data,
    required this.generalExpanded,
    required this.workloadExpanded,
    required this.clientsExpanded,
    required this.topServicesExpanded,
    required this.formatMoney,
    required this.onGeneralToggle,
    required this.onWorkloadToggle,
    required this.onClientsToggle,
    required this.onTopServicesToggle,
    required this.onOpenScheduleDay,
  });

  final bool isDark;
  final _AnalyticsViewData data;
  final ValueChanged<DateTime> onOpenScheduleDay;
  final bool generalExpanded;
  final bool workloadExpanded;
  final bool clientsExpanded;
  final bool topServicesExpanded;
  final String Function(double) formatMoney;
  final VoidCallback onGeneralToggle;
  final VoidCallback onWorkloadToggle;
  final VoidCallback onClientsToggle;
  final VoidCallback onTopServicesToggle;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.themeAccent(context);
    final cardColor = isDark ? AppColors.primaryWhiteDark : Colors.white;
    final workloadSurfaceColor =
        isDark ? AppColors.secondaryDarkLight : AppColors.secondaryDark;
    final labelColor = isDark ? AppColors.primaryWhite : AppColors.primaryDark;

    final showWeekStrip =
        data.singleDayLoad == null && !data.showPeriodWorkload;
    final showPeriodStrip = data.showPeriodWorkload;
    final workloadTitle = data.singleDayLabel ??
        (showPeriodStrip ? 'Загруженность за период' : 'Загруженность на неделю');

    return SingleChildScrollView(
      physics: AppRefreshIndicator.scrollPhysics,
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
                  value: data.productivityInRubles
                      ? formatMoney(data.productivityAmount)
                      : '${data.productivityPercent}%',
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
                if (data.showIncome || data.showPayDue)
                  Row(
                    children: [
                      if (data.showIncome)
                        Expanded(
                          child: _MetricCard(
                            title: 'Доход',
                            value: formatMoney(data.income),
                            cardColor: cardColor,
                            labelColor: labelColor,
                            accent: accent,
                          ),
                        ),
                      if (data.showIncome && data.showPayDue) const Gap(10),
                      if (data.showPayDue && !data.productivityInRubles)
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
                            style: AppFonts.medium18.copyWith(
                              color: labelColor,
                            ),
                          ),
                        ),
                        const Gap(12),
                        ScheduleDayLoadCircle(
                          date: data.weekDays.first.date,
                          occupancyPercent: data.singleDayLoad!,
                          useMonthCalendarCircleFill: false,
                          circleFill: workloadSurfaceColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (showWeekStrip || showPeriodStrip) ...[
            const Gap(16),
            _AnalyticsSection(
              title: workloadTitle,
              expanded: workloadExpanded,
              accent: accent,
              labelColor: labelColor,
              onToggle: onWorkloadToggle,
              child: showPeriodStrip
                  ? _AnalyticsPeriodLoadStrip(
                      days: data.weekDays,
                      onDayTap: onOpenScheduleDay,
                    )
                  : DateStrip(
                      visibleWeekStart: data.weekStart,
                      initialDate: data.stripSelectedDate,
                      selectedDate: data.stripSelectedDate,
                      occupancyByDay: data.occupancyByDay,
                      onDateSelected: onOpenScheduleDay,
                      showFullDateLabel: false,
                      useGreyCircles: true,
                      useMonthCalendarCircleFill: true,
                    ),
            ),
          ],
          const Gap(16),
          _AnalyticsSection(
            title: 'Клиенты',
            expanded: clientsExpanded,
            accent: accent,
            labelColor: labelColor,
            onToggle: onClientsToggle,
            child: _AnalyticsMetricCardGrid(
              metrics: [
                _AnalyticsMetricItem(
                  title: 'Новые клиенты',
                  value: '${data.newClients}',
                ),
                if (data.showAverageCheck)
                  _AnalyticsMetricItem(
                    title: 'Средний чек',
                    value: formatMoney(data.averageCheck),
                  ),
                if (data.totalClients != null)
                  _AnalyticsMetricItem(
                    title: 'Всего клиентов',
                    value: '${data.totalClients}',
                  ),
                if (data.existingClients != null && !data.productivityInRubles)
                  _AnalyticsMetricItem(
                    title: 'Постоянные',
                    value: '${data.existingClients}',
                  ),
                if (data.oneshotClients != null && !data.productivityInRubles)
                  _AnalyticsMetricItem(
                    title: 'Разовые',
                    value: '${data.oneshotClients}',
                  ),
                if (data.averageAge != null)
                  _AnalyticsMetricItem(
                    title: 'Средний возраст',
                    value: '${data.averageAge!.round()} лет',
                  ),
                if (data.maleClients != null && data.femaleClients != null)
                  _AnalyticsMetricItem(
                    title: 'Пол',
                    valueWidget: _GenderStatsValue(
                      maleCount: data.maleClients!,
                      femaleCount: data.femaleClients!,
                      accent: accent,
                    ),
                  ),
              ],
              cardColor: cardColor,
              labelColor: labelColor,
              accent: accent,
            ),
          ),
          const Gap(16),
          _AnalyticsSection(
            title: 'Топ 10 услуг',
            expanded: topServicesExpanded,
            accent: accent,
            labelColor: labelColor,
            onToggle: onTopServicesToggle,
            child: data.topServices.isEmpty
                ? Text(
                    'Нет данных об услугах',
                    style: AppFonts.b2Medium.copyWith(color: labelColor),
                  )
                : Column(
                    children: [
                      for (var i = 0; i < data.topServices.length; i++) ...[
                        if (i > 0) const Gap(10),
                        _TopServiceRowCard(
                          rank: i + 1,
                          name: data.topServices[i].name,
                          cardColor: cardColor,
                          labelColor: labelColor,
                          accent: accent,
                        ),
                      ],
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

class _TopServiceRowCard extends StatelessWidget {
  const _TopServiceRowCard({
    required this.rank,
    required this.name,
    required this.cardColor,
    required this.labelColor,
    required this.accent,
  });

  final int rank;
  final String name;
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
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '$rank',
              style: AppFonts.b2Medium.copyWith(color: accent),
            ),
          ),
          Expanded(
            child: Text(
              name,
              style: AppFonts.b2Medium.copyWith(color: labelColor),
            ),
          ),
        ],
      ),
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

class _GenderStatsValue extends StatelessWidget {
  const _GenderStatsValue({
    required this.maleCount,
    required this.femaleCount,
    required this.accent,
  });

  final int maleCount;
  final int femaleCount;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final valueStyle = AppFonts.h4Medium.copyWith(color: accent);
    return Row(
      children: [
        Icon(Icons.boy_rounded, size: 28, color: accent),
        const Gap(5),
        Text('$maleCount', style: valueStyle),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text('·', style: valueStyle),
        ),
        Icon(Icons.girl_rounded, size: 28, color: accent),
        const Gap(4),
        Text('$femaleCount', style: valueStyle),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.title,
    required this.cardColor,
    required this.labelColor,
    required this.accent,
    this.value,
    this.valueWidget,
  });

  final String title;
  final String? value;
  final Widget? valueWidget;
  final Color cardColor;
  final Color labelColor;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final valueContent = valueWidget ??
        Text(
          value ?? '',
          style: AppFonts.h4Medium.copyWith(color: accent),
        );

    return DefaultContainerWidget(
      color: cardColor,
      hasShadow: false,
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: AppFonts.b2Medium.copyWith(color: labelColor)),
          const Gap(8),
          valueContent,
        ],
      ),
    );
  }
}

class _AnalyticsMetricItem {
  const _AnalyticsMetricItem({
    required this.title,
    this.value,
    this.valueWidget,
  }) : assert(
          value != null || valueWidget != null,
          'value or valueWidget required',
        );

  final String title;
  final String? value;
  final Widget? valueWidget;
}

class _AnalyticsMetricCardGrid extends StatelessWidget {
  const _AnalyticsMetricCardGrid({
    required this.metrics,
    required this.cardColor,
    required this.labelColor,
    required this.accent,
  });

  final List<_AnalyticsMetricItem> metrics;
  final Color cardColor;
  final Color labelColor;
  final Color accent;

  static const _crossAxisCount = 2;
  static const _spacing = 10.0;
  /// Высота карточки как в прежней вёрстке (padding + заголовок + gap + значение).
  static const _cellHeight = 84.0;

  @override
  Widget build(BuildContext context) {
    if (metrics.isEmpty) return const SizedBox.shrink();

    final rowCount = (metrics.length + _crossAxisCount - 1) ~/ _crossAxisCount;
    final gridHeight =
        rowCount * _cellHeight + (rowCount - 1) * _spacing;

    return SizedBox(
      height: gridHeight,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: metrics.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _crossAxisCount,
          mainAxisSpacing: _spacing,
          crossAxisSpacing: _spacing,
          mainAxisExtent: _cellHeight,
        ),
        itemBuilder: (context, index) {
          final metric = metrics[index];
          return _MetricCard(
            title: metric.title,
            value: metric.value,
            valueWidget: metric.valueWidget,
            cardColor: cardColor,
            labelColor: labelColor,
            accent: accent,
          );
        },
      ),
    );
  }
}
