import 'package:flutter_riverpod/legacy.dart';

/// Провайдер для выбранной даты на главной странице.
/// По умолчанию устанавливается сегодняшний день.
final selectedDateProvider = StateNotifierProvider<SelectedDateNotifier, DateTime>(
  (ref) => SelectedDateNotifier(),
);

class SelectedDateNotifier extends StateNotifier<DateTime> {
  SelectedDateNotifier()
      : super(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));

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