// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workers_api.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkersApiResponse {

 int get count; String? get next; String? get previous; List<WorkerApi> get results;
/// Create a copy of WorkersApiResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkersApiResponseCopyWith<WorkersApiResponse> get copyWith => _$WorkersApiResponseCopyWithImpl<WorkersApiResponse>(this as WorkersApiResponse, _$identity);

  /// Serializes this WorkersApiResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkersApiResponse&&(identical(other.count, count) || other.count == count)&&(identical(other.next, next) || other.next == next)&&(identical(other.previous, previous) || other.previous == previous)&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,next,previous,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'WorkersApiResponse(count: $count, next: $next, previous: $previous, results: $results)';
}


}

/// @nodoc
abstract mixin class $WorkersApiResponseCopyWith<$Res>  {
  factory $WorkersApiResponseCopyWith(WorkersApiResponse value, $Res Function(WorkersApiResponse) _then) = _$WorkersApiResponseCopyWithImpl;
@useResult
$Res call({
 int count, String? next, String? previous, List<WorkerApi> results
});




}
/// @nodoc
class _$WorkersApiResponseCopyWithImpl<$Res>
    implements $WorkersApiResponseCopyWith<$Res> {
  _$WorkersApiResponseCopyWithImpl(this._self, this._then);

  final WorkersApiResponse _self;
  final $Res Function(WorkersApiResponse) _then;

/// Create a copy of WorkersApiResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? next = freezed,Object? previous = freezed,Object? results = null,}) {
  return _then(_self.copyWith(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as String?,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<WorkerApi>,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkersApiResponse].
extension WorkersApiResponsePatterns on WorkersApiResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkersApiResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkersApiResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkersApiResponse value)  $default,){
final _that = this;
switch (_that) {
case _WorkersApiResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkersApiResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WorkersApiResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count,  String? next,  String? previous,  List<WorkerApi> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkersApiResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count,  String? next,  String? previous,  List<WorkerApi> results)  $default,) {final _that = this;
switch (_that) {
case _WorkersApiResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count,  String? next,  String? previous,  List<WorkerApi> results)?  $default,) {final _that = this;
switch (_that) {
case _WorkersApiResponse() when $default != null:
return $default(_that.count,_that.next,_that.previous,_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkersApiResponse implements WorkersApiResponse {
  const _WorkersApiResponse({required this.count, required this.next, required this.previous, required final  List<WorkerApi> results}): _results = results;
  factory _WorkersApiResponse.fromJson(Map<String, dynamic> json) => _$WorkersApiResponseFromJson(json);

@override final  int count;
@override final  String? next;
@override final  String? previous;
 final  List<WorkerApi> _results;
@override List<WorkerApi> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of WorkersApiResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkersApiResponseCopyWith<_WorkersApiResponse> get copyWith => __$WorkersApiResponseCopyWithImpl<_WorkersApiResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkersApiResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkersApiResponse&&(identical(other.count, count) || other.count == count)&&(identical(other.next, next) || other.next == next)&&(identical(other.previous, previous) || other.previous == previous)&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,next,previous,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'WorkersApiResponse(count: $count, next: $next, previous: $previous, results: $results)';
}


}

/// @nodoc
abstract mixin class _$WorkersApiResponseCopyWith<$Res> implements $WorkersApiResponseCopyWith<$Res> {
  factory _$WorkersApiResponseCopyWith(_WorkersApiResponse value, $Res Function(_WorkersApiResponse) _then) = __$WorkersApiResponseCopyWithImpl;
@override @useResult
$Res call({
 int count, String? next, String? previous, List<WorkerApi> results
});




}
/// @nodoc
class __$WorkersApiResponseCopyWithImpl<$Res>
    implements _$WorkersApiResponseCopyWith<$Res> {
  __$WorkersApiResponseCopyWithImpl(this._self, this._then);

  final _WorkersApiResponse _self;
  final $Res Function(_WorkersApiResponse) _then;

/// Create a copy of WorkersApiResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? next = freezed,Object? previous = freezed,Object? results = null,}) {
  return _then(_WorkersApiResponse(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as String?,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<WorkerApi>,
  ));
}


}


/// @nodoc
mixin _$WorkerApi {

 int get id;@JsonKey(name: 'first_name') String? get firstName;@JsonKey(name: 'last_name') String? get lastName; String? get specialization; String? get picture;@JsonKey(name: 'picture_thumbnail') String? get pictureThumbnail;
/// Create a copy of WorkerApi
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkerApiCopyWith<WorkerApi> get copyWith => _$WorkerApiCopyWithImpl<WorkerApi>(this as WorkerApi, _$identity);

  /// Serializes this WorkerApi to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkerApi&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.specialization, specialization) || other.specialization == specialization)&&(identical(other.picture, picture) || other.picture == picture)&&(identical(other.pictureThumbnail, pictureThumbnail) || other.pictureThumbnail == pictureThumbnail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName,lastName,specialization,picture,pictureThumbnail);

@override
String toString() {
  return 'WorkerApi(id: $id, firstName: $firstName, lastName: $lastName, specialization: $specialization, picture: $picture, pictureThumbnail: $pictureThumbnail)';
}


}

/// @nodoc
abstract mixin class $WorkerApiCopyWith<$Res>  {
  factory $WorkerApiCopyWith(WorkerApi value, $Res Function(WorkerApi) _then) = _$WorkerApiCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'first_name') String? firstName,@JsonKey(name: 'last_name') String? lastName, String? specialization, String? picture,@JsonKey(name: 'picture_thumbnail') String? pictureThumbnail
});




}
/// @nodoc
class _$WorkerApiCopyWithImpl<$Res>
    implements $WorkerApiCopyWith<$Res> {
  _$WorkerApiCopyWithImpl(this._self, this._then);

  final WorkerApi _self;
  final $Res Function(WorkerApi) _then;

/// Create a copy of WorkerApi
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? firstName = freezed,Object? lastName = freezed,Object? specialization = freezed,Object? picture = freezed,Object? pictureThumbnail = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,specialization: freezed == specialization ? _self.specialization : specialization // ignore: cast_nullable_to_non_nullable
as String?,picture: freezed == picture ? _self.picture : picture // ignore: cast_nullable_to_non_nullable
as String?,pictureThumbnail: freezed == pictureThumbnail ? _self.pictureThumbnail : pictureThumbnail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkerApi].
extension WorkerApiPatterns on WorkerApi {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkerApi value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkerApi() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkerApi value)  $default,){
final _that = this;
switch (_that) {
case _WorkerApi():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkerApi value)?  $default,){
final _that = this;
switch (_that) {
case _WorkerApi() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName,  String? specialization,  String? picture, @JsonKey(name: 'picture_thumbnail')  String? pictureThumbnail)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkerApi() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.specialization,_that.picture,_that.pictureThumbnail);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName,  String? specialization,  String? picture, @JsonKey(name: 'picture_thumbnail')  String? pictureThumbnail)  $default,) {final _that = this;
switch (_that) {
case _WorkerApi():
return $default(_that.id,_that.firstName,_that.lastName,_that.specialization,_that.picture,_that.pictureThumbnail);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'first_name')  String? firstName, @JsonKey(name: 'last_name')  String? lastName,  String? specialization,  String? picture, @JsonKey(name: 'picture_thumbnail')  String? pictureThumbnail)?  $default,) {final _that = this;
switch (_that) {
case _WorkerApi() when $default != null:
return $default(_that.id,_that.firstName,_that.lastName,_that.specialization,_that.picture,_that.pictureThumbnail);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkerApi implements WorkerApi {
  const _WorkerApi({required this.id, @JsonKey(name: 'first_name') required this.firstName, @JsonKey(name: 'last_name') required this.lastName, required this.specialization, required this.picture, @JsonKey(name: 'picture_thumbnail') required this.pictureThumbnail});
  factory _WorkerApi.fromJson(Map<String, dynamic> json) => _$WorkerApiFromJson(json);

@override final  int id;
@override@JsonKey(name: 'first_name') final  String? firstName;
@override@JsonKey(name: 'last_name') final  String? lastName;
@override final  String? specialization;
@override final  String? picture;
@override@JsonKey(name: 'picture_thumbnail') final  String? pictureThumbnail;

/// Create a copy of WorkerApi
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkerApiCopyWith<_WorkerApi> get copyWith => __$WorkerApiCopyWithImpl<_WorkerApi>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkerApiToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkerApi&&(identical(other.id, id) || other.id == id)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.specialization, specialization) || other.specialization == specialization)&&(identical(other.picture, picture) || other.picture == picture)&&(identical(other.pictureThumbnail, pictureThumbnail) || other.pictureThumbnail == pictureThumbnail));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,firstName,lastName,specialization,picture,pictureThumbnail);

