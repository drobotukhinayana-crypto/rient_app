// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedules_api.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SchedulesApiResponse {

 int get count; String? get next; String? get previous; List<ScheduleItemApi> get results;
/// Create a copy of SchedulesApiResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SchedulesApiResponseCopyWith<SchedulesApiResponse> get copyWith => _$SchedulesApiResponseCopyWithImpl<SchedulesApiResponse>(this as SchedulesApiResponse, _$identity);

  /// Serializes this SchedulesApiResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SchedulesApiResponse&&(identical(other.count, count) || other.count == count)&&(identical(other.next, next) || other.next == next)&&(identical(other.previous, previous) || other.previous == previous)&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,next,previous,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'SchedulesApiResponse(count: $count, next: $next, previous: $previous, results: $results)';
}


}

/// @nodoc
abstract mixin class $SchedulesApiResponseCopyWith<$Res>  {
  factory $SchedulesApiResponseCopyWith(SchedulesApiResponse value, $Res Function(SchedulesApiResponse) _then) = _$SchedulesApiResponseCopyWithImpl;
@useResult
$Res call({
 int count, String? next, String? previous, List<ScheduleItemApi> results
});




}
/// @nodoc
class _$SchedulesApiResponseCopyWithImpl<$Res>
    implements $SchedulesApiResponseCopyWith<$Res> {
  _$SchedulesApiResponseCopyWithImpl(this._self, this._then);

  final SchedulesApiResponse _self;
  final $Res Function(SchedulesApiResponse) _then;

/// Create a copy of SchedulesApiResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? next = freezed,Object? previous = freezed,Object? results = null,}) {
  return _then(_self.copyWith(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as String?,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<ScheduleItemApi>,
  ));
}

}


