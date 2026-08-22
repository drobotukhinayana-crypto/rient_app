import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/utils/branch_timezone.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';

/// Таймзона текущего филиала из [BranchApi.timezone].
final branchTimezoneProvider = Provider<BranchTimezone>((ref) {
  final branch = ref.watch(currentBranchProvider);
  return BranchTimezone(branch?.timezone);
});

/// «Сегодня» в таймзоне текущего филиала (без времени).
final branchTodayProvider = Provider<DateTime>((ref) {
  return ref.watch(branchTimezoneProvider).todayDateOnly();
});
