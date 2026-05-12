import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/services/unauthorized_handler.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';

class WorkerPermissions {
  const WorkerPermissions({
    required this.seeContactData,
    required this.deleteSchedule,
    required this.transferSchedule,
    required this.createSchedule,
    required this.seeIncome,
    required this.seeToBePaid,
    required this.change,
    required this.changeWorker,
    required this.changeStatus,
  });

  final bool seeContactData;
  final bool deleteSchedule;
  final bool transferSchedule;
  final bool createSchedule;
  final bool seeIncome;
  final bool seeToBePaid;
  final bool change;
  final bool changeWorker;
  final bool changeStatus;

  static const fullAccess = WorkerPermissions(
    seeContactData: true,
    deleteSchedule: true,
    transferSchedule: true,
    createSchedule: true,
    seeIncome: true,
    seeToBePaid: true,
    change: true,
    changeWorker: true,
    changeStatus: true,
  );
}

bool _boolFrom(dynamic raw, {bool fallback = false}) {
  if (raw is bool) return raw;
  if (raw is num) return raw != 0;
  if (raw is String) {
    final v = raw.trim().toLowerCase();
    if (v == 'true' || v == '1') return true;
    if (v == 'false' || v == '0') return false;
  }
  return fallback;
}

final workerPermissionsProvider = FutureProvider<WorkerPermissions>((ref) async {
  final roleId = ref.watch(roleProvider);
  if (roleId != UserRole.worker.value) {
    return WorkerPermissions.fullAccess;
  }

  final token = ref.watch(tokenProvider);
  if (token == null || token.isEmpty) {
    return WorkerPermissions.fullAccess;
  }

  final url = ApiConsts().createUrl('accounts/');
  try {
    final response = await Dio().get<Map<String, dynamic>>(
      url,
      options: Options(headers: {'Authorization': 'JWT $token'}),
    );
    final data = response.data;
    if (response.statusCode != 200 || data == null) {
      return WorkerPermissions.fullAccess;
    }

    final workerRaw = data['worker'];
    if (workerRaw is! Map) {
      return WorkerPermissions.fullAccess;
    }
    final worker = workerRaw.map((k, v) => MapEntry(k.toString(), v));

    return WorkerPermissions(
      seeContactData: _boolFrom(worker['see_contact_data'], fallback: true),
      deleteSchedule: _boolFrom(worker['delete_schedule'], fallback: true),
      transferSchedule: _boolFrom(worker['transfer_schedule'], fallback: true),
      createSchedule: _boolFrom(worker['create_schedule'], fallback: true),
      seeIncome: _boolFrom(worker['see_income'], fallback: true),
      seeToBePaid: _boolFrom(worker['see_to_be_paid'], fallback: true),
      change: _boolFrom(worker['change'], fallback: true),
      changeWorker: _boolFrom(worker['change_worker'], fallback: true),
      changeStatus: _boolFrom(worker['change_status'], fallback: true),
    );
  } catch (e) {
    await handleUnauthorizedIfNeeded(ref, e);
    return WorkerPermissions.fullAccess;
  }
});
