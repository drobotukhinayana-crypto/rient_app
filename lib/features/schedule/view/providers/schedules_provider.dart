import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/schedule/data/models/schedules_api/schedules_api.dart';
import 'package:rient_app/features/schedule/service/schedules_service.dart';

/// Строка даты DD.MM.YYYY для ключа кэша и API.
String scheduleDateKey(DateTime date) {
  final d = date.day.toString().padLeft(2, '0');
  final m = date.month.toString().padLeft(2, '0');
  final y = date.year;
  return '$d.$m.$y';
}

DateTime? _parseDateKey(String dateKey) {
  final parts = dateKey.split('.');
  if (parts.length != 3) return null;
  final day = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  final year = int.tryParse(parts[2]);
  if (day == null || month == null || year == null) return null;
  if (month < 1 || month > 12 || day < 1 || day > 31) return null;
  return DateTime(year, month, day);
}

/// Расписания на одну дату по текущему филиалу.
final scheduleForDateProvider =
    FutureProvider.family<SchedulesApiResponse, String>((ref, dateKey) async {
  final date = _parseDateKey(dateKey);
  if (date == null) throw Exception('Invalid date key: $dateKey');
  final branchId = ref.watch(currentBranchIdProvider);
  if (branchId == 0) throw Exception('No valid branch selected');
  final service = ref.watch(schedulesServiceProvider);
  return service.getSchedules(
    branchId: branchId,
    dateGte: date,
    dateLte: date,
    pageSize: 500,
  );
});

/// Id сотрудников, которые работают в указанный день.
final workerIdsWorkingOnDateProvider =
    Provider.family<List<int>, DateTime>((ref, date) {
  final schedulesAsync =
      ref.watch(scheduleForDateProvider(scheduleDateKey(date)));
  return schedulesAsync.maybeWhen(
    data: (response) => response.results
        .where((s) => s.active && s.workerId != null)
        .map((s) => s.workerId!)
        .toSet()
        .toList(),
    orElse: () => <int>[],
  );
});
