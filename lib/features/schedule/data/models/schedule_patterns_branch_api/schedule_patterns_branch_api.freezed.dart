// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_patterns_branch_api.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SchedulePatternsBranchApiResponse {

 int get count; String? get next; String? get previous; List<SchedulePatternBranchItemApi> get results;
/// Create a copy of SchedulePatternsBranchApiResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SchedulePatternsBranchApiResponseCopyWith<SchedulePatternsBranchApiResponse> get copyWith => _$SchedulePatternsBranchApiResponseCopyWithImpl<SchedulePatternsBranchApiResponse>(this as SchedulePatternsBranchApiResponse, _$identity);

  /// Serializes this SchedulePatternsBranchApiResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SchedulePatternsBranchApiResponse&&(identical(other.count, count) || other.count == count)&&(identical(other.next, next) || other.next == next)&&(identical(other.previous, previous) || other.previous == previous)&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,next,previous,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'SchedulePatternsBranchApiResponse(count: $count, next: $next, previous: $previous, results: $results)';
}


}

/// @nodoc
abstract mixin class $SchedulePatternsBranchApiResponseCopyWith<$Res>  {
  factory $SchedulePatternsBranchApiResponseCopyWith(SchedulePatternsBranchApiResponse value, $Res Function(SchedulePatternsBranchApiResponse) _then) = _$SchedulePatternsBranchApiResponseCopyWithImpl;
@useResult
$Res call({
 int count, String? next, String? previous, List<SchedulePatternBranchItemApi> results
});




}
/// @nodoc
class _$SchedulePatternsBranchApiResponseCopyWithImpl<$Res>
    implements $SchedulePatternsBranchApiResponseCopyWith<$Res> {
  _$SchedulePatternsBranchApiResponseCopyWithImpl(this._self, this._then);

  final SchedulePatternsBranchApiResponse _self;
  final $Res Function(SchedulePatternsBranchApiResponse) _then;

/// Create a copy of SchedulePatternsBranchApiResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? next = freezed,Object? previous = freezed,Object? results = null,}) {
  return _then(_self.copyWith(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as String?,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<SchedulePatternBranchItemApi>,
  ));
}

}


