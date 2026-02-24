// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'branches_api.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BranchesApiResponse {

 int get count; String? get next; String? get previous; List<BranchApi> get results;
/// Create a copy of BranchesApiResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BranchesApiResponseCopyWith<BranchesApiResponse> get copyWith => _$BranchesApiResponseCopyWithImpl<BranchesApiResponse>(this as BranchesApiResponse, _$identity);

  /// Serializes this BranchesApiResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BranchesApiResponse&&(identical(other.count, count) || other.count == count)&&(identical(other.next, next) || other.next == next)&&(identical(other.previous, previous) || other.previous == previous)&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,next,previous,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'BranchesApiResponse(count: $count, next: $next, previous: $previous, results: $results)';
}


}

/// @nodoc
abstract mixin class $BranchesApiResponseCopyWith<$Res>  {
  factory $BranchesApiResponseCopyWith(BranchesApiResponse value, $Res Function(BranchesApiResponse) _then) = _$BranchesApiResponseCopyWithImpl;
@useResult
$Res call({
 int count, String? next, String? previous, List<BranchApi> results
});




}
/// @nodoc
class _$BranchesApiResponseCopyWithImpl<$Res>
    implements $BranchesApiResponseCopyWith<$Res> {
  _$BranchesApiResponseCopyWithImpl(this._self, this._then);

  final BranchesApiResponse _self;
  final $Res Function(BranchesApiResponse) _then;

/// Create a copy of BranchesApiResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? next = freezed,Object? previous = freezed,Object? results = null,}) {
  return _then(_self.copyWith(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as String?,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<BranchApi>,
  ));
}

}


