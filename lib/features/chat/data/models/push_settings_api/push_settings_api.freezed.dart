// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'push_settings_api.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PushSettingsDeviceApi {

 int get id; int? get organization; int? get branch;@JsonKey(name: 'device_id') String? get deviceId; String? get platform;@JsonKey(name: 'push_enabled') bool get pushEnabled;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'last_seen') String? get lastSeen; String? get created; String? get updated;
/// Create a copy of PushSettingsDeviceApi
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PushSettingsDeviceApiCopyWith<PushSettingsDeviceApi> get copyWith => _$PushSettingsDeviceApiCopyWithImpl<PushSettingsDeviceApi>(this as PushSettingsDeviceApi, _$identity);

  /// Serializes this PushSettingsDeviceApi to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PushSettingsDeviceApi&&(identical(other.id, id) || other.id == id)&&(identical(other.organization, organization) || other.organization == organization)&&(identical(other.branch, branch) || other.branch == branch)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.pushEnabled, pushEnabled) || other.pushEnabled == pushEnabled)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.lastSeen, lastSeen) || other.lastSeen == lastSeen)&&(identical(other.created, created) || other.created == created)&&(identical(other.updated, updated) || other.updated == updated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,organization,branch,deviceId,platform,pushEnabled,isActive,lastSeen,created,updated);

@override
String toString() {
  return 'PushSettingsDeviceApi(id: $id, organization: $organization, branch: $branch, deviceId: $deviceId, platform: $platform, pushEnabled: $pushEnabled, isActive: $isActive, lastSeen: $lastSeen, created: $created, updated: $updated)';
}


}

