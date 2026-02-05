import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:rient_app/core/utils/base_state/base_state.dart';
import 'package:rient_app/features/auth/service/auth_exception.dart';
import 'package:rient_app/features/auth/service/auth_service.dart';

final getOtpControllerProvider =
    StateNotifierProvider.autoDispose<
      GetOtpController,
      BaseState<void, Exception>
    >((ref) => GetOtpController(ref));

class GetOtpController extends StateNotifier<BaseState<void, Exception>> {
  GetOtpController(this.ref) : super(const BaseState.initial());

  final Ref ref;

  AuthService get _authService => ref.read(authServiceProvider);

  Future<void> getOtp(String email, String captcha) async {
    state = const BaseState.loading();
    try {
      await _authService.requestVerificationCode(
        email: email,
        captcha: captcha,
      );

      state = const BaseState.success();
    } on AuthException catch (e) {
      state = BaseState.error(e);
    } catch (e) {
      state = BaseState.error(Exception(e));
    }
  }

  Future<void> verifyOtp(
    String email,
    String captcha,
    String verificationCode,
  ) async {
    state = const BaseState.loading();
    try {
      await _authService.verifyVerificationCode(
        email: email,
        captcha: captcha,
        verificationCode: verificationCode,
      );

      state = const BaseState.success();
    } on AuthException catch (e) {
      state = BaseState.error(e);
    } catch (e) {
      state = BaseState.error(Exception(e));
    }
  }
}
