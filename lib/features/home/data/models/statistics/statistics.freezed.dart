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

 Appointments get appointments;@JsonKey(name: 'appointments_by_day') Map<String, List<AppointmentByDay>> get appointmentsByDay;@JsonKey(name: 'income_by_day') List<IncomeByDay>? get incomeByDay; List<Service> get services;@JsonKey(name: 'services_by_day') Map<String, List<ServiceByDay>> get servicesByDay; double get occupancy;@JsonKey(name: 'occupancy_by_day') List<OccupancyByDay> get occupancyByDay;
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
 Appointments appointments,@JsonKey(name: 'appointments_by_day') Map<String, List<AppointmentByDay>> appointmentsByDay,@JsonKey(name: 'income_by_day') List<IncomeByDay>? incomeByDay, List<Service> services,@JsonKey(name: 'services_by_day') Map<String, List<ServiceByDay>> servicesByDay, double occupancy,@JsonKey(name: 'occupancy_by_day') List<OccupancyByDay> occupancyByDay
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
as Map<String, List<AppointmentByDay>>,incomeByDay: freezed == incomeByDay ? _self.incomeByDay : incomeByDay // ignore: cast_nullable_to_non_nullable
as List<IncomeByDay>?,services: null == services ? _self.services : services // ignore: cast_nullable_to_non_nullable
as List<Service>,servicesByDay: null == servicesByDay ? _self.servicesByDay : servicesByDay // ignore: cast_nullable_to_non_nullable
as Map<String, List<ServiceByDay>>,occupancy: null == occupancy ? _self.occupancy : occupancy // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Appointments appointments, @JsonKey(name: 'appointments_by_day')  Map<String, List<AppointmentByDay>> appointmentsByDay, @JsonKey(name: 'income_by_day')  List<IncomeByDay>? incomeByDay,  List<Service> services, @JsonKey(name: 'services_by_day')  Map<String, List<ServiceByDay>> servicesByDay,  double occupancy, @JsonKey(name: 'occupancy_by_day')  List<OccupancyByDay> occupancyByDay)?  $default,{required TResult orElse(),}) {final _that = this;
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Appointments appointments, @JsonKey(name: 'appointments_by_day')  Map<String, List<AppointmentByDay>> appointmentsByDay, @JsonKey(name: 'income_by_day')  List<IncomeByDay>? incomeByDay,  List<Service> services, @JsonKey(name: 'services_by_day')  Map<String, List<ServiceByDay>> servicesByDay,  double occupancy, @JsonKey(name: 'occupancy_by_day')  List<OccupancyByDay> occupancyByDay)  $default,) {final _that = this;
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Appointments appointments, @JsonKey(name: 'appointments_by_day')  Map<String, List<AppointmentByDay>> appointmentsByDay, @JsonKey(name: 'income_by_day')  List<IncomeByDay>? incomeByDay,  List<Service> services, @JsonKey(name: 'services_by_day')  Map<String, List<ServiceByDay>> servicesByDay,  double occupancy, @JsonKey(name: 'occupancy_by_day')  List<OccupancyByDay> occupancyByDay)?  $default,) {final _that = this;
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
  const _Statistics({required this.appointments, @JsonKey(name: 'appointments_by_day') required final  Map<String, List<AppointmentByDay>> appointmentsByDay, @JsonKey(name: 'income_by_day') required final  List<IncomeByDay>? incomeByDay, required final  List<Service> services, @JsonKey(name: 'services_by_day') required final  Map<String, List<ServiceByDay>> servicesByDay, required this.occupancy, @JsonKey(name: 'occupancy_by_day') required final  List<OccupancyByDay> occupancyByDay}): _appointmentsByDay = appointmentsByDay,_incomeByDay = incomeByDay,_services = services,_servicesByDay = servicesByDay,_occupancyByDay = occupancyByDay,super._();
  factory _Statistics.fromJson(Map<String, dynamic> json) => _$StatisticsFromJson(json);

@override final  Appointments appointments;
 final  Map<String, List<AppointmentByDay>> _appointmentsByDay;
@override@JsonKey(name: 'appointments_by_day') Map<String, List<AppointmentByDay>> get appointmentsByDay {
  if (_appointmentsByDay is EqualUnmodifiableMapView) return _appointmentsByDay;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_appointmentsByDay);
}

 final  List<IncomeByDay>? _incomeByDay;
@override@JsonKey(name: 'income_by_day') List<IncomeByDay>? get incomeByDay {
  final value = _incomeByDay;
  if (value == null) return null;
  if (_incomeByDay is EqualUnmodifiableListView) return _incomeByDay;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Service> _services;
@override List<Service> get services {
  if (_services is EqualUnmodifiableListView) return _services;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_services);
}

 final  Map<String, List<ServiceByDay>> _servicesByDay;
