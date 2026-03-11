import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/schedule/data/models/workers_api/workers_api.dart';
import 'package:rient_app/features/schedule/service/workers_service.dart';

/// Список рабочих (специалистов) для текущего филиала на странице расписания.
final scheduleWorkersProvider = FutureProvider<WorkersApiResponse>((ref) async {
  final branchId = ref.watch(currentBranchIdProvider);
  if (branchId == 0) {
    throw Exception('No valid branch selected');
  }
  final service = ref.watch(workersServiceProvider);
  return service.getWorkers(branchId: branchId);
});