/// @nodoc
abstract mixin class $PushSettingsDeviceApiCopyWith<$Res>  {
  factory $PushSettingsDeviceApiCopyWith(PushSettingsDeviceApi value, $Res Function(PushSettingsDeviceApi) _then) = _$PushSettingsDeviceApiCopyWithImpl;
@useResult
$Res call({
 int id, int? organization, int? branch,@JsonKey(name: 'device_id') String? deviceId, String? platform,@JsonKey(name: 'push_enabled') bool pushEnabled,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'last_seen') String? lastSeen, String? created, String? updated
});




}
/// @nodoc
class _$PushSettingsDeviceApiCopyWithImpl<$Res>
    implements $PushSettingsDeviceApiCopyWith<$Res> {
  _$PushSettingsDeviceApiCopyWithImpl(this._self, this._then);

  final PushSettingsDeviceApi _self;
  final $Res Function(PushSettingsDeviceApi) _then;

/// Create a copy of PushSettingsDeviceApi
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? organization = freezed,Object? branch = freezed,Object? deviceId = freezed,Object? platform = freezed,Object? pushEnabled = null,Object? isActive = null,Object? lastSeen = freezed,Object? created = freezed,Object? updated = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,organization: freezed == organization ? _self.organization : organization // ignore: cast_nullable_to_non_nullable
as int?,branch: freezed == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as int?,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,pushEnabled: null == pushEnabled ? _self.pushEnabled : pushEnabled // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,lastSeen: freezed == lastSeen ? _self.lastSeen : lastSeen // ignore: cast_nullable_to_non_nullable
as String?,created: freezed == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as String?,updated: freezed == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PushSettingsDeviceApi].
extension PushSettingsDeviceApiPatterns on PushSettingsDeviceApi {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PushSettingsDeviceApi value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PushSettingsDeviceApi() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PushSettingsDeviceApi value)  $default,){
final _that = this;
switch (_that) {
case _PushSettingsDeviceApi():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PushSettingsDeviceApi value)?  $default,){
final _that = this;
switch (_that) {
case _PushSettingsDeviceApi() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int? organization,  int? branch, @JsonKey(name: 'device_id')  String? deviceId,  String? platform, @JsonKey(name: 'push_enabled')  bool pushEnabled, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'last_seen')  String? lastSeen,  String? created,  String? updated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PushSettingsDeviceApi() when $default != null:
return $default(_that.id,_that.organization,_that.branch,_that.deviceId,_that.platform,_that.pushEnabled,_that.isActive,_that.lastSeen,_that.created,_that.updated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int? organization,  int? branch, @JsonKey(name: 'device_id')  String? deviceId,  String? platform, @JsonKey(name: 'push_enabled')  bool pushEnabled, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'last_seen')  String? lastSeen,  String? created,  String? updated)  $default,) {final _that = this;
switch (_that) {
case _PushSettingsDeviceApi():
return $default(_that.id,_that.organization,_that.branch,_that.deviceId,_that.platform,_that.pushEnabled,_that.isActive,_that.lastSeen,_that.created,_that.updated);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int? organization,  int? branch, @JsonKey(name: 'device_id')  String? deviceId,  String? platform, @JsonKey(name: 'push_enabled')  bool pushEnabled, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'last_seen')  String? lastSeen,  String? created,  String? updated)?  $default,) {final _that = this;
switch (_that) {
case _PushSettingsDeviceApi() when $default != null:
return $default(_that.id,_that.organization,_that.branch,_that.deviceId,_that.platform,_that.pushEnabled,_that.isActive,_that.lastSeen,_that.created,_that.updated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PushSettingsDeviceApi implements PushSettingsDeviceApi {
  const _PushSettingsDeviceApi({required this.id, required this.organization, required this.branch, @JsonKey(name: 'device_id') required this.deviceId, required this.platform, @JsonKey(name: 'push_enabled') required this.pushEnabled, @JsonKey(name: 'is_active') required this.isActive, @JsonKey(name: 'last_seen') required this.lastSeen, required this.created, required this.updated});
  factory _PushSettingsDeviceApi.fromJson(Map<String, dynamic> json) => _$PushSettingsDeviceApiFromJson(json);

@override final  int id;
@override final  int? organization;
@override final  int? branch;
@override@JsonKey(name: 'device_id') final  String? deviceId;
@override final  String? platform;
@override@JsonKey(name: 'push_enabled') final  bool pushEnabled;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'last_seen') final  String? lastSeen;
@override final  String? created;
@override final  String? updated;

/// Create a copy of PushSettingsDeviceApi
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PushSettingsDeviceApiCopyWith<_PushSettingsDeviceApi> get copyWith => __$PushSettingsDeviceApiCopyWithImpl<_PushSettingsDeviceApi>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PushSettingsDeviceApiToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PushSettingsDeviceApi&&(identical(other.id, id) || other.id == id)&&(identical(other.organization, organization) || other.organization == organization)&&(identical(other.branch, branch) || other.branch == branch)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.pushEnabled, pushEnabled) || other.pushEnabled == pushEnabled)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.lastSeen, lastSeen) || other.lastSeen == lastSeen)&&(identical(other.created, created) || other.created == created)&&(identical(other.updated, updated) || other.updated == updated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,organization,branch,deviceId,platform,pushEnabled,isActive,lastSeen,created,updated);

@override
String toString() {
  return 'PushSettingsDeviceApi(id: $id, organization: $organization, branch: $branch, deviceId: $deviceId, platform: $platform, pushEnabled: $pushEnabled, isActive: $isActive, lastSeen: $lastSeen, created: $created, updated: $updated)';
}


}