@override
String toString() {
  return 'WorkerApi(id: $id, firstName: $firstName, lastName: $lastName, specialization: $specialization, picture: $picture, pictureThumbnail: $pictureThumbnail)';
}


}

/// @nodoc
abstract mixin class _$WorkerApiCopyWith<$Res> implements $WorkerApiCopyWith<$Res> {
  factory _$WorkerApiCopyWith(_WorkerApi value, $Res Function(_WorkerApi) _then) = __$WorkerApiCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'first_name') String? firstName,@JsonKey(name: 'last_name') String? lastName, String? specialization, String? picture,@JsonKey(name: 'picture_thumbnail') String? pictureThumbnail
});




}
/// @nodoc
class __$WorkerApiCopyWithImpl<$Res>
    implements _$WorkerApiCopyWith<$Res> {
  __$WorkerApiCopyWithImpl(this._self, this._then);

  final _WorkerApi _self;
  final $Res Function(_WorkerApi) _then;

/// Create a copy of WorkerApi
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? firstName = freezed,Object? lastName = freezed,Object? specialization = freezed,Object? picture = freezed,Object? pictureThumbnail = freezed,}) {
  return _then(_WorkerApi(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,firstName: freezed == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String?,lastName: freezed == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String?,specialization: freezed == specialization ? _self.specialization : specialization // ignore: cast_nullable_to_non_nullable
as String?,picture: freezed == picture ? _self.picture : picture // ignore: cast_nullable_to_non_nullable
as String?,pictureThumbnail: freezed == pictureThumbnail ? _self.pictureThumbnail : pictureThumbnail // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
