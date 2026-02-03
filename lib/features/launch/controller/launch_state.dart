import 'package:freezed_annotation/freezed_annotation.dart';

part 'launch_state.freezed.dart';

@freezed
sealed class LaunchState with _$LaunchState {
  const factory LaunchState.initial() = InitialLaunchState;
  const factory LaunchState.loading() = LoadingLaunchState;
  const factory LaunchState.error(Object error) = ErrorLaunchState;
  const factory LaunchState.loggedIn() = LoggedInLaunchState;
  const factory LaunchState.notLoggedIn() = NotLoggedInLaunchState;
}
