// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'statistics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Statistics {

 Appointments get appointments;@JsonKey(name: 'appointments_by_day') List<AppointmentByDayItem> get appointmentsByDay;@JsonKey(name: 'income_by_day') List<IncomeByDay>? get incomeByDay; Map<String, int> get services;@JsonKey(name: 'services_by_day') List<ServiceByDayItem> get servicesByDay; double get occupancy;@JsonKey(name: 'occupancy_by_day') List<OccupancyByDay> get occupancyByDay;
/// Create a copy of Statistics
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatisticsCopyWith<Statistics> get copyWith => _$StatisticsCopyWithImpl<Statistics>(this as Statistics, _$identity);

  /// Serializes this Statistics to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Statistics&&(identical(other.appointments, appointments) || other.appointments == appointments)&&const DeepCollectionEquality().equals(other.appointmentsByDay, appointmentsByDay)&&const DeepCollectionEquality().equals(other.incomeByDay, incomeByDay)&&const DeepCollectionEquality().equals(other.services, services)&&const DeepCollectionEquality().equals(other.servicesByDay, servicesByDay)&&(identical(other.occupancy, occupancy) || other.occupancy == occupancy)&&const DeepCollectionEquality().equals(other.occupancyByDay, occupancyByDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,appointments,const DeepCollectionEquality().hash(appointmentsByDay),const DeepCollectionEquality().hash(incomeByDay),const DeepCollectionEquality().hash(services),const DeepCollectionEquality().hash(servicesByDay),occupancy,const DeepCollectionEquality().hash(occupancyByDay));

@override
String toString() {
  return 'Statistics(appointments: $appointments, appointmentsByDay: $appointmentsByDay, incomeByDay: $incomeByDay, services: $services, servicesByDay: $servicesByDay, occupancy: $occupancy, occupancyByDay: $occupancyByDay)';
}


}

/// @nodoc
abstract mixin class $StatisticsCopyWith<$Res>  {
  factory $StatisticsCopyWith(Statistics value, $Res Function(Statistics) _then) = _$StatisticsCopyWithImpl;
@useResult
$Res call({
 Appointments appointments,@JsonKey(name: 'appointments_by_day') List<AppointmentByDayItem> appointmentsByDay,@JsonKey(name: 'income_by_day') List<IncomeByDay>? incomeByDay, Map<String, int> services,@JsonKey(name: 'services_by_day') List<ServiceByDayItem> servicesByDay, double occupancy,@JsonKey(name: 'occupancy_by_day') List<OccupancyByDay> occupancyByDay
});


$AppointmentsCopyWith<$Res> get appointments;

}
/// @nodoc
class _$StatisticsCopyWithImpl<$Res>
    implements $StatisticsCopyWith<$Res> {
  _$StatisticsCopyWithImpl(this._self, this._then);

  final Statistics _self;
  final $Res Function(Statistics) _then;

/// Create a copy of Statistics
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? appointments = null,Object? appointmentsByDay = null,Object? incomeByDay = freezed,Object? services = null,Object? servicesByDay = null,Object? occupancy = null,Object? occupancyByDay = null,}) {
  return _then(_self.copyWith(
appointments: null == appointments ? _self.appointments : appointments // ignore: cast_nullable_to_non_nullable
as Appointments,appointmentsByDay: null == appointmentsByDay ? _self.appointmentsByDay : appointmentsByDay // ignore: cast_nullable_to_non_nullable
as List<AppointmentByDayItem>,incomeByDay: freezed == incomeByDay ? _self.incomeByDay : incomeByDay // ignore: cast_nullable_to_non_nullable
as List<IncomeByDay>?,services: null == services ? _self.services : services // ignore: cast_nullable_to_non_nullable
as Map<String, int>,servicesByDay: null == servicesByDay ? _self.servicesByDay : servicesByDay // ignore: cast_nullable_to_non_nullable
as List<ServiceByDayItem>,occupancy: null == occupancy ? _self.occupancy : occupancy // ignore: cast_nullable_to_non_nullable
as double,occupancyByDay: null == occupancyByDay ? _self.occupancyByDay : occupancyByDay // ignore: cast_nullable_to_non_nullable
as List<OccupancyByDay>,
  ));
}
/// Create a copy of Statistics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppointmentsCopyWith<$Res> get appointments {
  
  return $AppointmentsCopyWith<$Res>(_self.appointments, (value) {
    return _then(_self.copyWith(appointments: value));
  });
}
}