/// Adds pattern-matching-related methods to [BranchesApiResponse].
extension BranchesApiResponsePatterns on BranchesApiResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BranchesApiResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BranchesApiResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BranchesApiResponse value)  $default,){
final _that = this;
switch (_that) {
case _BranchesApiResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BranchesApiResponse value)?  $default,){
final _that = this;
switch (_that) {
case _BranchesApiResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count,  String? next,  String? previous,  List<BranchApi> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BranchesApiResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count,  String? next,  String? previous,  List<BranchApi> results)  $default,) {final _that = this;
switch (_that) {
case _BranchesApiResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count,  String? next,  String? previous,  List<BranchApi> results)?  $default,) {final _that = this;
switch (_that) {
case _BranchesApiResponse() when $default != null:
return $default(_that.count,_that.next,_that.previous,_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BranchesApiResponse implements BranchesApiResponse {
  const _BranchesApiResponse({required this.count, required this.next, required this.previous, required final  List<BranchApi> results}): _results = results;
  factory _BranchesApiResponse.fromJson(Map<String, dynamic> json) => _$BranchesApiResponseFromJson(json);

@override final  int count;
@override final  String? next;
@override final  String? previous;
 final  List<BranchApi> _results;
@override List<BranchApi> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of BranchesApiResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BranchesApiResponseCopyWith<_BranchesApiResponse> get copyWith => __$BranchesApiResponseCopyWithImpl<_BranchesApiResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BranchesApiResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BranchesApiResponse&&(identical(other.count, count) || other.count == count)&&(identical(other.next, next) || other.next == next)&&(identical(other.previous, previous) || other.previous == previous)&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,next,previous,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'BranchesApiResponse(count: $count, next: $next, previous: $previous, results: $results)';
}


}

/// @nodoc
abstract mixin class _$BranchesApiResponseCopyWith<$Res> implements $BranchesApiResponseCopyWith<$Res> {
  factory _$BranchesApiResponseCopyWith(_BranchesApiResponse value, $Res Function(_BranchesApiResponse) _then) = __$BranchesApiResponseCopyWithImpl;
@override @useResult
$Res call({
 int count, String? next, String? previous, List<BranchApi> results
});




}
/// @nodoc
class __$BranchesApiResponseCopyWithImpl<$Res>
    implements _$BranchesApiResponseCopyWith<$Res> {
  __$BranchesApiResponseCopyWithImpl(this._self, this._then);

  final _BranchesApiResponse _self;
  final $Res Function(_BranchesApiResponse) _then;

/// Create a copy of BranchesApiResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? next = freezed,Object? previous = freezed,Object? results = null,}) {
  return _then(_BranchesApiResponse(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as String?,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<BranchApi>,
  ));
}


}


/// @nodoc
mixin _$BranchApi {

 int get id;@JsonKey(name: 'is_main') bool? get isMain; String? get name; String? get country; String? get region; String? get city; String? get address; Location? get location; String? get timezone; int? get workspaces; String? get phone; String? get email; List<SchedulePattern>? get schedulePatterns;@JsonKey(name: 'has_chat_settings') bool? get hasChatSettings;@JsonKey(name: 'is_blocked') bool? get isBlocked;@JsonKey(name: 'is_available') bool? get isAvailable; bool? get yandexable;@JsonKey(name: 'number_of_workers') int? get numberOfWorkers;@JsonKey(name: 'has_chat_push_settings') bool? get hasChatPushSettings;
/// Create a copy of BranchApi
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BranchApiCopyWith<BranchApi> get copyWith => _$BranchApiCopyWithImpl<BranchApi>(this as BranchApi, _$identity);

  /// Serializes this BranchApi to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BranchApi&&(identical(other.id, id) || other.id == id)&&(identical(other.isMain, isMain) || other.isMain == isMain)&&(identical(other.name, name) || other.name == name)&&(identical(other.country, country) || other.country == country)&&(identical(other.region, region) || other.region == region)&&(identical(other.city, city) || other.city == city)&&(identical(other.address, address) || other.address == address)&&(identical(other.location, location) || other.location == location)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.workspaces, workspaces) || other.workspaces == workspaces)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&const DeepCollectionEquality().equals(other.schedulePatterns, schedulePatterns)&&(identical(other.hasChatSettings, hasChatSettings) || other.hasChatSettings == hasChatSettings)&&(identical(other.isBlocked, isBlocked) || other.isBlocked == isBlocked)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.yandexable, yandexable) || other.yandexable == yandexable)&&(identical(other.numberOfWorkers, numberOfWorkers) || other.numberOfWorkers == numberOfWorkers)&&(identical(other.hasChatPushSettings, hasChatPushSettings) || other.hasChatPushSettings == hasChatPushSettings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,isMain,name,country,region,city,address,location,timezone,workspaces,phone,email,const DeepCollectionEquality().hash(schedulePatterns),hasChatSettings,isBlocked,isAvailable,yandexable,numberOfWorkers,hasChatPushSettings]);

@override
String toString() {
  return 'BranchApi(id: $id, isMain: $isMain, name: $name, country: $country, region: $region, city: $city, address: $address, location: $location, timezone: $timezone, workspaces: $workspaces, phone: $phone, email: $email, schedulePatterns: $schedulePatterns, hasChatSettings: $hasChatSettings, isBlocked: $isBlocked, isAvailable: $isAvailable, yandexable: $yandexable, numberOfWorkers: $numberOfWorkers, hasChatPushSettings: $hasChatPushSettings)';
}


}

/// @nodoc
abstract mixin class $BranchApiCopyWith<$Res>  {
  factory $BranchApiCopyWith(BranchApi value, $Res Function(BranchApi) _then) = _$BranchApiCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'is_main') bool? isMain, String? name, String? country, String? region, String? city, String? address, Location? location, String? timezone, int? workspaces, String? phone, String? email, List<SchedulePattern>? schedulePatterns,@JsonKey(name: 'has_chat_settings') bool? hasChatSettings,@JsonKey(name: 'is_blocked') bool? isBlocked,@JsonKey(name: 'is_available') bool? isAvailable, bool? yandexable,@JsonKey(name: 'number_of_workers') int? numberOfWorkers,@JsonKey(name: 'has_chat_push_settings') bool? hasChatPushSettings
});


