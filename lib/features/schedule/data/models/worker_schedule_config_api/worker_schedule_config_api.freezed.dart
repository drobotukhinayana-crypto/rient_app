// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'worker_schedule_config_api.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkerScheduleConfigApi {

 String get id; int get worker; int get branch;@JsonKey(name: 'schedule_type') int get scheduleType;@JsonKey(name: 'schedule_shift_pattern') String? get scheduleShiftPattern;@JsonKey(name: 'schedule_shift_start_date') String? get scheduleShiftStartDate;@JsonKey(name: 'time_start') String? get timeStart;@JsonKey(name: 'time_end') String? get timeEnd; bool get active;
/// Create a copy of WorkerScheduleConfigApi
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkerScheduleConfigApiCopyWith<WorkerScheduleConfigApi> get copyWith => _$WorkerScheduleConfigApiCopyWithImpl<WorkerScheduleConfigApi>(this as WorkerScheduleConfigApi, _$identity);

  /// Serializes this WorkerScheduleConfigApi to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkerScheduleConfigApi&&(identical(other.id, id) || other.id == id)&&(identical(other.worker, worker) || other.worker == worker)&&(identical(other.branch, branch) || other.branch == branch)&&(identical(other.scheduleType, scheduleType) || other.scheduleType == scheduleType)&&(identical(other.scheduleShiftPattern, scheduleShiftPattern) || other.scheduleShiftPattern == scheduleShiftPattern)&&(identical(other.scheduleShiftStartDate, scheduleShiftStartDate) || other.scheduleShiftStartDate == scheduleShiftStartDate)&&(identical(other.timeStart, timeStart) || other.timeStart == timeStart)&&(identical(other.timeEnd, timeEnd) || other.timeEnd == timeEnd)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,worker,branch,scheduleType,scheduleShiftPattern,scheduleShiftStartDate,timeStart,timeEnd,active);

@override
String toString() {
  return 'WorkerScheduleConfigApi(id: $id, worker: $worker, branch: $branch, scheduleType: $scheduleType, scheduleShiftPattern: $scheduleShiftPattern, scheduleShiftStartDate: $scheduleShiftStartDate, timeStart: $timeStart, timeEnd: $timeEnd, active: $active)';
}


}

