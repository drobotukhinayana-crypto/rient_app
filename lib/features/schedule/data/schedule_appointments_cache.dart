import 'dart:convert';

import 'package:rient_app/core/models/worker_entity_labels.dart';
import 'package:rient_app/core/services/local_storage.dart';
import 'package:rient_app/core/utils/branch_timezone.dart';
import 'package:rient_app/features/schedule/data/models/appointments_api/appointments_api.dart';
import 'package:rient_app/features/schedule/view/components/specialist_select_dialog.dart';

const scheduleOfflineCacheStorageKey = 'schedule_appointments_offline_cache_v1';
const scheduleOfflineDaysBefore = 14;
const scheduleOfflineDaysAfter = 14;

class ScheduleAppointmentsCacheSnapshot {
  const ScheduleAppointmentsCacheSnapshot({
    required this.branchId,
    required this.rangeFrom,
    required this.rangeTo,
    required this.cachedAt,
    required this.byWorker,
  });

  final int branchId;
  final DateTime rangeFrom;
  final DateTime rangeTo;
  final DateTime cachedAt;
  final Map<int, List<AppointmentApi>> byWorker;

  Map<String, dynamic> toJson() => {
        'branchId': branchId,
        'rangeFrom': rangeFrom.toUtc().toIso8601String(),
        'rangeTo': rangeTo.toUtc().toIso8601String(),
        'cachedAt': cachedAt.toUtc().toIso8601String(),
        'byWorker': byWorker.map(
          (workerId, list) => MapEntry(
            workerId.toString(),
            list.map(appointmentApiToCacheJson).toList(),
          ),
        ),
      };

  static ScheduleAppointmentsCacheSnapshot? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final branchId = (json['branchId'] as num?)?.toInt();
    final rangeFromRaw = json['rangeFrom'] as String?;
    final rangeToRaw = json['rangeTo'] as String?;
    final cachedAtRaw = json['cachedAt'] as String?;
    if (branchId == null ||
        rangeFromRaw == null ||
        rangeToRaw == null ||
        cachedAtRaw == null) {
      return null;
    }
    final rangeFrom = DateTime.tryParse(rangeFromRaw);
    final rangeTo = DateTime.tryParse(rangeToRaw);
    final cachedAt = DateTime.tryParse(cachedAtRaw);
    if (rangeFrom == null || rangeTo == null || cachedAt == null) return null;

    final byWorkerRaw = json['byWorker'] as Map<String, dynamic>? ?? {};
    final byWorker = <int, List<AppointmentApi>>{};
    for (final entry in byWorkerRaw.entries) {
      final workerId = int.tryParse(entry.key);
      if (workerId == null) continue;
      final items = entry.value as List<dynamic>? ?? const [];
      byWorker[workerId] = [
        for (final item in items)
          if (item is Map<String, dynamic>)
            AppointmentApi.fromJson(item)
          else if (item is Map)
            AppointmentApi.fromJson(item.map((k, v) => MapEntry(k.toString(), v))),
      ];
    }

    return ScheduleAppointmentsCacheSnapshot(
      branchId: branchId,
      rangeFrom: rangeFrom.toLocal(),
      rangeTo: rangeTo.toLocal(),
      cachedAt: cachedAt.toLocal(),
      byWorker: byWorker,
    );
  }
}

Map<String, dynamic> appointmentApiToCacheJson(AppointmentApi a) {
  return {
    'id': a.id,
    'datetime': a.datetime,
    'status': a.status,
    'paid': a.paid,
    if (a.source != null) 'source': a.source,
    'services': [
      for (final s in a.services)
        {
          'id': s.id,
          'service': s.serviceId,
          'name': s.name,
          'datetime': s.datetime,
          'duration': s.duration,
          'add_duration': s.addDuration,
        },
    ],
    'worker': a.worker == null
        ? null
        : {
            'id': a.worker!.id,
            'first_name': a.worker!.firstName,
            'last_name': a.worker!.lastName,
          },
    'client': a.client == null
        ? null
        : {
            'id': a.client!.id,
            'first_name': a.client!.firstName,
            'last_name': a.client!.lastName,
            'phone': a.client!.phone,
          },
    if (a.commentId != null || (a.commentText?.isNotEmpty ?? false))
      'comment': {
        'id': a.commentId,
        'text': a.commentText,
      },
  };
}

class ScheduleAppointmentsCache {
  ScheduleAppointmentsCache(this._storage);

