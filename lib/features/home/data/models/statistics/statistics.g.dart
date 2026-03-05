// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Statistics _$StatisticsFromJson(Map<String, dynamic> json) => _Statistics(
  appointments: Appointments.fromJson(
    json['appointments'] as Map<String, dynamic>,
  ),
  appointmentsByDay: (json['appointments_by_day'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(
      k,
      (e as List<dynamic>)
          .map((e) => AppointmentByDay.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  ),
  incomeByDay: (json['income_by_day'] as List<dynamic>?)
      ?.map((e) => IncomeByDay.fromJson(e as Map<String, dynamic>))
      .toList(),
  services: (json['services'] as List<dynamic>)
      .map((e) => Service.fromJson(e as Map<String, dynamic>))
      .toList(),
  servicesByDay: (json['services_by_day'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(
      k,
      (e as List<dynamic>)
          .map((e) => ServiceByDay.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  ),
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
      completed: (json['completed'] as num).toInt(),
      canceled: (json['canceled'] as num).toInt(),
      stalled: (json['stalled'] as num).toInt(),
      confirmed: (json['confirmed'] as num).toInt(),
      created: (json['created'] as num).toInt(),
    );

Map<String, dynamic> _$AppointmentsToJson(_Appointments instance) =>
    <String, dynamic>{
      'completed': instance.completed,
      'canceled': instance.canceled,
      'stalled': instance.stalled,
      'confirmed': instance.confirmed,
      'created': instance.created,
    };

_AppointmentByDay _$AppointmentByDayFromJson(Map<String, dynamic> json) =>
    _AppointmentByDay(
      date: json['date'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$AppointmentByDayToJson(_AppointmentByDay instance) =>
    <String, dynamic>{'date': instance.date, 'count': instance.count};

_IncomeByDay _$IncomeByDayFromJson(Map<String, dynamic> json) => _IncomeByDay(
  date: DateTime.parse(json['date'] as String),
  income: (json['income'] as num).toDouble(),
  payDue: (json['pay_due'] as num).toDouble(),
);

Map<String, dynamic> _$IncomeByDayToJson(_IncomeByDay instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'income': instance.income,
      'pay_due': instance.payDue,
    };

_Service _$ServiceFromJson(Map<String, dynamic> json) => _Service(
  name: json['_name'] as String,
  count: (json['count'] as num).toInt(),
);

Map<String, dynamic> _$ServiceToJson(_Service instance) => <String, dynamic>{
  '_name': instance.name,
  'count': instance.count,
};

_ServiceByDay _$ServiceByDayFromJson(Map<String, dynamic> json) =>
    _ServiceByDay(
      date: json['date'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$ServiceByDayToJson(_ServiceByDay instance) =>
    <String, dynamic>{'date': instance.date, 'count': instance.count};

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
