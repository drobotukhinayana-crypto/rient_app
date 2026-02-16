// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'branches.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Branch {

 int get id; String? get address; String? get city; String? get country; String? get email;@JsonKey(name: 'is_available') bool get isAvailable;@JsonKey(name: 'is_blocked') bool get isBlocked; String? get name; String? get phone; String? get region;
/// Create a copy of Branch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BranchCopyWith<Branch> get copyWith => _$BranchCopyWithImpl<Branch>(this as Branch, _$identity);

  /// Serializes this Branch to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Branch&&(identical(other.id, id) || other.id == id)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.country, country) || other.country == country)&&(identical(other.email, email) || other.email == email)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.isBlocked, isBlocked) || other.isBlocked == isBlocked)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.region, region) || other.region == region));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,address,city,country,email,isAvailable,isBlocked,name,phone,region);

@override
String toString() {
  return 'Branch(id: $id, address: $address, city: $city, country: $country, email: $email, isAvailable: $isAvailable, isBlocked: $isBlocked, name: $name, phone: $phone, region: $region)';
}


}

/// @nodoc
abstract mixin class $BranchCopyWith<$Res>  {
  factory $BranchCopyWith(Branch value, $Res Function(Branch) _then) = _$BranchCopyWithImpl;
@useResult
$Res call({
 int id, String? address, String? city, String? country, String? email,@JsonKey(name: 'is_available') bool isAvailable,@JsonKey(name: 'is_blocked') bool isBlocked, String? name, String? phone, String? region
});




}
/// @nodoc
class _$BranchCopyWithImpl<$Res>
    implements $BranchCopyWith<$Res> {
  _$BranchCopyWithImpl(this._self, this._then);

  final Branch _self;
  final $Res Function(Branch) _then;

/// Create a copy of Branch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? address = freezed,Object? city = freezed,Object? country = freezed,Object? email = freezed,Object? isAvailable = null,Object? isBlocked = null,Object? name = freezed,Object? phone = freezed,Object? region = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,isBlocked: null == isBlocked ? _self.isBlocked : isBlocked // ignore: cast_nullable_to_non_nullable
as bool,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,region: freezed == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Branch].
extension BranchPatterns on Branch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Branch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Branch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Branch value)  $default,){
final _that = this;
switch (_that) {
case _Branch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Branch value)?  $default,){
final _that = this;
switch (_that) {
case _Branch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? address,  String? city,  String? country,  String? email, @JsonKey(name: 'is_available')  bool isAvailable, @JsonKey(name: 'is_blocked')  bool isBlocked,  String? name,  String? phone,  String? region)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Branch() when $default != null:
return $default(_that.id,_that.address,_that.city,_that.country,_that.email,_that.isAvailable,_that.isBlocked,_that.name,_that.phone,_that.region);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? address,  String? city,  String? country,  String? email, @JsonKey(name: 'is_available')  bool isAvailable, @JsonKey(name: 'is_blocked')  bool isBlocked,  String? name,  String? phone,  String? region)  $default,) {final _that = this;
switch (_that) {
case _Branch():
return $default(_that.id,_that.address,_that.city,_that.country,_that.email,_that.isAvailable,_that.isBlocked,_that.name,_that.phone,_that.region);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? address,  String? city,  String? country,  String? email, @JsonKey(name: 'is_available')  bool isAvailable, @JsonKey(name: 'is_blocked')  bool isBlocked,  String? name,  String? phone,  String? region)?  $default,) {final _that = this;
switch (_that) {
case _Branch() when $default != null:
return $default(_that.id,_that.address,_that.city,_that.country,_that.email,_that.isAvailable,_that.isBlocked,_that.name,_that.phone,_that.region);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Branch implements Branch {
  const _Branch({required this.id, required this.address, required this.city, required this.country, required this.email, @JsonKey(name: 'is_available') required this.isAvailable, @JsonKey(name: 'is_blocked') required this.isBlocked, required this.name, required this.phone, required this.region});
  factory _Branch.fromJson(Map<String, dynamic> json) => _$BranchFromJson(json);

@override final  int id;
@override final  String? address;
@override final  String? city;
@override final  String? country;
@override final  String? email;
@override@JsonKey(name: 'is_available') final  bool isAvailable;
@override@JsonKey(name: 'is_blocked') final  bool isBlocked;
@override final  String? name;
@override final  String? phone;
@override final  String? region;

/// Create a copy of Branch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BranchCopyWith<_Branch> get copyWith => __$BranchCopyWithImpl<_Branch>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BranchToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Branch&&(identical(other.id, id) || other.id == id)&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.country, country) || other.country == country)&&(identical(other.email, email) || other.email == email)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.isBlocked, isBlocked) || other.isBlocked == isBlocked)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.region, region) || other.region == region));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,address,city,country,email,isAvailable,isBlocked,name,phone,region);

@override
String toString() {
  return 'Branch(id: $id, address: $address, city: $city, country: $country, email: $email, isAvailable: $isAvailable, isBlocked: $isBlocked, name: $name, phone: $phone, region: $region)';
}


}

/// @nodoc
abstract mixin class _$BranchCopyWith<$Res> implements $BranchCopyWith<$Res> {
  factory _$BranchCopyWith(_Branch value, $Res Function(_Branch) _then) = __$BranchCopyWithImpl;
@override @useResult
$Res call({
 int id, String? address, String? city, String? country, String? email,@JsonKey(name: 'is_available') bool isAvailable,@JsonKey(name: 'is_blocked') bool isBlocked, String? name, String? phone, String? region
});




}
/// @nodoc
class __$BranchCopyWithImpl<$Res>
    implements _$BranchCopyWith<$Res> {
  __$BranchCopyWithImpl(this._self, this._then);

  final _Branch _self;
  final $Res Function(_Branch) _then;

/// Create a copy of Branch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? address = freezed,Object? city = freezed,Object? country = freezed,Object? email = freezed,Object? isAvailable = null,Object? isBlocked = null,Object? name = freezed,Object? phone = freezed,Object? region = freezed,}) {
  return _then(_Branch(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,isBlocked: null == isBlocked ? _self.isBlocked : isBlocked // ignore: cast_nullable_to_non_nullable
as bool,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,region: freezed == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
