import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/services/unauthorized_handler.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';

final _currentAccountProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final roleId = ref.watch(roleProvider);
  if (roleId != UserRole.worker.value) return null;

  final token = ref.watch(tokenProvider);
  if (token == null || token.isEmpty) return null;

  final url = ApiConsts().createUrl('accounts/');
  try {
    final response = await Dio().get<Map<String, dynamic>>(
      url,
      options: Options(headers: {'Authorization': 'JWT $token'}),
    );
    final data = response.data;
    if (response.statusCode != 200 || data == null) return null;
    return data;
  } catch (e) {
    await handleUnauthorizedIfNeeded(ref, e);
    return null;
  }
});

final currentWorkerIdProvider = FutureProvider<int?>((ref) async {
  final data = await ref.watch(_currentAccountProvider.future);
  if (data == null) return null;
  final workerRaw = data['worker'];
  if (workerRaw is! Map) return null;
  final worker = workerRaw.map((k, v) => MapEntry(k.toString(), v));
  final idRaw = worker['id'];
  if (idRaw is int) return idRaw;
  if (idRaw is num) return idRaw.toInt();
  if (idRaw is String) return int.tryParse(idRaw);
  return null;
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
