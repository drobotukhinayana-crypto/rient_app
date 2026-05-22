// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'push_device_api.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PushDeviceApi {

 int get id; int? get organization; int? get branch; String? get token;@JsonKey(name: 'device_id') String? get deviceId; String? get platform;@JsonKey(name: 'app_version') String? get appVersion;@JsonKey(name: 'app_build') String? get appBuild; String? get locale;@JsonKey(name: 'timezone_name') String? get timezoneName;@JsonKey(name: 'push_enabled') bool get pushEnabled;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'last_seen') String? get lastSeen; String? get created; String? get updated;
/// Create a copy of PushDeviceApi
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PushDeviceApiCopyWith<PushDeviceApi> get copyWith => _$PushDeviceApiCopyWithImpl<PushDeviceApi>(this as PushDeviceApi, _$identity);

  /// Serializes this PushDeviceApi to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PushDeviceApi&&(identical(other.id, id) || other.id == id)&&(identical(other.organization, organization) || other.organization == organization)&&(identical(other.branch, branch) || other.branch == branch)&&(identical(other.token, token) || other.token == token)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.appBuild, appBuild) || other.appBuild == appBuild)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.timezoneName, timezoneName) || other.timezoneName == timezoneName)&&(identical(other.pushEnabled, pushEnabled) || other.pushEnabled == pushEnabled)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.lastSeen, lastSeen) || other.lastSeen == lastSeen)&&(identical(other.created, created) || other.created == created)&&(identical(other.updated, updated) || other.updated == updated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,organization,branch,token,deviceId,platform,appVersion,appBuild,locale,timezoneName,pushEnabled,isActive,lastSeen,created,updated);

@override
String toString() {
  return 'PushDeviceApi(id: $id, organization: $organization, branch: $branch, token: $token, deviceId: $deviceId, platform: $platform, appVersion: $appVersion, appBuild: $appBuild, locale: $locale, timezoneName: $timezoneName, pushEnabled: $pushEnabled, isActive: $isActive, lastSeen: $lastSeen, created: $created, updated: $updated)';
}


}

