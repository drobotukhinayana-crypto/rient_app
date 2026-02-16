import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:rient_app/core/services/email_storage.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/session_data/view/controller/session_data_controller.dart';
import 'package:rient_app/features/launch/controller/launch_state.dart';

final launchControllerProvider =
    StateNotifierProvider.autoDispose<LaunchController, LaunchState>(
      (ref) => LaunchController(ref),
    );

class LaunchController extends StateNotifier<LaunchState> {
  LaunchController(this.ref) : super(const LaunchState.loading()) {
    _init();
  }

  final Ref ref;

  Future<void> _init() async {
    try {
      state = const LaunchState.loading();
      await ref.read(emailStorageProvider.notifier).init();
      await ref.read(tokenProvider.notifier).init();
      final isLoggedIn = await ref
          .read(sessionDataControllerProvider.notifier)
          .init();

      if (isLoggedIn) {
        state = const LaunchState.loggedIn();
      } else {
        state = const LaunchState.notLoggedIn();
      }
    } catch (e) {
      state = const LaunchState.notLoggedIn();
    }
  }
}
