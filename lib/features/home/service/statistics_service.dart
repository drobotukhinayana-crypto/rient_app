import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/providers/branch_timezone_provider.dart';
import 'package:rient_app/core/network/app_dio.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/services/unauthorized_handler.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/home/data/models/branch_statistics_comparison.dart';
import 'package:rient_app/features/home/data/models/statistics/statistics.dart';
import 'package:rient_app/features/home/data/models/worker_month_statistics.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';

final statisticsServiceProvider = Provider<StatisticsService>(
  (ref) => StatisticsService(ref),
);

class StatisticsService {
  StatisticsService(this.ref);

  final Ref ref;
  final Map<String, Future<Statistics>> _statisticsInFlight = {};

  Map<String, dynamic>? _normalizeStatisticsPayload(dynamic payload) {
    Map<String, dynamic>? mapPayload;
    if (payload is Map<String, dynamic>) {
      mapPayload = payload;
    } else if (payload is List) {
      if (payload.isEmpty) return null;
      final first = payload.first;
      if (first is Map<String, dynamic>) {
        mapPayload = first;
      } else if (first is Map) {
        mapPayload = first.map((k, v) => MapEntry(k.toString(), v));
      }
    } else if (payload is Map) {
      mapPayload = payload.map((k, v) => MapEntry(k.toString(), v));
    }
    if (mapPayload == null) return null;

    final normalized = Map<String, dynamic>.from(mapPayload);

    Map<String, dynamic> normalizeAppointments(dynamic raw) {
      final src = raw is Map
          ? raw.map((k, v) => MapEntry(k.toString(), v))
          : <String, dynamic>{};
      final cancelled = src['cancelled'] ?? src['canceled'] ?? 0;
      return <String, dynamic>{
        'total': (src['total'] as num?)?.toInt() ?? 0,
        'cancelled': (cancelled as num?)?.toInt() ?? 0,
        'new': (src['new'] as num?)?.toInt() ?? 0,
      };
    }

    normalized['appointments'] = normalizeAppointments(normalized['appointments']);
    normalized['appointments_by_day'] =
        (normalized['appointments_by_day'] as List? ?? const [])
            .whereType<Map>()
            .map((item) {
              final row = item.map((k, v) => MapEntry(k.toString(), v));
              return <String, dynamic>{
                'date': row['date']?.toString() ?? '',
                'appointments': normalizeAppointments(row['appointments']),
              };
            })
            .toList();

    final rawServices = normalized['services'];
    if (rawServices is List) {
      final map = <String, int>{};
      for (final item in rawServices.whereType<Map>()) {
        final row = item.map((k, v) => MapEntry(k.toString(), v));
        final name = (row['_name'] ?? row['name'] ?? '').toString().trim();
        if (name.isEmpty) continue;
        map[name] = (row['count'] as num?)?.toInt() ?? 0;
      }
      normalized['services'] = map;
    } else if (rawServices is! Map) {
      normalized['services'] = <String, int>{};
    }

    normalized['income_by_day'] = (normalized['income_by_day'] as List? ?? const [])
        .whereType<Map>()
        .map((item) {
          final row = item.map((k, v) => MapEntry(k.toString(), v));
          final income = (row['income'] as num?)?.toDouble() ?? 0.0;
          final payDue = (row['pay_due'] as num?)?.toDouble() ?? 0.0;
          final projectedIncome =
              (row['projected_income'] as num?)?.toDouble();
          final factualIncome =
              (row['factual_income'] as num?)?.toDouble() ?? 0.0;
          final averageCheck =
              (row['average_check'] as num?)?.toDouble();
          return <String, dynamic>{
            'date': row['date']?.toString() ?? '',
            'income': income,
            'pay_due': payDue,
            'factual_income': factualIncome,
            if (projectedIncome != null) 'projected_income': projectedIncome,
            if (averageCheck != null) 'average_check': averageCheck,
          };
        })
        .toList();

    normalized['services_by_day'] =
        (normalized['services_by_day'] as List? ?? const []);
    normalized['occupancy_by_day'] =
        (normalized['occupancy_by_day'] as List? ?? const []);
    normalized['occupancy'] =
        ((normalized['occupancy'] as num?) ?? 0).toDouble();

    return normalized;
  }

  /// Статистика филиала за период (month / interval) — как на сайте в аналитике.
  Future<BranchStatisticsComparison> getBranchStatisticsComparison({
    required DateTime startDate,
    required DateTime endDate,
    required String type,
    int? branchId,
    int? workerId,
    String groupingType = '0',
  }) async {
    final token = ref.read(tokenProvider);
    final organizationId = ref.read(organizationIdProvider);
    final int effectiveBranchId =
        branchId ?? ref.read(currentBranchIdProvider);

    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }
    if (effectiveBranchId <= 0) {
      throw CustomException(causedError: Exception('Branch is missing'));
    }

    final branchTz = ref.read(branchTimezoneProvider);
    final startDateStr = branchTz.formatApiDayStart(startDate);
    final endDateStr = branchTz.formatApiDayEnd(endDate);

