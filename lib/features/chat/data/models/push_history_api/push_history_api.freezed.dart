// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'push_history_api.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PushHistoryApiResponse {

 int get count; String? get next; String? get previous; List<PushHistoryItemApi> get results;
/// Create a copy of PushHistoryApiResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PushHistoryApiResponseCopyWith<PushHistoryApiResponse> get copyWith => _$PushHistoryApiResponseCopyWithImpl<PushHistoryApiResponse>(this as PushHistoryApiResponse, _$identity);

  /// Serializes this PushHistoryApiResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PushHistoryApiResponse&&(identical(other.count, count) || other.count == count)&&(identical(other.next, next) || other.next == next)&&(identical(other.previous, previous) || other.previous == previous)&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,next,previous,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'PushHistoryApiResponse(count: $count, next: $next, previous: $previous, results: $results)';
}


}

/// @nodoc
abstract mixin class $PushHistoryApiResponseCopyWith<$Res>  {
  factory $PushHistoryApiResponseCopyWith(PushHistoryApiResponse value, $Res Function(PushHistoryApiResponse) _then) = _$PushHistoryApiResponseCopyWithImpl;
@useResult
$Res call({
 int count, String? next, String? previous, List<PushHistoryItemApi> results
});




}
/// @nodoc
class _$PushHistoryApiResponseCopyWithImpl<$Res>
    implements $PushHistoryApiResponseCopyWith<$Res> {
  _$PushHistoryApiResponseCopyWithImpl(this._self, this._then);

  final PushHistoryApiResponse _self;
  final $Res Function(PushHistoryApiResponse) _then;

/// Create a copy of PushHistoryApiResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? next = freezed,Object? previous = freezed,Object? results = null,}) {
  return _then(_self.copyWith(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as String?,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<PushHistoryItemApi>,
  ));
}

}