/// @nodoc
abstract mixin class $PushDeviceApiCopyWith<$Res>  {
  factory $PushDeviceApiCopyWith(PushDeviceApi value, $Res Function(PushDeviceApi) _then) = _$PushDeviceApiCopyWithImpl;
@useResult
$Res call({
 int id, int? organization, int? branch, String? token,@JsonKey(name: 'device_id') String? deviceId, String? platform,@JsonKey(name: 'app_version') String? appVersion,@JsonKey(name: 'app_build') String? appBuild, String? locale,@JsonKey(name: 'timezone_name') String? timezoneName,@JsonKey(name: 'push_enabled') bool pushEnabled,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'last_seen') String? lastSeen, String? created, String? updated
});




}
/// @nodoc
class _$PushDeviceApiCopyWithImpl<$Res>
    implements $PushDeviceApiCopyWith<$Res> {
  _$PushDeviceApiCopyWithImpl(this._self, this._then);

  final PushDeviceApi _self;
  final $Res Function(PushDeviceApi) _then;

/// Create a copy of PushDeviceApi
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? organization = freezed,Object? branch = freezed,Object? token = freezed,Object? deviceId = freezed,Object? platform = freezed,Object? appVersion = freezed,Object? appBuild = freezed,Object? locale = freezed,Object? timezoneName = freezed,Object? pushEnabled = null,Object? isActive = null,Object? lastSeen = freezed,Object? created = freezed,Object? updated = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,organization: freezed == organization ? _self.organization : organization // ignore: cast_nullable_to_non_nullable
as int?,branch: freezed == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as int?,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,appVersion: freezed == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String?,appBuild: freezed == appBuild ? _self.appBuild : appBuild // ignore: cast_nullable_to_non_nullable
as String?,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,timezoneName: freezed == timezoneName ? _self.timezoneName : timezoneName // ignore: cast_nullable_to_non_nullable
as String?,pushEnabled: null == pushEnabled ? _self.pushEnabled : pushEnabled // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,lastSeen: freezed == lastSeen ? _self.lastSeen : lastSeen // ignore: cast_nullable_to_non_nullable
as String?,created: freezed == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as String?,updated: freezed == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PushDeviceApi].
extension PushDeviceApiPatterns on PushDeviceApi {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PushDeviceApi value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PushDeviceApi() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PushDeviceApi value)  $default,){
final _that = this;
switch (_that) {
case _PushDeviceApi():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PushDeviceApi value)?  $default,){
final _that = this;
switch (_that) {
case _PushDeviceApi() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int? organization,  int? branch,  String? token, @JsonKey(name: 'device_id')  String? deviceId,  String? platform, @JsonKey(name: 'app_version')  String? appVersion, @JsonKey(name: 'app_build')  String? appBuild,  String? locale, @JsonKey(name: 'timezone_name')  String? timezoneName, @JsonKey(name: 'push_enabled')  bool pushEnabled, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'last_seen')  String? lastSeen,  String? created,  String? updated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PushDeviceApi() when $default != null:
return $default(_that.id,_that.organization,_that.branch,_that.token,_that.deviceId,_that.platform,_that.appVersion,_that.appBuild,_that.locale,_that.timezoneName,_that.pushEnabled,_that.isActive,_that.lastSeen,_that.created,_that.updated);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int? organization,  int? branch,  String? token, @JsonKey(name: 'device_id')  String? deviceId,  String? platform, @JsonKey(name: 'app_version')  String? appVersion, @JsonKey(name: 'app_build')  String? appBuild,  String? locale, @JsonKey(name: 'timezone_name')  String? timezoneName, @JsonKey(name: 'push_enabled')  bool pushEnabled, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'last_seen')  String? lastSeen,  String? created,  String? updated)  $default,) {final _that = this;
switch (_that) {
case _PushDeviceApi():
return $default(_that.id,_that.organization,_that.branch,_that.token,_that.deviceId,_that.platform,_that.appVersion,_that.appBuild,_that.locale,_that.timezoneName,_that.pushEnabled,_that.isActive,_that.lastSeen,_that.created,_that.updated);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int? organization,  int? branch,  String? token, @JsonKey(name: 'device_id')  String? deviceId,  String? platform, @JsonKey(name: 'app_version')  String? appVersion, @JsonKey(name: 'app_build')  String? appBuild,  String? locale, @JsonKey(name: 'timezone_name')  String? timezoneName, @JsonKey(name: 'push_enabled')  bool pushEnabled, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'last_seen')  String? lastSeen,  String? created,  String? updated)?  $default,) {final _that = this;
switch (_that) {
case _PushDeviceApi() when $default != null:
return $default(_that.id,_that.organization,_that.branch,_that.token,_that.deviceId,_that.platform,_that.appVersion,_that.appBuild,_that.locale,_that.timezoneName,_that.pushEnabled,_that.isActive,_that.lastSeen,_that.created,_that.updated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PushDeviceApi implements PushDeviceApi {
  const _PushDeviceApi({required this.id, required this.organization, required this.branch, required this.token, @JsonKey(name: 'device_id') required this.deviceId, required this.platform, @JsonKey(name: 'app_version') required this.appVersion, @JsonKey(name: 'app_build') required this.appBuild, required this.locale, @JsonKey(name: 'timezone_name') required this.timezoneName, @JsonKey(name: 'push_enabled') required this.pushEnabled, @JsonKey(name: 'is_active') required this.isActive, @JsonKey(name: 'last_seen') required this.lastSeen, required this.created, required this.updated});
  factory _PushDeviceApi.fromJson(Map<String, dynamic> json) => _$PushDeviceApiFromJson(json);

@override final  int id;
@override final  int? organization;
@override final  int? branch;
@override final  String? token;
@override@JsonKey(name: 'device_id') final  String? deviceId;
@override final  String? platform;
@override@JsonKey(name: 'app_version') final  String? appVersion;
@override@JsonKey(name: 'app_build') final  String? appBuild;
@override final  String? locale;
@override@JsonKey(name: 'timezone_name') final  String? timezoneName;
@override@JsonKey(name: 'push_enabled') final  bool pushEnabled;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'last_seen') final  String? lastSeen;
@override final  String? created;
@override final  String? updated;

/// Create a copy of PushDeviceApi
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PushDeviceApiCopyWith<_PushDeviceApi> get copyWith => __$PushDeviceApiCopyWithImpl<_PushDeviceApi>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PushDeviceApiToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PushDeviceApi&&(identical(other.id, id) || other.id == id)&&(identical(other.organization, organization) || other.organization == organization)&&(identical(other.branch, branch) || other.branch == branch)&&(identical(other.token, token) || other.token == token)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.appBuild, appBuild) || other.appBuild == appBuild)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.timezoneName, timezoneName) || other.timezoneName == timezoneName)&&(identical(other.pushEnabled, pushEnabled) || other.pushEnabled == pushEnabled)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.lastSeen, lastSeen) || other.lastSeen == lastSeen)&&(identical(other.created, created) || other.created == created)&&(identical(other.updated, updated) || other.updated == updated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,organization,branch,token,deviceId,platform,appVersion,appBuild,locale,timezoneName,pushEnabled,isActive,lastSeen,created,updated);