/// Adds pattern-matching-related methods to [SchedulesApiResponse].
extension SchedulesApiResponsePatterns on SchedulesApiResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SchedulesApiResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SchedulesApiResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SchedulesApiResponse value)  $default,){
final _that = this;
switch (_that) {
case _SchedulesApiResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SchedulesApiResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SchedulesApiResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count,  String? next,  String? previous,  List<ScheduleItemApi> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SchedulesApiResponse() when $default != null:
return $default(_that.count,_that.next,_that.previous,_that.results);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count,  String? next,  String? previous,  List<ScheduleItemApi> results)  $default,) {final _that = this;
switch (_that) {
case _SchedulesApiResponse():
return $default(_that.count,_that.next,_that.previous,_that.results);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count,  String? next,  String? previous,  List<ScheduleItemApi> results)?  $default,) {final _that = this;
switch (_that) {
case _SchedulesApiResponse() when $default != null:
return $default(_that.count,_that.next,_that.previous,_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SchedulesApiResponse implements SchedulesApiResponse {
  const _SchedulesApiResponse({required this.count, required this.next, required this.previous, required final  List<ScheduleItemApi> results}): _results = results;
  factory _SchedulesApiResponse.fromJson(Map<String, dynamic> json) => _$SchedulesApiResponseFromJson(json);

@override final  int count;
@override final  String? next;
@override final  String? previous;
 final  List<ScheduleItemApi> _results;
@override List<ScheduleItemApi> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of SchedulesApiResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SchedulesApiResponseCopyWith<_SchedulesApiResponse> get copyWith => __$SchedulesApiResponseCopyWithImpl<_SchedulesApiResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SchedulesApiResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SchedulesApiResponse&&(identical(other.count, count) || other.count == count)&&(identical(other.next, next) || other.next == next)&&(identical(other.previous, previous) || other.previous == previous)&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,next,previous,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'SchedulesApiResponse(count: $count, next: $next, previous: $previous, results: $results)';
}


}

/// @nodoc
abstract mixin class _$SchedulesApiResponseCopyWith<$Res> implements $SchedulesApiResponseCopyWith<$Res> {
  factory _$SchedulesApiResponseCopyWith(_SchedulesApiResponse value, $Res Function(_SchedulesApiResponse) _then) = __$SchedulesApiResponseCopyWithImpl;
@override @useResult
$Res call({
 int count, String? next, String? previous, List<ScheduleItemApi> results
});




}
/// @nodoc
class __$SchedulesApiResponseCopyWithImpl<$Res>
    implements _$SchedulesApiResponseCopyWith<$Res> {
  __$SchedulesApiResponseCopyWithImpl(this._self, this._then);

  final _SchedulesApiResponse _self;
  final $Res Function(_SchedulesApiResponse) _then;

/// Create a copy of SchedulesApiResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? next = freezed,Object? previous = freezed,Object? results = null,}) {
  return _then(_SchedulesApiResponse(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as String?,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<ScheduleItemApi>,
  ));
}


}


/// @nodoc
mixin _$ScheduleItemApi {

 int get id; int get branch; String get date; String get key;@JsonKey(name: 'time_start') String? get timeStart;@JsonKey(name: 'time_end') String? get timeEnd; bool get active; double get hours;@JsonKey(name: 'break_start') String? get breakStart;@JsonKey(name: 'break_end') String? get breakEnd; bool get auto;
/// Create a copy of ScheduleItemApi
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleItemApiCopyWith<ScheduleItemApi> get copyWith => _$ScheduleItemApiCopyWithImpl<ScheduleItemApi>(this as ScheduleItemApi, _$identity);

  /// Serializes this ScheduleItemApi to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleItemApi&&(identical(other.id, id) || other.id == id)&&(identical(other.branch, branch) || other.branch == branch)&&(identical(other.date, date) || other.date == date)&&(identical(other.key, key) || other.key == key)&&(identical(other.timeStart, timeStart) || other.timeStart == timeStart)&&(identical(other.timeEnd, timeEnd) || other.timeEnd == timeEnd)&&(identical(other.active, active) || other.active == active)&&(identical(other.hours, hours) || other.hours == hours)&&(identical(other.breakStart, breakStart) || other.breakStart == breakStart)&&(identical(other.breakEnd, breakEnd) || other.breakEnd == breakEnd)&&(identical(other.auto, auto) || other.auto == auto));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,branch,date,key,timeStart,timeEnd,active,hours,breakStart,breakEnd,auto);

@override
String toString() {
  return 'ScheduleItemApi(id: $id, branch: $branch, date: $date, key: $key, timeStart: $timeStart, timeEnd: $timeEnd, active: $active, hours: $hours, breakStart: $breakStart, breakEnd: $breakEnd, auto: $auto)';
}


}

/// @nodoc
abstract mixin class $ScheduleItemApiCopyWith<$Res>  {
  factory $ScheduleItemApiCopyWith(ScheduleItemApi value, $Res Function(ScheduleItemApi) _then) = _$ScheduleItemApiCopyWithImpl;
@useResult
$Res call({
 int id, int branch, String date, String key,@JsonKey(name: 'time_start') String? timeStart,@JsonKey(name: 'time_end') String? timeEnd, bool active, double hours,@JsonKey(name: 'break_start') String? breakStart,@JsonKey(name: 'break_end') String? breakEnd, bool auto
});




}
/// @nodoc
class _$ScheduleItemApiCopyWithImpl<$Res>
    implements $ScheduleItemApiCopyWith<$Res> {
  _$ScheduleItemApiCopyWithImpl(this._self, this._then);

  final ScheduleItemApi _self;
  final $Res Function(ScheduleItemApi) _then;

/// Create a copy of ScheduleItemApi
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? branch = null,Object? date = null,Object? key = null,Object? timeStart = freezed,Object? timeEnd = freezed,Object? active = null,Object? hours = null,Object? breakStart = freezed,Object? breakEnd = freezed,Object? auto = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,branch: null == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,timeStart: freezed == timeStart ? _self.timeStart : timeStart // ignore: cast_nullable_to_non_nullable
as String?,timeEnd: freezed == timeEnd ? _self.timeEnd : timeEnd // ignore: cast_nullable_to_non_nullable
as String?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as double,breakStart: freezed == breakStart ? _self.breakStart : breakStart // ignore: cast_nullable_to_non_nullable
as String?,breakEnd: freezed == breakEnd ? _self.breakEnd : breakEnd // ignore: cast_nullable_to_non_nullable
as String?,auto: null == auto ? _self.auto : auto // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleItemApi].
extension ScheduleItemApiPatterns on ScheduleItemApi {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleItemApi value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleItemApi() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleItemApi value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleItemApi():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleItemApi value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleItemApi() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int branch,  String date,  String key, @JsonKey(name: 'time_start')  String? timeStart, @JsonKey(name: 'time_end')  String? timeEnd,  bool active,  double hours, @JsonKey(name: 'break_start')  String? breakStart, @JsonKey(name: 'break_end')  String? breakEnd,  bool auto)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleItemApi() when $default != null:
return $default(_that.id,_that.branch,_that.date,_that.key,_that.timeStart,_that.timeEnd,_that.active,_that.hours,_that.breakStart,_that.breakEnd,_that.auto);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int branch,  String date,  String key, @JsonKey(name: 'time_start')  String? timeStart, @JsonKey(name: 'time_end')  String? timeEnd,  bool active,  double hours, @JsonKey(name: 'break_start')  String? breakStart, @JsonKey(name: 'break_end')  String? breakEnd,  bool auto)  $default,) {final _that = this;
switch (_that) {
case _ScheduleItemApi():
return $default(_that.id,_that.branch,_that.date,_that.key,_that.timeStart,_that.timeEnd,_that.active,_that.hours,_that.breakStart,_that.breakEnd,_that.auto);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int branch,  String date,  String key, @JsonKey(name: 'time_start')  String? timeStart, @JsonKey(name: 'time_end')  String? timeEnd,  bool active,  double hours, @JsonKey(name: 'break_start')  String? breakStart, @JsonKey(name: 'break_end')  String? breakEnd,  bool auto)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleItemApi() when $default != null:
return $default(_that.id,_that.branch,_that.date,_that.key,_that.timeStart,_that.timeEnd,_that.active,_that.hours,_that.breakStart,_that.breakEnd,_that.auto);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleItemApi implements ScheduleItemApi {
  const _ScheduleItemApi({required this.id, required this.branch, required this.date, required this.key, @JsonKey(name: 'time_start') required this.timeStart, @JsonKey(name: 'time_end') required this.timeEnd, required this.active, required this.hours, @JsonKey(name: 'break_start') required this.breakStart, @JsonKey(name: 'break_end') required this.breakEnd, required this.auto});
  factory _ScheduleItemApi.fromJson(Map<String, dynamic> json) => _$ScheduleItemApiFromJson(json);

@override final  int id;
@override final  int branch;
@override final  String date;
@override final  String key;
@override@JsonKey(name: 'time_start') final  String? timeStart;
@override@JsonKey(name: 'time_end') final  String? timeEnd;
@override final  bool active;
@override final  double hours;
@override@JsonKey(name: 'break_start') final  String? breakStart;
@override@JsonKey(name: 'break_end') final  String? breakEnd;
@override final  bool auto;

/// Create a copy of ScheduleItemApi
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleItemApiCopyWith<_ScheduleItemApi> get copyWith => __$ScheduleItemApiCopyWithImpl<_ScheduleItemApi>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleItemApiToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleItemApi&&(identical(other.id, id) || other.id == id)&&(identical(other.branch, branch) || other.branch == branch)&&(identical(other.date, date) || other.date == date)&&(identical(other.key, key) || other.key == key)&&(identical(other.timeStart, timeStart) || other.timeStart == timeStart)&&(identical(other.timeEnd, timeEnd) || other.timeEnd == timeEnd)&&(identical(other.active, active) || other.active == active)&&(identical(other.hours, hours) || other.hours == hours)&&(identical(other.breakStart, breakStart) || other.breakStart == breakStart)&&(identical(other.breakEnd, breakEnd) || other.breakEnd == breakEnd)&&(identical(other.auto, auto) || other.auto == auto));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,branch,date,key,timeStart,timeEnd,active,hours,breakStart,breakEnd,auto);