/// Adds pattern-matching-related methods to [PushHistoryApiResponse].
extension PushHistoryApiResponsePatterns on PushHistoryApiResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PushHistoryApiResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PushHistoryApiResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PushHistoryApiResponse value)  $default,){
final _that = this;
switch (_that) {
case _PushHistoryApiResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PushHistoryApiResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PushHistoryApiResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count,  String? next,  String? previous,  List<PushHistoryItemApi> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PushHistoryApiResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count,  String? next,  String? previous,  List<PushHistoryItemApi> results)  $default,) {final _that = this;
switch (_that) {
case _PushHistoryApiResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count,  String? next,  String? previous,  List<PushHistoryItemApi> results)?  $default,) {final _that = this;
switch (_that) {
case _PushHistoryApiResponse() when $default != null:
return $default(_that.count,_that.next,_that.previous,_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PushHistoryApiResponse implements PushHistoryApiResponse {
  const _PushHistoryApiResponse({required this.count, required this.next, required this.previous, required final  List<PushHistoryItemApi> results}): _results = results;
  factory _PushHistoryApiResponse.fromJson(Map<String, dynamic> json) => _$PushHistoryApiResponseFromJson(json);

@override final  int count;
@override final  String? next;
@override final  String? previous;
 final  List<PushHistoryItemApi> _results;
@override List<PushHistoryItemApi> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of PushHistoryApiResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PushHistoryApiResponseCopyWith<_PushHistoryApiResponse> get copyWith => __$PushHistoryApiResponseCopyWithImpl<_PushHistoryApiResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PushHistoryApiResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PushHistoryApiResponse&&(identical(other.count, count) || other.count == count)&&(identical(other.next, next) || other.next == next)&&(identical(other.previous, previous) || other.previous == previous)&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,next,previous,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'PushHistoryApiResponse(count: $count, next: $next, previous: $previous, results: $results)';
}


}

/// @nodoc
abstract mixin class _$PushHistoryApiResponseCopyWith<$Res> implements $PushHistoryApiResponseCopyWith<$Res> {
  factory _$PushHistoryApiResponseCopyWith(_PushHistoryApiResponse value, $Res Function(_PushHistoryApiResponse) _then) = __$PushHistoryApiResponseCopyWithImpl;
@override @useResult
$Res call({
 int count, String? next, String? previous, List<PushHistoryItemApi> results
});




}
/// @nodoc
class __$PushHistoryApiResponseCopyWithImpl<$Res>
    implements _$PushHistoryApiResponseCopyWith<$Res> {
  __$PushHistoryApiResponseCopyWithImpl(this._self, this._then);

  final _PushHistoryApiResponse _self;
  final $Res Function(_PushHistoryApiResponse) _then;

/// Create a copy of PushHistoryApiResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? next = freezed,Object? previous = freezed,Object? results = null,}) {
  return _then(_PushHistoryApiResponse(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as String?,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<PushHistoryItemApi>,
  ));
}


}


/// @nodoc
mixin _$PushHistoryItemApi {

 int get id; String? get type; String? get title; String? get body; Map<String, dynamic>? get payload; String? get status; String? get error; int? get appointment; int? get branch;@JsonKey(name: 'is_read') bool get isRead;@JsonKey(name: 'read_at') String? get readAt;@JsonKey(name: 'sent_at') String? get sentAt;@JsonKey(name: 'report_date') String? get reportDate;@JsonKey(name: 'delivered_devices_count') int? get deliveredDevicesCount;@JsonKey(name: 'failed_devices_count') int? get failedDevicesCount; String? get created;
/// Create a copy of PushHistoryItemApi
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PushHistoryItemApiCopyWith<PushHistoryItemApi> get copyWith => _$PushHistoryItemApiCopyWithImpl<PushHistoryItemApi>(this as PushHistoryItemApi, _$identity);

  /// Serializes this PushHistoryItemApi to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PushHistoryItemApi&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other.payload, payload)&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.appointment, appointment) || other.appointment == appointment)&&(identical(other.branch, branch) || other.branch == branch)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.readAt, readAt) || other.readAt == readAt)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt)&&(identical(other.reportDate, reportDate) || other.reportDate == reportDate)&&(identical(other.deliveredDevicesCount, deliveredDevicesCount) || other.deliveredDevicesCount == deliveredDevicesCount)&&(identical(other.failedDevicesCount, failedDevicesCount) || other.failedDevicesCount == failedDevicesCount)&&(identical(other.created, created) || other.created == created));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,body,const DeepCollectionEquality().hash(payload),status,error,appointment,branch,isRead,readAt,sentAt,reportDate,deliveredDevicesCount,failedDevicesCount,created);

@override
String toString() {
  return 'PushHistoryItemApi(id: $id, type: $type, title: $title, body: $body, payload: $payload, status: $status, error: $error, appointment: $appointment, branch: $branch, isRead: $isRead, readAt: $readAt, sentAt: $sentAt, reportDate: $reportDate, deliveredDevicesCount: $deliveredDevicesCount, failedDevicesCount: $failedDevicesCount, created: $created)';
}


}

/// @nodoc
abstract mixin class $PushHistoryItemApiCopyWith<$Res>  {
  factory $PushHistoryItemApiCopyWith(PushHistoryItemApi value, $Res Function(PushHistoryItemApi) _then) = _$PushHistoryItemApiCopyWithImpl;
@useResult
$Res call({
 int id, String? type, String? title, String? body, Map<String, dynamic>? payload, String? status, String? error, int? appointment, int? branch,@JsonKey(name: 'is_read') bool isRead,@JsonKey(name: 'read_at') String? readAt,@JsonKey(name: 'sent_at') String? sentAt,@JsonKey(name: 'report_date') String? reportDate,@JsonKey(name: 'delivered_devices_count') int? deliveredDevicesCount,@JsonKey(name: 'failed_devices_count') int? failedDevicesCount, String? created
});




}
/// @nodoc
class _$PushHistoryItemApiCopyWithImpl<$Res>
    implements $PushHistoryItemApiCopyWith<$Res> {
  _$PushHistoryItemApiCopyWithImpl(this._self, this._then);

  final PushHistoryItemApi _self;
  final $Res Function(PushHistoryItemApi) _then;

/// Create a copy of PushHistoryItemApi
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = freezed,Object? title = freezed,Object? body = freezed,Object? payload = freezed,Object? status = freezed,Object? error = freezed,Object? appointment = freezed,Object? branch = freezed,Object? isRead = null,Object? readAt = freezed,Object? sentAt = freezed,Object? reportDate = freezed,Object? deliveredDevicesCount = freezed,Object? failedDevicesCount = freezed,Object? created = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,payload: freezed == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,appointment: freezed == appointment ? _self.appointment : appointment // ignore: cast_nullable_to_non_nullable
as int?,branch: freezed == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as int?,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as String?,sentAt: freezed == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as String?,reportDate: freezed == reportDate ? _self.reportDate : reportDate // ignore: cast_nullable_to_non_nullable
as String?,deliveredDevicesCount: freezed == deliveredDevicesCount ? _self.deliveredDevicesCount : deliveredDevicesCount // ignore: cast_nullable_to_non_nullable
as int?,failedDevicesCount: freezed == failedDevicesCount ? _self.failedDevicesCount : failedDevicesCount // ignore: cast_nullable_to_non_nullable
as int?,created: freezed == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PushHistoryItemApi].
extension PushHistoryItemApiPatterns on PushHistoryItemApi {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PushHistoryItemApi value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PushHistoryItemApi() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PushHistoryItemApi value)  $default,){
final _that = this;
switch (_that) {
case _PushHistoryItemApi():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PushHistoryItemApi value)?  $default,){
final _that = this;
switch (_that) {
case _PushHistoryItemApi() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? type,  String? title,  String? body,  Map<String, dynamic>? payload,  String? status,  String? error,  int? appointment,  int? branch, @JsonKey(name: 'is_read')  bool isRead, @JsonKey(name: 'read_at')  String? readAt, @JsonKey(name: 'sent_at')  String? sentAt, @JsonKey(name: 'report_date')  String? reportDate, @JsonKey(name: 'delivered_devices_count')  int? deliveredDevicesCount, @JsonKey(name: 'failed_devices_count')  int? failedDevicesCount,  String? created)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PushHistoryItemApi() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.body,_that.payload,_that.status,_that.error,_that.appointment,_that.branch,_that.isRead,_that.readAt,_that.sentAt,_that.reportDate,_that.deliveredDevicesCount,_that.failedDevicesCount,_that.created);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? type,  String? title,  String? body,  Map<String, dynamic>? payload,  String? status,  String? error,  int? appointment,  int? branch, @JsonKey(name: 'is_read')  bool isRead, @JsonKey(name: 'read_at')  String? readAt, @JsonKey(name: 'sent_at')  String? sentAt, @JsonKey(name: 'report_date')  String? reportDate, @JsonKey(name: 'delivered_devices_count')  int? deliveredDevicesCount, @JsonKey(name: 'failed_devices_count')  int? failedDevicesCount,  String? created)  $default,) {final _that = this;
switch (_that) {
case _PushHistoryItemApi():
return $default(_that.id,_that.type,_that.title,_that.body,_that.payload,_that.status,_that.error,_that.appointment,_that.branch,_that.isRead,_that.readAt,_that.sentAt,_that.reportDate,_that.deliveredDevicesCount,_that.failedDevicesCount,_that.created);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? type,  String? title,  String? body,  Map<String, dynamic>? payload,  String? status,  String? error,  int? appointment,  int? branch, @JsonKey(name: 'is_read')  bool isRead, @JsonKey(name: 'read_at')  String? readAt, @JsonKey(name: 'sent_at')  String? sentAt, @JsonKey(name: 'report_date')  String? reportDate, @JsonKey(name: 'delivered_devices_count')  int? deliveredDevicesCount, @JsonKey(name: 'failed_devices_count')  int? failedDevicesCount,  String? created)?  $default,) {final _that = this;
switch (_that) {
case _PushHistoryItemApi() when $default != null:
return $default(_that.id,_that.type,_that.title,_that.body,_that.payload,_that.status,_that.error,_that.appointment,_that.branch,_that.isRead,_that.readAt,_that.sentAt,_that.reportDate,_that.deliveredDevicesCount,_that.failedDevicesCount,_that.created);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PushHistoryItemApi extends PushHistoryItemApi {
  const _PushHistoryItemApi({required this.id, required this.type, required this.title, required this.body, required final  Map<String, dynamic>? payload, required this.status, required this.error, required this.appointment, required this.branch, @JsonKey(name: 'is_read') required this.isRead, @JsonKey(name: 'read_at') required this.readAt, @JsonKey(name: 'sent_at') required this.sentAt, @JsonKey(name: 'report_date') required this.reportDate, @JsonKey(name: 'delivered_devices_count') required this.deliveredDevicesCount, @JsonKey(name: 'failed_devices_count') required this.failedDevicesCount, required this.created}): _payload = payload,super._();
  factory _PushHistoryItemApi.fromJson(Map<String, dynamic> json) => _$PushHistoryItemApiFromJson(json);

@override final  int id;
@override final  String? type;
@override final  String? title;
@override final  String? body;
 final  Map<String, dynamic>? _payload;
@override Map<String, dynamic>? get payload {
  final value = _payload;
  if (value == null) return null;
  if (_payload is EqualUnmodifiableMapView) return _payload;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String? status;
@override final  String? error;
@override final  int? appointment;
@override final  int? branch;
@override@JsonKey(name: 'is_read') final  bool isRead;
@override@JsonKey(name: 'read_at') final  String? readAt;
@override@JsonKey(name: 'sent_at') final  String? sentAt;
@override@JsonKey(name: 'report_date') final  String? reportDate;
@override@JsonKey(name: 'delivered_devices_count') final  int? deliveredDevicesCount;
@override@JsonKey(name: 'failed_devices_count') final  int? failedDevicesCount;
@override final  String? created;

/// Create a copy of PushHistoryItemApi
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PushHistoryItemApiCopyWith<_PushHistoryItemApi> get copyWith => __$PushHistoryItemApiCopyWithImpl<_PushHistoryItemApi>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PushHistoryItemApiToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PushHistoryItemApi&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.body, body) || other.body == body)&&const DeepCollectionEquality().equals(other._payload, _payload)&&(identical(other.status, status) || other.status == status)&&(identical(other.error, error) || other.error == error)&&(identical(other.appointment, appointment) || other.appointment == appointment)&&(identical(other.branch, branch) || other.branch == branch)&&(identical(other.isRead, isRead) || other.isRead == isRead)&&(identical(other.readAt, readAt) || other.readAt == readAt)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt)&&(identical(other.reportDate, reportDate) || other.reportDate == reportDate)&&(identical(other.deliveredDevicesCount, deliveredDevicesCount) || other.deliveredDevicesCount == deliveredDevicesCount)&&(identical(other.failedDevicesCount, failedDevicesCount) || other.failedDevicesCount == failedDevicesCount)&&(identical(other.created, created) || other.created == created));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,title,body,const DeepCollectionEquality().hash(_payload),status,error,appointment,branch,isRead,readAt,sentAt,reportDate,deliveredDevicesCount,failedDevicesCount,created);

