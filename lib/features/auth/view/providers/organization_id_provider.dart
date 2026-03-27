import 'package:flutter_riverpod/legacy.dart';
import 'package:rient_app/core/services/local_storage.dart';

final organizationIdProvider = StateNotifierProvider<OrganizationIdNotifier, int>(
  (ref) => OrganizationIdNotifier(ref.read(localStorageProvider)),
);

class OrganizationIdNotifier extends StateNotifier<int> {
  OrganizationIdNotifier(this.localStorage) : super(0) {
    _load();
  }

  final LocalStorage localStorage;
  static const _organizationIdKey = 'organization_id';

  Future<void> _load() async {
    final savedId = await localStorage.getString(_organizationIdKey);
    if (savedId != null && savedId.isNotEmpty) {
      state = int.tryParse(savedId) ?? 0;
    }
  }

  Future<void> setOrganizationId(int id) async {
    state = id;
    await localStorage.saveString(_organizationIdKey, id.toString());
  }

  Future<void> clearOrganizationId() async {
    state = 0;
    await localStorage.removeValue(_organizationIdKey);
  }
}