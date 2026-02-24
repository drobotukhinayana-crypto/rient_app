import 'package:flutter_riverpod/legacy.dart';

/// Провайдер для выбранной даты на главной странице.
/// По умолчанию устанавливается сегодняшний день.
final selectedDateProvider = StateNotifierProvider<SelectedDateNotifier, DateTime>(
  (ref) => SelectedDateNotifier(),
);

class SelectedDateNotifier extends StateNotifier<DateTime> {
  SelectedDateNotifier() : super(DateTime.now());

  void setDate(DateTime date) {
    state = date;
  }
}