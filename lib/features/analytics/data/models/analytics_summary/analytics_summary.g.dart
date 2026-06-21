// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AnalyticsSummary _$AnalyticsSummaryFromJson(Map<String, dynamic> json) =>
    _AnalyticsSummary(
      organizationId: (json['organization_id'] as num).toInt(),
      branchId: (json['branch_id'] as num).toInt(),
      workerId: (json['worker_id'] as num?)?.toInt(),
      period: AnalyticsPeriod.fromJson(json['period'] as Map<String, dynamic>),
      summary: AnalyticsSummaryBlock.fromJson(
        json['summary'] as Map<String, dynamic>,
      ),
      occupancy:
          (json['occupancy'] as List<dynamic>?)
              ?.map(
                (e) =>
                    AnalyticsOccupancyDay.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      comparison: AnalyticsComparison.fromJson(
        json['comparison'] as Map<String, dynamic>,
      ),
      global: AnalyticsGlobal.fromJson(json['global'] as Map<String, dynamic>),
      overview: json['overview'] == null
          ? null
          : AnalyticsOverview.fromJson(
              json['overview'] as Map<String, dynamic>,
            ),
      specialist: json['specialist'] == null
          ? null
          : AnalyticsSpecialist.fromJson(
              json['specialist'] as Map<String, dynamic>,
            ),
      benchmarking: json['benchmarking'] == null
          ? null
          : AnalyticsBenchmarking.fromJson(
              json['benchmarking'] as Map<String, dynamic>,
            ),
      meta: AnalyticsMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AnalyticsSummaryToJson(_AnalyticsSummary instance) =>
    <String, dynamic>{
      'organization_id': instance.organizationId,
      'branch_id': instance.branchId,
      'worker_id': instance.workerId,
      'period': instance.period,
      'summary': instance.summary,
      'occupancy': instance.occupancy,
      'comparison': instance.comparison,
      'global': instance.global,
      'overview': instance.overview,
      'specialist': instance.specialist,
      'benchmarking': instance.benchmarking,
      'meta': instance.meta,
    };

_AnalyticsPeriod _$AnalyticsPeriodFromJson(Map<String, dynamic> json) =>
    _AnalyticsPeriod(
      datetimeGte: json['datetime__gte'] as String,
      datetimeLte: json['datetime__lte'] as String,
    );

Map<String, dynamic> _$AnalyticsPeriodToJson(_AnalyticsPeriod instance) =>
    <String, dynamic>{
      'datetime__gte': instance.datetimeGte,
      'datetime__lte': instance.datetimeLte,
    };

_AnalyticsSummaryBlock _$AnalyticsSummaryBlockFromJson(
  Map<String, dynamic> json,
) => _AnalyticsSummaryBlock(
  appointments: AnalyticsAppointments.fromJson(
    json['appointments'] as Map<String, dynamic>,
  ),
  occupancy: (json['occupancy'] as num).toDouble(),
  occupancyToday: (json['occupancy_today'] as num?)?.toDouble(),
  occupancyByDay:
      (json['occupancy_by_day'] as List<dynamic>?)
          ?.map(
            (e) => AnalyticsOccupancyDay.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const [],
  incomeByDay:
      (json['income_by_day'] as List<dynamic>?)
          ?.map((e) => AnalyticsIncomeByDay.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  upcomingServicesToday:
      (json['upcoming_services_today'] as List<dynamic>?)
          ?.map((e) => AnalyticsNamedCount.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  averageCheckToday: (json['average_check_today'] as num?)?.toDouble(),
  projectedIncomeToday: (json['projected_income_today'] as num?)?.toDouble(),
  factualIncomeNow: (json['factual_income_now'] as num?)?.toDouble(),
);

Map<String, dynamic> _$AnalyticsSummaryBlockToJson(
  _AnalyticsSummaryBlock instance,
) => <String, dynamic>{
  'appointments': instance.appointments,
  'occupancy': instance.occupancy,
  'occupancy_today': instance.occupancyToday,
  'occupancy_by_day': instance.occupancyByDay,
  'income_by_day': instance.incomeByDay,
  'upcoming_services_today': instance.upcomingServicesToday,
  'average_check_today': instance.averageCheckToday,
  'projected_income_today': instance.projectedIncomeToday,
  'factual_income_now': instance.factualIncomeNow,
};

_AnalyticsAppointments _$AnalyticsAppointmentsFromJson(
  Map<String, dynamic> json,
) => _AnalyticsAppointments(
  total: (json['total'] as num).toInt(),
  cancelled: (json['cancelled'] as num).toInt(),
  newCount: (json['new'] as num).toInt(),
);

Map<String, dynamic> _$AnalyticsAppointmentsToJson(
  _AnalyticsAppointments instance,
) => <String, dynamic>{
  'total': instance.total,
  'cancelled': instance.cancelled,
  'new': instance.newCount,
};

_AnalyticsOccupancyDay _$AnalyticsOccupancyDayFromJson(
  Map<String, dynamic> json,
) => _AnalyticsOccupancyDay(
  date: json['date'] as String,
  occupancy: (json['occupancy'] as num).toDouble(),
);

Map<String, dynamic> _$AnalyticsOccupancyDayToJson(
  _AnalyticsOccupancyDay instance,
) => <String, dynamic>{'date': instance.date, 'occupancy': instance.occupancy};

_AnalyticsIncomeByDay _$AnalyticsIncomeByDayFromJson(
  Map<String, dynamic> json,
) => _AnalyticsIncomeByDay(
  date: json['date'] as String,
  sum: (json['sum'] as num?)?.toDouble(),
  income: (json['income'] as num?)?.toDouble(),
  payDue: (json['pay_due'] as num?)?.toDouble(),
);

Map<String, dynamic> _$AnalyticsIncomeByDayToJson(
  _AnalyticsIncomeByDay instance,
) => <String, dynamic>{
  'date': instance.date,
  'sum': instance.sum,
  'income': instance.income,
  'pay_due': instance.payDue,
};

_AnalyticsNamedCount _$AnalyticsNamedCountFromJson(Map<String, dynamic> json) =>
    _AnalyticsNamedCount(
      service: json['service'] as String?,
      name: json['name'] as String?,
      count: (json['count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$AnalyticsNamedCountToJson(
  _AnalyticsNamedCount instance,
) => <String, dynamic>{
  'service': instance.service,
  'name': instance.name,
  'count': instance.count,
};

_AnalyticsComparison _$AnalyticsComparisonFromJson(Map<String, dynamic> json) =>
    _AnalyticsComparison(
      current: AnalyticsComparisonPeriod.fromJson(
        json['current'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$AnalyticsComparisonToJson(
  _AnalyticsComparison instance,
) => <String, dynamic>{'current': instance.current};

_AnalyticsOverview _$AnalyticsOverviewFromJson(Map<String, dynamic> json) =>
    _AnalyticsOverview(
      performance: (json['performance'] as num?)?.toDouble(),
      payDue: (json['pay_due'] as num?)?.toDouble(),
      occupancy: (json['occupancy'] as num?)?.toDouble(),
      income: (json['income'] as num?)?.toDouble(),
      clients: (json['clients'] as num?)?.toInt(),
      averageCheck: (json['average_check'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AnalyticsOverviewToJson(_AnalyticsOverview instance) =>
    <String, dynamic>{
      'performance': instance.performance,
      'pay_due': instance.payDue,
      'occupancy': instance.occupancy,
      'income': instance.income,
      'clients': instance.clients,
      'average_check': instance.averageCheck,
    };

_AnalyticsComparisonPeriod _$AnalyticsComparisonPeriodFromJson(
  Map<String, dynamic> json,
) => _AnalyticsComparisonPeriod(
  totalIncome: (json['total_income'] as num?)?.toDouble(),
  performance: (json['performance'] as num?)?.toDouble(),
  payDue: (json['pay_due'] as num?)?.toDouble(),
  totalClients: (json['total_clients'] as num?)?.toInt(),
  completedAppointments: (json['completed_appointments'] as num?)?.toInt(),
  totalAppointments: (json['total_appointments'] as num?)?.toInt(),
  newClients: (json['new_clients'] as num?)?.toInt(),
  existingClients: (json['existing_clients'] as num?)?.toInt(),
  oneshotClients: (json['oneshot_clients'] as num?)?.toInt(),
  oneshotClientsAll: (json['oneshot_clients_all'] as num?)?.toInt(),
  averageTransactions: (json['average_transactions'] as num?)?.toDouble(),
  occupancy: (json['occupancy'] as num?)?.toDouble(),
  incomeByDay:
      (json['income_by_day'] as List<dynamic>?)
          ?.map((e) => AnalyticsIncomeByDay.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$AnalyticsComparisonPeriodToJson(
  _AnalyticsComparisonPeriod instance,
) => <String, dynamic>{
  'total_income': instance.totalIncome,
  'performance': instance.performance,
  'pay_due': instance.payDue,
  'total_clients': instance.totalClients,
  'completed_appointments': instance.completedAppointments,
  'total_appointments': instance.totalAppointments,
  'new_clients': instance.newClients,
  'existing_clients': instance.existingClients,
  'oneshot_clients': instance.oneshotClients,
  'oneshot_clients_all': instance.oneshotClientsAll,
  'average_transactions': instance.averageTransactions,
  'occupancy': instance.occupancy,
  'income_by_day': instance.incomeByDay,
};

_AnalyticsGlobal _$AnalyticsGlobalFromJson(Map<String, dynamic> json) =>
    _AnalyticsGlobal(
      services:
          (json['services'] as List<dynamic>?)
              ?.map(
                (e) =>
                    AnalyticsGlobalService.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      clients: json['clients'] == null
          ? const AnalyticsGlobalClients()
          : AnalyticsGlobalClients.fromJson(
              json['clients'] as Map<String, dynamic>,
            ),
      sources: json['sources'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$AnalyticsGlobalToJson(_AnalyticsGlobal instance) =>
    <String, dynamic>{
      'services': instance.services,
      'clients': instance.clients,
      'sources': instance.sources,
    };

_AnalyticsGlobalClients _$AnalyticsGlobalClientsFromJson(
  Map<String, dynamic> json,
) => _AnalyticsGlobalClients(
  averageAge: (json['average_age'] as num?)?.toDouble(),
  total: (json['total'] as num?)?.toInt() ?? 0,
  groupsMap:
      (json['groups_map'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          k,
          AnalyticsClientAgeGroup.fromJson(e as Map<String, dynamic>),
        ),
      ) ??
      const {},
);

Map<String, dynamic> _$AnalyticsGlobalClientsToJson(
  _AnalyticsGlobalClients instance,
) => <String, dynamic>{
  'average_age': instance.averageAge,
  'total': instance.total,
  'groups_map': instance.groupsMap,
};

_AnalyticsClientAgeGroup _$AnalyticsClientAgeGroupFromJson(
  Map<String, dynamic> json,
) => _AnalyticsClientAgeGroup(
  male: (json['male'] as num?)?.toInt() ?? 0,
  female: (json['female'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AnalyticsClientAgeGroupToJson(
  _AnalyticsClientAgeGroup instance,
) => <String, dynamic>{'male': instance.male, 'female': instance.female};

_AnalyticsGlobalService _$AnalyticsGlobalServiceFromJson(
  Map<String, dynamic> json,
) => _AnalyticsGlobalService(
  name: json['name'] as String?,
  service: json['service'] as String?,
  count: (json['count'] as num?)?.toInt() ?? 0,
  total: (json['total'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$AnalyticsGlobalServiceToJson(
  _AnalyticsGlobalService instance,
) => <String, dynamic>{
  'name': instance.name,
  'service': instance.service,
  'count': instance.count,
  'total': instance.total,
};

_AnalyticsSpecialist _$AnalyticsSpecialistFromJson(Map<String, dynamic> json) =>
    _AnalyticsSpecialist(
      performance: (json['performance'] as num?)?.toDouble(),
      payDue: (json['pay_due'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AnalyticsSpecialistToJson(
  _AnalyticsSpecialist instance,
) => <String, dynamic>{
  'performance': instance.performance,
  'pay_due': instance.payDue,
};

_AnalyticsBenchmarking _$AnalyticsBenchmarkingFromJson(
  Map<String, dynamic> json,
) => _AnalyticsBenchmarking(
  data: json['data'] as Map<String, dynamic>? ?? const {},
);

Map<String, dynamic> _$AnalyticsBenchmarkingToJson(
  _AnalyticsBenchmarking instance,
) => <String, dynamic>{'data': instance.data};

_AnalyticsMeta _$AnalyticsMetaFromJson(Map<String, dynamic> json) =>
    _AnalyticsMeta(
      role: (json['role'] as num?)?.toInt(),
      canSeeIncome: json['can_see_income'] as bool? ?? true,
      canSeePayDue: json['can_see_pay_due'] as bool? ?? false,
    );

Map<String, dynamic> _$AnalyticsMetaToJson(_AnalyticsMeta instance) =>
    <String, dynamic>{
      'role': instance.role,
      'can_see_income': instance.canSeeIncome,
      'can_see_pay_due': instance.canSeePayDue,
    };
