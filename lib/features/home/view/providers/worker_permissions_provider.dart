import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
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

Map<String, dynamic>? _asStringKeyMap(dynamic raw) {
  if (raw is! Map) return null;
  return raw.map((k, v) => MapEntry(k.toString(), v));
}

dynamic _permissionField(
  Map<String, dynamic> primary,
  Map<String, dynamic>? secondary,
  String key,
) {
  if (primary.containsKey(key)) return primary[key];
  return secondary?[key];
}

WorkerPermissions _permissionsFromMaps({
  required Map<String, dynamic> primary,
  Map<String, dynamic>? secondary,
}) {
  return WorkerPermissions(
    seeContactData: _boolFrom(
      _permissionField(primary, secondary, 'see_contact_data'),
      fallback: true,
    ),
    deleteSchedule: _boolFrom(
      _permissionField(primary, secondary, 'delete_schedule'),
      fallback: true,
    ),
    transferSchedule: _boolFrom(
      _permissionField(primary, secondary, 'transfer_schedule'),
      fallback: true,
    ),
    createSchedule: _boolFrom(
      _permissionField(primary, secondary, 'create_schedule'),
      fallback: true,
    ),
    seeIncome: _boolFrom(
      _permissionField(primary, secondary, 'see_income'),
      fallback: true,
    ),
    seeToBePaid: _boolFrom(
      _permissionField(primary, secondary, 'see_to_be_paid'),
      fallback: true,
    ),
    change: _boolFrom(
      _permissionField(primary, secondary, 'change'),
      fallback: true,
    ),
    changeWorker: _boolFrom(
      _permissionField(primary, secondary, 'change_worker'),
      fallback: true,
    ),
    changeStatus: _boolFrom(
      _permissionField(primary, secondary, 'change_status'),
      fallback: true,
    ),
  );
}

const _workSchedulePermissionKeys = [
  'change_schedule',
  'change_work_schedule',
  'can_change_schedule',
  'change',
];

dynamic _deepFindKey(dynamic node, String key, {int depth = 0}) {
  if (depth > 8) return null;
  if (node is Map) {
    final map = node.map((k, v) => MapEntry(k.toString(), v));
    if (map.containsKey(key)) return map[key];
    for (final value in map.values) {
      final found = _deepFindKey(value, key, depth: depth + 1);
      if (found != null) return found;
    }
  }
  return null;
}

bool? _resolveCanChangeWorkScheduleFromAccount(Map<String, dynamic> data) {
  for (final key in _workSchedulePermissionKeys) {
    final raw = _deepFindKey(data, key);
    if (raw != null) return _boolFrom(raw, fallback: true);
  }
  return null;
}

/// Запрет редактирования графика после 403 от API (если accounts/ не отдал флаг).
final workScheduleEditBlockedProvider = StateProvider<bool>((ref) => false);

void markWorkScheduleEditBlocked(dynamic ref) {
  ref.read(workScheduleEditBlockedProvider.notifier).state = true;
}

/// Сбрасывает кэш прав воркера и повторно запрашивает `accounts/`.
void refreshWorkerPermissions(dynamic ref) {
  ref.read(workScheduleEditBlockedProvider.notifier).state = false;
  ref.invalidate(workerPermissionsProvider);
  ref.invalidate(canChangeWorkScheduleProvider);
}

final canChangeWorkScheduleProvider = FutureProvider<bool>((ref) async {
  if (ref.watch(workScheduleEditBlockedProvider)) return false;

  final roleId = ref.watch(roleProvider);
  final token = ref.watch(tokenProvider);
  if (token == null || token.isEmpty) return true;

  final url = ApiConsts().createUrl('accounts/');
  try {
    final response = await Dio().get<Map<String, dynamic>>(
      url,
      options: Options(headers: {'Authorization': 'JWT $token'}),
    );
    final data = response.data;
    if (response.statusCode != 200 || data == null) return true;

    final worker = _asStringKeyMap(data['worker']);
    if (roleId == UserRole.worker.value && worker != null) {
      for (final key in _workSchedulePermissionKeys) {
        if (worker.containsKey(key)) {
          return _boolFrom(worker[key], fallback: true);
        }
      }
    }

    final resolved = _resolveCanChangeWorkScheduleFromAccount(data);
    if (resolved != null) return resolved;

    return true;
  } catch (e) {
    await handleUnauthorizedIfNeeded(ref, e);
    return true;
  }
});

final workerPermissionsProvider = FutureProvider<WorkerPermissions>((ref) async {
  final roleId = ref.watch(roleProvider);
  final isWorkerRole = roleId == UserRole.worker.value;

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

    final worker = _asStringKeyMap(data['worker']);

    if (isWorkerRole) {
      if (worker == null) return WorkerPermissions.fullAccess;
      return _permissionsFromMaps(primary: worker);
    }

    return _permissionsFromMaps(primary: data, secondary: worker);
  } catch (e) {
    await handleUnauthorizedIfNeeded(ref, e);
    return WorkerPermissions.fullAccess;
  }
});
