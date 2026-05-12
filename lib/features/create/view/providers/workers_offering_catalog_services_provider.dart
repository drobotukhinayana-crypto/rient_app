import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/create/service/worker_services_service.dart';
import 'package:rient_app/features/schedule/view/providers/workers_provider.dart';

/// Ключ: `"<branchId>|all"` — все сотрудники филиала; иначе
/// `"<branchId>|<catalogServiceId1>,<id2>,..."` (отсортированные id услуг из каталога).
///
/// Возвращает id сотрудников, у которых в филиале есть **все** указанные услуги
/// (сопоставление по [WorkerServiceInfo.id]).
final workersOfferingCatalogServicesProvider =
    FutureProvider.autoDispose.family<Set<int>, String>((ref, key) async {
      final parts = key.split('|');
      if (parts.isEmpty) return {};
      final branchId = int.tryParse(parts[0]) ?? 0;
      if (branchId == 0) return {};

      final workersResponse = await ref.watch(scheduleWorkersProvider.future);
      final allWorkerIds = {for (final w in workersResponse.results) w.id};

      if (parts.length < 2 || parts[1] == 'all') {
        return allWorkerIds;
      }

      final requiredRaw = parts[1];
      if (requiredRaw.isEmpty) return allWorkerIds;

      final requiredIds = requiredRaw
          .split(',')
          .map((s) => int.tryParse(s.trim()))
          .whereType<int>()
          .where((id) => id > 0)
          .toSet();

      if (requiredIds.isEmpty) return allWorkerIds;

      final api = ref.read(workerServicesServiceProvider);
      final results = await Future.wait(
        workersResponse.results.map((worker) async {
          try {
            final resp = await api.getWorkerServices(
              workerId: worker.id,
              branchId: branchId,
              pageSize: 500,
            );
            final offeredCatalogIds = resp.results
                .map((e) => e.service.id)
                .where((id) => id > 0)
                .toSet();
            if (requiredIds.every(offeredCatalogIds.contains)) {
              return worker.id;
            }
          } catch (_) {
            // пропускаем сотрудника при ошибке загрузки услуг
          }
          return null;
        }),
      );

      return {for (final id in results) if (id != null) id};
    });