    try {
      final url = ApiConsts().createUrl(
        'organizations/$organizationId/branches/$effectiveBranchId/statistics/',
      );
      final response = await createAppDio().get<dynamic>(
        url,
        queryParameters: {
          'datetime__gte': startDateStr,
          'datetime__lte': endDateStr,
          'type': type,
          'grouping_type': groupingType,
          'more': false,
          'page': 1,
          'page_size': 30,
          if (workerId != null && workerId > 0) 'worker': workerId,
        },
        options: Options(headers: {'Authorization': 'JWT $token'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final raw = response.data;
        final Map<String, dynamic> payload;
        if (raw is Map<String, dynamic>) {
          payload = raw;
        } else if (raw is Map) {
          payload = raw.map((k, v) => MapEntry(k.toString(), v));
        } else {
          throw CustomException(
            causedError: Exception(
              'Unexpected branch statistics payload: ${raw.runtimeType}',
            ),
          );
        }
        return BranchStatisticsComparison.fromJson(payload);
      }

      throw CustomException(
        causedError: Exception(
          'Failed to load branch statistics: ${response.statusCode}',
        ),
      );
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }

  Future<Statistics> getStatistics({
    required DateTime startDate,
    required DateTime endDate,
    int? branchId,
    int? workerId,
    bool bustCache = false,
  }) async {
    final token = ref.read(tokenProvider);
    final organizationId = ref.read(organizationIdProvider);
    final int resolvedBranchId = branchId ?? ref.read(currentBranchIdProvider);

    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    final branchTz = ref.read(branchTimezoneProvider);
    final startDateStr = branchTz.formatApiDayStart(startDate);
    final endDateStr = branchTz.formatApiDayEnd(endDate);
    final inFlightKey =
        '$organizationId|$resolvedBranchId|$startDateStr|$endDateStr|${workerId ?? 0}';

    if (!bustCache) {
      final inFlight = _statisticsInFlight[inFlightKey];
      if (inFlight != null) return inFlight;
    }

    final request = _fetchStatistics(
      organizationId: organizationId,
      branchId: resolvedBranchId,
      startDateStr: startDateStr,
      endDateStr: endDateStr,
      workerId: workerId,
      token: token,
      bustCache: bustCache,
    );

    if (!bustCache) {
      _statisticsInFlight[inFlightKey] = request;
    }
    try {
      return await request;
    } finally {
      if (!bustCache) {
        _statisticsInFlight.remove(inFlightKey);
      }
    }
  }

  Future<Statistics> _fetchStatistics({
    required int organizationId,
    required int branchId,
    required String startDateStr,
    required String endDateStr,
    required int? workerId,
    required String token,
    required bool bustCache,
  }) async {
    try {
      final url = ApiConsts().createUrl(
        'organizations/$organizationId/branches/$branchId/statistics_one/',
      );

      final response = await createAppDio().get<dynamic>(
        url,
        queryParameters: {
          'datetime__gte': startDateStr,
          'datetime__lte': endDateStr,
          if (workerId != null && workerId > 0) 'worker': workerId,
          if (bustCache)
            '_': DateTime.now().microsecondsSinceEpoch.toString(),
        },
        options: Options(headers: {'Authorization': 'JWT $token'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final payload = _normalizeStatisticsPayload(response.data);
        if (payload == null) {
          throw CustomException(
            causedError: Exception(
              'Unexpected statistics payload: ${response.data.runtimeType}',
            ),
          );
        }
        return Statistics.fromJson(payload);
      } else {
        throw CustomException(
          causedError: Exception(
            'Failed to load statistics: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }

  /// Статистика мастера за календарный месяц (как на сайте в модалке месяца).
  Future<WorkerMonthStatistics> getMonthStatistics({
    required int year,
    required int month,
    int? branchId,
    int? workerId,
  }) async {
    final token = ref.read(tokenProvider);
    final organizationId = ref.read(organizationIdProvider);
    final int effectiveBranchId =
        branchId ?? ref.read(currentBranchIdProvider);
    final roleId = ref.read(roleProvider);

    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }
    if (effectiveBranchId <= 0) {
      throw CustomException(causedError: Exception('Branch is missing'));
    }

    final isWorkerRole = roleId == UserRole.worker.value;
    final resolvedWorkerId = workerId;
    final path = isWorkerRole ||
            resolvedWorkerId == null ||
            resolvedWorkerId <= 0
        ? 'organizations/$organizationId/me/statistics/'
        : 'organizations/$organizationId/workers/$resolvedWorkerId/statistics/';

    try {
      final response = await createAppDio().get<dynamic>(
        ApiConsts().createUrl(path),
        queryParameters: {
          'branch_id': effectiveBranchId,
          'year': year,
          'month': month,
          'more': false,
          'page': 1,
          'page_size': 30,
        },
        options: Options(headers: {'Authorization': 'JWT $token'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final raw = response.data;
        final Map<String, dynamic> payload;
        if (raw is Map<String, dynamic>) {
          payload = raw;
        } else if (raw is Map) {
          payload = raw.map((k, v) => MapEntry(k.toString(), v));
        } else {
          throw CustomException(
            causedError: Exception(
              'Unexpected month statistics payload: ${raw.runtimeType}',
            ),
          );
        }
        return WorkerMonthStatistics.fromJson(payload);
      }

      throw CustomException(
        causedError: Exception(
          'Failed to load month statistics: ${response.statusCode}',
        ),
      );
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }
}