@override
String toString() {
  return 'PushDeviceApi(id: $id, organization: $organization, branch: $branch, token: $token, deviceId: $deviceId, platform: $platform, appVersion: $appVersion, appBuild: $appBuild, locale: $locale, timezoneName: $timezoneName, pushEnabled: $pushEnabled, isActive: $isActive, lastSeen: $lastSeen, created: $created, updated: $updated)';
}


}

/// @nodoc
abstract mixin class _$PushDeviceApiCopyWith<$Res> implements $PushDeviceApiCopyWith<$Res> {
  factory _$PushDeviceApiCopyWith(_PushDeviceApi value, $Res Function(_PushDeviceApi) _then) = __$PushDeviceApiCopyWithImpl;
@override @useResult
$Res call({
 int id, int? organization, int? branch, String? token,@JsonKey(name: 'device_id') String? deviceId, String? platform,@JsonKey(name: 'app_version') String? appVersion,@JsonKey(name: 'app_build') String? appBuild, String? locale,@JsonKey(name: 'timezone_name') String? timezoneName,@JsonKey(name: 'push_enabled') bool pushEnabled,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'last_seen') String? lastSeen, String? created, String? updated
});




}
/// @nodoc
class __$PushDeviceApiCopyWithImpl<$Res>
    implements _$PushDeviceApiCopyWith<$Res> {
  __$PushDeviceApiCopyWithImpl(this._self, this._then);

  final _PushDeviceApi _self;
  final $Res Function(_PushDeviceApi) _then;

/// Create a copy of PushDeviceApi
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? organization = freezed,Object? branch = freezed,Object? token = freezed,Object? deviceId = freezed,Object? platform = freezed,Object? appVersion = freezed,Object? appBuild = freezed,Object? locale = freezed,Object? timezoneName = freezed,Object? pushEnabled = null,Object? isActive = null,Object? lastSeen = freezed,Object? created = freezed,Object? updated = freezed,}) {
  return _then(_PushDeviceApi(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,organization: freezed == organization ? _self.organization : organization // ignore: cast_nullable_to_non_nullable
as int?,branch: freezed == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as int?,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,platform: freezed == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String?,appVersion: freezed == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String?,appBuild: freezed == appBuild ? _self.appBuild : appBuild // ignore: cast_nullable_to_non_nullable
as String?,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,timezoneName: freezed == timezoneName ? _self.timezoneName : timezoneName // ignore: cast_nullable_to_non_nullable
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
mixin _$RegisterPushDeviceRequest {

 int get organization; String get token; String get platform; int? get branch;@JsonKey(name: 'device_id') String? get deviceId;@JsonKey(name: 'app_version') String? get appVersion;@JsonKey(name: 'app_build') String? get appBuild; String? get locale;@JsonKey(name: 'timezone_name') String? get timezoneName;@JsonKey(name: 'push_enabled') bool? get pushEnabled;
/// Create a copy of RegisterPushDeviceRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterPushDeviceRequestCopyWith<RegisterPushDeviceRequest> get copyWith => _$RegisterPushDeviceRequestCopyWithImpl<RegisterPushDeviceRequest>(this as RegisterPushDeviceRequest, _$identity);

  /// Serializes this RegisterPushDeviceRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterPushDeviceRequest&&(identical(other.organization, organization) || other.organization == organization)&&(identical(other.token, token) || other.token == token)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.branch, branch) || other.branch == branch)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.appBuild, appBuild) || other.appBuild == appBuild)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.timezoneName, timezoneName) || other.timezoneName == timezoneName)&&(identical(other.pushEnabled, pushEnabled) || other.pushEnabled == pushEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,organization,token,platform,branch,deviceId,appVersion,appBuild,locale,timezoneName,pushEnabled);

@override
String toString() {
  return 'RegisterPushDeviceRequest(organization: $organization, token: $token, platform: $platform, branch: $branch, deviceId: $deviceId, appVersion: $appVersion, appBuild: $appBuild, locale: $locale, timezoneName: $timezoneName, pushEnabled: $pushEnabled)';
}


}

/// @nodoc
abstract mixin class $RegisterPushDeviceRequestCopyWith<$Res>  {
  factory $RegisterPushDeviceRequestCopyWith(RegisterPushDeviceRequest value, $Res Function(RegisterPushDeviceRequest) _then) = _$RegisterPushDeviceRequestCopyWithImpl;
@useResult
$Res call({
 int organization, String token, String platform, int? branch,@JsonKey(name: 'device_id') String? deviceId,@JsonKey(name: 'app_version') String? appVersion,@JsonKey(name: 'app_build') String? appBuild, String? locale,@JsonKey(name: 'timezone_name') String? timezoneName,@JsonKey(name: 'push_enabled') bool? pushEnabled
});




}
/// @nodoc
class _$RegisterPushDeviceRequestCopyWithImpl<$Res>
    implements $RegisterPushDeviceRequestCopyWith<$Res> {
  _$RegisterPushDeviceRequestCopyWithImpl(this._self, this._then);

  final RegisterPushDeviceRequest _self;
  final $Res Function(RegisterPushDeviceRequest) _then;

/// Create a copy of RegisterPushDeviceRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? organization = null,Object? token = null,Object? platform = null,Object? branch = freezed,Object? deviceId = freezed,Object? appVersion = freezed,Object? appBuild = freezed,Object? locale = freezed,Object? timezoneName = freezed,Object? pushEnabled = freezed,}) {
  return _then(_self.copyWith(
organization: null == organization ? _self.organization : organization // ignore: cast_nullable_to_non_nullable
as int,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,branch: freezed == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as int?,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,appVersion: freezed == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String?,appBuild: freezed == appBuild ? _self.appBuild : appBuild // ignore: cast_nullable_to_non_nullable
as String?,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,timezoneName: freezed == timezoneName ? _self.timezoneName : timezoneName // ignore: cast_nullable_to_non_nullable
as String?,pushEnabled: freezed == pushEnabled ? _self.pushEnabled : pushEnabled // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [RegisterPushDeviceRequest].
extension RegisterPushDeviceRequestPatterns on RegisterPushDeviceRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegisterPushDeviceRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegisterPushDeviceRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegisterPushDeviceRequest value)  $default,){
final _that = this;
switch (_that) {
case _RegisterPushDeviceRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegisterPushDeviceRequest value)?  $default,){
final _that = this;
switch (_that) {
case _RegisterPushDeviceRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int organization,  String token,  String platform,  int? branch, @JsonKey(name: 'device_id')  String? deviceId, @JsonKey(name: 'app_version')  String? appVersion, @JsonKey(name: 'app_build')  String? appBuild,  String? locale, @JsonKey(name: 'timezone_name')  String? timezoneName, @JsonKey(name: 'push_enabled')  bool? pushEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegisterPushDeviceRequest() when $default != null:
return $default(_that.organization,_that.token,_that.platform,_that.branch,_that.deviceId,_that.appVersion,_that.appBuild,_that.locale,_that.timezoneName,_that.pushEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int organization,  String token,  String platform,  int? branch, @JsonKey(name: 'device_id')  String? deviceId, @JsonKey(name: 'app_version')  String? appVersion, @JsonKey(name: 'app_build')  String? appBuild,  String? locale, @JsonKey(name: 'timezone_name')  String? timezoneName, @JsonKey(name: 'push_enabled')  bool? pushEnabled)  $default,) {final _that = this;
switch (_that) {
case _RegisterPushDeviceRequest():
return $default(_that.organization,_that.token,_that.platform,_that.branch,_that.deviceId,_that.appVersion,_that.appBuild,_that.locale,_that.timezoneName,_that.pushEnabled);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int organization,  String token,  String platform,  int? branch, @JsonKey(name: 'device_id')  String? deviceId, @JsonKey(name: 'app_version')  String? appVersion, @JsonKey(name: 'app_build')  String? appBuild,  String? locale, @JsonKey(name: 'timezone_name')  String? timezoneName, @JsonKey(name: 'push_enabled')  bool? pushEnabled)?  $default,) {final _that = this;
switch (_that) {
case _RegisterPushDeviceRequest() when $default != null:
return $default(_that.organization,_that.token,_that.platform,_that.branch,_that.deviceId,_that.appVersion,_that.appBuild,_that.locale,_that.timezoneName,_that.pushEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RegisterPushDeviceRequest implements RegisterPushDeviceRequest {
  const _RegisterPushDeviceRequest({required this.organization, required this.token, required this.platform, this.branch, @JsonKey(name: 'device_id') this.deviceId, @JsonKey(name: 'app_version') this.appVersion, @JsonKey(name: 'app_build') this.appBuild, this.locale, @JsonKey(name: 'timezone_name') this.timezoneName, @JsonKey(name: 'push_enabled') this.pushEnabled});
  factory _RegisterPushDeviceRequest.fromJson(Map<String, dynamic> json) => _$RegisterPushDeviceRequestFromJson(json);

@override final  int organization;
@override final  String token;
@override final  String platform;
@override final  int? branch;
@override@JsonKey(name: 'device_id') final  String? deviceId;
@override@JsonKey(name: 'app_version') final  String? appVersion;
@override@JsonKey(name: 'app_build') final  String? appBuild;
@override final  String? locale;
@override@JsonKey(name: 'timezone_name') final  String? timezoneName;
@override@JsonKey(name: 'push_enabled') final  bool? pushEnabled;

/// Create a copy of RegisterPushDeviceRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisterPushDeviceRequestCopyWith<_RegisterPushDeviceRequest> get copyWith => __$RegisterPushDeviceRequestCopyWithImpl<_RegisterPushDeviceRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegisterPushDeviceRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegisterPushDeviceRequest&&(identical(other.organization, organization) || other.organization == organization)&&(identical(other.token, token) || other.token == token)&&(identical(other.platform, platform) || other.platform == platform)&&(identical(other.branch, branch) || other.branch == branch)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.appVersion, appVersion) || other.appVersion == appVersion)&&(identical(other.appBuild, appBuild) || other.appBuild == appBuild)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.timezoneName, timezoneName) || other.timezoneName == timezoneName)&&(identical(other.pushEnabled, pushEnabled) || other.pushEnabled == pushEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,organization,token,platform,branch,deviceId,appVersion,appBuild,locale,timezoneName,pushEnabled);

@override
String toString() {
  return 'RegisterPushDeviceRequest(organization: $organization, token: $token, platform: $platform, branch: $branch, deviceId: $deviceId, appVersion: $appVersion, appBuild: $appBuild, locale: $locale, timezoneName: $timezoneName, pushEnabled: $pushEnabled)';
}


}

/// @nodoc
abstract mixin class _$RegisterPushDeviceRequestCopyWith<$Res> implements $RegisterPushDeviceRequestCopyWith<$Res> {
  factory _$RegisterPushDeviceRequestCopyWith(_RegisterPushDeviceRequest value, $Res Function(_RegisterPushDeviceRequest) _then) = __$RegisterPushDeviceRequestCopyWithImpl;
@override @useResult
$Res call({
 int organization, String token, String platform, int? branch,@JsonKey(name: 'device_id') String? deviceId,@JsonKey(name: 'app_version') String? appVersion,@JsonKey(name: 'app_build') String? appBuild, String? locale,@JsonKey(name: 'timezone_name') String? timezoneName,@JsonKey(name: 'push_enabled') bool? pushEnabled
});




}
/// @nodoc
class __$RegisterPushDeviceRequestCopyWithImpl<$Res>
    implements _$RegisterPushDeviceRequestCopyWith<$Res> {
  __$RegisterPushDeviceRequestCopyWithImpl(this._self, this._then);

  final _RegisterPushDeviceRequest _self;
  final $Res Function(_RegisterPushDeviceRequest) _then;

/// Create a copy of RegisterPushDeviceRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? organization = null,Object? token = null,Object? platform = null,Object? branch = freezed,Object? deviceId = freezed,Object? appVersion = freezed,Object? appBuild = freezed,Object? locale = freezed,Object? timezoneName = freezed,Object? pushEnabled = freezed,}) {
  return _then(_RegisterPushDeviceRequest(
organization: null == organization ? _self.organization : organization // ignore: cast_nullable_to_non_nullable
as int,token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,platform: null == platform ? _self.platform : platform // ignore: cast_nullable_to_non_nullable
as String,branch: freezed == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as int?,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,appVersion: freezed == appVersion ? _self.appVersion : appVersion // ignore: cast_nullable_to_non_nullable
as String?,appBuild: freezed == appBuild ? _self.appBuild : appBuild // ignore: cast_nullable_to_non_nullable
as String?,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,timezoneName: freezed == timezoneName ? _self.timezoneName : timezoneName // ignore: cast_nullable_to_non_nullable
as String?,pushEnabled: freezed == pushEnabled ? _self.pushEnabled : pushEnabled // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$DeactivatePushDeviceRequest {

 int get organization; int? get id; String? get token;@JsonKey(name: 'device_id') String? get deviceId;
/// Create a copy of DeactivatePushDeviceRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeactivatePushDeviceRequestCopyWith<DeactivatePushDeviceRequest> get copyWith => _$DeactivatePushDeviceRequestCopyWithImpl<DeactivatePushDeviceRequest>(this as DeactivatePushDeviceRequest, _$identity);

  /// Serializes this DeactivatePushDeviceRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeactivatePushDeviceRequest&&(identical(other.organization, organization) || other.organization == organization)&&(identical(other.id, id) || other.id == id)&&(identical(other.token, token) || other.token == token)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,organization,id,token,deviceId);

@override
String toString() {
  return 'DeactivatePushDeviceRequest(organization: $organization, id: $id, token: $token, deviceId: $deviceId)';
}


}

/// @nodoc
abstract mixin class $DeactivatePushDeviceRequestCopyWith<$Res>  {
  factory $DeactivatePushDeviceRequestCopyWith(DeactivatePushDeviceRequest value, $Res Function(DeactivatePushDeviceRequest) _then) = _$DeactivatePushDeviceRequestCopyWithImpl;
@useResult
$Res call({
 int organization, int? id, String? token,@JsonKey(name: 'device_id') String? deviceId
});




}
/// @nodoc
class _$DeactivatePushDeviceRequestCopyWithImpl<$Res>
    implements $DeactivatePushDeviceRequestCopyWith<$Res> {
  _$DeactivatePushDeviceRequestCopyWithImpl(this._self, this._then);

  final DeactivatePushDeviceRequest _self;
  final $Res Function(DeactivatePushDeviceRequest) _then;

/// Create a copy of DeactivatePushDeviceRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? organization = null,Object? id = freezed,Object? token = freezed,Object? deviceId = freezed,}) {
  return _then(_self.copyWith(
organization: null == organization ? _self.organization : organization // ignore: cast_nullable_to_non_nullable
as int,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeactivatePushDeviceRequest].
extension DeactivatePushDeviceRequestPatterns on DeactivatePushDeviceRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeactivatePushDeviceRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeactivatePushDeviceRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeactivatePushDeviceRequest value)  $default,){
final _that = this;
switch (_that) {
case _DeactivatePushDeviceRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeactivatePushDeviceRequest value)?  $default,){
final _that = this;
switch (_that) {
case _DeactivatePushDeviceRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int organization,  int? id,  String? token, @JsonKey(name: 'device_id')  String? deviceId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeactivatePushDeviceRequest() when $default != null:
return $default(_that.organization,_that.id,_that.token,_that.deviceId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int organization,  int? id,  String? token, @JsonKey(name: 'device_id')  String? deviceId)  $default,) {final _that = this;
switch (_that) {
case _DeactivatePushDeviceRequest():
return $default(_that.organization,_that.id,_that.token,_that.deviceId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int organization,  int? id,  String? token, @JsonKey(name: 'device_id')  String? deviceId)?  $default,) {final _that = this;
switch (_that) {
case _DeactivatePushDeviceRequest() when $default != null:
return $default(_that.organization,_that.id,_that.token,_that.deviceId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeactivatePushDeviceRequest implements DeactivatePushDeviceRequest {
  const _DeactivatePushDeviceRequest({required this.organization, this.id, this.token, @JsonKey(name: 'device_id') this.deviceId});
  factory _DeactivatePushDeviceRequest.fromJson(Map<String, dynamic> json) => _$DeactivatePushDeviceRequestFromJson(json);

@override final  int organization;
@override final  int? id;
@override final  String? token;
@override@JsonKey(name: 'device_id') final  String? deviceId;

/// Create a copy of DeactivatePushDeviceRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeactivatePushDeviceRequestCopyWith<_DeactivatePushDeviceRequest> get copyWith => __$DeactivatePushDeviceRequestCopyWithImpl<_DeactivatePushDeviceRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeactivatePushDeviceRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeactivatePushDeviceRequest&&(identical(other.organization, organization) || other.organization == organization)&&(identical(other.id, id) || other.id == id)&&(identical(other.token, token) || other.token == token)&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,organization,id,token,deviceId);

@override
String toString() {
  return 'DeactivatePushDeviceRequest(organization: $organization, id: $id, token: $token, deviceId: $deviceId)';
}


}

/// @nodoc
abstract mixin class _$DeactivatePushDeviceRequestCopyWith<$Res> implements $DeactivatePushDeviceRequestCopyWith<$Res> {
  factory _$DeactivatePushDeviceRequestCopyWith(_DeactivatePushDeviceRequest value, $Res Function(_DeactivatePushDeviceRequest) _then) = __$DeactivatePushDeviceRequestCopyWithImpl;
@override @useResult
$Res call({
 int organization, int? id, String? token,@JsonKey(name: 'device_id') String? deviceId
});




}
/// @nodoc
class __$DeactivatePushDeviceRequestCopyWithImpl<$Res>
    implements _$DeactivatePushDeviceRequestCopyWith<$Res> {
  __$DeactivatePushDeviceRequestCopyWithImpl(this._self, this._then);

  final _DeactivatePushDeviceRequest _self;
  final $Res Function(_DeactivatePushDeviceRequest) _then;

/// Create a copy of DeactivatePushDeviceRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? organization = null,Object? id = freezed,Object? token = freezed,Object? deviceId = freezed,}) {
  return _then(_DeactivatePushDeviceRequest(
organization: null == organization ? _self.organization : organization // ignore: cast_nullable_to_non_nullable
as int,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,deviceId: freezed == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$DeactivatePushDeviceResponse {

 int get updated;
/// Create a copy of DeactivatePushDeviceResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeactivatePushDeviceResponseCopyWith<DeactivatePushDeviceResponse> get copyWith => _$DeactivatePushDeviceResponseCopyWithImpl<DeactivatePushDeviceResponse>(this as DeactivatePushDeviceResponse, _$identity);

  /// Serializes this DeactivatePushDeviceResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeactivatePushDeviceResponse&&(identical(other.updated, updated) || other.updated == updated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,updated);

@override
String toString() {
  return 'DeactivatePushDeviceResponse(updated: $updated)';
}


}

/// @nodoc
abstract mixin class $DeactivatePushDeviceResponseCopyWith<$Res>  {
  factory $DeactivatePushDeviceResponseCopyWith(DeactivatePushDeviceResponse value, $Res Function(DeactivatePushDeviceResponse) _then) = _$DeactivatePushDeviceResponseCopyWithImpl;
@useResult
$Res call({
 int updated
});




}
/// @nodoc
class _$DeactivatePushDeviceResponseCopyWithImpl<$Res>
    implements $DeactivatePushDeviceResponseCopyWith<$Res> {
  _$DeactivatePushDeviceResponseCopyWithImpl(this._self, this._then);

  final DeactivatePushDeviceResponse _self;
  final $Res Function(DeactivatePushDeviceResponse) _then;

/// Create a copy of DeactivatePushDeviceResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? updated = null,}) {
  return _then(_self.copyWith(
updated: null == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DeactivatePushDeviceResponse].
extension DeactivatePushDeviceResponsePatterns on DeactivatePushDeviceResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeactivatePushDeviceResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeactivatePushDeviceResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeactivatePushDeviceResponse value)  $default,){
final _that = this;
switch (_that) {
case _DeactivatePushDeviceResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeactivatePushDeviceResponse value)?  $default,){
final _that = this;
switch (_that) {
case _DeactivatePushDeviceResponse() when $default != null:
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
case _DeactivatePushDeviceResponse() when $default != null:
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
case _DeactivatePushDeviceResponse():
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
case _DeactivatePushDeviceResponse() when $default != null:
return $default(_that.updated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeactivatePushDeviceResponse implements DeactivatePushDeviceResponse {
  const _DeactivatePushDeviceResponse({required this.updated});
  factory _DeactivatePushDeviceResponse.fromJson(Map<String, dynamic> json) => _$DeactivatePushDeviceResponseFromJson(json);

@override final  int updated;

/// Create a copy of DeactivatePushDeviceResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeactivatePushDeviceResponseCopyWith<_DeactivatePushDeviceResponse> get copyWith => __$DeactivatePushDeviceResponseCopyWithImpl<_DeactivatePushDeviceResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeactivatePushDeviceResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeactivatePushDeviceResponse&&(identical(other.updated, updated) || other.updated == updated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,updated);

@override
String toString() {
  return 'DeactivatePushDeviceResponse(updated: $updated)';
}


}

/// @nodoc
abstract mixin class _$DeactivatePushDeviceResponseCopyWith<$Res> implements $DeactivatePushDeviceResponseCopyWith<$Res> {
  factory _$DeactivatePushDeviceResponseCopyWith(_DeactivatePushDeviceResponse value, $Res Function(_DeactivatePushDeviceResponse) _then) = __$DeactivatePushDeviceResponseCopyWithImpl;
@override @useResult
$Res call({
 int updated
});




}
/// @nodoc
class __$DeactivatePushDeviceResponseCopyWithImpl<$Res>
    implements _$DeactivatePushDeviceResponseCopyWith<$Res> {
  __$DeactivatePushDeviceResponseCopyWithImpl(this._self, this._then);

  final _DeactivatePushDeviceResponse _self;
  final $Res Function(_DeactivatePushDeviceResponse) _then;

/// Create a copy of DeactivatePushDeviceResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? updated = null,}) {
  return _then(_DeactivatePushDeviceResponse(
updated: null == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
