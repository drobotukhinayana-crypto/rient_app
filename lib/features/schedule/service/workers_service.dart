import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/services/unauthorized_handler.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/home/data/models/branches_api/branches_api.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/schedule/data/models/available_workers_api/available_workers_api.dart';
import 'package:rient_app/features/schedule/data/models/workers_api/workers_api.dart';

final workersServiceProvider = Provider<WorkersService>(
  (ref) => WorkersService(ref),
);

class WorkersService {
  WorkersService(this.ref);

  final Ref ref;

  /// Загружает список рабочих (специалистов) для филиала.
  Future<WorkersApiResponse> getWorkers({
    required int branchId,
    int pageSize = 500,
    int page = 1,
    int withServices = 1,
    int withSchedules = 1,
  }) async {
    final organizationId = ref.read(organizationIdProvider);
    final token = ref.read(tokenProvider);

    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    final url = ApiConsts().createUrl('organizations/$organizationId/workers/');
    final queryParams = <String, dynamic>{
      'branches__id__in': branchId,
      'page_size': pageSize,
      'page': page,
      'with_services': withServices,
      'with_schedules': withSchedules,
    };

    try {
      final response = await Dio().get<Map<String, dynamic>>(
        url,
        queryParameters: queryParams,
        options: Options(headers: {'Authorization': 'JWT $token'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        return WorkersApiResponse.fromJson(response.data!);
      }
      throw CustomException(
        causedError: Exception(
          'Failed to load workers: ${response.statusCode}',
        ),
      );
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }

  double _timeToHourFromSchedulePattern(String? value) {
    if (value == null || value.isEmpty) return 0;
    final parts = value.split(':');
    if (parts.length < 2) return 0;
    final hour = int.tryParse(parts[0]) ?? 0;
    final minute = int.tryParse(parts[1]) ?? 0;
    return hour + (minute / 60.0);
  }

  /// Дни недели (1…7), когда филиал открыт по [SchedulePattern] текущего филиала.
  Set<int> _weekdaysFromBranchSchedulePatterns(
    List<SchedulePattern>? patterns,
    int branchId,
  ) {
    if (patterns == null || patterns.isEmpty) return const {};
    final result = <int>{};
    for (final pattern in patterns) {
      if (!(pattern.active ?? false)) continue;
      final patternBranch = pattern.branch;
      if (patternBranch != null && patternBranch != branchId) continue;
      final weekday = _weekdayFromApi(pattern.day);
      if (weekday == null) continue;
      final start = _timeToHourFromSchedulePattern(pattern.timeStart);
      final end = _timeToHourFromSchedulePattern(pattern.timeEnd);
      if (start <= 0 || end <= 0 || end <= start) continue;
      result.add(weekday);
    }
    return result;
  }

  int? _weekdayFromApi(String? day) {
    switch ((day ?? '').toLowerCase()) {
      case 'mon':
        return DateTime.monday;
      case 'tue':
        return DateTime.tuesday;
      case 'wed':
      case 'wen':
        return DateTime.wednesday;
      case 'thu':
        return DateTime.thursday;
      case 'fri':
        return DateTime.friday;
      case 'sat':
        return DateTime.saturday;
      case 'sun':
        return DateTime.sunday;
      default:
        return null;
    }
  }

  /// Строка сотрудника из /workers/?with_schedules=1 (schedule_config, schedule_patterns).
  Future<Map<String, dynamic>?> getWorkerRow({
    required int workerId,
    required int branchId,
  }) async {
    final organizationId = ref.read(organizationIdProvider);
    final token = ref.read(tokenProvider);
    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    final url = ApiConsts().createUrl('organizations/$organizationId/workers/');
    try {
      final response = await Dio().get<Map<String, dynamic>>(
        url,
        queryParameters: {
          'branches__id__in': branchId,
          'page_size': 500,
          'page': 1,
          'with_services': 1,
          'with_schedules': 1,
        },
        options: Options(headers: {'Authorization': 'JWT $token'}),
      );
      final rows = (response.data?['results'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>();
      for (final row in rows) {
        final id = (row['id'] as num?)?.toInt();
        if (id == workerId) return row;
      }
      return null;
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }

  /// Рабочие дни по каждому сотруднику из /workers/?with_schedules=1.
  Future<Map<int, Set<int>>> getWorkersWorkingWeekdays({
    required int branchId,
  }) async {
    final organizationId = ref.read(organizationIdProvider);
    final token = ref.read(tokenProvider);
    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    final url = ApiConsts().createUrl('organizations/$organizationId/workers/');
    try {
      final response = await Dio().get<Map<String, dynamic>>(
        url,
        queryParameters: {
          'branches__id__in': branchId,
          'page_size': 500,
          'page': 1,
          'with_services': 1,
          'with_schedules': 1,
        },
        options: Options(headers: {'Authorization': 'JWT $token'}),
      );
      final rows = (response.data?['results'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>();

      final map = <int, Set<int>>{};
      for (final row in rows) {
        final workerId = (row['id'] as num?)?.toInt();
        if (workerId == null) continue;
        final weekdays = <int>{};

        final patterns =
            (row['schedule_patterns'] as List<dynamic>? ?? const [])
                .whereType<Map<String, dynamic>>();
        for (final pattern in patterns) {
          final patternBranch = (pattern['branch'] as num?)?.toInt();
          final active = pattern['active'] == true;
          if (!active) continue;
          if (patternBranch != null && patternBranch != branchId) continue;
          final weekday = _weekdayFromApi(pattern['day']?.toString());
          if (weekday != null) weekdays.add(weekday);
        }

        if (weekdays.isEmpty) {
          final weekStart = _weekdayFromApi(row['week_start']?.toString());
          final weekEnd = _weekdayFromApi(row['week_end']?.toString());
          if (weekStart != null && weekEnd != null) {
            if (weekStart <= weekEnd) {
              for (var d = weekStart; d <= weekEnd; d++) {
                weekdays.add(d);
              }
            } else {
              for (var d = weekStart; d <= DateTime.sunday; d++) {
                weekdays.add(d);
              }
              for (var d = DateTime.monday; d <= weekEnd; d++) {
                weekdays.add(d);
              }
            }
          }
        }

        map[workerId] = weekdays;
      }

      /// Если у сотрудника в ответе API нет ни одного дня, подставляем дни работы
      /// филиала из [BranchApi.schedulePatterns] — как в сетке расписания по часам филиала.
      final fallbackWeekdays = _weekdaysFromBranchSchedulePatterns(
        ref.read(currentBranchProvider)?.schedulePatterns,
        branchId,
      );
      if (fallbackWeekdays.isNotEmpty) {
        for (final id in map.keys.toList()) {
          if (map[id]!.isEmpty) {
            map[id] = {...fallbackWeekdays};
          }
        }
      }

      return map;
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }

  /// Загружает сотрудников, доступных в конкретный день.
  Future<List<AvailableWorkerShift>> getAvailableWorkers({
    required int branchId,
    required DateTime date,
  }) async {
    final organizationId = ref.read(organizationIdProvider);
    final token = ref.read(tokenProvider);

    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    final url = ApiConsts().createUrl(
      'organizations/$organizationId/branches/$branchId/available_workers/',
    );
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final dateQuery = normalizedDate.toUtc().toIso8601String();

    try {
      final response = await Dio().get<List<dynamic>>(
        url,
        queryParameters: {'date': dateQuery},
        options: Options(headers: {'Authorization': 'JWT $token'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data!
            .map(
              (e) => AvailableWorkerShift.fromJson(e as Map<String, dynamic>),
            )
            .toList();
      }
      throw CustomException(
        causedError: Exception(
          'Failed to load available workers: ${response.statusCode}',
        ),
      );
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }
}
