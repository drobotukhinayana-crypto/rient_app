import 'package:dio/dio.dart';
import 'package:rient_app/core/network/app_dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/services/unauthorized_handler.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';

class AccountProfile {
  const AccountProfile({
    required this.email,
    required this.roleId,
    required this.avatar,
    required this.avatarThumbnail,
    this.workerDisplayName,
    this.workerSpecialization,
  });

  final String? email;
  final int? roleId;
  final String? avatar;
  final String? avatarThumbnail;

  /// «Фамилия Имя» из accounts/ (worker или корень профиля).
  final String? workerDisplayName;

  /// Должность (например specialization) из [worker].
  final String? workerSpecialization;
}

String? _displayNameFromMap(Map<String, dynamic> map) {
  final last = (map['last_name'] ?? '').toString().trim();
  final first = (map['first_name'] ?? '').toString().trim();
  final combined = [last, first].where((s) => s.isNotEmpty).join(' ');
  return combined.isEmpty ? null : combined;
}

final accountProfileProvider = FutureProvider<AccountProfile?>((ref) async {
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

    int? roleId;
    final roleRaw = data['role'];
    if (roleRaw is int) roleId = roleRaw;
    if (roleRaw is num) roleId ??= roleRaw.toInt();
    if (roleRaw is String) roleId ??= int.tryParse(roleRaw);

    String? workerDisplayName;
    String? workerSpecialization;
    final workerRaw = data['worker'];
    if (workerRaw is Map) {
      final w = workerRaw.map((k, v) => MapEntry(k.toString(), v));
      workerDisplayName = _displayNameFromMap(w);
      final spec = (w['specialization'] ?? '').toString().trim();
      workerSpecialization = spec.isEmpty ? null : spec;
    }
    workerDisplayName ??= _displayNameFromMap(data);

    return AccountProfile(
      email: data['email']?.toString(),
      roleId: roleId,
      avatar: data['avatar']?.toString(),
      avatarThumbnail: data['avatar_thumbnail']?.toString(),
      workerDisplayName: workerDisplayName,
      workerSpecialization: workerSpecialization,
    );
  } catch (e) {
    await handleUnauthorizedIfNeeded(ref, e);
    return null;
  }
});
