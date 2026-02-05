import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_state.freezed.dart';

/// T - возвращаемое значение (опционально) <br>
/// E - тип данных ошибки <br>
@freezed
class BaseState<T, E> with _$BaseState<T, E> {
  const factory BaseState.initial() = _InitialBaseState;
  const factory BaseState.loading() = LoadingBaseState;
  const factory BaseState.error([E? errorValue]) = _ErrorBaseState;
  const factory BaseState.success([T? value]) = _SuccessBaseState;
  const BaseState._();

  T? get value => whenOrNull(success: (e) => e);
  bool get isLoading => maybeWhen(orElse: () => false, loading: () => true);
}