/// Adds pattern-matching-related methods to [Statistics].
extension StatisticsPatterns on Statistics {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Statistics value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Statistics() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Statistics value)  $default,){
final _that = this;
switch (_that) {
case _Statistics():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Statistics value)?  $default,){
final _that = this;
switch (_that) {
case _Statistics() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Appointments appointments, @JsonKey(name: 'appointments_by_day')  List<AppointmentByDayItem> appointmentsByDay, @JsonKey(name: 'income_by_day')  List<IncomeByDay>? incomeByDay,  Map<String, int> services, @JsonKey(name: 'services_by_day')  List<ServiceByDayItem> servicesByDay,  double occupancy, @JsonKey(name: 'occupancy_by_day')  List<OccupancyByDay> occupancyByDay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Statistics() when $default != null:
return $default(_that.appointments,_that.appointmentsByDay,_that.incomeByDay,_that.services,_that.servicesByDay,_that.occupancy,_that.occupancyByDay);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Appointments appointments, @JsonKey(name: 'appointments_by_day')  List<AppointmentByDayItem> appointmentsByDay, @JsonKey(name: 'income_by_day')  List<IncomeByDay>? incomeByDay,  Map<String, int> services, @JsonKey(name: 'services_by_day')  List<ServiceByDayItem> servicesByDay,  double occupancy, @JsonKey(name: 'occupancy_by_day')  List<OccupancyByDay> occupancyByDay)  $default,) {final _that = this;
switch (_that) {
case _Statistics():
return $default(_that.appointments,_that.appointmentsByDay,_that.incomeByDay,_that.services,_that.servicesByDay,_that.occupancy,_that.occupancyByDay);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Appointments appointments, @JsonKey(name: 'appointments_by_day')  List<AppointmentByDayItem> appointmentsByDay, @JsonKey(name: 'income_by_day')  List<IncomeByDay>? incomeByDay,  Map<String, int> services, @JsonKey(name: 'services_by_day')  List<ServiceByDayItem> servicesByDay,  double occupancy, @JsonKey(name: 'occupancy_by_day')  List<OccupancyByDay> occupancyByDay)?  $default,) {final _that = this;
switch (_that) {
case _Statistics() when $default != null:
return $default(_that.appointments,_that.appointmentsByDay,_that.incomeByDay,_that.services,_that.servicesByDay,_that.occupancy,_that.occupancyByDay);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Statistics extends Statistics {
  const _Statistics({required this.appointments, @JsonKey(name: 'appointments_by_day') required final  List<AppointmentByDayItem> appointmentsByDay, @JsonKey(name: 'income_by_day') required final  List<IncomeByDay>? incomeByDay, required final  Map<String, int> services, @JsonKey(name: 'services_by_day') required final  List<ServiceByDayItem> servicesByDay, required this.occupancy, @JsonKey(name: 'occupancy_by_day') required final  List<OccupancyByDay> occupancyByDay}): _appointmentsByDay = appointmentsByDay,_incomeByDay = incomeByDay,_services = services,_servicesByDay = servicesByDay,_occupancyByDay = occupancyByDay,super._();
  factory _Statistics.fromJson(Map<String, dynamic> json) => _$StatisticsFromJson(json);

@override final  Appointments appointments;
 final  List<AppointmentByDayItem> _appointmentsByDay;
@override@JsonKey(name: 'appointments_by_day') List<AppointmentByDayItem> get appointmentsByDay {
  if (_appointmentsByDay is EqualUnmodifiableListView) return _appointmentsByDay;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_appointmentsByDay);
}

 final  List<IncomeByDay>? _incomeByDay;
@override@JsonKey(name: 'income_by_day') List<IncomeByDay>? get incomeByDay {
  final value = _incomeByDay;
  if (value == null) return null;
  if (_incomeByDay is EqualUnmodifiableListView) return _incomeByDay;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  Map<String, int> _services;
@override Map<String, int> get services {
  if (_services is EqualUnmodifiableMapView) return _services;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_services);
}

 final  List<ServiceByDayItem> _servicesByDay;
@override@JsonKey(name: 'services_by_day') List<ServiceByDayItem> get servicesByDay {
  if (_servicesByDay is EqualUnmodifiableListView) return _servicesByDay;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_servicesByDay);
}

@override final  double occupancy;
 final  List<OccupancyByDay> _occupancyByDay;
@override@JsonKey(name: 'occupancy_by_day') List<OccupancyByDay> get occupancyByDay {
  if (_occupancyByDay is EqualUnmodifiableListView) return _occupancyByDay;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_occupancyByDay);
}


