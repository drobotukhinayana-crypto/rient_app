import 'package:freezed_annotation/freezed_annotation.dart';

part 'statistics.freezed.dart';
part 'statistics.g.dart';

@freezed
sealed class Statistics with _$Statistics {
  const factory Statistics({
    required Appointments appointments,
    @JsonKey(name: 'appointments_by_day')
    required Map<String, List<AppointmentByDay>> appointmentsByDay,
    @JsonKey(name: 'income_by_day') required List<IncomeByDay>? incomeByDay,
    required List<Service> services,
    @JsonKey(name: 'services_by_day')
    required Map<String, List<ServiceByDay>> servicesByDay,
    required double occupancy,
    @JsonKey(name: 'occupancy_by_day')
    required List<OccupancyByDay> occupancyByDay,
  }) = _Statistics;

  const Statistics._();

  factory Statistics.fromJson(Map<String, dynamic> json) =>
      _$StatisticsFromJson(json);
}

@freezed
sealed class Appointments with _$Appointments {
  const factory Appointments({
    required int completed,
    required int canceled,
    required int stalled,
    required int confirmed,
    required int created,
  }) = _Appointments;

  factory Appointments.fromJson(Map<String, dynamic> json) =>
      _$AppointmentsFromJson(json);
}

@freezed
sealed class AppointmentByDay with _$AppointmentByDay {
  const factory AppointmentByDay({required String date, required int count}) =
      _AppointmentByDay;

  factory AppointmentByDay.fromJson(Map<String, dynamic> json) =>
      _$AppointmentByDayFromJson(json);
}

@freezed
sealed class IncomeByDay with _$IncomeByDay {
  const factory IncomeByDay({
    required DateTime date,
    required double income,
    @JsonKey(name: 'pay_due') required double payDue,
  }) = _IncomeByDay;

  factory IncomeByDay.fromJson(Map<String, dynamic> json) =>
      _$IncomeByDayFromJson(json);
}

extension IncomeByDayX on IncomeByDay {
  @JsonKey(name: 'pay_due')
  double get payDue => this.payDue;
}

@freezed
sealed class Service with _$Service {
  const factory Service({
    @JsonKey(name: '_name') required String name,
    required int count,
  }) = _Service;

  factory Service.fromJson(Map<String, dynamic> json) =>
      _$ServiceFromJson(json);
}

@freezed
sealed class ServiceByDay with _$ServiceByDay {
  const factory ServiceByDay({required String date, required int count}) =
      _ServiceByDay;

  factory ServiceByDay.fromJson(Map<String, dynamic> json) =>
      _$ServiceByDayFromJson(json);
}

@freezed
sealed class OccupancyByDay with _$OccupancyByDay {
  const factory OccupancyByDay({
    required DateTime date,
    required double occupancy,
  }) = _OccupancyByDay;

  factory OccupancyByDay.fromJson(Map<String, dynamic> json) =>
      _$OccupancyByDayFromJson(json);
}
