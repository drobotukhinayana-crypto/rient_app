import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rient_app/core/models/worker_entity_labels.dart';
import 'package:rient_app/core/network/app_dio.dart';
import 'package:rient_app/core/services/local_storage.dart';
import 'package:rient_app/features/schedule/data/models/workers_api/workers_api.dart';
import 'package:rient_app/features/schedule/view/components/specialist_select_dialog.dart';

const scheduleWorkersCacheStorageKey = 'schedule_workers_offline_cache_v1';

class ScheduleWorkersCacheSnapshot {
  const ScheduleWorkersCacheSnapshot({
    required this.branchId,
    required this.cachedAt,
    required this.workers,
    required this.localPictures,
  });

  final int branchId;
  final DateTime cachedAt;
  final List<WorkerApi> workers;
  final Map<int, String> localPictures;

  Map<String, dynamic> toJson() => {
        'branchId': branchId,
        'cachedAt': cachedAt.toUtc().toIso8601String(),
        'workers': workers.map((w) => w.toJson()).toList(),
        'localPictures': localPictures.map(
          (id, path) => MapEntry(id.toString(), path),
        ),
      };

  static ScheduleWorkersCacheSnapshot? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final branchId = (json['branchId'] as num?)?.toInt();
    final cachedAtRaw = json['cachedAt'] as String?;
    if (branchId == null || cachedAtRaw == null) return null;
    final cachedAt = DateTime.tryParse(cachedAtRaw);
    if (cachedAt == null) return null;

    final workersRaw = json['workers'] as List<dynamic>? ?? const [];
    final workers = <WorkerApi>[];
    for (final item in workersRaw) {
      if (item is Map<String, dynamic>) {
        workers.add(WorkerApi.fromJson(item));
      } else if (item is Map) {
        workers.add(
          WorkerApi.fromJson(item.map((k, v) => MapEntry(k.toString(), v))),
        );
      }
    }

    final picturesRaw = json['localPictures'] as Map<String, dynamic>? ?? {};
    final localPictures = <int, String>{};
    for (final entry in picturesRaw.entries) {
      final workerId = int.tryParse(entry.key);
      final path = entry.value?.toString();
      if (workerId == null || path == null || path.isEmpty) continue;
      localPictures[workerId] = path;
    }

    return ScheduleWorkersCacheSnapshot(
      branchId: branchId,
      cachedAt: cachedAt.toLocal(),
      workers: workers,
      localPictures: localPictures,
    );
  }

  WorkersApiResponse toWorkersApiResponse() {
    return WorkersApiResponse(
      count: workers.length,
      next: null,
      previous: null,
      results: [
        for (final worker in workers) withLocalPicture(worker),
      ],
    );
  }

  /// Подставляет локальный `file://` путь, если аватар скачан в кэш.
  WorkerApi withLocalPicture(WorkerApi worker) {
    final localUrl = ScheduleWorkersCache.localPictureUrl(
      worker.id,
      localPictures,
    );
    if (localUrl == null) return worker;
    return worker.copyWith(
      pictureThumbnail: localUrl,
      picture: localUrl,
    );
  }

  /// URL аватарки: локальный файл важнее remote (оффлайн).
  String? pictureUrlFor(WorkerApi worker) {
    return ScheduleWorkersCache.localPictureUrl(worker.id, localPictures) ??
        worker.pictureThumbnail ??
        worker.picture;
  }

  List<SpecialistItem> toSpecialistItems(WorkerEntityLabels labels) {
    return [
      for (final worker in workers)
        SpecialistItem(
          name: labels.personDisplayName(
            '${worker.firstName ?? ''} ${worker.lastName ?? ''}'.trim(),
          ),
          role: worker.specialization ?? '',
          id: worker.id,
          pictureUrl: pictureUrlFor(worker),
        ),
    ];
  }
}

class ScheduleWorkersCache {
  ScheduleWorkersCache(this._storage);

  final LocalStorage _storage;

  static String? localPictureUrl(int workerId, Map<int, String> localPictures) {
    final path = localPictures[workerId];
    if (path == null || path.isEmpty) return null;
    if (!File(path).existsSync()) return null;
    return 'file://$path';
  }

  Future<ScheduleWorkersCacheSnapshot?> read() async {
    final raw = await _storage.getString(scheduleWorkersCacheStorageKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return null;
      return ScheduleWorkersCacheSnapshot.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  Future<ScheduleWorkersCacheSnapshot?> readForBranch(int branchId) async {
    final snapshot = await read();
    if (snapshot == null || snapshot.branchId != branchId) return null;
    return snapshot;
  }

  Future<void> saveForBranch({
    required int branchId,
    required List<WorkerApi> workers,
  }) async {
    final existing = await readForBranch(branchId);
    final localPictures = await _syncPictures(
      workers: workers,
      previousPictures: existing?.localPictures ?? const {},
    );
    final snapshot = ScheduleWorkersCacheSnapshot(
      branchId: branchId,
      cachedAt: DateTime.now(),
      workers: workers,
      localPictures: localPictures,
    );
    await _storage.saveString(
      scheduleWorkersCacheStorageKey,
      jsonEncode(snapshot.toJson()),
    );
  }

  Future<Map<int, String>> _syncPictures({
    required List<WorkerApi> workers,
    required Map<int, String> previousPictures,
  }) async {
    final dir = await _picturesDirectory();
    final result = <int, String>{};

    for (final worker in workers) {
      final remoteUrl = (worker.pictureThumbnail ?? worker.picture)?.trim();
      if (remoteUrl == null || remoteUrl.isEmpty) continue;

      final previousPath = previousPictures[worker.id];
      if (previousPath != null && File(previousPath).existsSync()) {
        result[worker.id] = previousPath;
        continue;
      }

      try {
        final response = await createAppDio().get<List<int>>(
          remoteUrl,
          options: Options(responseType: ResponseType.bytes),
        );
        final bytes = response.data;
        if (bytes == null || bytes.isEmpty) continue;
        final file = File('${dir.path}/${worker.id}.img');
        await file.writeAsBytes(bytes, flush: true);
        result[worker.id] = file.path;
      } catch (_) {
        if (previousPath != null && File(previousPath).existsSync()) {
          result[worker.id] = previousPath;
        }
      }
    }

    return result;
  }

  Future<Directory> _picturesDirectory() async {
    final base = await getApplicationCacheDirectory();
    final dir = Directory('${base.path}/schedule_workers_avatars');
    if (!dir.existsSync()) {
      await dir.create(recursive: true);
    }
    return dir;
  }
}
