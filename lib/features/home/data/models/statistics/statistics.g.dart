// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Statistics _$StatisticsFromJson(Map<String, dynamic> json) => _Statistics(
  appointments: Appointments.fromJson(
    json['appointments'] as Map<String, dynamic>,
  ),
  appointmentsByDay: (json['appointments_by_day'] as List<dynamic>)
      .map((e) => AppointmentByDayItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  incomeByDay: (json['income_by_day'] as List<dynamic>?)
      ?.map((e) => IncomeByDay.fromJson(e as Map<String, dynamic>))
      .toList(),
  services: Map<String, int>.from(json['services'] as Map),
  servicesByDay: (json['services_by_day'] as List<dynamic>)
      .map((e) => ServiceByDayItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  occupancy: (json['occupancy'] as num).toDouble(),
  occupancyByDay: (json['occupancy_by_day'] as List<dynamic>)
      .map((e) => OccupancyByDay.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$StatisticsToJson(_Statistics instance) =>
    <String, dynamic>{
      'appointments': instance.appointments,
      'appointments_by_day': instance.appointmentsByDay,
      'income_by_day': instance.incomeByDay,
      'services': instance.services,
      'services_by_day': instance.servicesByDay,
      'occupancy': instance.occupancy,
      'occupancy_by_day': instance.occupancyByDay,
    };

_Appointments _$AppointmentsFromJson(Map<String, dynamic> json) =>
    _Appointments(
      total: (json['total'] as num).toInt(),
      cancelled: (json['cancelled'] as num).toInt(),
      newCount: (json['new'] as num).toInt(),
    );

Map<String, dynamic> _$AppointmentsToJson(_Appointments instance) =>
    <String, dynamic>{
      'total': instance.total,
      'cancelled': instance.cancelled,
      'new': instance.newCount,
    };

_AppointmentByDayItem _$AppointmentByDayItemFromJson(
  Map<String, dynamic> json,
) => _AppointmentByDayItem(
  date: json['date'] as String,
  appointments: Appointments.fromJson(
    json['appointments'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$AppointmentByDayItemToJson(
  _AppointmentByDayItem instance,
) => <String, dynamic>{
  'date': instance.date,
  'appointments': instance.appointments,
};

_IncomeByDay _$IncomeByDayFromJson(Map<String, dynamic> json) => _IncomeByDay(
  date: DateTime.parse(json['date'] as String),
  income: (json['income'] as num).toDouble(),
  payDue: (json['pay_due'] as num).toDouble(),
  projectedIncome: (json['projected_income'] as num?)?.toDouble(),
  factualIncome: (json['factual_income'] as num?)?.toDouble(),
  averageCheck: (json['average_check'] as num?)?.toDouble(),
);

Map<String, dynamic> _$IncomeByDayToJson(_IncomeByDay instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'income': instance.income,
      'pay_due': instance.payDue,
      'projected_income': instance.projectedIncome,
      'factual_income': instance.factualIncome,
      'average_check': instance.averageCheck,
    };

_ServiceByDayItem _$ServiceByDayItemFromJson(Map<String, dynamic> json) =>
    _ServiceByDayItem(
      date: json['date'] as String,
      services: Map<String, int>.from(json['services'] as Map),
    );

Map<String, dynamic> _$ServiceByDayItemToJson(_ServiceByDayItem instance) =>
    <String, dynamic>{'date': instance.date, 'services': instance.services};

_OccupancyByDay _$OccupancyByDayFromJson(Map<String, dynamic> json) =>
    _OccupancyByDay(
      date: DateTime.parse(json['date'] as String),
      occupancy: (json['occupancy'] as num).toDouble(),
    );

Map<String, dynamic> _$OccupancyByDayToJson(_OccupancyByDay instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'occupancy': instance.occupancy,
    };