$LocationCopyWith<$Res>? get location;

}
/// @nodoc
class _$BranchApiCopyWithImpl<$Res>
    implements $BranchApiCopyWith<$Res> {
  _$BranchApiCopyWithImpl(this._self, this._then);

  final BranchApi _self;
  final $Res Function(BranchApi) _then;

/// Create a copy of BranchApi
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? isMain = freezed,Object? name = freezed,Object? country = freezed,Object? region = freezed,Object? city = freezed,Object? address = freezed,Object? location = freezed,Object? timezone = freezed,Object? workspaces = freezed,Object? phone = freezed,Object? email = freezed,Object? schedulePatterns = freezed,Object? hasChatSettings = freezed,Object? isBlocked = freezed,Object? isAvailable = freezed,Object? yandexable = freezed,Object? numberOfWorkers = freezed,Object? hasChatPushSettings = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,isMain: freezed == isMain ? _self.isMain : isMain // ignore: cast_nullable_to_non_nullable
as bool?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,region: freezed == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as Location?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,workspaces: freezed == workspaces ? _self.workspaces : workspaces // ignore: cast_nullable_to_non_nullable
as int?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,schedulePatterns: freezed == schedulePatterns ? _self.schedulePatterns : schedulePatterns // ignore: cast_nullable_to_non_nullable
as List<SchedulePattern>?,hasChatSettings: freezed == hasChatSettings ? _self.hasChatSettings : hasChatSettings // ignore: cast_nullable_to_non_nullable
as bool?,isBlocked: freezed == isBlocked ? _self.isBlocked : isBlocked // ignore: cast_nullable_to_non_nullable
as bool?,isAvailable: freezed == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool?,yandexable: freezed == yandexable ? _self.yandexable : yandexable // ignore: cast_nullable_to_non_nullable
as bool?,numberOfWorkers: freezed == numberOfWorkers ? _self.numberOfWorkers : numberOfWorkers // ignore: cast_nullable_to_non_nullable
as int?,hasChatPushSettings: freezed == hasChatPushSettings ? _self.hasChatPushSettings : hasChatPushSettings // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}
/// Create a copy of BranchApi
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocationCopyWith<$Res>? get location {
    if (_self.location == null) {
    return null;
  }

  return $LocationCopyWith<$Res>(_self.location!, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// Adds pattern-matching-related methods to [BranchApi].
extension BranchApiPatterns on BranchApi {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BranchApi value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BranchApi() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BranchApi value)  $default,){
final _that = this;
switch (_that) {
case _BranchApi():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BranchApi value)?  $default,){
final _that = this;
switch (_that) {
case _BranchApi() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'is_main')  bool? isMain,  String? name,  String? country,  String? region,  String? city,  String? address,  Location? location,  String? timezone,  int? workspaces,  String? phone,  String? email,  List<SchedulePattern>? schedulePatterns, @JsonKey(name: 'has_chat_settings')  bool? hasChatSettings, @JsonKey(name: 'is_blocked')  bool? isBlocked, @JsonKey(name: 'is_available')  bool? isAvailable,  bool? yandexable, @JsonKey(name: 'number_of_workers')  int? numberOfWorkers, @JsonKey(name: 'has_chat_push_settings')  bool? hasChatPushSettings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BranchApi() when $default != null:
return $default(_that.id,_that.isMain,_that.name,_that.country,_that.region,_that.city,_that.address,_that.location,_that.timezone,_that.workspaces,_that.phone,_that.email,_that.schedulePatterns,_that.hasChatSettings,_that.isBlocked,_that.isAvailable,_that.yandexable,_that.numberOfWorkers,_that.hasChatPushSettings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'is_main')  bool? isMain,  String? name,  String? country,  String? region,  String? city,  String? address,  Location? location,  String? timezone,  int? workspaces,  String? phone,  String? email,  List<SchedulePattern>? schedulePatterns, @JsonKey(name: 'has_chat_settings')  bool? hasChatSettings, @JsonKey(name: 'is_blocked')  bool? isBlocked, @JsonKey(name: 'is_available')  bool? isAvailable,  bool? yandexable, @JsonKey(name: 'number_of_workers')  int? numberOfWorkers, @JsonKey(name: 'has_chat_push_settings')  bool? hasChatPushSettings)  $default,) {final _that = this;
switch (_that) {
case _BranchApi():
return $default(_that.id,_that.isMain,_that.name,_that.country,_that.region,_that.city,_that.address,_that.location,_that.timezone,_that.workspaces,_that.phone,_that.email,_that.schedulePatterns,_that.hasChatSettings,_that.isBlocked,_that.isAvailable,_that.yandexable,_that.numberOfWorkers,_that.hasChatPushSettings);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'is_main')  bool? isMain,  String? name,  String? country,  String? region,  String? city,  String? address,  Location? location,  String? timezone,  int? workspaces,  String? phone,  String? email,  List<SchedulePattern>? schedulePatterns, @JsonKey(name: 'has_chat_settings')  bool? hasChatSettings, @JsonKey(name: 'is_blocked')  bool? isBlocked, @JsonKey(name: 'is_available')  bool? isAvailable,  bool? yandexable, @JsonKey(name: 'number_of_workers')  int? numberOfWorkers, @JsonKey(name: 'has_chat_push_settings')  bool? hasChatPushSettings)?  $default,) {final _that = this;
switch (_that) {
case _BranchApi() when $default != null:
return $default(_that.id,_that.isMain,_that.name,_that.country,_that.region,_that.city,_that.address,_that.location,_that.timezone,_that.workspaces,_that.phone,_that.email,_that.schedulePatterns,_that.hasChatSettings,_that.isBlocked,_that.isAvailable,_that.yandexable,_that.numberOfWorkers,_that.hasChatPushSettings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BranchApi implements BranchApi {
  const _BranchApi({required this.id, @JsonKey(name: 'is_main') required this.isMain, required this.name, required this.country, required this.region, required this.city, required this.address, required this.location, required this.timezone, required this.workspaces, required this.phone, required this.email, required final  List<SchedulePattern>? schedulePatterns, @JsonKey(name: 'has_chat_settings') required this.hasChatSettings, @JsonKey(name: 'is_blocked') required this.isBlocked, @JsonKey(name: 'is_available') required this.isAvailable, required this.yandexable, @JsonKey(name: 'number_of_workers') required this.numberOfWorkers, @JsonKey(name: 'has_chat_push_settings') required this.hasChatPushSettings}): _schedulePatterns = schedulePatterns;
  factory _BranchApi.fromJson(Map<String, dynamic> json) => _$BranchApiFromJson(json);

@override final  int id;
@override@JsonKey(name: 'is_main') final  bool? isMain;
@override final  String? name;
@override final  String? country;
@override final  String? region;
@override final  String? city;
@override final  String? address;
@override final  Location? location;
@override final  String? timezone;
@override final  int? workspaces;
@override final  String? phone;
@override final  String? email;
 final  List<SchedulePattern>? _schedulePatterns;
@override List<SchedulePattern>? get schedulePatterns {
  final value = _schedulePatterns;
  if (value == null) return null;
  if (_schedulePatterns is EqualUnmodifiableListView) return _schedulePatterns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey(name: 'has_chat_settings') final  bool? hasChatSettings;
@override@JsonKey(name: 'is_blocked') final  bool? isBlocked;
@override@JsonKey(name: 'is_available') final  bool? isAvailable;
@override final  bool? yandexable;
@override@JsonKey(name: 'number_of_workers') final  int? numberOfWorkers;
@override@JsonKey(name: 'has_chat_push_settings') final  bool? hasChatPushSettings;

/// Create a copy of BranchApi
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BranchApiCopyWith<_BranchApi> get copyWith => __$BranchApiCopyWithImpl<_BranchApi>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BranchApiToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BranchApi&&(identical(other.id, id) || other.id == id)&&(identical(other.isMain, isMain) || other.isMain == isMain)&&(identical(other.name, name) || other.name == name)&&(identical(other.country, country) || other.country == country)&&(identical(other.region, region) || other.region == region)&&(identical(other.city, city) || other.city == city)&&(identical(other.address, address) || other.address == address)&&(identical(other.location, location) || other.location == location)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.workspaces, workspaces) || other.workspaces == workspaces)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&const DeepCollectionEquality().equals(other._schedulePatterns, _schedulePatterns)&&(identical(other.hasChatSettings, hasChatSettings) || other.hasChatSettings == hasChatSettings)&&(identical(other.isBlocked, isBlocked) || other.isBlocked == isBlocked)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.yandexable, yandexable) || other.yandexable == yandexable)&&(identical(other.numberOfWorkers, numberOfWorkers) || other.numberOfWorkers == numberOfWorkers)&&(identical(other.hasChatPushSettings, hasChatPushSettings) || other.hasChatPushSettings == hasChatPushSettings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,isMain,name,country,region,city,address,location,timezone,workspaces,phone,email,const DeepCollectionEquality().hash(_schedulePatterns),hasChatSettings,isBlocked,isAvailable,yandexable,numberOfWorkers,hasChatPushSettings]);

