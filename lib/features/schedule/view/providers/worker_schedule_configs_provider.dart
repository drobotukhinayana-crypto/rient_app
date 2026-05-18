import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/schedule/data/models/worker_schedule_config_api/update_worker_schedule_config_request.dart';
import 'package:rient_app/features/schedule/data/models/worker_schedule_config_api/worker_schedule_config_api.dart';
import 'package:rient_app/features/schedule/service/worker_schedule_configs_service.dart';

class UpdateWorkerScheduleConfigParams {
  const UpdateWorkerScheduleConfigParams({
    required this.workerId,
    required this.configUuid,
    required this.body,
  });

  final int workerId;
  final String configUuid;
  final UpdateWorkerScheduleConfigRequest body;
}

/// PATCH конфига режима работы сотрудника (неделя / смена).
Future<WorkerScheduleConfigApi> updateWorkerScheduleConfig(
  Ref ref, {
  required int workerId,
  required String configUuid,
  required UpdateWorkerScheduleConfigRequest body,
}) {
  return ref.read(workerScheduleConfigsServiceProvider).updateWorkerScheduleConfig(
        workerId: workerId,
        configUuid: configUuid,
        body: body,
      );
}

/// Self-service: PATCH своего schedule config в текущем филиале.
Future<WorkerScheduleConfigApi> updateMyScheduleConfig(
  Ref ref, {
  required UpdateWorkerScheduleConfigRequest body,
}) {
  return ref.read(workerScheduleConfigsServiceProvider).updateMyScheduleConfig(
        body: body,
      );
}
