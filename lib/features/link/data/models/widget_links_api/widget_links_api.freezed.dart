// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'widget_links_api.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WidgetLinksApiResponse {

 int get count; String? get next; String? get previous; List<WidgetLinkApi> get results;
/// Create a copy of WidgetLinksApiResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WidgetLinksApiResponseCopyWith<WidgetLinksApiResponse> get copyWith => _$WidgetLinksApiResponseCopyWithImpl<WidgetLinksApiResponse>(this as WidgetLinksApiResponse, _$identity);

  /// Serializes this WidgetLinksApiResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WidgetLinksApiResponse&&(identical(other.count, count) || other.count == count)&&(identical(other.next, next) || other.next == next)&&(identical(other.previous, previous) || other.previous == previous)&&const DeepCollectionEquality().equals(other.results, results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,next,previous,const DeepCollectionEquality().hash(results));

@override
String toString() {
  return 'WidgetLinksApiResponse(count: $count, next: $next, previous: $previous, results: $results)';
}


}

/// @nodoc
abstract mixin class $WidgetLinksApiResponseCopyWith<$Res>  {
  factory $WidgetLinksApiResponseCopyWith(WidgetLinksApiResponse value, $Res Function(WidgetLinksApiResponse) _then) = _$WidgetLinksApiResponseCopyWithImpl;
@useResult
$Res call({
 int count, String? next, String? previous, List<WidgetLinkApi> results
});




}
/// @nodoc
class _$WidgetLinksApiResponseCopyWithImpl<$Res>
    implements $WidgetLinksApiResponseCopyWith<$Res> {
  _$WidgetLinksApiResponseCopyWithImpl(this._self, this._then);

  final WidgetLinksApiResponse _self;
  final $Res Function(WidgetLinksApiResponse) _then;

/// Create a copy of WidgetLinksApiResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? next = freezed,Object? previous = freezed,Object? results = null,}) {
  return _then(_self.copyWith(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as String?,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<WidgetLinkApi>,
  ));
}

}


/// Adds pattern-matching-related methods to [WidgetLinksApiResponse].
extension WidgetLinksApiResponsePatterns on WidgetLinksApiResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WidgetLinksApiResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WidgetLinksApiResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WidgetLinksApiResponse value)  $default,){
final _that = this;
switch (_that) {
case _WidgetLinksApiResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WidgetLinksApiResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WidgetLinksApiResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int count,  String? next,  String? previous,  List<WidgetLinkApi> results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WidgetLinksApiResponse() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int count,  String? next,  String? previous,  List<WidgetLinkApi> results)  $default,) {final _that = this;
switch (_that) {
case _WidgetLinksApiResponse():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int count,  String? next,  String? previous,  List<WidgetLinkApi> results)?  $default,) {final _that = this;
switch (_that) {
case _WidgetLinksApiResponse() when $default != null:
return $default(_that.count,_that.next,_that.previous,_that.results);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WidgetLinksApiResponse implements WidgetLinksApiResponse {
  const _WidgetLinksApiResponse({required this.count, required this.next, required this.previous, required final  List<WidgetLinkApi> results}): _results = results;
  factory _WidgetLinksApiResponse.fromJson(Map<String, dynamic> json) => _$WidgetLinksApiResponseFromJson(json);

@override final  int count;
@override final  String? next;
@override final  String? previous;
 final  List<WidgetLinkApi> _results;
@override List<WidgetLinkApi> get results {
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_results);
}


/// Create a copy of WidgetLinksApiResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WidgetLinksApiResponseCopyWith<_WidgetLinksApiResponse> get copyWith => __$WidgetLinksApiResponseCopyWithImpl<_WidgetLinksApiResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WidgetLinksApiResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WidgetLinksApiResponse&&(identical(other.count, count) || other.count == count)&&(identical(other.next, next) || other.next == next)&&(identical(other.previous, previous) || other.previous == previous)&&const DeepCollectionEquality().equals(other._results, _results));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,next,previous,const DeepCollectionEquality().hash(_results));

@override
String toString() {
  return 'WidgetLinksApiResponse(count: $count, next: $next, previous: $previous, results: $results)';
}


}

/// @nodoc
abstract mixin class _$WidgetLinksApiResponseCopyWith<$Res> implements $WidgetLinksApiResponseCopyWith<$Res> {
  factory _$WidgetLinksApiResponseCopyWith(_WidgetLinksApiResponse value, $Res Function(_WidgetLinksApiResponse) _then) = __$WidgetLinksApiResponseCopyWithImpl;
@override @useResult
$Res call({
 int count, String? next, String? previous, List<WidgetLinkApi> results
});




}
/// @nodoc
class __$WidgetLinksApiResponseCopyWithImpl<$Res>
    implements _$WidgetLinksApiResponseCopyWith<$Res> {
  __$WidgetLinksApiResponseCopyWithImpl(this._self, this._then);

  final _WidgetLinksApiResponse _self;
  final $Res Function(_WidgetLinksApiResponse) _then;

/// Create a copy of WidgetLinksApiResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? next = freezed,Object? previous = freezed,Object? results = null,}) {
  return _then(_WidgetLinksApiResponse(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,next: freezed == next ? _self.next : next // ignore: cast_nullable_to_non_nullable
as String?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as String?,results: null == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<WidgetLinkApi>,
  ));
}


}


