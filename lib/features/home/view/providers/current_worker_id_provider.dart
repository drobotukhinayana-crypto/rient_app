import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/local_storage.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/services/unauthorized_handler.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/core/network/app_offline.dart';
import 'package:rient_app/core/network/app_connectivity_provider.dart'
    show
        appNoConnectionProvider,
        onScheduleNetworkFailure,
        scheduleServerReachableProvider;
import 'package:rient_app/core/network/app_dio.dart';
import 'package:rient_app/core/network/network_failure.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_offline_provider.dart'
    show scheduleOfflineCurrentWorkerIdKey, scheduleOfflineModeProvider;

Future<int?> readCachedWorkerId(Ref ref) async {
  final raw = await ref
      .read(localStorageProvider)
      .getString(scheduleOfflineCurrentWorkerIdKey);
  return int.tryParse(raw ?? '');
}

final _currentAccountProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final roleId = ref.watch(roleProvider);
  if (roleId != UserRole.worker.value) return null;

  if (ref.watch(appNoConnectionProvider) ||
      ref.watch(scheduleOfflineModeProvider) ||
      !ref.watch(scheduleServerReachableProvider)) {
    return null;
  }

  final token = ref.watch(tokenProvider);
  if (token == null || token.isEmpty) return null;

  final url = ApiConsts().createUrl('accounts/');
  try {
    final response = await createAppDio().get<Map<String, dynamic>>(
      url,
      options: Options(headers: {'Authorization': 'JWT $token'}),
    );
    final data = response.data;
    if (response.statusCode != 200 || data == null) return null;
    return data;
  } catch (e) {
    await handleUnauthorizedIfNeeded(ref, e);
    final caused = e is CustomException ? e.causedError : e;
    if (isNetworkFailure(caused ?? e)) {
      onScheduleNetworkFailure(ref, caused ?? e);
      throw const AppOfflineException();
    }
    return null;
  }
});

final FutureProvider<int?> currentWorkerIdProvider =
    FutureProvider<int?>((ref) async {
  if (ref.watch(appNoConnectionProvider) ||
      ref.watch(scheduleOfflineModeProvider)) {
    return readCachedWorkerId(ref);
  }

  final data = await ref.watch(_currentAccountProvider.future);
  if (data == null) {
    return readCachedWorkerId(ref);
  }
  final workerRaw = data['worker'];
  if (workerRaw is! Map) return readCachedWorkerId(ref);
  final worker = workerRaw.map((k, v) => MapEntry(k.toString(), v));
  final idRaw = worker['id'];
  int? id;
  if (idRaw is int) {
    id = idRaw;
  } else if (idRaw is num) {
    id = idRaw.toInt();
  } else if (idRaw is String) {
    id = int.tryParse(idRaw);
  }
  if (id != null && id > 0) {
    await ref
        .read(localStorageProvider)
        .saveString(scheduleOfflineCurrentWorkerIdKey, id.toString());
  }
  return id;
});

final currentWorkerCanCreateScheduleProvider = FutureProvider<bool?>((ref) async {
  final data = await ref.watch(_currentAccountProvider.future);
  if (data == null) return null;
  final workerRaw = data['worker'];
  if (workerRaw is! Map) return null;
  final worker = workerRaw.map((k, v) => MapEntry(k.toString(), v));
  final raw = worker['create_schedule'];
  if (raw is bool) return raw;
  if (raw is num) return raw != 0;
  if (raw is String) {
    final v = raw.toLowerCase().trim();
    if (v == 'true' || v == '1') return true;
    if (v == 'false' || v == '0') return false;
  }
  return null;
});
