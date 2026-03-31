import 'package:flutter_riverpod/legacy.dart';

/// Допустимые интервалы длительности ячейки расписания (в минутах).
const scheduleCellIntervalOptions = <int>[5, 10, 15, 20, 30, 60];

/// Интервал ячейки, выбранный пользователем вручную.
final scheduleCellIntervalMinutesProvider = StateProvider<int>((ref) => 60);

