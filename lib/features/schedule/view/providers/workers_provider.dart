import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:rient_app/core/providers/branch_timezone_provider.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/core/network/network_failure.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/core/services/email_storage.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/schedule/data/models/available_workers_api/available_workers_api.dart';
import 'package:rient_app/features/schedule/data/models/schedule_patterns_api/schedule_patterns_api.dart';
import 'package:rient_app/features/schedule/data/models/workers_api/workers_api.dart';
import 'package:rient_app/features/schedule/data/schedule_workers_cache.dart';
import 'package:rient_app/features/schedule/service/schedule_offline_sync_service.dart';
import 'package:rient_app/features/schedule/service/schedule_patterns_service.dart';
import 'package:rient_app/features/schedule/service/workers_service.dart';
import 'package:rient_app/features/schedule/utils/worker_schedule_config_map.dart';
import 'package:rient_app/features/schedule/utils/worker_schedule_template.dart';
import 'package:rient_app/features/schedule/view/components/work_schedule_mapper.dart';
import 'package:rient_app/core/network/app_connectivity_provider.dart'
    show
        appNoConnectionProvider,
        markScheduleServerReachable,
        onScheduleNetworkFailure,
        scheduleServerReachableProvider;
import 'package:rient_app/features/schedule/view/providers/schedule_offline_provider.dart';

Future<int> resolveScheduleBranchId(Ref ref) async {
  var branchId = ref.read(currentBranchIdProvider);
  if (branchId > 0) return branchId;

  final selected = ref.read(selectedBranchProvider);
  if (selected != null) return selected.id;

  final restored = await ensureSelectedBranchRestored(ref);
  if (restored != null && restored.id > 0) return restored.id;

  if (ref.read(appNoConnectionProvider) ||
      !ref.read(scheduleServerReachableProvider)) {
    return 0;
  }

  final branchesAsync = ref.read(branchesProvider);
  if (branchesAsync.isLoading) {
    try {
      await ref.read(branchesProvider.future);
    } catch (_) {}
    branchId = ref.read(currentBranchIdProvider);
  }
  return branchId;
}

WorkerApi workerApiFromScheduleRow(Map<String, dynamic> row) {
  return WorkerApi(
    id: (row['id'] as num?)?.toInt() ?? 0,
    firstName: row['first_name'] as String?,
    lastName: row['last_name'] as String?,
    specialization: row['specialization'] as String?,
    picture: row['picture'] as String?,
    pictureThumbnail: row['picture_thumbnail'] as String?,
  );
}

Map<String, dynamic>? workerScheduleRowById(
  List<Map<String, dynamic>> rows,
  int workerId,
) {
  for (final row in rows) {
    if ((row['id'] as num?)?.toInt() == workerId) return row;
  }
  return null;
}

WorkersApiResponse workersApiResponseFromScheduleRows(
  List<Map<String, dynamic>> rows,
) {
  final workers = [
    for (final row in rows)
      if (((row['id'] as num?)?.toInt() ?? 0) > 0) workerApiFromScheduleRow(row),
  ];
  return WorkersApiResponse(
    count: workers.length,
    next: null,
    previous: null,
    results: workers,
  );
}

/// Сырые строки /workers/?with_schedules=1 — один запрос на экран расписания.
final scheduleWorkerScheduleRowsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  ref.watch(organizationIdProvider);
  ref.watch(currentBranchIdProvider);
  final branchId = await resolveScheduleBranchId(ref);
  if (branchId == 0) return const [];

  if (ref.watch(appNoConnectionProvider) ||
      !ref.watch(scheduleServerReachableProvider)) {
    return const [];
  }

  final workersCache = ref.read(scheduleWorkersCacheProvider);
  final service = ref.watch(workersServiceProvider);
  try {
    final rows = await service.getWorkerRowsWithSchedules(branchId: branchId);
    final workers = workersApiResponseFromScheduleRows(rows).results;
    if (workers.isNotEmpty) {
      unawaited(
        workersCache.saveForBranch(
          branchId: branchId,
          workers: workers,
        ),
      );
    }
    markScheduleServerReachable(ref);
    return rows;
  } catch (e) {
    final caused = e is CustomException ? e.causedError : e;
    if (isPermissionDenied(caused ?? e)) {
      return const [];
    }
    if (isNetworkFailure(caused ?? e) && !isClientHttpError(caused ?? e)) {
      onScheduleNetworkFailure(ref, caused ?? e);
    }
    return const [];
  }
});

