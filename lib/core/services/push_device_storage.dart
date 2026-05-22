import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/local_storage.dart';
import 'package:uuid/uuid.dart';

const pushDeviceIdStorageKey = 'push_device_id';
const pushRegisteredDeviceApiIdKey = 'push_registered_device_api_id';

final pushDeviceStorageProvider = Provider<PushDeviceStorage>(
  (ref) => PushDeviceStorage(ref.read(localStorageProvider)),
);

class PushDeviceStorage {
  PushDeviceStorage(this._localStorage);

  final LocalStorage _localStorage;
  static const _uuid = Uuid();

  Future<String> getOrCreateDeviceId() async {
    final saved = await _localStorage.getString(pushDeviceIdStorageKey);
    if (saved != null && saved.isNotEmpty) return saved;
    final id = _uuid.v4();
    await _localStorage.saveString(pushDeviceIdStorageKey, id);
    return id;
  }

  Future<int?> getRegisteredDeviceApiId() async {
    final raw = await _localStorage.getString(pushRegisteredDeviceApiIdKey);
    if (raw == null || raw.isEmpty) return null;
    return int.tryParse(raw);
  }

  Future<void> saveRegisteredDeviceApiId(int id) async {
    await _localStorage.saveString(pushRegisteredDeviceApiIdKey, id.toString());
  }

  Future<void> clearRegisteredDeviceApiId() async {
    await _localStorage.removeValue(pushRegisteredDeviceApiIdKey);
  }
}