@override
String toString() {
  return 'ScheduleItemApi(id: $id, branch: $branch, date: $date, key: $key, timeStart: $timeStart, timeEnd: $timeEnd, active: $active, hours: $hours, breakStart: $breakStart, breakEnd: $breakEnd, auto: $auto)';
}


}

/// @nodoc
abstract mixin class _$ScheduleItemApiCopyWith<$Res> implements $ScheduleItemApiCopyWith<$Res> {
  factory _$ScheduleItemApiCopyWith(_ScheduleItemApi value, $Res Function(_ScheduleItemApi) _then) = __$ScheduleItemApiCopyWithImpl;
@override @useResult
$Res call({
 int id, int branch, String date, String key,@JsonKey(name: 'time_start') String? timeStart,@JsonKey(name: 'time_end') String? timeEnd, bool active, double hours,@JsonKey(name: 'break_start') String? breakStart,@JsonKey(name: 'break_end') String? breakEnd, bool auto
});




}
/// @nodoc
class __$ScheduleItemApiCopyWithImpl<$Res>
    implements _$ScheduleItemApiCopyWith<$Res> {
  __$ScheduleItemApiCopyWithImpl(this._self, this._then);

  final _ScheduleItemApi _self;
  final $Res Function(_ScheduleItemApi) _then;

/// Create a copy of ScheduleItemApi
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? branch = null,Object? date = null,Object? key = null,Object? timeStart = freezed,Object? timeEnd = freezed,Object? active = null,Object? hours = null,Object? breakStart = freezed,Object? breakEnd = freezed,Object? auto = null,}) {
  return _then(_ScheduleItemApi(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,branch: null == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,timeStart: freezed == timeStart ? _self.timeStart : timeStart // ignore: cast_nullable_to_non_nullable
as String?,timeEnd: freezed == timeEnd ? _self.timeEnd : timeEnd // ignore: cast_nullable_to_non_nullable
as String?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as double,breakStart: freezed == breakStart ? _self.breakStart : breakStart // ignore: cast_nullable_to_non_nullable
as String?,breakEnd: freezed == breakEnd ? _self.breakEnd : breakEnd // ignore: cast_nullable_to_non_nullable
as String?,auto: null == auto ? _self.auto : auto // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