@override@JsonKey(name: 'services_by_day') Map<String, List<ServiceByDay>> get servicesByDay {
  if (_servicesByDay is EqualUnmodifiableMapView) return _servicesByDay;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_servicesByDay);
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
 Appointments appointments,@JsonKey(name: 'appointments_by_day') Map<String, List<AppointmentByDay>> appointmentsByDay,@JsonKey(name: 'income_by_day') List<IncomeByDay>? incomeByDay, List<Service> services,@JsonKey(name: 'services_by_day') Map<String, List<ServiceByDay>> servicesByDay, double occupancy,@JsonKey(name: 'occupancy_by_day') List<OccupancyByDay> occupancyByDay
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
as Map<String, List<AppointmentByDay>>,incomeByDay: freezed == incomeByDay ? _self._incomeByDay : incomeByDay // ignore: cast_nullable_to_non_nullable
as List<IncomeByDay>?,services: null == services ? _self._services : services // ignore: cast_nullable_to_non_nullable
as List<Service>,servicesByDay: null == servicesByDay ? _self._servicesByDay : servicesByDay // ignore: cast_nullable_to_non_nullable
as Map<String, List<ServiceByDay>>,occupancy: null == occupancy ? _self.occupancy : occupancy // ignore: cast_nullable_to_non_nullable
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

 int get completed; int get canceled; int get stalled; int get confirmed; int get created;
/// Create a copy of Appointments
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppointmentsCopyWith<Appointments> get copyWith => _$AppointmentsCopyWithImpl<Appointments>(this as Appointments, _$identity);

  /// Serializes this Appointments to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Appointments&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.canceled, canceled) || other.canceled == canceled)&&(identical(other.stalled, stalled) || other.stalled == stalled)&&(identical(other.confirmed, confirmed) || other.confirmed == confirmed)&&(identical(other.created, created) || other.created == created));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,completed,canceled,stalled,confirmed,created);

@override
String toString() {
  return 'Appointments(completed: $completed, canceled: $canceled, stalled: $stalled, confirmed: $confirmed, created: $created)';
}


}

