// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_patterns_api.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SchedulePatternsApiResponse {

 int get count; String? get next; String? get previous; List<SchedulePatternItemApi> get results;
/// Create a copy of SchedulePatternsApiResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SchedulePatternsApiResponseCopyWith<SchedulePatternsApiResponse> get copyWith => _$SchedulePatternsApiResponseCopyWithImpl<SchedulePatternsApiResponse>(this as SchedulePatternsApiResponse, _$identity);

  /// Serializes this SchedulePatternsApiResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SchedulePatternsApiResponse&&(identical(other.count, count) || other.count == count)&&(identical(other.next, next) || other.next == next)&&(identical(other.previous, previous) || other.previous == previous)&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,next,previous,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'SchedulePatternsApiResponse(count: $count, next: $next, previous: $previous, results: $results)';
}


}

/// @nodoc
abstract mixin class $SchedulePatternsApiResponseCopyWith<$Res>  {
  factory $SchedulePatternsApiResponseCopyWith(SchedulePatternsApiResponse value, $Res Function(SchedulePatternsApiResponse) _then) = _$SchedulePatternsApiResponseCopyWithImpl;
@useResult
$Res call({
 int count, String? next, String? previous, List<SchedulePatternItemApi> results
});




}
/// @nodoc
class _$SchedulePatternsApiResponseCopyWithImpl<$Res>
    implements $SchedulePatternsApiResponseCopyWith<$Res> {
  _$SchedulePatternsApiResponseCopyWithImpl(this._self, this._then);

  final SchedulePatternsApiResponse _self;
  final $Res Function(SchedulePatternsApiResponse) _then;

/// Create a copy of SchedulePatternsApiResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? next = freezed,Object? previous = freezed,Object? results = null,}) {
  return _then(_self.copyWith(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as String?,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<SchedulePatternItemApi>,
  ));
}

}


