import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Сигнал из drawer: показать диалог выхода на уровне TabBar (стабильный context).
final logoutRequestProvider = StateProvider<int>((ref) => 0);

void requestLogout(WidgetRef ref) {
  ref.read(logoutRequestProvider.notifier).update((value) => value + 1);
}
