// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'launch_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LaunchState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LaunchState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LaunchState()';
}


}

/// @nodoc
class $LaunchStateCopyWith<$Res>  {
$LaunchStateCopyWith(LaunchState _, $Res Function(LaunchState) __);
}


/// Adds pattern-matching-related methods to [LaunchState].
extension LaunchStatePatterns on LaunchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( InitialLaunchState value)?  initial,TResult Function( LoadingLaunchState value)?  loading,TResult Function( ErrorLaunchState value)?  error,TResult Function( LoggedInLaunchState value)?  loggedIn,TResult Function( NotLoggedInLaunchState value)?  notLoggedIn,required TResult orElse(),}){
final _that = this;
switch (_that) {
case InitialLaunchState() when initial != null:
return initial(_that);case LoadingLaunchState() when loading != null:
return loading(_that);case ErrorLaunchState() when error != null:
return error(_that);case LoggedInLaunchState() when loggedIn != null:
return loggedIn(_that);case NotLoggedInLaunchState() when notLoggedIn != null:
return notLoggedIn(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( InitialLaunchState value)  initial,required TResult Function( LoadingLaunchState value)  loading,required TResult Function( ErrorLaunchState value)  error,required TResult Function( LoggedInLaunchState value)  loggedIn,required TResult Function( NotLoggedInLaunchState value)  notLoggedIn,}){
final _that = this;
switch (_that) {
case InitialLaunchState():
return initial(_that);case LoadingLaunchState():
return loading(_that);case ErrorLaunchState():
return error(_that);case LoggedInLaunchState():
return loggedIn(_that);case NotLoggedInLaunchState():
return notLoggedIn(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( InitialLaunchState value)?  initial,TResult? Function( LoadingLaunchState value)?  loading,TResult? Function( ErrorLaunchState value)?  error,TResult? Function( LoggedInLaunchState value)?  loggedIn,TResult? Function( NotLoggedInLaunchState value)?  notLoggedIn,}){
final _that = this;
switch (_that) {
case InitialLaunchState() when initial != null:
return initial(_that);case LoadingLaunchState() when loading != null:
return loading(_that);case ErrorLaunchState() when error != null:
return error(_that);case LoggedInLaunchState() when loggedIn != null:
return loggedIn(_that);case NotLoggedInLaunchState() when notLoggedIn != null:
return notLoggedIn(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( Object error)?  error,TResult Function()?  loggedIn,TResult Function()?  notLoggedIn,required TResult orElse(),}) {final _that = this;
switch (_that) {
case InitialLaunchState() when initial != null:
return initial();case LoadingLaunchState() when loading != null:
return loading();case ErrorLaunchState() when error != null:
return error(_that.error);case LoggedInLaunchState() when loggedIn != null:
return loggedIn();case NotLoggedInLaunchState() when notLoggedIn != null:
return notLoggedIn();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( Object error)  error,required TResult Function()  loggedIn,required TResult Function()  notLoggedIn,}) {final _that = this;
switch (_that) {
case InitialLaunchState():
return initial();case LoadingLaunchState():
return loading();case ErrorLaunchState():
return error(_that.error);case LoggedInLaunchState():
return loggedIn();case NotLoggedInLaunchState():
return notLoggedIn();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( Object error)?  error,TResult? Function()?  loggedIn,TResult? Function()?  notLoggedIn,}) {final _that = this;
switch (_that) {
case InitialLaunchState() when initial != null:
return initial();case LoadingLaunchState() when loading != null:
return loading();case ErrorLaunchState() when error != null:
return error(_that.error);case LoggedInLaunchState() when loggedIn != null:
return loggedIn();case NotLoggedInLaunchState() when notLoggedIn != null:
return notLoggedIn();case _:
  return null;

}
}

}

/// @nodoc


class InitialLaunchState implements LaunchState {
  const InitialLaunchState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InitialLaunchState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LaunchState.initial()';
}


}




/// @nodoc


class LoadingLaunchState implements LaunchState {
  const LoadingLaunchState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadingLaunchState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LaunchState.loading()';
}


}




/// @nodoc


class ErrorLaunchState implements LaunchState {
  const ErrorLaunchState(this.error);
  

 final  Object error;

/// Create a copy of LaunchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ErrorLaunchStateCopyWith<ErrorLaunchState> get copyWith => _$ErrorLaunchStateCopyWithImpl<ErrorLaunchState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorLaunchState&&const DeepCollectionEquality().equals(other.error, error));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(error));

@override
String toString() {
  return 'LaunchState.error(error: $error)';
}


}

/// @nodoc
abstract mixin class $ErrorLaunchStateCopyWith<$Res> implements $LaunchStateCopyWith<$Res> {
  factory $ErrorLaunchStateCopyWith(ErrorLaunchState value, $Res Function(ErrorLaunchState) _then) = _$ErrorLaunchStateCopyWithImpl;
@useResult
$Res call({
 Object error
});




}
/// @nodoc
class _$ErrorLaunchStateCopyWithImpl<$Res>
    implements $ErrorLaunchStateCopyWith<$Res> {
  _$ErrorLaunchStateCopyWithImpl(this._self, this._then);

  final ErrorLaunchState _self;
  final $Res Function(ErrorLaunchState) _then;

/// Create a copy of LaunchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(ErrorLaunchState(
null == error ? _self.error : error ,
  ));
}


}

/// @nodoc


class LoggedInLaunchState implements LaunchState {
  const LoggedInLaunchState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoggedInLaunchState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LaunchState.loggedIn()';
}


}




/// @nodoc


class NotLoggedInLaunchState implements LaunchState {
  const NotLoggedInLaunchState();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotLoggedInLaunchState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LaunchState.notLoggedIn()';
}


}




// dart format on