@override
String toString() {
  return 'BranchApi(id: $id, isMain: $isMain, name: $name, country: $country, region: $region, city: $city, address: $address, location: $location, timezone: $timezone, workspaces: $workspaces, phone: $phone, email: $email, schedulePatterns: $schedulePatterns, hasChatSettings: $hasChatSettings, isBlocked: $isBlocked, isAvailable: $isAvailable, yandexable: $yandexable, numberOfWorkers: $numberOfWorkers, hasChatPushSettings: $hasChatPushSettings)';
}


}

/// @nodoc
abstract mixin class _$BranchApiCopyWith<$Res> implements $BranchApiCopyWith<$Res> {
  factory _$BranchApiCopyWith(_BranchApi value, $Res Function(_BranchApi) _then) = __$BranchApiCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'is_main') bool? isMain, String? name, String? country, String? region, String? city, String? address, Location? location, String? timezone, int? workspaces, String? phone, String? email, List<SchedulePattern>? schedulePatterns,@JsonKey(name: 'has_chat_settings') bool? hasChatSettings,@JsonKey(name: 'is_blocked') bool? isBlocked,@JsonKey(name: 'is_available') bool? isAvailable, bool? yandexable,@JsonKey(name: 'number_of_workers') int? numberOfWorkers,@JsonKey(name: 'has_chat_push_settings') bool? hasChatPushSettings
});


