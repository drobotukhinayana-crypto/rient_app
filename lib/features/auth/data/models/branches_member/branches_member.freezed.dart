// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'branches_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BranchesMember {

@JsonKey(fromJson: _roleFromJson, toJson: _roleToJson) UserRole get role; Branches get branches;
/// Create a copy of BranchesMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BranchesMemberCopyWith<BranchesMember> get copyWith => _$BranchesMemberCopyWithImpl<BranchesMember>(this as BranchesMember, _$identity);

  /// Serializes this BranchesMember to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BranchesMember&&(identical(other.role, role) || other.role == role)&&const DeepCollectionEquality().equals(other.branches, branches));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role,const DeepCollectionEquality().hash(branches));

@override
String toString() {
  return 'BranchesMember(role: $role, branches: $branches)';
}


}

/// @nodoc
abstract mixin class $BranchesMemberCopyWith<$Res>  {
  factory $BranchesMemberCopyWith(BranchesMember value, $Res Function(BranchesMember) _then) = _$BranchesMemberCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _roleFromJson, toJson: _roleToJson) UserRole role, Branches branches
});




}
/// @nodoc
class _$BranchesMemberCopyWithImpl<$Res>
    implements $BranchesMemberCopyWith<$Res> {
  _$BranchesMemberCopyWithImpl(this._self, this._then);

  final BranchesMember _self;
  final $Res Function(BranchesMember) _then;

/// Create a copy of BranchesMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? role = null,Object? branches = null,}) {
  return _then(_self.copyWith(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,branches: null == branches ? _self.branches : branches // ignore: cast_nullable_to_non_nullable
as Branches,
  ));
}

}


/// Adds pattern-matching-related methods to [BranchesMember].
extension BranchesMemberPatterns on BranchesMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BranchesMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BranchesMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BranchesMember value)  $default,){
final _that = this;
switch (_that) {
case _BranchesMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BranchesMember value)?  $default,){
final _that = this;
switch (_that) {
case _BranchesMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _roleFromJson, toJson: _roleToJson)  UserRole role,  Branches branches)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BranchesMember() when $default != null:
return $default(_that.role,_that.branches);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _roleFromJson, toJson: _roleToJson)  UserRole role,  Branches branches)  $default,) {final _that = this;
switch (_that) {
case _BranchesMember():
return $default(_that.role,_that.branches);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _roleFromJson, toJson: _roleToJson)  UserRole role,  Branches branches)?  $default,) {final _that = this;
switch (_that) {
case _BranchesMember() when $default != null:
return $default(_that.role,_that.branches);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BranchesMember implements BranchesMember {
  const _BranchesMember({@JsonKey(fromJson: _roleFromJson, toJson: _roleToJson) required this.role, required final  Branches branches}): _branches = branches;
  factory _BranchesMember.fromJson(Map<String, dynamic> json) => _$BranchesMemberFromJson(json);

@override@JsonKey(fromJson: _roleFromJson, toJson: _roleToJson) final  UserRole role;
 final  Branches _branches;
@override Branches get branches {
  if (_branches is EqualUnmodifiableListView) return _branches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_branches);
}


/// Create a copy of BranchesMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BranchesMemberCopyWith<_BranchesMember> get copyWith => __$BranchesMemberCopyWithImpl<_BranchesMember>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BranchesMemberToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BranchesMember&&(identical(other.role, role) || other.role == role)&&const DeepCollectionEquality().equals(other._branches, _branches));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role,const DeepCollectionEquality().hash(_branches));

@override
String toString() {
  return 'BranchesMember(role: $role, branches: $branches)';
}


}

/// @nodoc
abstract mixin class _$BranchesMemberCopyWith<$Res> implements $BranchesMemberCopyWith<$Res> {
  factory _$BranchesMemberCopyWith(_BranchesMember value, $Res Function(_BranchesMember) _then) = __$BranchesMemberCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _roleFromJson, toJson: _roleToJson) UserRole role, Branches branches
});




}
/// @nodoc
class __$BranchesMemberCopyWithImpl<$Res>
    implements _$BranchesMemberCopyWith<$Res> {
  __$BranchesMemberCopyWithImpl(this._self, this._then);

  final _BranchesMember _self;
  final $Res Function(_BranchesMember) _then;

/// Create a copy of BranchesMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? role = null,Object? branches = null,}) {
  return _then(_BranchesMember(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as UserRole,branches: null == branches ? _self._branches : branches // ignore: cast_nullable_to_non_nullable
as Branches,
  ));
}


}

// dart format on