/// Adds pattern-matching-related methods to [SchedulePatternsApiResponse].
extension SchedulePatternsApiResponsePatterns on SchedulePatternsApiResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SchedulePatternsApiResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SchedulePatternsApiResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SchedulePatternsApiResponse value)  $default,){
final _that = this;
switch (_that) {
case _SchedulePatternsApiResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SchedulePatternsApiResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SchedulePatternsApiResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count,  String? next,  String? previous,  List<SchedulePatternItemApi> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SchedulePatternsApiResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count,  String? next,  String? previous,  List<SchedulePatternItemApi> results)  $default,) {final _that = this;
switch (_that) {
case _SchedulePatternsApiResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count,  String? next,  String? previous,  List<SchedulePatternItemApi> results)?  $default,) {final _that = this;
switch (_that) {
case _SchedulePatternsApiResponse() when $default != null:
return $default(_that.count,_that.next,_that.previous,_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SchedulePatternsApiResponse implements SchedulePatternsApiResponse {
  const _SchedulePatternsApiResponse({required this.count, required this.next, required this.previous, required final  List<SchedulePatternItemApi> results}): _results = results;
  factory _SchedulePatternsApiResponse.fromJson(Map<String, dynamic> json) => _$SchedulePatternsApiResponseFromJson(json);

@override final  int count;
@override final  String? next;
@override final  String? previous;
 final  List<SchedulePatternItemApi> _results;
@override List<SchedulePatternItemApi> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of SchedulePatternsApiResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SchedulePatternsApiResponseCopyWith<_SchedulePatternsApiResponse> get copyWith => __$SchedulePatternsApiResponseCopyWithImpl<_SchedulePatternsApiResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SchedulePatternsApiResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SchedulePatternsApiResponse&&(identical(other.count, count) || other.count == count)&&(identical(other.next, next) || other.next == next)&&(identical(other.previous, previous) || other.previous == previous)&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,next,previous,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'SchedulePatternsApiResponse(count: $count, next: $next, previous: $previous, results: $results)';
}


}

/// @nodoc
abstract mixin class _$SchedulePatternsApiResponseCopyWith<$Res> implements $SchedulePatternsApiResponseCopyWith<$Res> {
  factory _$SchedulePatternsApiResponseCopyWith(_SchedulePatternsApiResponse value, $Res Function(_SchedulePatternsApiResponse) _then) = __$SchedulePatternsApiResponseCopyWithImpl;
@override @useResult
$Res call({
 int count, String? next, String? previous, List<SchedulePatternItemApi> results
});




}
/// @nodoc
class __$SchedulePatternsApiResponseCopyWithImpl<$Res>
    implements _$SchedulePatternsApiResponseCopyWith<$Res> {
  __$SchedulePatternsApiResponseCopyWithImpl(this._self, this._then);

  final _SchedulePatternsApiResponse _self;
  final $Res Function(_SchedulePatternsApiResponse) _then;

/// Create a copy of SchedulePatternsApiResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? next = freezed,Object? previous = freezed,Object? results = null,}) {
  return _then(_SchedulePatternsApiResponse(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as String?,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<SchedulePatternItemApi>,
  ));
}


}


/// @nodoc
mixin _$SchedulePatternItemApi {

 int get id; String get day;@JsonKey(name: 'time_start') String? get timeStart;@JsonKey(name: 'time_end') String? get timeEnd; bool get active; int get worker;@JsonKey(name: 'break_start') String? get breakStart;@JsonKey(name: 'break_end') String? get breakEnd;
/// Create a copy of SchedulePatternItemApi
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SchedulePatternItemApiCopyWith<SchedulePatternItemApi> get copyWith => _$SchedulePatternItemApiCopyWithImpl<SchedulePatternItemApi>(this as SchedulePatternItemApi, _$identity);

  /// Serializes this SchedulePatternItemApi to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SchedulePatternItemApi&&(identical(other.id, id) || other.id == id)&&(identical(other.day, day) || other.day == day)&&(identical(other.timeStart, timeStart) || other.timeStart == timeStart)&&(identical(other.timeEnd, timeEnd) || other.timeEnd == timeEnd)&&(identical(other.active, active) || other.active == active)&&(identical(other.worker, worker) || other.worker == worker)&&(identical(other.breakStart, breakStart) || other.breakStart == breakStart)&&(identical(other.breakEnd, breakEnd) || other.breakEnd == breakEnd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,day,timeStart,timeEnd,active,worker,breakStart,breakEnd);

@override
String toString() {
  return 'SchedulePatternItemApi(id: $id, day: $day, timeStart: $timeStart, timeEnd: $timeEnd, active: $active, worker: $worker, breakStart: $breakStart, breakEnd: $breakEnd)';
}


}

/// @nodoc
abstract mixin class $SchedulePatternItemApiCopyWith<$Res>  {
  factory $SchedulePatternItemApiCopyWith(SchedulePatternItemApi value, $Res Function(SchedulePatternItemApi) _then) = _$SchedulePatternItemApiCopyWithImpl;
@useResult
$Res call({
 int id, String day,@JsonKey(name: 'time_start') String? timeStart,@JsonKey(name: 'time_end') String? timeEnd, bool active, int worker,@JsonKey(name: 'break_start') String? breakStart,@JsonKey(name: 'break_end') String? breakEnd
});




}
/// @nodoc
class _$SchedulePatternItemApiCopyWithImpl<$Res>
    implements $SchedulePatternItemApiCopyWith<$Res> {
  _$SchedulePatternItemApiCopyWithImpl(this._self, this._then);

  final SchedulePatternItemApi _self;
  final $Res Function(SchedulePatternItemApi) _then;

/// Create a copy of SchedulePatternItemApi
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? day = null,Object? timeStart = freezed,Object? timeEnd = freezed,Object? active = null,Object? worker = null,Object? breakStart = freezed,Object? breakEnd = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as String,timeStart: freezed == timeStart ? _self.timeStart : timeStart // ignore: cast_nullable_to_non_nullable
as String?,timeEnd: freezed == timeEnd ? _self.timeEnd : timeEnd // ignore: cast_nullable_to_non_nullable
as String?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,worker: null == worker ? _self.worker : worker // ignore: cast_nullable_to_non_nullable
as int,breakStart: freezed == breakStart ? _self.breakStart : breakStart // ignore: cast_nullable_to_non_nullable
as String?,breakEnd: freezed == breakEnd ? _self.breakEnd : breakEnd // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SchedulePatternItemApi].
extension SchedulePatternItemApiPatterns on SchedulePatternItemApi {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SchedulePatternItemApi value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SchedulePatternItemApi() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SchedulePatternItemApi value)  $default,){
final _that = this;
switch (_that) {
case _SchedulePatternItemApi():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SchedulePatternItemApi value)?  $default,){
final _that = this;
switch (_that) {
case _SchedulePatternItemApi() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String day, @JsonKey(name: 'time_start')  String? timeStart, @JsonKey(name: 'time_end')  String? timeEnd,  bool active,  int worker, @JsonKey(name: 'break_start')  String? breakStart, @JsonKey(name: 'break_end')  String? breakEnd)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SchedulePatternItemApi() when $default != null:
return $default(_that.id,_that.day,_that.timeStart,_that.timeEnd,_that.active,_that.worker,_that.breakStart,_that.breakEnd);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String day, @JsonKey(name: 'time_start')  String? timeStart, @JsonKey(name: 'time_end')  String? timeEnd,  bool active,  int worker, @JsonKey(name: 'break_start')  String? breakStart, @JsonKey(name: 'break_end')  String? breakEnd)  $default,) {final _that = this;
switch (_that) {
case _SchedulePatternItemApi():
return $default(_that.id,_that.day,_that.timeStart,_that.timeEnd,_that.active,_that.worker,_that.breakStart,_that.breakEnd);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String day, @JsonKey(name: 'time_start')  String? timeStart, @JsonKey(name: 'time_end')  String? timeEnd,  bool active,  int worker, @JsonKey(name: 'break_start')  String? breakStart, @JsonKey(name: 'break_end')  String? breakEnd)?  $default,) {final _that = this;
switch (_that) {
case _SchedulePatternItemApi() when $default != null:
return $default(_that.id,_that.day,_that.timeStart,_that.timeEnd,_that.active,_that.worker,_that.breakStart,_that.breakEnd);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SchedulePatternItemApi implements SchedulePatternItemApi {
  const _SchedulePatternItemApi({required this.id, required this.day, @JsonKey(name: 'time_start') required this.timeStart, @JsonKey(name: 'time_end') required this.timeEnd, required this.active, required this.worker, @JsonKey(name: 'break_start') required this.breakStart, @JsonKey(name: 'break_end') required this.breakEnd});
  factory _SchedulePatternItemApi.fromJson(Map<String, dynamic> json) => _$SchedulePatternItemApiFromJson(json);

@override final  int id;
@override final  String day;
@override@JsonKey(name: 'time_start') final  String? timeStart;
@override@JsonKey(name: 'time_end') final  String? timeEnd;
@override final  bool active;
@override final  int worker;
@override@JsonKey(name: 'break_start') final  String? breakStart;
@override@JsonKey(name: 'break_end') final  String? breakEnd;

/// Create a copy of SchedulePatternItemApi
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SchedulePatternItemApiCopyWith<_SchedulePatternItemApi> get copyWith => __$SchedulePatternItemApiCopyWithImpl<_SchedulePatternItemApi>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SchedulePatternItemApiToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SchedulePatternItemApi&&(identical(other.id, id) || other.id == id)&&(identical(other.day, day) || other.day == day)&&(identical(other.timeStart, timeStart) || other.timeStart == timeStart)&&(identical(other.timeEnd, timeEnd) || other.timeEnd == timeEnd)&&(identical(other.active, active) || other.active == active)&&(identical(other.worker, worker) || other.worker == worker)&&(identical(other.breakStart, breakStart) || other.breakStart == breakStart)&&(identical(other.breakEnd, breakEnd) || other.breakEnd == breakEnd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,day,timeStart,timeEnd,active,worker,breakStart,breakEnd);

@override
String toString() {
  return 'SchedulePatternItemApi(id: $id, day: $day, timeStart: $timeStart, timeEnd: $timeEnd, active: $active, worker: $worker, breakStart: $breakStart, breakEnd: $breakEnd)';
}


}

/// @nodoc
abstract mixin class _$SchedulePatternItemApiCopyWith<$Res> implements $SchedulePatternItemApiCopyWith<$Res> {
  factory _$SchedulePatternItemApiCopyWith(_SchedulePatternItemApi value, $Res Function(_SchedulePatternItemApi) _then) = __$SchedulePatternItemApiCopyWithImpl;
@override @useResult
$Res call({
 int id, String day,@JsonKey(name: 'time_start') String? timeStart,@JsonKey(name: 'time_end') String? timeEnd, bool active, int worker,@JsonKey(name: 'break_start') String? breakStart,@JsonKey(name: 'break_end') String? breakEnd
});




}
/// @nodoc
class __$SchedulePatternItemApiCopyWithImpl<$Res>
    implements _$SchedulePatternItemApiCopyWith<$Res> {
  __$SchedulePatternItemApiCopyWithImpl(this._self, this._then);

  final _SchedulePatternItemApi _self;
  final $Res Function(_SchedulePatternItemApi) _then;

/// Create a copy of SchedulePatternItemApi
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? day = null,Object? timeStart = freezed,Object? timeEnd = freezed,Object? active = null,Object? worker = null,Object? breakStart = freezed,Object? breakEnd = freezed,}) {
  return _then(_SchedulePatternItemApi(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as String,timeStart: freezed == timeStart ? _self.timeStart : timeStart // ignore: cast_nullable_to_non_nullable
as String?,timeEnd: freezed == timeEnd ? _self.timeEnd : timeEnd // ignore: cast_nullable_to_non_nullable
as String?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,worker: null == worker ? _self.worker : worker // ignore: cast_nullable_to_non_nullable
as int,breakStart: freezed == breakStart ? _self.breakStart : breakStart // ignore: cast_nullable_to_non_nullable
as String?,breakEnd: freezed == breakEnd ? _self.breakEnd : breakEnd // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