/// Список рабочих (специалистов) для текущего филиала на странице расписания.
final scheduleWorkersProvider = FutureProvider<WorkersApiResponse>((ref) async {
  ref.watch(currentBranchIdProvider);
  final branchId = await resolveScheduleBranchId(ref);
  if (branchId == 0) {
    return scheduleOfflineEmptyWorkers;
  }

  final workersCache = ref.read(scheduleWorkersCacheProvider);
  if (ref.watch(appNoConnectionProvider) ||
      !ref.watch(scheduleServerReachableProvider)) {
    final cached = await workersCache.readForBranch(branchId);
    if (cached != null && cached.workers.isNotEmpty) {
      return cached.toWorkersApiResponse();
    }
    return scheduleOfflineEmptyWorkers;
  }

  final rows = await ref.watch(scheduleWorkerScheduleRowsProvider.future);
  if (rows.isNotEmpty) {
    return _workersWithCachedLocalPictures(
      workersCache,
      branchId,
      workersApiResponseFromScheduleRows(rows),
    );
  }

  final cached = await workersCache.readForBranch(branchId);
  if (cached != null && cached.workers.isNotEmpty) {
    return cached.toWorkersApiResponse();
  }
  return scheduleOfflineEmptyWorkers;
});

Future<WorkersApiResponse> _workersWithCachedLocalPictures(
  ScheduleWorkersCache cache,
  int branchId,
  WorkersApiResponse response,
) async {
  if (response.results.isEmpty) return response;
  final snapshot = await cache.readForBranch(branchId);
  if (snapshot == null || snapshot.localPictures.isEmpty) return response;
  return WorkersApiResponse(
    count: response.count,
    next: response.next,
    previous: response.previous,
    results: [
      for (final worker in response.results) snapshot.withLocalPicture(worker),
    ],
  );
}

/// Доступные сотрудники в конкретный день для текущего филиала.
final availableWorkersForDateProvider =
    FutureProvider.family<List<AvailableWorkerShift>, DateTime>((ref, date) async {
      if (ref.watch(appNoConnectionProvider) ||
          !ref.watch(scheduleServerReachableProvider)) {
        return const [];
      }
      final branchId = ref.watch(currentBranchIdProvider);
      if (branchId == 0) {
        return const [];
      }
      final service = ref.watch(workersServiceProvider);
      final normalizedDate = DateTime(date.year, date.month, date.day);
      try {
        final workers = await service.getAvailableWorkers(
          branchId: branchId,
          date: normalizedDate,
        );
        markScheduleServerReachable(ref);
        return workers;
      } catch (e) {
        final caused = e is CustomException ? e.causedError : e;
        if (isPermissionDenied(caused ?? e)) {
          return const [];
        }
        if (isNetworkFailure(caused ?? e) && !isClientHttpError(caused ?? e)) {
          onScheduleNetworkFailure(ref, caused ?? e);
        }
        return const [];
      }
    });