/// @nodoc
abstract mixin class $WorkerScheduleConfigApiCopyWith<$Res>  {
  factory $WorkerScheduleConfigApiCopyWith(WorkerScheduleConfigApi value, $Res Function(WorkerScheduleConfigApi) _then) = _$WorkerScheduleConfigApiCopyWithImpl;
@useResult
$Res call({
 String id, int worker, int branch,@JsonKey(name: 'schedule_type') int scheduleType,@JsonKey(name: 'schedule_shift_pattern') String? scheduleShiftPattern,@JsonKey(name: 'schedule_shift_start_date') String? scheduleShiftStartDate,@JsonKey(name: 'time_start') String? timeStart,@JsonKey(name: 'time_end') String? timeEnd, bool active
});




}
/// @nodoc
class _$WorkerScheduleConfigApiCopyWithImpl<$Res>
    implements $WorkerScheduleConfigApiCopyWith<$Res> {
  _$WorkerScheduleConfigApiCopyWithImpl(this._self, this._then);

  final WorkerScheduleConfigApi _self;
  final $Res Function(WorkerScheduleConfigApi) _then;

/// Create a copy of WorkerScheduleConfigApi
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? worker = null,Object? branch = null,Object? scheduleType = null,Object? scheduleShiftPattern = freezed,Object? scheduleShiftStartDate = freezed,Object? timeStart = freezed,Object? timeEnd = freezed,Object? active = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,worker: null == worker ? _self.worker : worker // ignore: cast_nullable_to_non_nullable
as int,branch: null == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as int,scheduleType: null == scheduleType ? _self.scheduleType : scheduleType // ignore: cast_nullable_to_non_nullable
as int,scheduleShiftPattern: freezed == scheduleShiftPattern ? _self.scheduleShiftPattern : scheduleShiftPattern // ignore: cast_nullable_to_non_nullable
as String?,scheduleShiftStartDate: freezed == scheduleShiftStartDate ? _self.scheduleShiftStartDate : scheduleShiftStartDate // ignore: cast_nullable_to_non_nullable
as String?,timeStart: freezed == timeStart ? _self.timeStart : timeStart // ignore: cast_nullable_to_non_nullable
as String?,timeEnd: freezed == timeEnd ? _self.timeEnd : timeEnd // ignore: cast_nullable_to_non_nullable
as String?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkerScheduleConfigApi].
extension WorkerScheduleConfigApiPatterns on WorkerScheduleConfigApi {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkerScheduleConfigApi value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkerScheduleConfigApi() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkerScheduleConfigApi value)  $default,){
final _that = this;
switch (_that) {
case _WorkerScheduleConfigApi():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkerScheduleConfigApi value)?  $default,){
final _that = this;
switch (_that) {
case _WorkerScheduleConfigApi() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int worker,  int branch, @JsonKey(name: 'schedule_type')  int scheduleType, @JsonKey(name: 'schedule_shift_pattern')  String? scheduleShiftPattern, @JsonKey(name: 'schedule_shift_start_date')  String? scheduleShiftStartDate, @JsonKey(name: 'time_start')  String? timeStart, @JsonKey(name: 'time_end')  String? timeEnd,  bool active)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkerScheduleConfigApi() when $default != null:
return $default(_that.id,_that.worker,_that.branch,_that.scheduleType,_that.scheduleShiftPattern,_that.scheduleShiftStartDate,_that.timeStart,_that.timeEnd,_that.active);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int worker,  int branch, @JsonKey(name: 'schedule_type')  int scheduleType, @JsonKey(name: 'schedule_shift_pattern')  String? scheduleShiftPattern, @JsonKey(name: 'schedule_shift_start_date')  String? scheduleShiftStartDate, @JsonKey(name: 'time_start')  String? timeStart, @JsonKey(name: 'time_end')  String? timeEnd,  bool active)  $default,) {final _that = this;
switch (_that) {
case _WorkerScheduleConfigApi():
return $default(_that.id,_that.worker,_that.branch,_that.scheduleType,_that.scheduleShiftPattern,_that.scheduleShiftStartDate,_that.timeStart,_that.timeEnd,_that.active);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int worker,  int branch, @JsonKey(name: 'schedule_type')  int scheduleType, @JsonKey(name: 'schedule_shift_pattern')  String? scheduleShiftPattern, @JsonKey(name: 'schedule_shift_start_date')  String? scheduleShiftStartDate, @JsonKey(name: 'time_start')  String? timeStart, @JsonKey(name: 'time_end')  String? timeEnd,  bool active)?  $default,) {final _that = this;
switch (_that) {
case _WorkerScheduleConfigApi() when $default != null:
return $default(_that.id,_that.worker,_that.branch,_that.scheduleType,_that.scheduleShiftPattern,_that.scheduleShiftStartDate,_that.timeStart,_that.timeEnd,_that.active);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkerScheduleConfigApi implements WorkerScheduleConfigApi {
  const _WorkerScheduleConfigApi({required this.id, required this.worker, required this.branch, @JsonKey(name: 'schedule_type') required this.scheduleType, @JsonKey(name: 'schedule_shift_pattern') required this.scheduleShiftPattern, @JsonKey(name: 'schedule_shift_start_date') required this.scheduleShiftStartDate, @JsonKey(name: 'time_start') required this.timeStart, @JsonKey(name: 'time_end') required this.timeEnd, required this.active});
  factory _WorkerScheduleConfigApi.fromJson(Map<String, dynamic> json) => _$WorkerScheduleConfigApiFromJson(json);

@override final  String id;
@override final  int worker;
@override final  int branch;
@override@JsonKey(name: 'schedule_type') final  int scheduleType;
@override@JsonKey(name: 'schedule_shift_pattern') final  String? scheduleShiftPattern;
@override@JsonKey(name: 'schedule_shift_start_date') final  String? scheduleShiftStartDate;
@override@JsonKey(name: 'time_start') final  String? timeStart;
@override@JsonKey(name: 'time_end') final  String? timeEnd;
@override final  bool active;

/// Create a copy of WorkerScheduleConfigApi
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkerScheduleConfigApiCopyWith<_WorkerScheduleConfigApi> get copyWith => __$WorkerScheduleConfigApiCopyWithImpl<_WorkerScheduleConfigApi>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkerScheduleConfigApiToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkerScheduleConfigApi&&(identical(other.id, id) || other.id == id)&&(identical(other.worker, worker) || other.worker == worker)&&(identical(other.branch, branch) || other.branch == branch)&&(identical(other.scheduleType, scheduleType) || other.scheduleType == scheduleType)&&(identical(other.scheduleShiftPattern, scheduleShiftPattern) || other.scheduleShiftPattern == scheduleShiftPattern)&&(identical(other.scheduleShiftStartDate, scheduleShiftStartDate) || other.scheduleShiftStartDate == scheduleShiftStartDate)&&(identical(other.timeStart, timeStart) || other.timeStart == timeStart)&&(identical(other.timeEnd, timeEnd) || other.timeEnd == timeEnd)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,worker,branch,scheduleType,scheduleShiftPattern,scheduleShiftStartDate,timeStart,timeEnd,active);

@override
String toString() {
  return 'WorkerScheduleConfigApi(id: $id, worker: $worker, branch: $branch, scheduleType: $scheduleType, scheduleShiftPattern: $scheduleShiftPattern, scheduleShiftStartDate: $scheduleShiftStartDate, timeStart: $timeStart, timeEnd: $timeEnd, active: $active)';
}


}

/// @nodoc
abstract mixin class _$WorkerScheduleConfigApiCopyWith<$Res> implements $WorkerScheduleConfigApiCopyWith<$Res> {
  factory _$WorkerScheduleConfigApiCopyWith(_WorkerScheduleConfigApi value, $Res Function(_WorkerScheduleConfigApi) _then) = __$WorkerScheduleConfigApiCopyWithImpl;
@override @useResult
$Res call({
 String id, int worker, int branch,@JsonKey(name: 'schedule_type') int scheduleType,@JsonKey(name: 'schedule_shift_pattern') String? scheduleShiftPattern,@JsonKey(name: 'schedule_shift_start_date') String? scheduleShiftStartDate,@JsonKey(name: 'time_start') String? timeStart,@JsonKey(name: 'time_end') String? timeEnd, bool active
});




}
/// @nodoc
class __$WorkerScheduleConfigApiCopyWithImpl<$Res>
    implements _$WorkerScheduleConfigApiCopyWith<$Res> {
  __$WorkerScheduleConfigApiCopyWithImpl(this._self, this._then);

  final _WorkerScheduleConfigApi _self;
  final $Res Function(_WorkerScheduleConfigApi) _then;

/// Create a copy of WorkerScheduleConfigApi
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? worker = null,Object? branch = null,Object? scheduleType = null,Object? scheduleShiftPattern = freezed,Object? scheduleShiftStartDate = freezed,Object? timeStart = freezed,Object? timeEnd = freezed,Object? active = null,}) {
  return _then(_WorkerScheduleConfigApi(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,worker: null == worker ? _self.worker : worker // ignore: cast_nullable_to_non_nullable
as int,branch: null == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as int,scheduleType: null == scheduleType ? _self.scheduleType : scheduleType // ignore: cast_nullable_to_non_nullable
as int,scheduleShiftPattern: freezed == scheduleShiftPattern ? _self.scheduleShiftPattern : scheduleShiftPattern // ignore: cast_nullable_to_non_nullable
as String?,scheduleShiftStartDate: freezed == scheduleShiftStartDate ? _self.scheduleShiftStartDate : scheduleShiftStartDate // ignore: cast_nullable_to_non_nullable
as String?,timeStart: freezed == timeStart ? _self.timeStart : timeStart // ignore: cast_nullable_to_non_nullable
as String?,timeEnd: freezed == timeEnd ? _self.timeEnd : timeEnd // ignore: cast_nullable_to_non_nullable
as String?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
