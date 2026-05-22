// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'push_history_count.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PushHistoryCount {

 int get total; int get unread;
/// Create a copy of PushHistoryCount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PushHistoryCountCopyWith<PushHistoryCount> get copyWith => _$PushHistoryCountCopyWithImpl<PushHistoryCount>(this as PushHistoryCount, _$identity);

  /// Serializes this PushHistoryCount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PushHistoryCount&&(identical(other.total, total) || other.total == total)&&(identical(other.unread, unread) || other.unread == unread));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,unread);

@override
String toString() {
  return 'PushHistoryCount(total: $total, unread: $unread)';
}


}

/// @nodoc
abstract mixin class $PushHistoryCountCopyWith<$Res>  {
  factory $PushHistoryCountCopyWith(PushHistoryCount value, $Res Function(PushHistoryCount) _then) = _$PushHistoryCountCopyWithImpl;
@useResult
$Res call({
 int total, int unread
});




}
/// @nodoc
class _$PushHistoryCountCopyWithImpl<$Res>
    implements $PushHistoryCountCopyWith<$Res> {
  _$PushHistoryCountCopyWithImpl(this._self, this._then);

  final PushHistoryCount _self;
  final $Res Function(PushHistoryCount) _then;

/// Create a copy of PushHistoryCount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? unread = null,}) {
  return _then(_self.copyWith(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,unread: null == unread ? _self.unread : unread // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PushHistoryCount].
extension PushHistoryCountPatterns on PushHistoryCount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PushHistoryCount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PushHistoryCount() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PushHistoryCount value)  $default,){
final _that = this;
switch (_that) {
case _PushHistoryCount():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PushHistoryCount value)?  $default,){
final _that = this;
switch (_that) {
case _PushHistoryCount() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  int unread)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PushHistoryCount() when $default != null:
return $default(_that.total,_that.unread);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  int unread)  $default,) {final _that = this;
switch (_that) {
case _PushHistoryCount():
return $default(_that.total,_that.unread);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  int unread)?  $default,) {final _that = this;
switch (_that) {
case _PushHistoryCount() when $default != null:
return $default(_that.total,_that.unread);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PushHistoryCount implements PushHistoryCount {
  const _PushHistoryCount({required this.total, required this.unread});
  factory _PushHistoryCount.fromJson(Map<String, dynamic> json) => _$PushHistoryCountFromJson(json);

@override final  int total;
@override final  int unread;

/// Create a copy of PushHistoryCount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PushHistoryCountCopyWith<_PushHistoryCount> get copyWith => __$PushHistoryCountCopyWithImpl<_PushHistoryCount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PushHistoryCountToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PushHistoryCount&&(identical(other.total, total) || other.total == total)&&(identical(other.unread, unread) || other.unread == unread));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,total,unread);

@override
String toString() {
  return 'PushHistoryCount(total: $total, unread: $unread)';
}


}

/// @nodoc
abstract mixin class _$PushHistoryCountCopyWith<$Res> implements $PushHistoryCountCopyWith<$Res> {
  factory _$PushHistoryCountCopyWith(_PushHistoryCount value, $Res Function(_PushHistoryCount) _then) = __$PushHistoryCountCopyWithImpl;
@override @useResult
$Res call({
 int total, int unread
});




}
/// @nodoc
class __$PushHistoryCountCopyWithImpl<$Res>
    implements _$PushHistoryCountCopyWith<$Res> {
  __$PushHistoryCountCopyWithImpl(this._self, this._then);

  final _PushHistoryCount _self;
  final $Res Function(_PushHistoryCount) _then;

/// Create a copy of PushHistoryCount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? unread = null,}) {
  return _then(_PushHistoryCount(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,unread: null == unread ? _self.unread : unread // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