/// Create a copy of Statistics
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatisticsCopyWith<_Statistics> get copyWith => __$StatisticsCopyWithImpl<_Statistics>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StatisticsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Statistics&&(identical(other.appointments, appointments) || other.appointments == appointments)&&const DeepCollectionEquality().equals(other._appointmentsByDay, _appointmentsByDay)&&const DeepCollectionEquality().equals(other._incomeByDay, _incomeByDay)&&const DeepCollectionEquality().equals(other._services, _services)&&const DeepCollectionEquality().equals(other._servicesByDay, _servicesByDay)&&(identical(other.occupancy, occupancy) || other.occupancy == occupancy)&&const DeepCollectionEquality().equals(other._occupancyByDay, _occupancyByDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,appointments,const DeepCollectionEquality().hash(_appointmentsByDay),const DeepCollectionEquality().hash(_incomeByDay),const DeepCollectionEquality().hash(_services),const DeepCollectionEquality().hash(_servicesByDay),occupancy,const DeepCollectionEquality().hash(_occupancyByDay));

@override
String toString() {
  return 'Statistics(appointments: $appointments, appointmentsByDay: $appointmentsByDay, incomeByDay: $incomeByDay, services: $services, servicesByDay: $servicesByDay, occupancy: $occupancy, occupancyByDay: $occupancyByDay)';
}


}

/// @nodoc
abstract mixin class _$StatisticsCopyWith<$Res> implements $StatisticsCopyWith<$Res> {
  factory _$StatisticsCopyWith(_Statistics value, $Res Function(_Statistics) _then) = __$StatisticsCopyWithImpl;
@override @useResult
$Res call({
 Appointments appointments,@JsonKey(name: 'appointments_by_day') List<AppointmentByDayItem> appointmentsByDay,@JsonKey(name: 'income_by_day') List<IncomeByDay>? incomeByDay, Map<String, int> services,@JsonKey(name: 'services_by_day') List<ServiceByDayItem> servicesByDay, double occupancy,@JsonKey(name: 'occupancy_by_day') List<OccupancyByDay> occupancyByDay
});


@override $AppointmentsCopyWith<$Res> get appointments;

}
/// @nodoc
class __$StatisticsCopyWithImpl<$Res>
    implements _$StatisticsCopyWith<$Res> {
  __$StatisticsCopyWithImpl(this._self, this._then);

  final _Statistics _self;
  final $Res Function(_Statistics) _then;

/// Create a copy of Statistics
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? appointments = null,Object? appointmentsByDay = null,Object? incomeByDay = freezed,Object? services = null,Object? servicesByDay = null,Object? occupancy = null,Object? occupancyByDay = null,}) {
  return _then(_Statistics(
appointments: null == appointments ? _self.appointments : appointments // ignore: cast_nullable_to_non_nullable
as Appointments,appointmentsByDay: null == appointmentsByDay ? _self._appointmentsByDay : appointmentsByDay // ignore: cast_nullable_to_non_nullable
as List<AppointmentByDayItem>,incomeByDay: freezed == incomeByDay ? _self._incomeByDay : incomeByDay // ignore: cast_nullable_to_non_nullable
as List<IncomeByDay>?,services: null == services ? _self._services : services // ignore: cast_nullable_to_non_nullable
as Map<String, int>,servicesByDay: null == servicesByDay ? _self._servicesByDay : servicesByDay // ignore: cast_nullable_to_non_nullable
as List<ServiceByDayItem>,occupancy: null == occupancy ? _self.occupancy : occupancy // ignore: cast_nullable_to_non_nullable
as double,occupancyByDay: null == occupancyByDay ? _self._occupancyByDay : occupancyByDay // ignore: cast_nullable_to_non_nullable
as List<OccupancyByDay>,
  ));
}