/// @nodoc
abstract mixin class $AppointmentsCopyWith<$Res>  {
  factory $AppointmentsCopyWith(Appointments value, $Res Function(Appointments) _then) = _$AppointmentsCopyWithImpl;
@useResult
$Res call({
 int completed, int canceled, int stalled, int confirmed, int created
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
@pragma('vm:prefer-inline') @override $Res call({Object? completed = null,Object? canceled = null,Object? stalled = null,Object? confirmed = null,Object? created = null,}) {
  return _then(_self.copyWith(
completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as int,canceled: null == canceled ? _self.canceled : canceled // ignore: cast_nullable_to_non_nullable
as int,stalled: null == stalled ? _self.stalled : stalled // ignore: cast_nullable_to_non_nullable
as int,confirmed: null == confirmed ? _self.confirmed : confirmed // ignore: cast_nullable_to_non_nullable
as int,created: null == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int completed,  int canceled,  int stalled,  int confirmed,  int created)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Appointments() when $default != null:
return $default(_that.completed,_that.canceled,_that.stalled,_that.confirmed,_that.created);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int completed,  int canceled,  int stalled,  int confirmed,  int created)  $default,) {final _that = this;
switch (_that) {
case _Appointments():
return $default(_that.completed,_that.canceled,_that.stalled,_that.confirmed,_that.created);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int completed,  int canceled,  int stalled,  int confirmed,  int created)?  $default,) {final _that = this;
switch (_that) {
case _Appointments() when $default != null:
return $default(_that.completed,_that.canceled,_that.stalled,_that.confirmed,_that.created);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Appointments implements Appointments {
  const _Appointments({required this.completed, required this.canceled, required this.stalled, required this.confirmed, required this.created});
  factory _Appointments.fromJson(Map<String, dynamic> json) => _$AppointmentsFromJson(json);

@override final  int completed;
@override final  int canceled;
@override final  int stalled;
@override final  int confirmed;
@override final  int created;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Appointments&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.canceled, canceled) || other.canceled == canceled)&&(identical(other.stalled, stalled) || other.stalled == stalled)&&(identical(other.confirmed, confirmed) || other.confirmed == confirmed)&&(identical(other.created, created) || other.created == created));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,completed,canceled,stalled,confirmed,created);

@override
String toString() {
  return 'Appointments(completed: $completed, canceled: $canceled, stalled: $stalled, confirmed: $confirmed, created: $created)';
}


}

/// @nodoc
abstract mixin class _$AppointmentsCopyWith<$Res> implements $AppointmentsCopyWith<$Res> {
  factory _$AppointmentsCopyWith(_Appointments value, $Res Function(_Appointments) _then) = __$AppointmentsCopyWithImpl;
@override @useResult
$Res call({
 int completed, int canceled, int stalled, int confirmed, int created
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
@override @pragma('vm:prefer-inline') $Res call({Object? completed = null,Object? canceled = null,Object? stalled = null,Object? confirmed = null,Object? created = null,}) {
  return _then(_Appointments(
completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as int,canceled: null == canceled ? _self.canceled : canceled // ignore: cast_nullable_to_non_nullable
as int,stalled: null == stalled ? _self.stalled : stalled // ignore: cast_nullable_to_non_nullable
as int,confirmed: null == confirmed ? _self.confirmed : confirmed // ignore: cast_nullable_to_non_nullable
as int,created: null == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AppointmentByDay {

 String get date; int get count;
/// Create a copy of AppointmentByDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppointmentByDayCopyWith<AppointmentByDay> get copyWith => _$AppointmentByDayCopyWithImpl<AppointmentByDay>(this as AppointmentByDay, _$identity);

  /// Serializes this AppointmentByDay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppointmentByDay&&(identical(other.date, date) || other.date == date)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,count);

@override
String toString() {
  return 'AppointmentByDay(date: $date, count: $count)';
}


}

/// @nodoc
abstract mixin class $AppointmentByDayCopyWith<$Res>  {
  factory $AppointmentByDayCopyWith(AppointmentByDay value, $Res Function(AppointmentByDay) _then) = _$AppointmentByDayCopyWithImpl;
@useResult
$Res call({
 String date, int count
});




}
/// @nodoc
class _$AppointmentByDayCopyWithImpl<$Res>
    implements $AppointmentByDayCopyWith<$Res> {
  _$AppointmentByDayCopyWithImpl(this._self, this._then);

  final AppointmentByDay _self;
  final $Res Function(AppointmentByDay) _then;

/// Create a copy of AppointmentByDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? count = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AppointmentByDay].
extension AppointmentByDayPatterns on AppointmentByDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppointmentByDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppointmentByDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppointmentByDay value)  $default,){
final _that = this;
switch (_that) {
case _AppointmentByDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppointmentByDay value)?  $default,){
final _that = this;
switch (_that) {
case _AppointmentByDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppointmentByDay() when $default != null:
return $default(_that.date,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  int count)  $default,) {final _that = this;
switch (_that) {
case _AppointmentByDay():
return $default(_that.date,_that.count);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  int count)?  $default,) {final _that = this;
switch (_that) {
case _AppointmentByDay() when $default != null:
return $default(_that.date,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppointmentByDay implements AppointmentByDay {
  const _AppointmentByDay({required this.date, required this.count});
  factory _AppointmentByDay.fromJson(Map<String, dynamic> json) => _$AppointmentByDayFromJson(json);

@override final  String date;
@override final  int count;

/// Create a copy of AppointmentByDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppointmentByDayCopyWith<_AppointmentByDay> get copyWith => __$AppointmentByDayCopyWithImpl<_AppointmentByDay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppointmentByDayToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppointmentByDay&&(identical(other.date, date) || other.date == date)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,count);

@override
String toString() {
  return 'AppointmentByDay(date: $date, count: $count)';
}


}

/// @nodoc
abstract mixin class _$AppointmentByDayCopyWith<$Res> implements $AppointmentByDayCopyWith<$Res> {
  factory _$AppointmentByDayCopyWith(_AppointmentByDay value, $Res Function(_AppointmentByDay) _then) = __$AppointmentByDayCopyWithImpl;
@override @useResult
$Res call({
 String date, int count
});




}
/// @nodoc
class __$AppointmentByDayCopyWithImpl<$Res>
    implements _$AppointmentByDayCopyWith<$Res> {
  __$AppointmentByDayCopyWithImpl(this._self, this._then);

  final _AppointmentByDay _self;
  final $Res Function(_AppointmentByDay) _then;

/// Create a copy of AppointmentByDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? count = null,}) {
  return _then(_AppointmentByDay(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
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
mixin _$Service {

@JsonKey(name: '_name') String get name; int get count;
/// Create a copy of Service
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceCopyWith<Service> get copyWith => _$ServiceCopyWithImpl<Service>(this as Service, _$identity);

  /// Serializes this Service to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Service&&(identical(other.name, name) || other.name == name)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,count);

@override
String toString() {
  return 'Service(name: $name, count: $count)';
}


}

/// @nodoc
abstract mixin class $ServiceCopyWith<$Res>  {
  factory $ServiceCopyWith(Service value, $Res Function(Service) _then) = _$ServiceCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: '_name') String name, int count
});




}
/// @nodoc
class _$ServiceCopyWithImpl<$Res>
    implements $ServiceCopyWith<$Res> {
  _$ServiceCopyWithImpl(this._self, this._then);

  final Service _self;
  final $Res Function(Service) _then;

/// Create a copy of Service
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? count = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Service].
extension ServicePatterns on Service {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Service value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Service() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Service value)  $default,){
final _that = this;
switch (_that) {
case _Service():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Service value)?  $default,){
final _that = this;
switch (_that) {
case _Service() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: '_name')  String name,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Service() when $default != null:
return $default(_that.name,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: '_name')  String name,  int count)  $default,) {final _that = this;
switch (_that) {
case _Service():
return $default(_that.name,_that.count);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: '_name')  String name,  int count)?  $default,) {final _that = this;
switch (_that) {
case _Service() when $default != null:
return $default(_that.name,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Service implements Service {
  const _Service({@JsonKey(name: '_name') required this.name, required this.count});
  factory _Service.fromJson(Map<String, dynamic> json) => _$ServiceFromJson(json);

@override@JsonKey(name: '_name') final  String name;
@override final  int count;

/// Create a copy of Service
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceCopyWith<_Service> get copyWith => __$ServiceCopyWithImpl<_Service>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServiceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Service&&(identical(other.name, name) || other.name == name)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,count);

@override
String toString() {
  return 'Service(name: $name, count: $count)';
}


}

/// @nodoc
abstract mixin class _$ServiceCopyWith<$Res> implements $ServiceCopyWith<$Res> {
  factory _$ServiceCopyWith(_Service value, $Res Function(_Service) _then) = __$ServiceCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: '_name') String name, int count
});




}
/// @nodoc
class __$ServiceCopyWithImpl<$Res>
    implements _$ServiceCopyWith<$Res> {
  __$ServiceCopyWithImpl(this._self, this._then);

  final _Service _self;
  final $Res Function(_Service) _then;

/// Create a copy of Service
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? count = null,}) {
  return _then(_Service(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ServiceByDay {

 String get date; int get count;
/// Create a copy of ServiceByDay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceByDayCopyWith<ServiceByDay> get copyWith => _$ServiceByDayCopyWithImpl<ServiceByDay>(this as ServiceByDay, _$identity);

  /// Serializes this ServiceByDay to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceByDay&&(identical(other.date, date) || other.date == date)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,count);

@override
String toString() {
  return 'ServiceByDay(date: $date, count: $count)';
}


}

/// @nodoc
abstract mixin class $ServiceByDayCopyWith<$Res>  {
  factory $ServiceByDayCopyWith(ServiceByDay value, $Res Function(ServiceByDay) _then) = _$ServiceByDayCopyWithImpl;
@useResult
$Res call({
 String date, int count
});




}
/// @nodoc
class _$ServiceByDayCopyWithImpl<$Res>
    implements $ServiceByDayCopyWith<$Res> {
  _$ServiceByDayCopyWithImpl(this._self, this._then);

  final ServiceByDay _self;
  final $Res Function(ServiceByDay) _then;

/// Create a copy of ServiceByDay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? count = null,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ServiceByDay].
extension ServiceByDayPatterns on ServiceByDay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServiceByDay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServiceByDay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServiceByDay value)  $default,){
final _that = this;
switch (_that) {
case _ServiceByDay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServiceByDay value)?  $default,){
final _that = this;
switch (_that) {
case _ServiceByDay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String date,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServiceByDay() when $default != null:
return $default(_that.date,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String date,  int count)  $default,) {final _that = this;
switch (_that) {
case _ServiceByDay():
return $default(_that.date,_that.count);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String date,  int count)?  $default,) {final _that = this;
switch (_that) {
case _ServiceByDay() when $default != null:
return $default(_that.date,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServiceByDay implements ServiceByDay {
  const _ServiceByDay({required this.date, required this.count});
  factory _ServiceByDay.fromJson(Map<String, dynamic> json) => _$ServiceByDayFromJson(json);

@override final  String date;
@override final  int count;

/// Create a copy of ServiceByDay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceByDayCopyWith<_ServiceByDay> get copyWith => __$ServiceByDayCopyWithImpl<_ServiceByDay>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServiceByDayToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServiceByDay&&(identical(other.date, date) || other.date == date)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,count);

@override
String toString() {
  return 'ServiceByDay(date: $date, count: $count)';
}


}

/// @nodoc
abstract mixin class _$ServiceByDayCopyWith<$Res> implements $ServiceByDayCopyWith<$Res> {
  factory _$ServiceByDayCopyWith(_ServiceByDay value, $Res Function(_ServiceByDay) _then) = __$ServiceByDayCopyWithImpl;
@override @useResult
$Res call({
 String date, int count
});




}
/// @nodoc
class __$ServiceByDayCopyWithImpl<$Res>
    implements _$ServiceByDayCopyWith<$Res> {
  __$ServiceByDayCopyWithImpl(this._self, this._then);

  final _ServiceByDay _self;
  final $Res Function(_ServiceByDay) _then;

/// Create a copy of ServiceByDay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? count = null,}) {
  return _then(_ServiceByDay(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
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