/// Adds pattern-matching-related methods to [SchedulePatternsBranchApiResponse].
extension SchedulePatternsBranchApiResponsePatterns on SchedulePatternsBranchApiResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SchedulePatternsBranchApiResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SchedulePatternsBranchApiResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SchedulePatternsBranchApiResponse value)  $default,){
final _that = this;
switch (_that) {
case _SchedulePatternsBranchApiResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SchedulePatternsBranchApiResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SchedulePatternsBranchApiResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count,  String? next,  String? previous,  List<SchedulePatternBranchItemApi> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SchedulePatternsBranchApiResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count,  String? next,  String? previous,  List<SchedulePatternBranchItemApi> results)  $default,) {final _that = this;
switch (_that) {
case _SchedulePatternsBranchApiResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count,  String? next,  String? previous,  List<SchedulePatternBranchItemApi> results)?  $default,) {final _that = this;
switch (_that) {
case _SchedulePatternsBranchApiResponse() when $default != null:
return $default(_that.count,_that.next,_that.previous,_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SchedulePatternsBranchApiResponse implements SchedulePatternsBranchApiResponse {
  const _SchedulePatternsBranchApiResponse({required this.count, required this.next, required this.previous, required final  List<SchedulePatternBranchItemApi> results}): _results = results;
  factory _SchedulePatternsBranchApiResponse.fromJson(Map<String, dynamic> json) => _$SchedulePatternsBranchApiResponseFromJson(json);

@override final  int count;
@override final  String? next;
@override final  String? previous;
 final  List<SchedulePatternBranchItemApi> _results;
@override List<SchedulePatternBranchItemApi> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of SchedulePatternsBranchApiResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SchedulePatternsBranchApiResponseCopyWith<_SchedulePatternsBranchApiResponse> get copyWith => __$SchedulePatternsBranchApiResponseCopyWithImpl<_SchedulePatternsBranchApiResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SchedulePatternsBranchApiResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SchedulePatternsBranchApiResponse&&(identical(other.count, count) || other.count == count)&&(identical(other.next, next) || other.next == next)&&(identical(other.previous, previous) || other.previous == previous)&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,next,previous,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'SchedulePatternsBranchApiResponse(count: $count, next: $next, previous: $previous, results: $results)';
}


}

/// @nodoc
abstract mixin class _$SchedulePatternsBranchApiResponseCopyWith<$Res> implements $SchedulePatternsBranchApiResponseCopyWith<$Res> {
  factory _$SchedulePatternsBranchApiResponseCopyWith(_SchedulePatternsBranchApiResponse value, $Res Function(_SchedulePatternsBranchApiResponse) _then) = __$SchedulePatternsBranchApiResponseCopyWithImpl;
@override @useResult
$Res call({
 int count, String? next, String? previous, List<SchedulePatternBranchItemApi> results
});




}
/// @nodoc
class __$SchedulePatternsBranchApiResponseCopyWithImpl<$Res>
    implements _$SchedulePatternsBranchApiResponseCopyWith<$Res> {
  __$SchedulePatternsBranchApiResponseCopyWithImpl(this._self, this._then);

  final _SchedulePatternsBranchApiResponse _self;
  final $Res Function(_SchedulePatternsBranchApiResponse) _then;

/// Create a copy of SchedulePatternsBranchApiResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? next = freezed,Object? previous = freezed,Object? results = null,}) {
  return _then(_SchedulePatternsBranchApiResponse(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as String?,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<SchedulePatternBranchItemApi>,
  ));
}


}


/// @nodoc
mixin _$SchedulePatternBranchItemApi {

 int get id; int get branch; String get day;@JsonKey(name: 'time_start') String? get timeStart;@JsonKey(name: 'time_end') String? get timeEnd; bool get active;
/// Create a copy of SchedulePatternBranchItemApi
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SchedulePatternBranchItemApiCopyWith<SchedulePatternBranchItemApi> get copyWith => _$SchedulePatternBranchItemApiCopyWithImpl<SchedulePatternBranchItemApi>(this as SchedulePatternBranchItemApi, _$identity);

  /// Serializes this SchedulePatternBranchItemApi to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SchedulePatternBranchItemApi&&(identical(other.id, id) || other.id == id)&&(identical(other.branch, branch) || other.branch == branch)&&(identical(other.day, day) || other.day == day)&&(identical(other.timeStart, timeStart) || other.timeStart == timeStart)&&(identical(other.timeEnd, timeEnd) || other.timeEnd == timeEnd)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,branch,day,timeStart,timeEnd,active);

@override
String toString() {
  return 'SchedulePatternBranchItemApi(id: $id, branch: $branch, day: $day, timeStart: $timeStart, timeEnd: $timeEnd, active: $active)';
}


}

/// @nodoc
abstract mixin class $SchedulePatternBranchItemApiCopyWith<$Res>  {
  factory $SchedulePatternBranchItemApiCopyWith(SchedulePatternBranchItemApi value, $Res Function(SchedulePatternBranchItemApi) _then) = _$SchedulePatternBranchItemApiCopyWithImpl;
@useResult
$Res call({
 int id, int branch, String day,@JsonKey(name: 'time_start') String? timeStart,@JsonKey(name: 'time_end') String? timeEnd, bool active
});




}
/// @nodoc
class _$SchedulePatternBranchItemApiCopyWithImpl<$Res>
    implements $SchedulePatternBranchItemApiCopyWith<$Res> {
  _$SchedulePatternBranchItemApiCopyWithImpl(this._self, this._then);

  final SchedulePatternBranchItemApi _self;
  final $Res Function(SchedulePatternBranchItemApi) _then;

/// Create a copy of SchedulePatternBranchItemApi
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? branch = null,Object? day = null,Object? timeStart = freezed,Object? timeEnd = freezed,Object? active = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,branch: null == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as int,day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as String,timeStart: freezed == timeStart ? _self.timeStart : timeStart // ignore: cast_nullable_to_non_nullable
as String?,timeEnd: freezed == timeEnd ? _self.timeEnd : timeEnd // ignore: cast_nullable_to_non_nullable
as String?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SchedulePatternBranchItemApi].
extension SchedulePatternBranchItemApiPatterns on SchedulePatternBranchItemApi {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SchedulePatternBranchItemApi value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SchedulePatternBranchItemApi() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SchedulePatternBranchItemApi value)  $default,){
final _that = this;
switch (_that) {
case _SchedulePatternBranchItemApi():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SchedulePatternBranchItemApi value)?  $default,){
final _that = this;
switch (_that) {
case _SchedulePatternBranchItemApi() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int branch,  String day, @JsonKey(name: 'time_start')  String? timeStart, @JsonKey(name: 'time_end')  String? timeEnd,  bool active)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SchedulePatternBranchItemApi() when $default != null:
return $default(_that.id,_that.branch,_that.day,_that.timeStart,_that.timeEnd,_that.active);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int branch,  String day, @JsonKey(name: 'time_start')  String? timeStart, @JsonKey(name: 'time_end')  String? timeEnd,  bool active)  $default,) {final _that = this;
switch (_that) {
case _SchedulePatternBranchItemApi():
return $default(_that.id,_that.branch,_that.day,_that.timeStart,_that.timeEnd,_that.active);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int branch,  String day, @JsonKey(name: 'time_start')  String? timeStart, @JsonKey(name: 'time_end')  String? timeEnd,  bool active)?  $default,) {final _that = this;
switch (_that) {
case _SchedulePatternBranchItemApi() when $default != null:
return $default(_that.id,_that.branch,_that.day,_that.timeStart,_that.timeEnd,_that.active);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SchedulePatternBranchItemApi implements SchedulePatternBranchItemApi {
  const _SchedulePatternBranchItemApi({required this.id, required this.branch, required this.day, @JsonKey(name: 'time_start') required this.timeStart, @JsonKey(name: 'time_end') required this.timeEnd, required this.active});
  factory _SchedulePatternBranchItemApi.fromJson(Map<String, dynamic> json) => _$SchedulePatternBranchItemApiFromJson(json);

@override final  int id;
@override final  int branch;
@override final  String day;
@override@JsonKey(name: 'time_start') final  String? timeStart;
@override@JsonKey(name: 'time_end') final  String? timeEnd;
@override final  bool active;

/// Create a copy of SchedulePatternBranchItemApi
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SchedulePatternBranchItemApiCopyWith<_SchedulePatternBranchItemApi> get copyWith => __$SchedulePatternBranchItemApiCopyWithImpl<_SchedulePatternBranchItemApi>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SchedulePatternBranchItemApiToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SchedulePatternBranchItemApi&&(identical(other.id, id) || other.id == id)&&(identical(other.branch, branch) || other.branch == branch)&&(identical(other.day, day) || other.day == day)&&(identical(other.timeStart, timeStart) || other.timeStart == timeStart)&&(identical(other.timeEnd, timeEnd) || other.timeEnd == timeEnd)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,branch,day,timeStart,timeEnd,active);

@override
String toString() {
  return 'SchedulePatternBranchItemApi(id: $id, branch: $branch, day: $day, timeStart: $timeStart, timeEnd: $timeEnd, active: $active)';
}


}

/// @nodoc
abstract mixin class _$SchedulePatternBranchItemApiCopyWith<$Res> implements $SchedulePatternBranchItemApiCopyWith<$Res> {
  factory _$SchedulePatternBranchItemApiCopyWith(_SchedulePatternBranchItemApi value, $Res Function(_SchedulePatternBranchItemApi) _then) = __$SchedulePatternBranchItemApiCopyWithImpl;
@override @useResult
$Res call({
 int id, int branch, String day,@JsonKey(name: 'time_start') String? timeStart,@JsonKey(name: 'time_end') String? timeEnd, bool active
});




}
/// @nodoc
class __$SchedulePatternBranchItemApiCopyWithImpl<$Res>
    implements _$SchedulePatternBranchItemApiCopyWith<$Res> {
  __$SchedulePatternBranchItemApiCopyWithImpl(this._self, this._then);

  final _SchedulePatternBranchItemApi _self;
  final $Res Function(_SchedulePatternBranchItemApi) _then;

/// Create a copy of SchedulePatternBranchItemApi
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? branch = null,Object? day = null,Object? timeStart = freezed,Object? timeEnd = freezed,Object? active = null,}) {
  return _then(_SchedulePatternBranchItemApi(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,branch: null == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as int,day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as String,timeStart: freezed == timeStart ? _self.timeStart : timeStart // ignore: cast_nullable_to_non_nullable
as String?,timeEnd: freezed == timeEnd ? _self.timeEnd : timeEnd // ignore: cast_nullable_to_non_nullable
as String?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
