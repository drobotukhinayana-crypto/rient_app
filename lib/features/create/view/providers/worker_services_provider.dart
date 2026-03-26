import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/create/data/models/worker_services_api.dart';
import 'package:rient_app/features/create/service/worker_services_service.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';

final workerServicesForWorkerProvider =
    FutureProvider.family<List<WorkerServiceItem>, int>((ref, workerId) async {
      final branchId = ref.watch(currentBranchIdProvider);
      if (branchId == 0 || workerId == 0) return const [];
      final service = ref.watch(workerServicesServiceProvider);
      final response = await service.getWorkerServices(
        workerId: workerId,
        branchId: branchId,
      );
      return response.results;
    });