/// Create a copy of Statistics
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppointmentsCopyWith<$Res> get appointments {
  
  return $AppointmentsCopyWith<$Res>(_self.appointments, (value) {
    return _then(_self.copyWith(appointments: value));
  });
}
}


/// @nodoc
mixin _$Appointments {

 int get total; int get cancelled;@JsonKey(name: 'new') int get newCount;
/// Create a copy of Appointments
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppointmentsCopyWith<Appointments> get copyWith => _$AppointmentsCopyWithImpl<Appointments>(this as Appointments, _$identity);

  /// Serializes this Appointments to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Appointments&&(identical(other.total, total) || other.total == total)&&(identical(other.cancelled, cancelled) || other.cancelled == cancelled)&&(identical(other.newCount, newCount) || other.newCount == newCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,cancelled,newCount);

@override
String toString() {
  return 'Appointments(total: $total, cancelled: $cancelled, newCount: $newCount)';
}


}

/// @nodoc
abstract mixin class $AppointmentsCopyWith<$Res>  {
  factory $AppointmentsCopyWith(Appointments value, $Res Function(Appointments) _then) = _$AppointmentsCopyWithImpl;
@useResult
$Res call({
 int total, int cancelled,@JsonKey(name: 'new') int newCount
});




}
/// @nodoc
class _$AppointmentsCopyWithImpl<$Res>
    implements $AppointmentsCopyWith<$Res> {
  _$AppointmentsCopyWithImpl(this._self, this._then);

  final Appointments _self;
  final $Res Function(Appointments) _then;

/// Create a copy of Appointments
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? cancelled = null,Object? newCount = null,}) {
  return _then(_self.copyWith(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,cancelled: null == cancelled ? _self.cancelled : cancelled // ignore: cast_nullable_to_non_nullable
as int,newCount: null == newCount ? _self.newCount : newCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Appointments].
extension AppointmentsPatterns on Appointments {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Appointments value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Appointments() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Appointments value)  $default,){
final _that = this;
switch (_that) {
case _Appointments():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Appointments value)?  $default,){
final _that = this;
switch (_that) {
case _Appointments() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  int cancelled, @JsonKey(name: 'new')  int newCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Appointments() when $default != null:
return $default(_that.total,_that.cancelled,_that.newCount);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  int cancelled, @JsonKey(name: 'new')  int newCount)  $default,) {final _that = this;
switch (_that) {
case _Appointments():
return $default(_that.total,_that.cancelled,_that.newCount);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  int cancelled, @JsonKey(name: 'new')  int newCount)?  $default,) {final _that = this;
switch (_that) {
case _Appointments() when $default != null:
return $default(_that.total,_that.cancelled,_that.newCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Appointments implements Appointments {
  const _Appointments({required this.total, required this.cancelled, @JsonKey(name: 'new') required this.newCount});
  factory _Appointments.fromJson(Map<String, dynamic> json) => _$AppointmentsFromJson(json);

@override final  int total;
@override final  int cancelled;
@override@JsonKey(name: 'new') final  int newCount;

/// Create a copy of Appointments
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppointmentsCopyWith<_Appointments> get copyWith => __$AppointmentsCopyWithImpl<_Appointments>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppointmentsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Appointments&&(identical(other.total, total) || other.total == total)&&(identical(other.cancelled, cancelled) || other.cancelled == cancelled)&&(identical(other.newCount, newCount) || other.newCount == newCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,cancelled,newCount);

@override
String toString() {
  return 'Appointments(total: $total, cancelled: $cancelled, newCount: $newCount)';
}


}

/// @nodoc
abstract mixin class _$AppointmentsCopyWith<$Res> implements $AppointmentsCopyWith<$Res> {
  factory _$AppointmentsCopyWith(_Appointments value, $Res Function(_Appointments) _then) = __$AppointmentsCopyWithImpl;
@override @useResult
$Res call({
 int total, int cancelled,@JsonKey(name: 'new') int newCount
});




}
/// @nodoc
class __$AppointmentsCopyWithImpl<$Res>
    implements _$AppointmentsCopyWith<$Res> {
  __$AppointmentsCopyWithImpl(this._self, this._then);

  final _Appointments _self;
  final $Res Function(_Appointments) _then;

/// Create a copy of Appointments
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? cancelled = null,Object? newCount = null,}) {
  return _then(_Appointments(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,cancelled: null == cancelled ? _self.cancelled : cancelled // ignore: cast_nullable_to_non_nullable
as int,newCount: null == newCount ? _self.newCount : newCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AppointmentByDayItem {

 String get date; Appointments get appointments;
/// Create a copy of AppointmentByDayItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppointmentByDayItemCopyWith<AppointmentByDayItem> get copyWith => _$AppointmentByDayItemCopyWithImpl<AppointmentByDayItem>(this as AppointmentByDayItem, _$identity);

  /// Serializes this AppointmentByDayItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppointmentByDayItem&&(identical(other.date, date) || other.date == date)&&(identical(other.appointments, appointments) || other.appointments == appointments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,appointments);

@override
String toString() {
  return 'AppointmentByDayItem(date: $date, appointments: $appointments)';
}


}

/// @nodoc
abstract mixin class $AppointmentByDayItemCopyWith<$Res>  {
  factory $AppointmentByDayItemCopyWith(AppointmentByDayItem value, $Res Function(AppointmentByDayItem) _then) = _$AppointmentByDayItemCopyWithImpl;
@useResult
$Res call({
 String date, Appointments appointments
});


$AppointmentsCopyWith<$Res> get appointments;

}
/// @nodoc
class _$AppointmentByDayItemCopyWithImpl<$Res>
    implements $AppointmentByDayItemCopyWith<$Res> {
  _$AppointmentByDayItemCopyWithImpl(this._self, this._then);

  final AppointmentByDayItem _self;
  final $Res Function(AppointmentByDayItem) _then;

/// Create a copy of AppointmentByDayItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? appointments = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,appointments: null == appointments ? _self.appointments : appointments // ignore: cast_nullable_to_non_nullable
as Appointments,
  ));
}
/// Create a copy of AppointmentByDayItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppointmentsCopyWith<$Res> get appointments {
  
  return $AppointmentsCopyWith<$Res>(_self.appointments, (value) {
    return _then(_self.copyWith(appointments: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppointmentByDayItem].
extension AppointmentByDayItemPatterns on AppointmentByDayItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppointmentByDayItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppointmentByDayItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppointmentByDayItem value)  $default,){
final _that = this;
switch (_that) {
case _AppointmentByDayItem():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppointmentByDayItem value)?  $default,){
final _that = this;
switch (_that) {
case _AppointmentByDayItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  Appointments appointments)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppointmentByDayItem() when $default != null:
return $default(_that.date,_that.appointments);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  Appointments appointments)  $default,) {final _that = this;
switch (_that) {
case _AppointmentByDayItem():
return $default(_that.date,_that.appointments);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  Appointments appointments)?  $default,) {final _that = this;
switch (_that) {
case _AppointmentByDayItem() when $default != null:
return $default(_that.date,_that.appointments);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppointmentByDayItem implements AppointmentByDayItem {
  const _AppointmentByDayItem({required this.date, required this.appointments});
  factory _AppointmentByDayItem.fromJson(Map<String, dynamic> json) => _$AppointmentByDayItemFromJson(json);

@override final  String date;
@override final  Appointments appointments;

/// Create a copy of AppointmentByDayItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppointmentByDayItemCopyWith<_AppointmentByDayItem> get copyWith => __$AppointmentByDayItemCopyWithImpl<_AppointmentByDayItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppointmentByDayItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppointmentByDayItem&&(identical(other.date, date) || other.date == date)&&(identical(other.appointments, appointments) || other.appointments == appointments));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,appointments);

@override
String toString() {
  return 'AppointmentByDayItem(date: $date, appointments: $appointments)';
}


}

/// @nodoc
abstract mixin class _$AppointmentByDayItemCopyWith<$Res> implements $AppointmentByDayItemCopyWith<$Res> {
  factory _$AppointmentByDayItemCopyWith(_AppointmentByDayItem value, $Res Function(_AppointmentByDayItem) _then) = __$AppointmentByDayItemCopyWithImpl;
@override @useResult
$Res call({
 String date, Appointments appointments
});


@override $AppointmentsCopyWith<$Res> get appointments;

}
/// @nodoc
class __$AppointmentByDayItemCopyWithImpl<$Res>
    implements _$AppointmentByDayItemCopyWith<$Res> {
  __$AppointmentByDayItemCopyWithImpl(this._self, this._then);

  final _AppointmentByDayItem _self;
  final $Res Function(_AppointmentByDayItem) _then;

/// Create a copy of AppointmentByDayItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? appointments = null,}) {
  return _then(_AppointmentByDayItem(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,appointments: null == appointments ? _self.appointments : appointments // ignore: cast_nullable_to_non_nullable
as Appointments,
  ));
}

/// Create a copy of AppointmentByDayItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppointmentsCopyWith<$Res> get appointments {
  
  return $AppointmentsCopyWith<$Res>(_self.appointments, (value) {
    return _then(_self.copyWith(appointments: value));
  });
}
}


/// @nodoc
mixin _$IncomeByDay {

 DateTime get date; double get income;@JsonKey(name: 'pay_due') double get payDue;
/// Create a copy of IncomeByDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IncomeByDayCopyWith<IncomeByDay> get copyWith => _$IncomeByDayCopyWithImpl<IncomeByDay>(this as IncomeByDay, _$identity);

  /// Serializes this IncomeByDay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IncomeByDay&&(identical(other.date, date) || other.date == date)&&(identical(other.income, income) || other.income == income)&&(identical(other.payDue, payDue) || other.payDue == payDue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,income,payDue);

@override
String toString() {
  return 'IncomeByDay(date: $date, income: $income, payDue: $payDue)';
}


}

/// @nodoc
abstract mixin class $IncomeByDayCopyWith<$Res>  {
  factory $IncomeByDayCopyWith(IncomeByDay value, $Res Function(IncomeByDay) _then) = _$IncomeByDayCopyWithImpl;
@useResult
$Res call({
 DateTime date, double income,@JsonKey(name: 'pay_due') double payDue
});




}
/// @nodoc
class _$IncomeByDayCopyWithImpl<$Res>
    implements $IncomeByDayCopyWith<$Res> {
  _$IncomeByDayCopyWithImpl(this._self, this._then);

  final IncomeByDay _self;
  final $Res Function(IncomeByDay) _then;

/// Create a copy of IncomeByDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? income = null,Object? payDue = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as double,payDue: null == payDue ? _self.payDue : payDue // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [IncomeByDay].
extension IncomeByDayPatterns on IncomeByDay {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IncomeByDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IncomeByDay() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IncomeByDay value)  $default,){
final _that = this;
switch (_that) {
case _IncomeByDay():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IncomeByDay value)?  $default,){
final _that = this;
switch (_that) {
case _IncomeByDay() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  double income, @JsonKey(name: 'pay_due')  double payDue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IncomeByDay() when $default != null:
return $default(_that.date,_that.income,_that.payDue);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  double income, @JsonKey(name: 'pay_due')  double payDue)  $default,) {final _that = this;
switch (_that) {
case _IncomeByDay():
return $default(_that.date,_that.income,_that.payDue);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  double income, @JsonKey(name: 'pay_due')  double payDue)?  $default,) {final _that = this;
switch (_that) {
case _IncomeByDay() when $default != null:
return $default(_that.date,_that.income,_that.payDue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IncomeByDay implements IncomeByDay {
  const _IncomeByDay({required this.date, required this.income, @JsonKey(name: 'pay_due') required this.payDue});
  factory _IncomeByDay.fromJson(Map<String, dynamic> json) => _$IncomeByDayFromJson(json);

@override final  DateTime date;
@override final  double income;
@override@JsonKey(name: 'pay_due') final  double payDue;

/// Create a copy of IncomeByDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IncomeByDayCopyWith<_IncomeByDay> get copyWith => __$IncomeByDayCopyWithImpl<_IncomeByDay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IncomeByDayToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IncomeByDay&&(identical(other.date, date) || other.date == date)&&(identical(other.income, income) || other.income == income)&&(identical(other.payDue, payDue) || other.payDue == payDue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,income,payDue);

@override
String toString() {
  return 'IncomeByDay(date: $date, income: $income, payDue: $payDue)';
}


}

/// @nodoc
abstract mixin class _$IncomeByDayCopyWith<$Res> implements $IncomeByDayCopyWith<$Res> {
  factory _$IncomeByDayCopyWith(_IncomeByDay value, $Res Function(_IncomeByDay) _then) = __$IncomeByDayCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, double income,@JsonKey(name: 'pay_due') double payDue
});




}
/// @nodoc
class __$IncomeByDayCopyWithImpl<$Res>
    implements _$IncomeByDayCopyWith<$Res> {
  __$IncomeByDayCopyWithImpl(this._self, this._then);

  final _IncomeByDay _self;
  final $Res Function(_IncomeByDay) _then;

/// Create a copy of IncomeByDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? income = null,Object? payDue = null,}) {
  return _then(_IncomeByDay(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,income: null == income ? _self.income : income // ignore: cast_nullable_to_non_nullable
as double,payDue: null == payDue ? _self.payDue : payDue // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$ServiceByDayItem {

 String get date; Map<String, int> get services;
/// Create a copy of ServiceByDayItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceByDayItemCopyWith<ServiceByDayItem> get copyWith => _$ServiceByDayItemCopyWithImpl<ServiceByDayItem>(this as ServiceByDayItem, _$identity);

  /// Serializes this ServiceByDayItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceByDayItem&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other.services, services));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,const DeepCollectionEquality().hash(services));

@override
String toString() {
  return 'ServiceByDayItem(date: $date, services: $services)';
}


}

/// @nodoc
abstract mixin class $ServiceByDayItemCopyWith<$Res>  {
  factory $ServiceByDayItemCopyWith(ServiceByDayItem value, $Res Function(ServiceByDayItem) _then) = _$ServiceByDayItemCopyWithImpl;
@useResult
$Res call({
 String date, Map<String, int> services
});




}
/// @nodoc
class _$ServiceByDayItemCopyWithImpl<$Res>
    implements $ServiceByDayItemCopyWith<$Res> {
  _$ServiceByDayItemCopyWithImpl(this._self, this._then);

  final ServiceByDayItem _self;
  final $Res Function(ServiceByDayItem) _then;

/// Create a copy of ServiceByDayItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? services = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,services: null == services ? _self.services : services // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}

}


/// Adds pattern-matching-related methods to [ServiceByDayItem].
extension ServiceByDayItemPatterns on ServiceByDayItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServiceByDayItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServiceByDayItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServiceByDayItem value)  $default,){
final _that = this;
switch (_that) {
case _ServiceByDayItem():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServiceByDayItem value)?  $default,){
final _that = this;
switch (_that) {
case _ServiceByDayItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  Map<String, int> services)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServiceByDayItem() when $default != null:
return $default(_that.date,_that.services);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  Map<String, int> services)  $default,) {final _that = this;
switch (_that) {
case _ServiceByDayItem():
return $default(_that.date,_that.services);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  Map<String, int> services)?  $default,) {final _that = this;
switch (_that) {
case _ServiceByDayItem() when $default != null:
return $default(_that.date,_that.services);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServiceByDayItem implements ServiceByDayItem {
  const _ServiceByDayItem({required this.date, required final  Map<String, int> services}): _services = services;
  factory _ServiceByDayItem.fromJson(Map<String, dynamic> json) => _$ServiceByDayItemFromJson(json);

@override final  String date;
 final  Map<String, int> _services;
@override Map<String, int> get services {
  if (_services is EqualUnmodifiableMapView) return _services;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_services);
}


/// Create a copy of ServiceByDayItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceByDayItemCopyWith<_ServiceByDayItem> get copyWith => __$ServiceByDayItemCopyWithImpl<_ServiceByDayItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServiceByDayItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServiceByDayItem&&(identical(other.date, date) || other.date == date)&&const DeepCollectionEquality().equals(other._services, _services));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,const DeepCollectionEquality().hash(_services));

@override
String toString() {
  return 'ServiceByDayItem(date: $date, services: $services)';
}


}

/// @nodoc
abstract mixin class _$ServiceByDayItemCopyWith<$Res> implements $ServiceByDayItemCopyWith<$Res> {
  factory _$ServiceByDayItemCopyWith(_ServiceByDayItem value, $Res Function(_ServiceByDayItem) _then) = __$ServiceByDayItemCopyWithImpl;
@override @useResult
$Res call({
 String date, Map<String, int> services
});




}
/// @nodoc
class __$ServiceByDayItemCopyWithImpl<$Res>
    implements _$ServiceByDayItemCopyWith<$Res> {
  __$ServiceByDayItemCopyWithImpl(this._self, this._then);

  final _ServiceByDayItem _self;
  final $Res Function(_ServiceByDayItem) _then;

/// Create a copy of ServiceByDayItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? services = null,}) {
  return _then(_ServiceByDayItem(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,services: null == services ? _self._services : services // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}


}


/// @nodoc
mixin _$OccupancyByDay {

 DateTime get date; double get occupancy;
/// Create a copy of OccupancyByDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OccupancyByDayCopyWith<OccupancyByDay> get copyWith => _$OccupancyByDayCopyWithImpl<OccupancyByDay>(this as OccupancyByDay, _$identity);

  /// Serializes this OccupancyByDay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OccupancyByDay&&(identical(other.date, date) || other.date == date)&&(identical(other.occupancy, occupancy) || other.occupancy == occupancy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,occupancy);

@override
String toString() {
  return 'OccupancyByDay(date: $date, occupancy: $occupancy)';
}


}

/// @nodoc
abstract mixin class $OccupancyByDayCopyWith<$Res>  {
  factory $OccupancyByDayCopyWith(OccupancyByDay value, $Res Function(OccupancyByDay) _then) = _$OccupancyByDayCopyWithImpl;
@useResult
$Res call({
 DateTime date, double occupancy
});




}
/// @nodoc
class _$OccupancyByDayCopyWithImpl<$Res>
    implements $OccupancyByDayCopyWith<$Res> {
  _$OccupancyByDayCopyWithImpl(this._self, this._then);

  final OccupancyByDay _self;
  final $Res Function(OccupancyByDay) _then;

/// Create a copy of OccupancyByDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? occupancy = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,occupancy: null == occupancy ? _self.occupancy : occupancy // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [OccupancyByDay].
extension OccupancyByDayPatterns on OccupancyByDay {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OccupancyByDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OccupancyByDay() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OccupancyByDay value)  $default,){
final _that = this;
switch (_that) {
case _OccupancyByDay():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OccupancyByDay value)?  $default,){
final _that = this;
switch (_that) {
case _OccupancyByDay() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  double occupancy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OccupancyByDay() when $default != null:
return $default(_that.date,_that.occupancy);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  double occupancy)  $default,) {final _that = this;
switch (_that) {
case _OccupancyByDay():
return $default(_that.date,_that.occupancy);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  double occupancy)?  $default,) {final _that = this;
switch (_that) {
case _OccupancyByDay() when $default != null:
return $default(_that.date,_that.occupancy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OccupancyByDay implements OccupancyByDay {
  const _OccupancyByDay({required this.date, required this.occupancy});
  factory _OccupancyByDay.fromJson(Map<String, dynamic> json) => _$OccupancyByDayFromJson(json);

@override final  DateTime date;
@override final  double occupancy;

/// Create a copy of OccupancyByDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OccupancyByDayCopyWith<_OccupancyByDay> get copyWith => __$OccupancyByDayCopyWithImpl<_OccupancyByDay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OccupancyByDayToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OccupancyByDay&&(identical(other.date, date) || other.date == date)&&(identical(other.occupancy, occupancy) || other.occupancy == occupancy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,occupancy);

@override
String toString() {
  return 'OccupancyByDay(date: $date, occupancy: $occupancy)';
}


}

/// @nodoc
abstract mixin class _$OccupancyByDayCopyWith<$Res> implements $OccupancyByDayCopyWith<$Res> {
  factory _$OccupancyByDayCopyWith(_OccupancyByDay value, $Res Function(_OccupancyByDay) _then) = __$OccupancyByDayCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, double occupancy
});




}
/// @nodoc
class __$OccupancyByDayCopyWithImpl<$Res>
    implements _$OccupancyByDayCopyWith<$Res> {
  __$OccupancyByDayCopyWithImpl(this._self, this._then);

  final _OccupancyByDay _self;
  final $Res Function(_OccupancyByDay) _then;

/// Create a copy of OccupancyByDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? occupancy = null,}) {
  return _then(_OccupancyByDay(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,occupancy: null == occupancy ? _self.occupancy : occupancy // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