/// @nodoc
mixin _$WidgetLinkApi {

 int get id; int get type; int? get organization; int? get branch; int? get worker; int? get service; String? get token;@JsonKey(name: 'widget_url') String get widgetUrl;
/// Create a copy of WidgetLinkApi
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WidgetLinkApiCopyWith<WidgetLinkApi> get copyWith => _$WidgetLinkApiCopyWithImpl<WidgetLinkApi>(this as WidgetLinkApi, _$identity);

  /// Serializes this WidgetLinkApi to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WidgetLinkApi&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.organization, organization) || other.organization == organization)&&(identical(other.branch, branch) || other.branch == branch)&&(identical(other.worker, worker) || other.worker == worker)&&(identical(other.service, service) || other.service == service)&&(identical(other.token, token) || other.token == token)&&(identical(other.widgetUrl, widgetUrl) || other.widgetUrl == widgetUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,organization,branch,worker,service,token,widgetUrl);

@override
String toString() {
  return 'WidgetLinkApi(id: $id, type: $type, organization: $organization, branch: $branch, worker: $worker, service: $service, token: $token, widgetUrl: $widgetUrl)';
}


}

/// @nodoc
abstract mixin class $WidgetLinkApiCopyWith<$Res>  {
  factory $WidgetLinkApiCopyWith(WidgetLinkApi value, $Res Function(WidgetLinkApi) _then) = _$WidgetLinkApiCopyWithImpl;
@useResult
$Res call({
 int id, int type, int? organization, int? branch, int? worker, int? service, String? token,@JsonKey(name: 'widget_url') String widgetUrl
});




}
/// @nodoc
class _$WidgetLinkApiCopyWithImpl<$Res>
    implements $WidgetLinkApiCopyWith<$Res> {
  _$WidgetLinkApiCopyWithImpl(this._self, this._then);

  final WidgetLinkApi _self;
  final $Res Function(WidgetLinkApi) _then;

/// Create a copy of WidgetLinkApi
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? organization = freezed,Object? branch = freezed,Object? worker = freezed,Object? service = freezed,Object? token = freezed,Object? widgetUrl = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,organization: freezed == organization ? _self.organization : organization // ignore: cast_nullable_to_non_nullable
as int?,branch: freezed == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as int?,worker: freezed == worker ? _self.worker : worker // ignore: cast_nullable_to_non_nullable
as int?,service: freezed == service ? _self.service : service // ignore: cast_nullable_to_non_nullable
as int?,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,widgetUrl: null == widgetUrl ? _self.widgetUrl : widgetUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WidgetLinkApi].
extension WidgetLinkApiPatterns on WidgetLinkApi {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WidgetLinkApi value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WidgetLinkApi() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WidgetLinkApi value)  $default,){
final _that = this;
switch (_that) {
case _WidgetLinkApi():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WidgetLinkApi value)?  $default,){
final _that = this;
switch (_that) {
case _WidgetLinkApi() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int type,  int? organization,  int? branch,  int? worker,  int? service,  String? token, @JsonKey(name: 'widget_url')  String widgetUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WidgetLinkApi() when $default != null:
return $default(_that.id,_that.type,_that.organization,_that.branch,_that.worker,_that.service,_that.token,_that.widgetUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int type,  int? organization,  int? branch,  int? worker,  int? service,  String? token, @JsonKey(name: 'widget_url')  String widgetUrl)  $default,) {final _that = this;
switch (_that) {
case _WidgetLinkApi():
return $default(_that.id,_that.type,_that.organization,_that.branch,_that.worker,_that.service,_that.token,_that.widgetUrl);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int type,  int? organization,  int? branch,  int? worker,  int? service,  String? token, @JsonKey(name: 'widget_url')  String widgetUrl)?  $default,) {final _that = this;
switch (_that) {
case _WidgetLinkApi() when $default != null:
return $default(_that.id,_that.type,_that.organization,_that.branch,_that.worker,_that.service,_that.token,_that.widgetUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WidgetLinkApi implements WidgetLinkApi {
  const _WidgetLinkApi({required this.id, required this.type, required this.organization, required this.branch, required this.worker, required this.service, required this.token, @JsonKey(name: 'widget_url') required this.widgetUrl});
  factory _WidgetLinkApi.fromJson(Map<String, dynamic> json) => _$WidgetLinkApiFromJson(json);

@override final  int id;
@override final  int type;
@override final  int? organization;
@override final  int? branch;
@override final  int? worker;
@override final  int? service;
@override final  String? token;
@override@JsonKey(name: 'widget_url') final  String widgetUrl;

/// Create a copy of WidgetLinkApi
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WidgetLinkApiCopyWith<_WidgetLinkApi> get copyWith => __$WidgetLinkApiCopyWithImpl<_WidgetLinkApi>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WidgetLinkApiToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WidgetLinkApi&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.organization, organization) || other.organization == organization)&&(identical(other.branch, branch) || other.branch == branch)&&(identical(other.worker, worker) || other.worker == worker)&&(identical(other.service, service) || other.service == service)&&(identical(other.token, token) || other.token == token)&&(identical(other.widgetUrl, widgetUrl) || other.widgetUrl == widgetUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,organization,branch,worker,service,token,widgetUrl);

@override
String toString() {
  return 'WidgetLinkApi(id: $id, type: $type, organization: $organization, branch: $branch, worker: $worker, service: $service, token: $token, widgetUrl: $widgetUrl)';
}


}

/// @nodoc
abstract mixin class _$WidgetLinkApiCopyWith<$Res> implements $WidgetLinkApiCopyWith<$Res> {
  factory _$WidgetLinkApiCopyWith(_WidgetLinkApi value, $Res Function(_WidgetLinkApi) _then) = __$WidgetLinkApiCopyWithImpl;
@override @useResult
$Res call({
 int id, int type, int? organization, int? branch, int? worker, int? service, String? token,@JsonKey(name: 'widget_url') String widgetUrl
});




}
/// @nodoc
class __$WidgetLinkApiCopyWithImpl<$Res>
    implements _$WidgetLinkApiCopyWith<$Res> {
  __$WidgetLinkApiCopyWithImpl(this._self, this._then);

  final _WidgetLinkApi _self;
  final $Res Function(_WidgetLinkApi) _then;

/// Create a copy of WidgetLinkApi
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? organization = freezed,Object? branch = freezed,Object? worker = freezed,Object? service = freezed,Object? token = freezed,Object? widgetUrl = null,}) {
  return _then(_WidgetLinkApi(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as int,organization: freezed == organization ? _self.organization : organization // ignore: cast_nullable_to_non_nullable
as int?,branch: freezed == branch ? _self.branch : branch // ignore: cast_nullable_to_non_nullable
as int?,worker: freezed == worker ? _self.worker : worker // ignore: cast_nullable_to_non_nullable
as int?,service: freezed == service ? _self.service : service // ignore: cast_nullable_to_non_nullable
as int?,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,widgetUrl: null == widgetUrl ? _self.widgetUrl : widgetUrl // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
