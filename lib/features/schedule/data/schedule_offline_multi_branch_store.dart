import 'dart:convert';

import 'package:rient_app/core/services/local_storage.dart';

const scheduleOfflineMultiBranchVersion = 2;

Future<Map<int, Map<String, dynamic>>> loadBranchPayloads(
  LocalStorage storage,
  String storageKey,
) async {
  final raw = await storage.getString(storageKey);
  if (raw == null || raw.isEmpty) return {};
  try {
    final decoded = jsonDecode(raw);
    if (decoded is! Map) return {};
    final map = decoded.map((k, v) => MapEntry(k.toString(), v));
    if (map['v'] == scheduleOfflineMultiBranchVersion) {
      final branches = map['branches'];
      if (branches is! Map) return {};
      final result = <int, Map<String, dynamic>>{};
      for (final entry in branches.entries) {
        final branchId = int.tryParse(entry.key);
        final value = entry.value;
        if (branchId == null || value is! Map) continue;
        result[branchId] = value.map((k, v) => MapEntry(k.toString(), v));
      }
      return result;
    }
    if (map.containsKey('branchId')) {
      final branchId = (map['branchId'] as num?)?.toInt();
      if (branchId != null) {
        return {branchId: map};
      }
    }
  } catch (_) {}
  return {};
}

Future<void> saveBranchPayload(
  LocalStorage storage,
  String storageKey,
  int branchId,
  Map<String, dynamic> payload,
) async {
  final all = await loadBranchPayloads(storage, storageKey);
  all[branchId] = payload;
  await storage.saveString(
    storageKey,
    jsonEncode({
      'v': scheduleOfflineMultiBranchVersion,
      'branches': all.map((k, v) => MapEntry(k.toString(), v)),
    }),
  );
}

Future<Set<int>> cachedBranchIdsFromStore(
  LocalStorage storage,
  String storageKey,
) async {
  return (await loadBranchPayloads(storage, storageKey)).keys.toSet();
}

Future<void> clearBranchStore(LocalStorage storage, String storageKey) async {
  await storage.removeValue(storageKey);
}