  final LocalStorage _storage;

  static DateTime offlineRangeStart(DateTime anchor) {
    final day = DateTime(anchor.year, anchor.month, anchor.day);
    return day.subtract(const Duration(days: scheduleOfflineDaysBefore));
  }

  static DateTime offlineRangeEnd(DateTime anchor) {
    final day = DateTime(anchor.year, anchor.month, anchor.day);
    return day
        .add(const Duration(days: scheduleOfflineDaysAfter + 1))
        .subtract(const Duration(milliseconds: 1));
  }

  static bool isDateInOfflineRange(DateTime date, DateTime anchor) {
    final start = offlineRangeStart(anchor);
    final end = offlineRangeEnd(anchor);
    return !date.isBefore(start) && !date.isAfter(end);
  }

  Future<ScheduleAppointmentsCacheSnapshot?> read() async {
    final raw = await _storage.getString(scheduleOfflineCacheStorageKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return null;
      return ScheduleAppointmentsCacheSnapshot.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  Future<void> save(ScheduleAppointmentsCacheSnapshot snapshot) async {
    await _storage.saveString(
      scheduleOfflineCacheStorageKey,
      jsonEncode(snapshot.toJson()),
    );
  }

  /// Дополняет кэш записями мастера после успешной загрузки с API.
  Future<void> mergeWorkerAppointments({
    required int branchId,
    required int workerId,
    required Iterable<AppointmentApi> appointments,
    required DateTime rangeFrom,
    required DateTime rangeTo,
  }) async {
    final existing = await read();
    final Map<int, List<AppointmentApi>> byWorker;
    final DateTime mergedFrom;
    final DateTime mergedTo;

    if (existing != null && existing.branchId == branchId) {
      byWorker = {
        for (final entry in existing.byWorker.entries)
          entry.key: List<AppointmentApi>.from(entry.value),
      };
      mergedFrom =
          existing.rangeFrom.isBefore(rangeFrom) ? existing.rangeFrom : rangeFrom;
      mergedTo = existing.rangeTo.isAfter(rangeTo) ? existing.rangeTo : rangeTo;
    } else {
      byWorker = {};
      mergedFrom = rangeFrom;
      mergedTo = rangeTo;
    }

    final byId = <int, AppointmentApi>{
      for (final appointment in byWorker[workerId] ?? const <AppointmentApi>[])
        appointment.id: appointment,
    };
    for (final appointment in appointments) {
      byId[appointment.id] = appointment;
    }
    byWorker[workerId] = byId.values.toList();

    await save(
      ScheduleAppointmentsCacheSnapshot(
        branchId: branchId,
        rangeFrom: mergedFrom,
        rangeTo: mergedTo,
        cachedAt: DateTime.now(),
        byWorker: byWorker,
      ),
    );
  }

  static List<SpecialistItem> specialistsFromSnapshot(
    ScheduleAppointmentsCacheSnapshot? snapshot,
    WorkerEntityLabels labels,
  ) {
    if (snapshot == null || snapshot.byWorker.isEmpty) return const [];
    final items = <SpecialistItem>[];
    for (final entry in snapshot.byWorker.entries) {
      final workerId = entry.key;
      var name = '';
      for (final appointment in entry.value) {
        final worker = appointment.worker;
        if (worker == null || worker.id != workerId) continue;
        name = labels.personDisplayName(
          '${worker.firstName ?? ''} ${worker.lastName ?? ''}'.trim(),
        );
        if (name.isNotEmpty) break;
      }
      if (name.isEmpty) {
        name = '${labels.name} $workerId';
      }
      items.add(SpecialistItem(name: name, role: '', id: workerId));
    }
    items.sort((a, b) => (a.id ?? 0).compareTo(b.id ?? 0));
    return items;
  }

  List<AppointmentApi> appointmentsForQuery({
    required ScheduleAppointmentsCacheSnapshot snapshot,
    required int branchId,
    required int workerId,
    required DateTime dateTimeGte,
    required DateTime dateTimeLte,
    required BranchTimezone branchTz,
  }) {
    if (snapshot.branchId != branchId) return const [];
    final list = snapshot.byWorker[workerId] ?? const [];
    return list.where((a) {
      if (!a.isActive) return false;
      return a.overlapsScheduleInstantRange(dateTimeGte, dateTimeLte, branchTz);
    }).toList();
  }
}
