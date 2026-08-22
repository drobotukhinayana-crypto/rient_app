import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/providers/branch_timezone_provider.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/home/view/providers/selected_date_provider.dart';
import 'package:rient_app/features/schedule/view/providers/workers_provider.dart';

/// При смене таймзоны филиала обновляет выбранные даты на «сегодня» филиала.
final branchTimezoneSyncListenerProvider = Provider<void>((ref) {
  ref.listen(currentBranchProvider, (previous, next) {
    if (next == null) return;
    if (previous?.timezone == next.timezone) return;
    final today = ref.read(branchTodayProvider);
    ref.read(selectedScheduleDateProvider.notifier).state = today;
    ref.read(selectedDateProvider.notifier).setDate(today);
  });
});
