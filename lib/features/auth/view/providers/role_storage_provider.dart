import 'package:flutter_riverpod/legacy.dart';
import 'package:rient_app/core/services/local_storage.dart';

final roleStorageProvider = StateNotifierProvider<RoleStorageNotifier, int>((
  ref,
) {
  final localStorage = ref.read(localStorageProvider);
  return RoleStorageNotifier(localStorage);
});

class RoleStorageNotifier extends StateNotifier<int> {
  RoleStorageNotifier(this.localStorage) : super(0);

  final LocalStorage localStorage;
  static const _roleIdKey = 'role_id';

  Future<void> init() async {
    final saved = await localStorage.getString(_roleIdKey);
    state = int.tryParse(saved ?? '') ?? 0;
  }

  Future<void> setRole(int roleId) async {
    state = roleId;
    await localStorage.saveString(_roleIdKey, roleId.toString());
  }

  Future<void> clearRole() async {
    state = 0;
    await localStorage.removeValue(_roleIdKey);
  }
}