@override
String toString() {
  return 'PushHistoryItemApi(id: $id, type: $type, title: $title, body: $body, payload: $payload, status: $status, error: $error, appointment: $appointment, branch: $branch, isRead: $isRead, readAt: $readAt, sentAt: $sentAt, reportDate: $reportDate, deliveredDevicesCount: $deliveredDevicesCount, failedDevicesCount: $failedDevicesCount, created: $created)';
}


}

/// @nodoc
abstract mixin class _$PushHistoryItemApiCopyWith<$Res> implements $PushHistoryItemApiCopyWith<$Res> {
  factory _$PushHistoryItemApiCopyWith(_PushHistoryItemApi value, $Res Function(_PushHistoryItemApi) _then) = __$PushHistoryItemApiCopyWithImpl;
@override @useResult
$Res call({
 int id, String? type, String? title, String? body, Map<String, dynamic>? payload, String? status, String? error, int? appointment, int? branch,@JsonKey(name: 'is_read') bool isRead,@JsonKey(name: 'read_at') String? readAt,@JsonKey(name: 'sent_at') String? sentAt,@JsonKey(name: 'report_date') String? reportDate,@JsonKey(name: 'delivered_devices_count') int? deliveredDevicesCount,@JsonKey(name: 'failed_devices_count') int? failedDevicesCount, String? created
});




}
/// @nodoc
class __$PushHistoryItemApiCopyWithImpl<$Res>
    implements _$PushHistoryItemApiCopyWith<$Res> {
  __$PushHistoryItemApiCopyWithImpl(this._self, this._then);

  final _PushHistoryItemApi _self;
  final $Res Function(_PushHistoryItemApi) _then;

/// Create a copy of PushHistoryItemApi
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = freezed,Object? title = freezed,Object? body = freezed,Object? payload = freezed,Object? status = freezed,Object? error = freezed,Object? appointment = freezed,Object? branch = freezed,Object? isRead = null,Object? readAt = freezed,Object? sentAt = freezed,Object? reportDate = freezed,Object? deliveredDevicesCount = freezed,Object? failedDevicesCount = freezed,Object? created = freezed,}) {
  return _then(_PushHistoryItemApi(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,body: freezed == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String?,payload: freezed == payload ? _self._payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,appointment: freezed == appointment ? _self.appointment : appointment // ignore: cast_nullable_to_non_nullable
as int?,branch: freezed == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as int?,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as String?,sentAt: freezed == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as String?,reportDate: freezed == reportDate ? _self.reportDate : reportDate // ignore: cast_nullable_to_non_nullable
as String?,deliveredDevicesCount: freezed == deliveredDevicesCount ? _self.deliveredDevicesCount : deliveredDevicesCount // ignore: cast_nullable_to_non_nullable
as int?,failedDevicesCount: freezed == failedDevicesCount ? _self.failedDevicesCount : failedDevicesCount // ignore: cast_nullable_to_non_nullable
as int?,created: freezed == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