/// @nodoc
abstract mixin class _$PushSettingsDeviceApiCopyWith<$Res> implements $PushSettingsDeviceApiCopyWith<$Res> {
  factory _$PushSettingsDeviceApiCopyWith(_PushSettingsDeviceApi value, $Res Function(_PushSettingsDeviceApi) _then) = __$PushSettingsDeviceApiCopyWithImpl;
@override @useResult
$Res call({
 int id, int? organization, int? branch,@JsonKey(name: 'device_id') String? deviceId, String? platform,@JsonKey(name: 'push_enabled') bool pushEnabled,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'last_seen') String? lastSeen, String? created, String? updated
});




}
/// @nodoc
class __$PushSettingsDeviceApiCopyWithImpl<$Res>
    implements _$PushSettingsDeviceApiCopyWith<$Res> {
  __$PushSettingsDeviceApiCopyWithImpl(this._self, this._then);

  final _PushSettingsDeviceApi _self;
  final $Res Function(_PushSettingsDeviceApi) _then;

/// Create a copy of PushSettingsDeviceApi
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? organization = freezed,Object? branch = freezed,Object? deviceId = freezed,Object? platform = freezed,Object? pushEnabled = null,Object? isActive = null,Object? lastSeen = freezed,Object? created = freezed,Object? updated = freezed,}) {
  return _then(_PushSettingsDeviceApi(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,organization: freezed == organization ? _self.organization : organization // ignore: cast_nullable_to_non_nullable
as int?,branch: freezed == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as int?,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,pushEnabled: null == pushEnabled ? _self.pushEnabled : pushEnabled // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,lastSeen: freezed == lastSeen ? _self.lastSeen : lastSeen // ignore: cast_nullable_to_non_nullable
as String?,created: freezed == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as String?,updated: freezed == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$UpdatePushSettingsRequest {

 int get organization;@JsonKey(name: 'push_enabled') bool get pushEnabled; int? get id; String? get token;@JsonKey(name: 'device_id') String? get deviceId;
/// Create a copy of UpdatePushSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdatePushSettingsRequestCopyWith<UpdatePushSettingsRequest> get copyWith => _$UpdatePushSettingsRequestCopyWithImpl<UpdatePushSettingsRequest>(this as UpdatePushSettingsRequest, _$identity);

  /// Serializes this UpdatePushSettingsRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdatePushSettingsRequest&&(identical(other.organization, organization) || other.organization == organization)&&(identical(other.pushEnabled, pushEnabled) || other.pushEnabled == pushEnabled)&&(identical(other.id, id) || other.id == id)&&(identical(other.token, token) || other.token == token)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,organization,pushEnabled,id,token,deviceId);

@override
String toString() {
  return 'UpdatePushSettingsRequest(organization: $organization, pushEnabled: $pushEnabled, id: $id, token: $token, deviceId: $deviceId)';
}


}

/// @nodoc
abstract mixin class $UpdatePushSettingsRequestCopyWith<$Res>  {
  factory $UpdatePushSettingsRequestCopyWith(UpdatePushSettingsRequest value, $Res Function(UpdatePushSettingsRequest) _then) = _$UpdatePushSettingsRequestCopyWithImpl;
@useResult
$Res call({
 int organization,@JsonKey(name: 'push_enabled') bool pushEnabled, int? id, String? token,@JsonKey(name: 'device_id') String? deviceId
});




}
/// @nodoc
class _$UpdatePushSettingsRequestCopyWithImpl<$Res>
    implements $UpdatePushSettingsRequestCopyWith<$Res> {
  _$UpdatePushSettingsRequestCopyWithImpl(this._self, this._then);

  final UpdatePushSettingsRequest _self;
  final $Res Function(UpdatePushSettingsRequest) _then;

/// Create a copy of UpdatePushSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? organization = null,Object? pushEnabled = null,Object? id = freezed,Object? token = freezed,Object? deviceId = freezed,}) {
  return _then(_self.copyWith(
organization: null == organization ? _self.organization : organization // ignore: cast_nullable_to_non_nullable
as int,pushEnabled: null == pushEnabled ? _self.pushEnabled : pushEnabled // ignore: cast_nullable_to_non_nullable
as bool,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdatePushSettingsRequest].
extension UpdatePushSettingsRequestPatterns on UpdatePushSettingsRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdatePushSettingsRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdatePushSettingsRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdatePushSettingsRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdatePushSettingsRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdatePushSettingsRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdatePushSettingsRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int organization, @JsonKey(name: 'push_enabled')  bool pushEnabled,  int? id,  String? token, @JsonKey(name: 'device_id')  String? deviceId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdatePushSettingsRequest() when $default != null:
return $default(_that.organization,_that.pushEnabled,_that.id,_that.token,_that.deviceId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int organization, @JsonKey(name: 'push_enabled')  bool pushEnabled,  int? id,  String? token, @JsonKey(name: 'device_id')  String? deviceId)  $default,) {final _that = this;
switch (_that) {
case _UpdatePushSettingsRequest():
return $default(_that.organization,_that.pushEnabled,_that.id,_that.token,_that.deviceId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int organization, @JsonKey(name: 'push_enabled')  bool pushEnabled,  int? id,  String? token, @JsonKey(name: 'device_id')  String? deviceId)?  $default,) {final _that = this;
switch (_that) {
case _UpdatePushSettingsRequest() when $default != null:
return $default(_that.organization,_that.pushEnabled,_that.id,_that.token,_that.deviceId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdatePushSettingsRequest implements UpdatePushSettingsRequest {
  const _UpdatePushSettingsRequest({required this.organization, @JsonKey(name: 'push_enabled') required this.pushEnabled, this.id, this.token, @JsonKey(name: 'device_id') this.deviceId});
  factory _UpdatePushSettingsRequest.fromJson(Map<String, dynamic> json) => _$UpdatePushSettingsRequestFromJson(json);

@override final  int organization;
@override@JsonKey(name: 'push_enabled') final  bool pushEnabled;
@override final  int? id;
@override final  String? token;
@override@JsonKey(name: 'device_id') final  String? deviceId;

/// Create a copy of UpdatePushSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdatePushSettingsRequestCopyWith<_UpdatePushSettingsRequest> get copyWith => __$UpdatePushSettingsRequestCopyWithImpl<_UpdatePushSettingsRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdatePushSettingsRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdatePushSettingsRequest&&(identical(other.organization, organization) || other.organization == organization)&&(identical(other.pushEnabled, pushEnabled) || other.pushEnabled == pushEnabled)&&(identical(other.id, id) || other.id == id)&&(identical(other.token, token) || other.token == token)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,organization,pushEnabled,id,token,deviceId);

@override
String toString() {
  return 'UpdatePushSettingsRequest(organization: $organization, pushEnabled: $pushEnabled, id: $id, token: $token, deviceId: $deviceId)';
}


}

/// @nodoc
abstract mixin class _$UpdatePushSettingsRequestCopyWith<$Res> implements $UpdatePushSettingsRequestCopyWith<$Res> {
  factory _$UpdatePushSettingsRequestCopyWith(_UpdatePushSettingsRequest value, $Res Function(_UpdatePushSettingsRequest) _then) = __$UpdatePushSettingsRequestCopyWithImpl;
@override @useResult
$Res call({
 int organization,@JsonKey(name: 'push_enabled') bool pushEnabled, int? id, String? token,@JsonKey(name: 'device_id') String? deviceId
});




}
/// @nodoc
class __$UpdatePushSettingsRequestCopyWithImpl<$Res>
    implements _$UpdatePushSettingsRequestCopyWith<$Res> {
  __$UpdatePushSettingsRequestCopyWithImpl(this._self, this._then);

  final _UpdatePushSettingsRequest _self;
  final $Res Function(_UpdatePushSettingsRequest) _then;

/// Create a copy of UpdatePushSettingsRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? organization = null,Object? pushEnabled = null,Object? id = freezed,Object? token = freezed,Object? deviceId = freezed,}) {
  return _then(_UpdatePushSettingsRequest(
organization: null == organization ? _self.organization : organization // ignore: cast_nullable_to_non_nullable
as int,pushEnabled: null == pushEnabled ? _self.pushEnabled : pushEnabled // ignore: cast_nullable_to_non_nullable
as bool,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$UpdatePushSettingsResponse {

 int get updated;
/// Create a copy of UpdatePushSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdatePushSettingsResponseCopyWith<UpdatePushSettingsResponse> get copyWith => _$UpdatePushSettingsResponseCopyWithImpl<UpdatePushSettingsResponse>(this as UpdatePushSettingsResponse, _$identity);

  /// Serializes this UpdatePushSettingsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdatePushSettingsResponse&&(identical(other.updated, updated) || other.updated == updated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,updated);

@override
String toString() {
  return 'UpdatePushSettingsResponse(updated: $updated)';
}


}

/// @nodoc
abstract mixin class $UpdatePushSettingsResponseCopyWith<$Res>  {
  factory $UpdatePushSettingsResponseCopyWith(UpdatePushSettingsResponse value, $Res Function(UpdatePushSettingsResponse) _then) = _$UpdatePushSettingsResponseCopyWithImpl;
@useResult
$Res call({
 int updated
});




}
/// @nodoc
class _$UpdatePushSettingsResponseCopyWithImpl<$Res>
    implements $UpdatePushSettingsResponseCopyWith<$Res> {
  _$UpdatePushSettingsResponseCopyWithImpl(this._self, this._then);

  final UpdatePushSettingsResponse _self;
  final $Res Function(UpdatePushSettingsResponse) _then;

/// Create a copy of UpdatePushSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? updated = null,}) {
  return _then(_self.copyWith(
updated: null == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdatePushSettingsResponse].
extension UpdatePushSettingsResponsePatterns on UpdatePushSettingsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdatePushSettingsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdatePushSettingsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdatePushSettingsResponse value)  $default,){
final _that = this;
switch (_that) {
case _UpdatePushSettingsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdatePushSettingsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _UpdatePushSettingsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int updated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdatePushSettingsResponse() when $default != null:
return $default(_that.updated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int updated)  $default,) {final _that = this;
switch (_that) {
case _UpdatePushSettingsResponse():
return $default(_that.updated);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int updated)?  $default,) {final _that = this;
switch (_that) {
case _UpdatePushSettingsResponse() when $default != null:
return $default(_that.updated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdatePushSettingsResponse implements UpdatePushSettingsResponse {
  const _UpdatePushSettingsResponse({required this.updated});
  factory _UpdatePushSettingsResponse.fromJson(Map<String, dynamic> json) => _$UpdatePushSettingsResponseFromJson(json);

@override final  int updated;

/// Create a copy of UpdatePushSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdatePushSettingsResponseCopyWith<_UpdatePushSettingsResponse> get copyWith => __$UpdatePushSettingsResponseCopyWithImpl<_UpdatePushSettingsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdatePushSettingsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdatePushSettingsResponse&&(identical(other.updated, updated) || other.updated == updated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,updated);

@override
String toString() {
  return 'UpdatePushSettingsResponse(updated: $updated)';
}


}

/// @nodoc
abstract mixin class _$UpdatePushSettingsResponseCopyWith<$Res> implements $UpdatePushSettingsResponseCopyWith<$Res> {
  factory _$UpdatePushSettingsResponseCopyWith(_UpdatePushSettingsResponse value, $Res Function(_UpdatePushSettingsResponse) _then) = __$UpdatePushSettingsResponseCopyWithImpl;
@override @useResult
$Res call({
 int updated
});




}
/// @nodoc
class __$UpdatePushSettingsResponseCopyWithImpl<$Res>
    implements _$UpdatePushSettingsResponseCopyWith<$Res> {
  __$UpdatePushSettingsResponseCopyWithImpl(this._self, this._then);

  final _UpdatePushSettingsResponse _self;
  final $Res Function(_UpdatePushSettingsResponse) _then;

/// Create a copy of UpdatePushSettingsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? updated = null,}) {
  return _then(_UpdatePushSettingsResponse(
updated: null == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
