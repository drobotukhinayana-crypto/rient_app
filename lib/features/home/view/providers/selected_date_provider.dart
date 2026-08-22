import 'package:rient_app/core/providers/branch_timezone_provider.dart';
import 'package:flutter_riverpod/legacy.dart';

/// Провайдер для выбранной даты на главной странице.
/// По умолчанию — сегодня в таймзоне филиала.
final selectedDateProvider = StateNotifierProvider<SelectedDateNotifier, DateTime>(
  (ref) => SelectedDateNotifier(ref.watch(branchTodayProvider)),
);

class SelectedDateNotifier extends StateNotifier<DateTime> {
  SelectedDateNotifier(super.initialDate);

  void setDate(DateTime date) {
    final next = DateTime(date.year, date.month, date.day);
    if (state.year == next.year &&
        state.month == next.month &&
        state.day == next.day) {
      return;
    }
    state = next;
  }
}