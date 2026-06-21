import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_summary.freezed.dart';
part 'analytics_summary.g.dart';

@freezed
sealed class AnalyticsSummary with _$AnalyticsSummary {
  const factory AnalyticsSummary({
    @JsonKey(name: 'organization_id') required int organizationId,
    @JsonKey(name: 'branch_id') required int branchId,
    @JsonKey(name: 'worker_id') int? workerId,
    required AnalyticsPeriod period,
    required AnalyticsSummaryBlock summary,
    @Default([]) List<AnalyticsOccupancyDay> occupancy,
    required AnalyticsComparison comparison,
    required AnalyticsGlobal global,
    AnalyticsOverview? overview,
    AnalyticsSpecialist? specialist,
    AnalyticsBenchmarking? benchmarking,
    required AnalyticsMeta meta,
  }) = _AnalyticsSummary;

  factory AnalyticsSummary.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsSummaryFromJson(json);
}

@freezed
sealed class AnalyticsPeriod with _$AnalyticsPeriod {
  const factory AnalyticsPeriod({
    @JsonKey(name: 'datetime__gte') required String datetimeGte,
    @JsonKey(name: 'datetime__lte') required String datetimeLte,
  }) = _AnalyticsPeriod;

  factory AnalyticsPeriod.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsPeriodFromJson(json);
}

@freezed
sealed class AnalyticsSummaryBlock with _$AnalyticsSummaryBlock {
  const factory AnalyticsSummaryBlock({
    required AnalyticsAppointments appointments,
    required double occupancy,
    @JsonKey(name: 'occupancy_today') double? occupancyToday,
    @JsonKey(name: 'occupancy_by_day')
    @Default([])
    List<AnalyticsOccupancyDay> occupancyByDay,
    @JsonKey(name: 'income_by_day')
    @Default([])
    List<AnalyticsIncomeByDay> incomeByDay,
    @JsonKey(name: 'upcoming_services_today')
    @Default([])
    List<AnalyticsNamedCount> upcomingServicesToday,
    @JsonKey(name: 'average_check_today') double? averageCheckToday,
    @JsonKey(name: 'projected_income_today') double? projectedIncomeToday,
    @JsonKey(name: 'factual_income_now') double? factualIncomeNow,
  }) = _AnalyticsSummaryBlock;

  factory AnalyticsSummaryBlock.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsSummaryBlockFromJson(json);
}

@freezed
sealed class AnalyticsAppointments with _$AnalyticsAppointments {
  const factory AnalyticsAppointments({
    required int total,
    required int cancelled,
    @JsonKey(name: 'new') required int newCount,
  }) = _AnalyticsAppointments;

  factory AnalyticsAppointments.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsAppointmentsFromJson(json);
}

@freezed
sealed class AnalyticsOccupancyDay with _$AnalyticsOccupancyDay {
  const factory AnalyticsOccupancyDay({
    required String date,
    required double occupancy,
  }) = _AnalyticsOccupancyDay;

  factory AnalyticsOccupancyDay.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsOccupancyDayFromJson(json);
}

@freezed
sealed class AnalyticsIncomeByDay with _$AnalyticsIncomeByDay {
  const factory AnalyticsIncomeByDay({
    required String date,
    double? sum,
    double? income,
    @JsonKey(name: 'pay_due') double? payDue,
  }) = _AnalyticsIncomeByDay;

  const AnalyticsIncomeByDay._();

  double get incomeValue => income ?? sum ?? 0;

  double get payDueValue => payDue ?? 0;

  factory AnalyticsIncomeByDay.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsIncomeByDayFromJson(json);
}

@freezed
sealed class AnalyticsNamedCount with _$AnalyticsNamedCount {
  const factory AnalyticsNamedCount({
    String? service,
    String? name,
    @Default(0) int count,
  }) = _AnalyticsNamedCount;

  const AnalyticsNamedCount._();

  String get displayName =>
      (service ?? name ?? '').trim().isEmpty ? 'Услуга' : (service ?? name)!.trim();

  factory AnalyticsNamedCount.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsNamedCountFromJson(json);
}

@freezed
sealed class AnalyticsComparison with _$AnalyticsComparison {
  const factory AnalyticsComparison({
    required AnalyticsComparisonPeriod current,
  }) = _AnalyticsComparison;

  factory AnalyticsComparison.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsComparisonFromJson(json);
}

@freezed
sealed class AnalyticsOverview with _$AnalyticsOverview {
  const factory AnalyticsOverview({
    double? performance,
    @JsonKey(name: 'pay_due') double? payDue,
    double? occupancy,
    double? income,
    int? clients,
    @JsonKey(name: 'average_check') double? averageCheck,
  }) = _AnalyticsOverview;

