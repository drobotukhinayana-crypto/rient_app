import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:rient_app/core/utils/base_state/base_state.dart';
import 'package:rient_app/features/auth/service/auth_exception.dart';
import 'package:rient_app/features/auth/service/auth_service.dart';

final getTokenControllerProvider =
    StateNotifierProvider.autoDispose<
      GetTokenController,
      BaseState<void, Exception>
    >((ref) => GetTokenController(ref));

class GetTokenController extends StateNotifier<BaseState<void, Exception>> {
  GetTokenController(this.ref) : super(const BaseState.initial());

  final Ref ref;

  AuthService get _authService => ref.read(authServiceProvider);

  Future<void> getToken({
    required String password,
    required int deviceId,
    required int userAgent,
    int? branchId,
  }) async {
    state = const BaseState.loading();
    try {
      await _authService.getToken(
        password: password,
        deviceId: deviceId,
        userAgent: userAgent,
        branchId: branchId,
      );

      state = const BaseState.success();
    } on AuthException catch (e) {
      state = BaseState.error(e);
    } catch (e) {
      state = BaseState.error(Exception(e));
    }
  }
}
