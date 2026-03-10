import 'package:freezed_annotation/freezed_annotation.dart';

part 'statistics.freezed.dart';
part 'statistics.g.dart';

@freezed
sealed class Statistics with _$Statistics {
  const factory Statistics({
    required Appointments appointments,
    @JsonKey(name: 'appointments_by_day')
    required List<AppointmentByDayItem> appointmentsByDay,
    @JsonKey(name: 'income_by_day') required List<IncomeByDay>? incomeByDay,
    required Map<String, int> services,
    @JsonKey(name: 'services_by_day')
    required List<ServiceByDayItem> servicesByDay,
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
    required int total,
    required int cancelled,
    @JsonKey(name: 'new') required int newCount,
  }) = _Appointments;

  factory Appointments.fromJson(Map<String, dynamic> json) =>
      _$AppointmentsFromJson(json);
}

@freezed
sealed class AppointmentByDayItem with _$AppointmentByDayItem {
  const factory AppointmentByDayItem({
    required String date,
    required Appointments appointments,
  }) = _AppointmentByDayItem;

  factory AppointmentByDayItem.fromJson(Map<String, dynamic> json) =>
      _$AppointmentByDayItemFromJson(json);
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

@freezed
sealed class ServiceByDayItem with _$ServiceByDayItem {
  const factory ServiceByDayItem({
    required String date,
    required Map<String, int> services,
  }) = _ServiceByDayItem;

  factory ServiceByDayItem.fromJson(Map<String, dynamic> json) =>
      _$ServiceByDayItemFromJson(json);
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
