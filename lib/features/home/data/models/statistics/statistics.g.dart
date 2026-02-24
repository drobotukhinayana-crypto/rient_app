// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Statistics _$StatisticsFromJson(Map<String, dynamic> json) => _Statistics(
  appointments: Appointments.fromJson(
    json['appointments'] as Map<String, dynamic>,
  ),
  appointmentsByDay: (json['appointmentsByDay'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(
      k,
      (e as List<dynamic>)
          .map((e) => AppointmentByDay.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  ),
  incomeByDay: (json['incomeByDay'] as List<dynamic>)
      .map((e) => IncomeByDay.fromJson(e as Map<String, dynamic>))
      .toList(),
  services: (json['services'] as List<dynamic>)
      .map((e) => Service.fromJson(e as Map<String, dynamic>))
      .toList(),
  servicesByDay: (json['servicesByDay'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(
      k,
      (e as List<dynamic>)
          .map((e) => ServiceByDay.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  ),
  occupancy: (json['occupancy'] as num).toDouble(),
  occupancyByDay: (json['occupancyByDay'] as List<dynamic>)
      .map((e) => OccupancyByDay.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$StatisticsToJson(_Statistics instance) =>
    <String, dynamic>{
      'appointments': instance.appointments,
      'appointmentsByDay': instance.appointmentsByDay,
      'incomeByDay': instance.incomeByDay,
      'services': instance.services,
      'servicesByDay': instance.servicesByDay,
      'occupancy': instance.occupancy,
      'occupancyByDay': instance.occupancyByDay,
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
  date: json['date'] as String,
  income: (json['income'] as num).toDouble(),
  payDue: (json['pay_due'] as num).toDouble(),
);

Map<String, dynamic> _$IncomeByDayToJson(_IncomeByDay instance) =>
    <String, dynamic>{
      'date': instance.date,
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
      date: json['date'] as String,
      occupancy: (json['occupancy'] as num).toDouble(),
    );

Map<String, dynamic> _$OccupancyByDayToJson(_OccupancyByDay instance) =>
    <String, dynamic>{'date': instance.date, 'occupancy': instance.occupancy};