@override $LocationCopyWith<$Res>? get location;

}
/// @nodoc
class __$BranchApiCopyWithImpl<$Res>
    implements _$BranchApiCopyWith<$Res> {
  __$BranchApiCopyWithImpl(this._self, this._then);

  final _BranchApi _self;
  final $Res Function(_BranchApi) _then;

/// Create a copy of BranchApi
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? isMain = freezed,Object? name = freezed,Object? country = freezed,Object? region = freezed,Object? city = freezed,Object? address = freezed,Object? location = freezed,Object? timezone = freezed,Object? workspaces = freezed,Object? phone = freezed,Object? email = freezed,Object? schedulePatterns = freezed,Object? hasChatSettings = freezed,Object? isBlocked = freezed,Object? isAvailable = freezed,Object? yandexable = freezed,Object? numberOfWorkers = freezed,Object? hasChatPushSettings = freezed,}) {
  return _then(_BranchApi(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,isMain: freezed == isMain ? _self.isMain : isMain // ignore: cast_nullable_to_non_nullable
as bool?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,region: freezed == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as Location?,timezone: freezed == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String?,workspaces: freezed == workspaces ? _self.workspaces : workspaces // ignore: cast_nullable_to_non_nullable
as int?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,schedulePatterns: freezed == schedulePatterns ? _self._schedulePatterns : schedulePatterns // ignore: cast_nullable_to_non_nullable
as List<SchedulePattern>?,hasChatSettings: freezed == hasChatSettings ? _self.hasChatSettings : hasChatSettings // ignore: cast_nullable_to_non_nullable
as bool?,isBlocked: freezed == isBlocked ? _self.isBlocked : isBlocked // ignore: cast_nullable_to_non_nullable
as bool?,isAvailable: freezed == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool?,yandexable: freezed == yandexable ? _self.yandexable : yandexable // ignore: cast_nullable_to_non_nullable
as bool?,numberOfWorkers: freezed == numberOfWorkers ? _self.numberOfWorkers : numberOfWorkers // ignore: cast_nullable_to_non_nullable
as int?,hasChatPushSettings: freezed == hasChatPushSettings ? _self.hasChatPushSettings : hasChatPushSettings // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

/// Create a copy of BranchApi
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocationCopyWith<$Res>? get location {
    if (_self.location == null) {
    return null;
  }

  return $LocationCopyWith<$Res>(_self.location!, (value) {
    return _then(_self.copyWith(location: value));
  });
}
}


/// @nodoc
mixin _$Location {

 double get lat; double get lon;
/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationCopyWith<Location> get copyWith => _$LocationCopyWithImpl<Location>(this as Location, _$identity);

  /// Serializes this Location to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Location&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lon);

@override
String toString() {
  return 'Location(lat: $lat, lon: $lon)';
}


}

/// @nodoc
abstract mixin class $LocationCopyWith<$Res>  {
  factory $LocationCopyWith(Location value, $Res Function(Location) _then) = _$LocationCopyWithImpl;
@useResult
$Res call({
 double lat, double lon
});




}
/// @nodoc
class _$LocationCopyWithImpl<$Res>
    implements $LocationCopyWith<$Res> {
  _$LocationCopyWithImpl(this._self, this._then);

  final Location _self;
  final $Res Function(Location) _then;

/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lat = null,Object? lon = null,}) {
  return _then(_self.copyWith(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [Location].
extension LocationPatterns on Location {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Location value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Location() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Location value)  $default,){
final _that = this;
switch (_that) {
case _Location():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Location value)?  $default,){
final _that = this;
switch (_that) {
case _Location() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double lat,  double lon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Location() when $default != null:
return $default(_that.lat,_that.lon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double lat,  double lon)  $default,) {final _that = this;
switch (_that) {
case _Location():
return $default(_that.lat,_that.lon);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double lat,  double lon)?  $default,) {final _that = this;
switch (_that) {
case _Location() when $default != null:
return $default(_that.lat,_that.lon);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Location implements Location {
  const _Location({required this.lat, required this.lon});
  factory _Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);

@override final  double lat;
@override final  double lon;

/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationCopyWith<_Location> get copyWith => __$LocationCopyWithImpl<_Location>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LocationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Location&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lat,lon);

@override
String toString() {
  return 'Location(lat: $lat, lon: $lon)';
}


}

/// @nodoc
abstract mixin class _$LocationCopyWith<$Res> implements $LocationCopyWith<$Res> {
  factory _$LocationCopyWith(_Location value, $Res Function(_Location) _then) = __$LocationCopyWithImpl;
@override @useResult
$Res call({
 double lat, double lon
});




}
/// @nodoc
class __$LocationCopyWithImpl<$Res>
    implements _$LocationCopyWith<$Res> {
  __$LocationCopyWithImpl(this._self, this._then);

  final _Location _self;
  final $Res Function(_Location) _then;

/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lat = null,Object? lon = null,}) {
  return _then(_Location(
lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lon: null == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$SchedulePattern {

 int? get id; int? get branch; String? get day;@JsonKey(name: 'time_start') String? get timeStart;@JsonKey(name: 'time_end') String? get timeEnd; bool? get active;
/// Create a copy of SchedulePattern
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SchedulePatternCopyWith<SchedulePattern> get copyWith => _$SchedulePatternCopyWithImpl<SchedulePattern>(this as SchedulePattern, _$identity);

  /// Serializes this SchedulePattern to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SchedulePattern&&(identical(other.id, id) || other.id == id)&&(identical(other.branch, branch) || other.branch == branch)&&(identical(other.day, day) || other.day == day)&&(identical(other.timeStart, timeStart) || other.timeStart == timeStart)&&(identical(other.timeEnd, timeEnd) || other.timeEnd == timeEnd)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,branch,day,timeStart,timeEnd,active);

@override
String toString() {
  return 'SchedulePattern(id: $id, branch: $branch, day: $day, timeStart: $timeStart, timeEnd: $timeEnd, active: $active)';
}


}

/// @nodoc
abstract mixin class $SchedulePatternCopyWith<$Res>  {
  factory $SchedulePatternCopyWith(SchedulePattern value, $Res Function(SchedulePattern) _then) = _$SchedulePatternCopyWithImpl;
@useResult
$Res call({
 int? id, int? branch, String? day,@JsonKey(name: 'time_start') String? timeStart,@JsonKey(name: 'time_end') String? timeEnd, bool? active
});




}
/// @nodoc
class _$SchedulePatternCopyWithImpl<$Res>
    implements $SchedulePatternCopyWith<$Res> {
  _$SchedulePatternCopyWithImpl(this._self, this._then);

  final SchedulePattern _self;
  final $Res Function(SchedulePattern) _then;

/// Create a copy of SchedulePattern
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? branch = freezed,Object? day = freezed,Object? timeStart = freezed,Object? timeEnd = freezed,Object? active = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,branch: freezed == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as int?,day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as String?,timeStart: freezed == timeStart ? _self.timeStart : timeStart // ignore: cast_nullable_to_non_nullable
as String?,timeEnd: freezed == timeEnd ? _self.timeEnd : timeEnd // ignore: cast_nullable_to_non_nullable
as String?,active: freezed == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [SchedulePattern].
extension SchedulePatternPatterns on SchedulePattern {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SchedulePattern value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SchedulePattern() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SchedulePattern value)  $default,){
final _that = this;
switch (_that) {
case _SchedulePattern():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SchedulePattern value)?  $default,){
final _that = this;
switch (_that) {
case _SchedulePattern() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int? branch,  String? day, @JsonKey(name: 'time_start')  String? timeStart, @JsonKey(name: 'time_end')  String? timeEnd,  bool? active)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SchedulePattern() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int? branch,  String? day, @JsonKey(name: 'time_start')  String? timeStart, @JsonKey(name: 'time_end')  String? timeEnd,  bool? active)  $default,) {final _that = this;
switch (_that) {
case _SchedulePattern():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int? branch,  String? day, @JsonKey(name: 'time_start')  String? timeStart, @JsonKey(name: 'time_end')  String? timeEnd,  bool? active)?  $default,) {final _that = this;
switch (_that) {
case _SchedulePattern() when $default != null:
return $default(_that.id,_that.branch,_that.day,_that.timeStart,_that.timeEnd,_that.active);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SchedulePattern implements SchedulePattern {
  const _SchedulePattern({required this.id, required this.branch, required this.day, @JsonKey(name: 'time_start') required this.timeStart, @JsonKey(name: 'time_end') required this.timeEnd, required this.active});
  factory _SchedulePattern.fromJson(Map<String, dynamic> json) => _$SchedulePatternFromJson(json);

@override final  int? id;
@override final  int? branch;
@override final  String? day;
@override@JsonKey(name: 'time_start') final  String? timeStart;
@override@JsonKey(name: 'time_end') final  String? timeEnd;
@override final  bool? active;

/// Create a copy of SchedulePattern
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SchedulePatternCopyWith<_SchedulePattern> get copyWith => __$SchedulePatternCopyWithImpl<_SchedulePattern>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SchedulePatternToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SchedulePattern&&(identical(other.id, id) || other.id == id)&&(identical(other.branch, branch) || other.branch == branch)&&(identical(other.day, day) || other.day == day)&&(identical(other.timeStart, timeStart) || other.timeStart == timeStart)&&(identical(other.timeEnd, timeEnd) || other.timeEnd == timeEnd)&&(identical(other.active, active) || other.active == active));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,branch,day,timeStart,timeEnd,active);

@override
String toString() {
  return 'SchedulePattern(id: $id, branch: $branch, day: $day, timeStart: $timeStart, timeEnd: $timeEnd, active: $active)';
}


}

/// @nodoc
abstract mixin class _$SchedulePatternCopyWith<$Res> implements $SchedulePatternCopyWith<$Res> {
  factory _$SchedulePatternCopyWith(_SchedulePattern value, $Res Function(_SchedulePattern) _then) = __$SchedulePatternCopyWithImpl;
@override @useResult
$Res call({
 int? id, int? branch, String? day,@JsonKey(name: 'time_start') String? timeStart,@JsonKey(name: 'time_end') String? timeEnd, bool? active
});




}
/// @nodoc
class __$SchedulePatternCopyWithImpl<$Res>
    implements _$SchedulePatternCopyWith<$Res> {
  __$SchedulePatternCopyWithImpl(this._self, this._then);

  final _SchedulePattern _self;
  final $Res Function(_SchedulePattern) _then;

/// Create a copy of SchedulePattern
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? branch = freezed,Object? day = freezed,Object? timeStart = freezed,Object? timeEnd = freezed,Object? active = freezed,}) {
  return _then(_SchedulePattern(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,branch: freezed == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as int?,day: freezed == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as String?,timeStart: freezed == timeStart ? _self.timeStart : timeStart // ignore: cast_nullable_to_non_nullable
as String?,timeEnd: freezed == timeEnd ? _self.timeEnd : timeEnd // ignore: cast_nullable_to_non_nullable
as String?,active: freezed == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