  factory AnalyticsOverview.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsOverviewFromJson(json);
}

@freezed
sealed class AnalyticsComparisonPeriod with _$AnalyticsComparisonPeriod {
  const factory AnalyticsComparisonPeriod({
    @JsonKey(name: 'total_income') double? totalIncome,
    double? performance,
    @JsonKey(name: 'pay_due') double? payDue,
    @JsonKey(name: 'total_clients') int? totalClients,
    @JsonKey(name: 'completed_appointments') int? completedAppointments,
    @JsonKey(name: 'total_appointments') int? totalAppointments,
    @JsonKey(name: 'new_clients') int? newClients,
    @JsonKey(name: 'existing_clients') int? existingClients,
    @JsonKey(name: 'oneshot_clients') int? oneshotClients,
    @JsonKey(name: 'oneshot_clients_all') int? oneshotClientsAll,
    @JsonKey(name: 'average_transactions') double? averageTransactions,
    double? occupancy,
    @JsonKey(name: 'income_by_day')
    @Default([])
    List<AnalyticsIncomeByDay> incomeByDay,
  }) = _AnalyticsComparisonPeriod;

  factory AnalyticsComparisonPeriod.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsComparisonPeriodFromJson(json);
}

@freezed
sealed class AnalyticsGlobal with _$AnalyticsGlobal {
  const factory AnalyticsGlobal({
    @Default([]) List<AnalyticsGlobalService> services,
    @Default(AnalyticsGlobalClients()) AnalyticsGlobalClients clients,
    @Default({}) Map<String, dynamic> sources,
  }) = _AnalyticsGlobal;

  factory AnalyticsGlobal.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsGlobalFromJson(json);
}

@freezed
sealed class AnalyticsGlobalClients with _$AnalyticsGlobalClients {
  const factory AnalyticsGlobalClients({
    @JsonKey(name: 'average_age') double? averageAge,
    @Default(0) int total,
    @JsonKey(name: 'groups_map')
    @Default({})
    Map<String, AnalyticsClientAgeGroup> groupsMap,
  }) = _AnalyticsGlobalClients;

  const AnalyticsGlobalClients._();

  int get maleTotal => groupsMap.values.fold(0, (sum, g) => sum + g.male);

  int get femaleTotal => groupsMap.values.fold(0, (sum, g) => sum + g.female);

  factory AnalyticsGlobalClients.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsGlobalClientsFromJson(json);
}

@freezed
sealed class AnalyticsClientAgeGroup with _$AnalyticsClientAgeGroup {
  const factory AnalyticsClientAgeGroup({
    @Default(0) int male,
    @Default(0) int female,
  }) = _AnalyticsClientAgeGroup;

  factory AnalyticsClientAgeGroup.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsClientAgeGroupFromJson(json);
}

@freezed
sealed class AnalyticsGlobalService with _$AnalyticsGlobalService {
  const factory AnalyticsGlobalService({
    String? name,
    String? service,
    @Default(0) int count,
    @Default(0) int total,
  }) = _AnalyticsGlobalService;

  const AnalyticsGlobalService._();

  String get displayName {
    final value = (name ?? service ?? '').trim();
    return value.isEmpty ? 'Услуга' : value;
  }

  int get countValue => count > 0 ? count : total;

  factory AnalyticsGlobalService.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsGlobalServiceFromJson(json);
}

@freezed
sealed class AnalyticsSpecialist with _$AnalyticsSpecialist {
  const factory AnalyticsSpecialist({
    double? performance,
    @JsonKey(name: 'pay_due') double? payDue,
  }) = _AnalyticsSpecialist;

  factory AnalyticsSpecialist.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsSpecialistFromJson(json);
}

@freezed
sealed class AnalyticsBenchmarking with _$AnalyticsBenchmarking {
  const factory AnalyticsBenchmarking({
    @Default({}) Map<String, dynamic> data,
  }) = _AnalyticsBenchmarking;

  factory AnalyticsBenchmarking.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsBenchmarkingFromJson(json);
}

@freezed
sealed class AnalyticsMeta with _$AnalyticsMeta {
  const factory AnalyticsMeta({
    int? role,
    @JsonKey(name: 'can_see_income') @Default(true) bool canSeeIncome,
    @JsonKey(name: 'can_see_pay_due') @Default(false) bool canSeePayDue,
  }) = _AnalyticsMeta;

  factory AnalyticsMeta.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsMetaFromJson(json);
}
