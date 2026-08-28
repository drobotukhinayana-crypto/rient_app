import 'dart:convert';

import 'package:rient_app/core/services/local_storage.dart';
import 'package:rient_app/features/home/data/models/branches_api/branches_api.dart';
import 'package:rient_app/features/schedule/data/schedule_appointments_cache.dart';
import 'package:rient_app/features/schedule/data/schedule_offline_multi_branch_store.dart';
import 'package:rient_app/features/schedule/data/schedule_worker_templates_cache.dart';
import 'package:rient_app/features/schedule/data/schedule_workers_cache.dart';

const scheduleOfflineBranchesRegistryKey =
    'schedule_offline_branches_registry_v1';

class OfflineBranchMeta {
  const OfflineBranchMeta({
    required this.id,
    required this.name,
    this.timezone,
    required this.cachedAt,
  });

  final int id;
  final String name;
  final String? timezone;
  final DateTime cachedAt;

  BranchApi toBranchApi() {
    return offlineStubBranch(id: id, name: name).copyWith(timezone: timezone);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (timezone != null) 'timezone': timezone,
        'cachedAt': cachedAt.toUtc().toIso8601String(),
      };

  static OfflineBranchMeta? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final id = (json['id'] as num?)?.toInt();
    final name = json['name']?.toString().trim();
    final cachedAtRaw = json['cachedAt'] as String?;
    if (id == null || id <= 0 || name == null || name.isEmpty) return null;
    final cachedAt = DateTime.tryParse(cachedAtRaw ?? '');
    return OfflineBranchMeta(
      id: id,
      name: name,
      timezone: json['timezone'] as String?,
      cachedAt: cachedAt?.toLocal() ?? DateTime.now(),
    );
  }
}

class ScheduleOfflineBranchesRegistry {
  ScheduleOfflineBranchesRegistry(this._storage);

  final LocalStorage _storage;

  Future<Map<int, OfflineBranchMeta>> readAll() async {
    final raw = await _storage.getString(scheduleOfflineBranchesRegistryKey);
    if (raw == null || raw.isEmpty) return {};
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map) return {};
      final branches = decoded['branches'];
      if (branches is! Map) return {};
      final result = <int, OfflineBranchMeta>{};
      for (final entry in branches.entries) {
        final branchId = int.tryParse(entry.key);
        final value = entry.value;
        if (branchId == null || value is! Map) continue;
        final meta = OfflineBranchMeta.fromJson(
          value.map((k, v) => MapEntry(k.toString(), v)),
        );
        if (meta != null) {
          result[branchId] = meta;
        }
      }
      return result;
    } catch (_) {
      return {};
    }
  }

  Future<void> register({
    required int branchId,
    required String? name,
    String? timezone,
  }) async {
    if (branchId <= 0) return;
    final trimmedName = name?.trim();
    if (trimmedName == null || trimmedName.isEmpty) return;

    final all = await readAll();
    all[branchId] = OfflineBranchMeta(
      id: branchId,
      name: trimmedName,
      timezone: timezone ?? all[branchId]?.timezone,
      cachedAt: DateTime.now(),
    );
    await _storage.saveString(
      scheduleOfflineBranchesRegistryKey,
      jsonEncode({
        'branches': all.map((k, v) => MapEntry(k.toString(), v.toJson())),
      }),
    );
  }

  Future<void> registerFromBranch(BranchApi branch) async {
    await register(
      branchId: branch.id,
      name: branch.name,
      timezone: branch.timezone,
    );
  }

  Future<List<BranchApi>> readBranchList() async {
    final all = await readAll();
    if (all.isEmpty) return const [];

    final branches = all.values.map((meta) => meta.toBranchApi()).toList()
      ..sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
    return branches;
  }

  Future<void> clear() async {
    await _storage.removeValue(scheduleOfflineBranchesRegistryKey);
  }
}

Future<Set<int>> readAllOfflineCachedBranchIds(LocalStorage storage) async {
  final registry = ScheduleOfflineBranchesRegistry(storage);
  final fromRegistry = (await registry.readAll()).keys.toSet();
  if (fromRegistry.isNotEmpty) return fromRegistry;

  final ids = <int>{};
  ids.addAll(
    await cachedBranchIdsFromStore(storage, scheduleOfflineCacheStorageKey),
  );
  ids.addAll(
    await cachedBranchIdsFromStore(storage, scheduleWorkersCacheStorageKey),
  );
  ids.addAll(
    await cachedBranchIdsFromStore(
      storage,
      scheduleWorkerTemplatesCacheStorageKey,
    ),
  );
  return ids;
}

Future<List<BranchApi>> readOfflineCachedBranches(LocalStorage storage) async {
  final registry = ScheduleOfflineBranchesRegistry(storage);
  var fromRegistry = await registry.readBranchList();
  if (fromRegistry.isNotEmpty) return fromRegistry;

  final ids = await readAllOfflineCachedBranchIds(storage);
  for (final id in ids) {
    await registry.register(branchId: id, name: 'Филиал');
  }
  fromRegistry = await registry.readBranchList();
  if (fromRegistry.isNotEmpty) return fromRegistry;

  if (ids.isEmpty) return const [];

  final branches = [
    for (final id in ids) offlineStubBranch(id: id, name: 'Филиал'),
  ]..sort((a, b) => a.id.compareTo(b.id));
  return branches;
}

Future<void> registerOfflineBranch(
  LocalStorage storage, {
  required int branchId,
  required String? name,
  String? timezone,
}) async {
  await ScheduleOfflineBranchesRegistry(storage).register(
    branchId: branchId,
    name: name,
    timezone: timezone,
  );
}
