// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'base_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BaseState<T,E> {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BaseState<T, E>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BaseState<$T, $E>()';
}


}

/// @nodoc
class $BaseStateCopyWith<T,E,$Res>  {
$BaseStateCopyWith(BaseState<T, E> _, $Res Function(BaseState<T, E>) __);
}


/// Adds pattern-matching-related methods to [BaseState].
extension BaseStatePatterns<T,E> on BaseState<T, E> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _InitialBaseState<T, E> value)?  initial,TResult Function( LoadingBaseState<T, E> value)?  loading,TResult Function( _ErrorBaseState<T, E> value)?  error,TResult Function( _SuccessBaseState<T, E> value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InitialBaseState() when initial != null:
return initial(_that);case LoadingBaseState() when loading != null:
return loading(_that);case _ErrorBaseState() when error != null:
return error(_that);case _SuccessBaseState() when success != null:
return success(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _InitialBaseState<T, E> value)  initial,required TResult Function( LoadingBaseState<T, E> value)  loading,required TResult Function( _ErrorBaseState<T, E> value)  error,required TResult Function( _SuccessBaseState<T, E> value)  success,}){
final _that = this;
switch (_that) {
case _InitialBaseState():
return initial(_that);case LoadingBaseState():
return loading(_that);case _ErrorBaseState():
return error(_that);case _SuccessBaseState():
return success(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _InitialBaseState<T, E> value)?  initial,TResult? Function( LoadingBaseState<T, E> value)?  loading,TResult? Function( _ErrorBaseState<T, E> value)?  error,TResult? Function( _SuccessBaseState<T, E> value)?  success,}){
final _that = this;
switch (_that) {
case _InitialBaseState() when initial != null:
return initial(_that);case LoadingBaseState() when loading != null:
return loading(_that);case _ErrorBaseState() when error != null:
return error(_that);case _SuccessBaseState() when success != null:
return success(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( E? errorValue)?  error,TResult Function( T? value)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InitialBaseState() when initial != null:
return initial();case LoadingBaseState() when loading != null:
return loading();case _ErrorBaseState() when error != null:
return error(_that.errorValue);case _SuccessBaseState() when success != null:
return success(_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( E? errorValue)  error,required TResult Function( T? value)  success,}) {final _that = this;
switch (_that) {
case _InitialBaseState():
return initial();case LoadingBaseState():
return loading();case _ErrorBaseState():
return error(_that.errorValue);case _SuccessBaseState():
return success(_that.value);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( E? errorValue)?  error,TResult? Function( T? value)?  success,}) {final _that = this;
switch (_that) {
case _InitialBaseState() when initial != null:
return initial();case LoadingBaseState() when loading != null:
return loading();case _ErrorBaseState() when error != null:
return error(_that.errorValue);case _SuccessBaseState() when success != null:
return success(_that.value);case _:
  return null;

}
}

}

/// @nodoc


class _InitialBaseState<T,E> extends BaseState<T, E> {
  const _InitialBaseState(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InitialBaseState<T, E>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BaseState<$T, $E>.initial()';
}


}




/// @nodoc


class LoadingBaseState<T,E> extends BaseState<T, E> {
  const LoadingBaseState(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadingBaseState<T, E>);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BaseState<$T, $E>.loading()';
}


}




/// @nodoc


class _ErrorBaseState<T,E> extends BaseState<T, E> {
  const _ErrorBaseState([this.errorValue]): super._();
  

 final  E? errorValue;

/// Create a copy of BaseState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorBaseStateCopyWith<T, E, _ErrorBaseState<T, E>> get copyWith => __$ErrorBaseStateCopyWithImpl<T, E, _ErrorBaseState<T, E>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ErrorBaseState<T, E>&&const DeepCollectionEquality().equals(other.errorValue, errorValue));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(errorValue));

@override
String toString() {
  return 'BaseState<$T, $E>.error(errorValue: $errorValue)';
}


}

/// @nodoc
abstract mixin class _$ErrorBaseStateCopyWith<T,E,$Res> implements $BaseStateCopyWith<T, E, $Res> {
  factory _$ErrorBaseStateCopyWith(_ErrorBaseState<T, E> value, $Res Function(_ErrorBaseState<T, E>) _then) = __$ErrorBaseStateCopyWithImpl;
@useResult
$Res call({
 E? errorValue
});




}
/// @nodoc
class __$ErrorBaseStateCopyWithImpl<T,E,$Res>
    implements _$ErrorBaseStateCopyWith<T, E, $Res> {
  __$ErrorBaseStateCopyWithImpl(this._self, this._then);

  final _ErrorBaseState<T, E> _self;
  final $Res Function(_ErrorBaseState<T, E>) _then;

/// Create a copy of BaseState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? errorValue = freezed,}) {
  return _then(_ErrorBaseState<T, E>(
freezed == errorValue ? _self.errorValue : errorValue // ignore: cast_nullable_to_non_nullable
as E?,
  ));
}


}

/// @nodoc


class _SuccessBaseState<T,E> extends BaseState<T, E> {
  const _SuccessBaseState([this.value]): super._();
  

 final  T? value;

/// Create a copy of BaseState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SuccessBaseStateCopyWith<T, E, _SuccessBaseState<T, E>> get copyWith => __$SuccessBaseStateCopyWithImpl<T, E, _SuccessBaseState<T, E>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SuccessBaseState<T, E>&&const DeepCollectionEquality().equals(other.value, value));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(value));

@override
String toString() {
  return 'BaseState<$T, $E>.success(value: $value)';
}


}

/// @nodoc
abstract mixin class _$SuccessBaseStateCopyWith<T,E,$Res> implements $BaseStateCopyWith<T, E, $Res> {
  factory _$SuccessBaseStateCopyWith(_SuccessBaseState<T, E> value, $Res Function(_SuccessBaseState<T, E>) _then) = __$SuccessBaseStateCopyWithImpl;
@useResult
$Res call({
 T? value
});




}
/// @nodoc
class __$SuccessBaseStateCopyWithImpl<T,E,$Res>
    implements _$SuccessBaseStateCopyWith<T, E, $Res> {
  __$SuccessBaseStateCopyWithImpl(this._self, this._then);

  final _SuccessBaseState<T, E> _self;
  final $Res Function(_SuccessBaseState<T, E>) _then;

/// Create a copy of BaseState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = freezed,}) {
  return _then(_SuccessBaseState<T, E>(
freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as T?,
  ));
}


}

// dart format on
