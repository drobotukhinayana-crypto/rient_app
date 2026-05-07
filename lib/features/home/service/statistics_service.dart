import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/services/unauthorized_handler.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/home/data/models/statistics/statistics.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';

final statisticsServiceProvider = Provider<StatisticsService>(
  (ref) => StatisticsService(ref),
);

class StatisticsService {
  StatisticsService(this.ref);

  final Ref ref;

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
          final income = ((row['income'] ?? row['sum']) as num?)?.toDouble() ?? 0.0;
          final payDue = ((row['pay_due'] ?? row['payDue'] ?? row['sum']) as num?)
                  ?.toDouble() ??
              0.0;
          return <String, dynamic>{
            'date': row['date']?.toString() ?? '',
            'income': income,
            'pay_due': payDue,
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

  Future<Statistics> getStatistics({
    required DateTime startDate,
    required DateTime endDate,
    int? branchId,
  }) async {
    final token = ref.read(tokenProvider);
    final organizationId = ref.read(organizationIdProvider);
    final currentBranchId = branchId ?? ref.read(currentBranchIdProvider);

    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    try {
      final url = ApiConsts().createUrl(
        'organizations/$organizationId/branches/$currentBranchId/statistics_one/',
      );

      final startDateStr =
          '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}T00:00:00+03:00';
      final endDateStr =
          '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}T23:59:00+03:00';

      final response = await Dio().get<dynamic>(
        url,
        queryParameters: {
          'datetime__gte': startDateStr,
          'datetime__lte': endDateStr,
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
        final statistics = Statistics.fromJson(payload);
        return statistics;
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
}