/// Шаблоны графика сотрудников — те же данные, что в сетке «График работы».
final workerScheduleTemplatesByIdProvider =
    FutureProvider<Map<int, WorkerScheduleTemplate>>((ref) async {
  ref.watch(organizationIdProvider);
  final branchId = ref.watch(currentBranchIdProvider);
  if (branchId == 0) return const <int, WorkerScheduleTemplate>{};

  final templatesCache = ref.read(scheduleWorkerTemplatesCacheProvider);
  if (ref.watch(appNoConnectionProvider) ||
      !ref.watch(scheduleServerReachableProvider)) {
    final cached = await templatesCache.readForBranch(branchId);
    return cached?.templates ?? const <int, WorkerScheduleTemplate>{};
  }

  final patternsService = ref.watch(schedulePatternsServiceProvider);
  try {
    final patternsFuture =
        patternsService.getSchedulePatterns(branchId: branchId);
    final rowsFuture = ref.read(scheduleWorkerScheduleRowsProvider.future);
    final results = await Future.wait([patternsFuture, rowsFuture]);
    final patternsResponse = results[0] as SchedulePatternsApiResponse;
    final rows = results[1] as List<Map<String, dynamic>>;
    final patternsByWorker =
        groupSchedulePatternsByWorker(patternsResponse.results);

    final templates = <int, WorkerScheduleTemplate>{};
    for (final row in rows) {
      final workerId = (row['id'] as num?)?.toInt();
      if (workerId == null) continue;
      templates[workerId] = WorkerScheduleTemplate(
        patterns: mergeSchedulePatternsForWorker(
          fromBranchApi: patternsByWorker[workerId] ?? const [],
          workerRow: row,
        ),
        shiftConfig: workerScheduleConfigForBranch(row, branchId),
      );
    }
    if (templates.isNotEmpty) {
      unawaited(
        templatesCache.saveForBranch(
          branchId: branchId,
          templates: templates,
        ),
      );
    }
    return templates;
  } catch (_) {
    final cached = await templatesCache.readForBranch(branchId);
    return cached?.templates ?? const <int, WorkerScheduleTemplate>{};
  }
});

/// Рабочие дни сотрудников по merged-шаблонам.
/// workerId -> Set<weekday>, где weekday: 1..7 (Mon..Sun).
final workerWeekdaysByIdProvider = FutureProvider<Map<int, Set<int>>>((
  ref,
) async {
  final templates = await ref.watch(workerScheduleTemplatesByIdProvider.future);
  return {
    for (final entry in templates.entries)
      entry.key: {
        for (final pattern in dedupeSchedulePatternsByDay(entry.value.patterns))
          if (pattern.active) pattern.weekdayNumber,
      }.whereType<int>().toSet(),
  };
});

/// Ключ для сохранения id выбранного специалиста (привязан к org/филиалу/роли).
String buildSelectedSpecialistStorageKey({
  required String? email,
  required int organizationId,
  required int branchId,
  required int roleId,
}) {
  final safeEmail = (email ?? '').trim().toLowerCase();
  if (safeEmail.isEmpty || organizationId <= 0 || branchId <= 0 || roleId < 0) {
    return selectedSpecialistIdStorageKey;
  }
  return '${selectedSpecialistIdStorageKey}_${safeEmail}_${organizationId}_${branchId}_$roleId';
}

const selectedSpecialistIdStorageKey = 'selected_specialist_id';

final selectedSpecialistStorageKeyProvider = Provider<String>((ref) {
  final email = ref.watch(emailStorageProvider);
  final organizationId = ref.watch(organizationIdProvider);
  final branchId = ref.watch(currentBranchIdProvider);
  final roleId = ref.watch(roleProvider);
  return buildSelectedSpecialistStorageKey(
    email: email,
    organizationId: organizationId,
    branchId: branchId,
    roleId: roleId,
  );
});

/// Id выбранного специалиста на странице расписания (сохраняется между переключениями и после перезапуска приложения).
final selectedSpecialistIdProvider = StateProvider<int?>((ref) => null);

/// Флаг: восстановлен ли выбор специалиста из хранилища в этой сессии.
final restoredSpecialistSelectionProvider = StateProvider<bool>((ref) => false);

/// Выбранная дата на странице расписания (для фильтра «кто работает в этот день»). По умолчанию — сегодня в таймзоне филиала.
final selectedScheduleDateProvider = StateProvider<DateTime>((ref) {
  return ref.watch(branchTodayProvider);
});

/// Открыть расписание в режиме «День» на эту дату (например, из аналитики).
final openScheduleOnDayProvider = StateProvider<DateTime?>((ref) => null);
