import 'package:rient_app/core/services/local_storage.dart';
import 'package:rient_app/features/schedule/data/models/schedule_patterns_api/schedule_patterns_api.dart';
import 'package:rient_app/features/schedule/data/schedule_offline_multi_branch_store.dart';
import 'package:rient_app/features/schedule/utils/worker_schedule_template.dart';

const scheduleWorkerTemplatesCacheStorageKey =
    'schedule_worker_templates_offline_cache_v1';

class ScheduleWorkerTemplatesCacheSnapshot {
  const ScheduleWorkerTemplatesCacheSnapshot({
    required this.branchId,
    required this.cachedAt,
    required this.templates,
  });

  final int branchId;
  final DateTime cachedAt;
  final Map<int, WorkerScheduleTemplate> templates;

  Map<String, dynamic> toJson() => {
        'branchId': branchId,
        'cachedAt': cachedAt.toUtc().toIso8601String(),
        'templates': {
          for (final entry in templates.entries)
            entry.key.toString(): {
              'patterns': entry.value.patterns.map((p) => p.toJson()).toList(),
              'shiftConfig': entry.value.shiftConfig,
            },
        },
      };

  static ScheduleWorkerTemplatesCacheSnapshot? fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) return null;
    final branchId = (json['branchId'] as num?)?.toInt();
    final cachedAtRaw = json['cachedAt'] as String?;
    if (branchId == null || cachedAtRaw == null) return null;
    final cachedAt = DateTime.tryParse(cachedAtRaw);
    if (cachedAt == null) return null;

    final templatesRaw = json['templates'];
    if (templatesRaw is! Map) {
      return ScheduleWorkerTemplatesCacheSnapshot(
        branchId: branchId,
        cachedAt: cachedAt.toLocal(),
        templates: const {},
      );
    }

    final templates = <int, WorkerScheduleTemplate>{};
    for (final entry in templatesRaw.entries) {
      final workerId = int.tryParse(entry.key.toString());
      if (workerId == null) continue;
      final value = entry.value;
      if (value is! Map) continue;
      final map = value.map((k, v) => MapEntry(k.toString(), v));
      final patternsRaw = map['patterns'] as List<dynamic>? ?? const [];
      final patterns = <SchedulePatternItemApi>[];
      for (final item in patternsRaw) {
        if (item is Map<String, dynamic>) {
          patterns.add(SchedulePatternItemApi.fromJson(item));
        } else if (item is Map) {
          patterns.add(
            SchedulePatternItemApi.fromJson(
              item.map((k, v) => MapEntry(k.toString(), v)),
            ),
          );
        }
      }
      final shiftRaw = map['shiftConfig'];
      Map<String, dynamic>? shiftConfig;
      if (shiftRaw is Map<String, dynamic>) {
        shiftConfig = shiftRaw;
      } else if (shiftRaw is Map) {
        shiftConfig = shiftRaw.map((k, v) => MapEntry(k.toString(), v));
      }
      templates[workerId] = WorkerScheduleTemplate(
        patterns: patterns,
        shiftConfig: shiftConfig,
      );
    }

    return ScheduleWorkerTemplatesCacheSnapshot(
      branchId: branchId,
      cachedAt: cachedAt.toLocal(),
      templates: templates,
    );
  }
}

class ScheduleWorkerTemplatesCache {
  ScheduleWorkerTemplatesCache(this._storage);

  final LocalStorage _storage;

  Future<ScheduleWorkerTemplatesCacheSnapshot?> readForBranch(
    int branchId,
  ) async {
    final payloads =
        await loadBranchPayloads(_storage, scheduleWorkerTemplatesCacheStorageKey);
    final payload = payloads[branchId];
    if (payload == null) return null;
    return ScheduleWorkerTemplatesCacheSnapshot.fromJson(payload);
  }

  Future<Set<int>> cachedBranchIds() async {
    return cachedBranchIdsFromStore(
      _storage,
      scheduleWorkerTemplatesCacheStorageKey,
    );
  }

  Future<void> saveForBranch({
    required int branchId,
    required Map<int, WorkerScheduleTemplate> templates,
  }) async {
    final snapshot = ScheduleWorkerTemplatesCacheSnapshot(
      branchId: branchId,
      cachedAt: DateTime.now(),
      templates: templates,
    );
    await saveBranchPayload(
      _storage,
      scheduleWorkerTemplatesCacheStorageKey,
      branchId,
      snapshot.toJson(),
    );
  }

  Future<void> clear() async {
    await clearBranchStore(_storage, scheduleWorkerTemplatesCacheStorageKey);
  }
}
