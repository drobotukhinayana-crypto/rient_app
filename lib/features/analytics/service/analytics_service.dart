import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/network/app_dio.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/services/unauthorized_handler.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/features/analytics/data/models/analytics_summary/analytics_summary.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';

final analyticsServiceProvider = Provider<AnalyticsService>(
  (ref) => AnalyticsService(ref),
);

class AnalyticsService {
  AnalyticsService(this.ref);

  final Ref ref;

  static String _isoDateTime(DateTime date, {required bool endOfDay}) {
    final y = date.year;
    final m = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    final time = endOfDay ? '23:59:59' : '00:00:00';
    return '$y-$m-${day}T$time+03:00';
  }

  List<Map<String, dynamic>> _normalizeOccupancyList(dynamic raw) {
    if (raw is! List) return const [];
    return raw.whereType<Map>().map((item) {
      final row = item.map((k, v) => MapEntry(k.toString(), v));
      return <String, dynamic>{
        'date': row['date']?.toString() ?? '',
        'occupancy': ((row['occupancy'] as num?) ?? 0).toDouble(),
      };
    }).toList();
  }

  List<Map<String, dynamic>> _normalizeIncomeByDay(dynamic raw) {
    if (raw is! List) return const [];
    return raw.whereType<Map>().map((item) {
      final row = item.map((k, v) => MapEntry(k.toString(), v));
      final income = ((row['income'] ?? row['sum']) as num?)?.toDouble();
      final payDue = (row['pay_due'] as num?)?.toDouble();
      return <String, dynamic>{
        'date': row['date']?.toString() ?? '',
        if (row['sum'] != null) 'sum': (row['sum'] as num).toDouble(),
        if (income != null) 'income': income,
        if (payDue != null) 'pay_due': payDue,
      };
    }).toList();
  }

  List<Map<String, dynamic>> _normalizeGlobalServices(dynamic raw) {
    if (raw is List) {
      return raw.whereType<Map>().map((item) {
        final row = item.map((k, v) => MapEntry(k.toString(), v));
        final name =
            (row['name'] ?? row['_name'] ?? row['service'] ?? '').toString();
        final count =
            (row['count'] as num?)?.toInt() ?? (row['total'] as num?)?.toInt();
        return <String, dynamic>{
          if (name.isNotEmpty) 'name': name,
          if (row['service'] != null) 'service': row['service'].toString(),
          'count': count ?? 0,
          if (row['total'] != null) 'total': (row['total'] as num).toInt(),
        };
      }).toList();
    }
    if (raw is Map) {
      return raw.entries
          .map(
            (e) => <String, dynamic>{
              'name': e.key.toString(),
              'count': (e.value as num?)?.toInt() ?? 0,
            },
          )
          .toList();
    }
    return const [];
  }

  Map<String, dynamic> _normalizeGlobalClients(dynamic raw) {
    if (raw is! Map) {
      return const <String, dynamic>{'total': 0, 'groups_map': <String, dynamic>{}};
    }
    final row = raw.map((k, v) => MapEntry(k.toString(), v));
    final groupsMapRaw = row['groups_map'];
    final groupsMap = <String, dynamic>{};
    if (groupsMapRaw is Map) {
      for (final entry in groupsMapRaw.entries) {
        if (entry.value is! Map) continue;
        final group = (entry.value as Map).map(
          (k, v) => MapEntry(k.toString(), v),
        );
        groupsMap[entry.key.toString()] = <String, dynamic>{
          'male': (group['male'] as num?)?.toInt() ?? 0,
          'female': (group['female'] as num?)?.toInt() ?? 0,
        };
      }
    }
    return <String, dynamic>{
      if (row['average_age'] != null)
        'average_age': (row['average_age'] as num).toDouble(),
      'total': (row['total'] as num?)?.toInt() ?? 0,
      'groups_map': groupsMap,
    };
  }

  Map<String, dynamic> _normalizeComparisonPeriod(dynamic raw) {
    if (raw is! Map) return <String, dynamic>{};
    final row = raw.map((k, v) => MapEntry(k.toString(), v));
    return <String, dynamic>{
      if (row['total_income'] != null)
        'total_income': (row['total_income'] as num).toDouble(),
      if (row['total_clients'] != null)
        'total_clients': (row['total_clients'] as num).toInt(),
      if (row['completed_appointments'] != null)
        'completed_appointments':
            (row['completed_appointments'] as num).toInt(),
      if (row['total_appointments'] != null)
        'total_appointments': (row['total_appointments'] as num).toInt(),
      if (row['new_clients'] != null)
        'new_clients': (row['new_clients'] as num).toInt(),
      if (row['existing_clients'] != null)
        'existing_clients': (row['existing_clients'] as num).toInt(),
      if (row['oneshot_clients'] != null)
        'oneshot_clients': (row['oneshot_clients'] as num).toInt(),
      if (row['oneshot_clients_all'] != null)
        'oneshot_clients_all': (row['oneshot_clients_all'] as num).toInt(),
      if (row['average_transactions'] != null)
        'average_transactions':
            (row['average_transactions'] as num).toDouble(),
      if (row['performance'] != null)
        'performance': (row['performance'] as num).toDouble(),
      if (row['pay_due'] != null) 'pay_due': (row['pay_due'] as num).toDouble(),
      if (row['occupancy'] != null)
        'occupancy': (row['occupancy'] as num).toDouble(),
      if (row['income_by_day'] != null)
        'income_by_day': _normalizeIncomeByDay(row['income_by_day']),
    };
  }

  Map<String, dynamic> _normalizePayload(Map<String, dynamic> source) {
    final normalized = Map<String, dynamic>.from(source);
    final summary = (normalized['summary'] as Map?)?.map(
          (k, v) => MapEntry(k.toString(), v),
        ) ??
        <String, dynamic>{};

    final appointmentsRaw = summary['appointments'];
    final appointments = appointmentsRaw is Map
        ? appointmentsRaw.map((k, v) => MapEntry(k.toString(), v))
        : <String, dynamic>{};
    final cancelled = appointments['cancelled'] ?? appointments['canceled'] ?? 0;

    summary['appointments'] = <String, dynamic>{
      'total': (appointments['total'] as num?)?.toInt() ?? 0,
      'cancelled': (cancelled as num?)?.toInt() ?? 0,
      'new': (appointments['new'] as num?)?.toInt() ?? 0,
    };
    summary['occupancy'] = ((summary['occupancy'] as num?) ?? 0).toDouble();
    summary['occupancy_by_day'] =
        _normalizeOccupancyList(summary['occupancy_by_day']);
    summary['income_by_day'] = _normalizeIncomeByDay(summary['income_by_day']);
    normalized['summary'] = summary;

    normalized['occupancy'] = _normalizeOccupancyList(normalized['occupancy']);

    final comparison = (normalized['comparison'] as Map?)?.map(
          (k, v) => MapEntry(k.toString(), v),
        ) ??
        <String, dynamic>{};
    comparison['current'] = _normalizeComparisonPeriod(comparison['current']);
    normalized['comparison'] = comparison;

    final currentIncome = comparison['current'] is Map
        ? (comparison['current'] as Map)['income_by_day']
        : null;
    if ((summary['income_by_day'] as List).isEmpty && currentIncome is List) {
      summary['income_by_day'] = _normalizeIncomeByDay(currentIncome);
      normalized['summary'] = summary;
    }

    final global = (normalized['global'] as Map?)?.map(
          (k, v) => MapEntry(k.toString(), v),
        ) ??
        <String, dynamic>{};
    global['services'] = _normalizeGlobalServices(global['services']);
    global['clients'] = _normalizeGlobalClients(global['clients']);
    final sourcesRaw = global['sources'];
    if (sourcesRaw is Map) {
      global['sources'] = sourcesRaw.map((k, v) => MapEntry(k.toString(), v));
    } else if (sourcesRaw is List) {
      global['sources'] = <String, dynamic>{
        'items': sourcesRaw,
      };
    } else {
      global['sources'] = <String, dynamic>{};
    }
    normalized['global'] = global;

    final overviewRaw = normalized['overview'];
    if (overviewRaw is Map) {
      final row = overviewRaw.map((k, v) => MapEntry(k.toString(), v));
      normalized['overview'] = <String, dynamic>{
        if (row['performance'] != null)
          'performance': (row['performance'] as num).toDouble(),
        if (row['pay_due'] != null) 'pay_due': (row['pay_due'] as num).toDouble(),
        if (row['occupancy'] != null)
          'occupancy': (row['occupancy'] as num).toDouble(),
        if (row['income'] != null) 'income': (row['income'] as num).toDouble(),
        if (row['clients'] != null) 'clients': (row['clients'] as num).toInt(),
        if (row['average_check'] != null)
          'average_check': (row['average_check'] as num).toDouble(),
      };
    }

    final specialistRaw = normalized['specialist'];
    if (specialistRaw is Map) {
      final row = specialistRaw.map((k, v) => MapEntry(k.toString(), v));
      normalized['specialist'] = <String, dynamic>{
        if (row['performance'] != null)
          'performance': (row['performance'] as num).toDouble(),
        if (row['pay_due'] != null) 'pay_due': (row['pay_due'] as num).toDouble(),
      };
    }

    final meta = (normalized['meta'] as Map?)?.map(
          (k, v) => MapEntry(k.toString(), v),
        ) ??
        <String, dynamic>{};
    normalized['meta'] = <String, dynamic>{
      if (meta['role'] != null) 'role': (meta['role'] as num).toInt(),
      'can_see_income': meta['can_see_income'] != false,
      'can_see_pay_due': meta['can_see_pay_due'] == true,
    };

    return normalized;
  }

  Future<AnalyticsSummary> getSummary({
    required DateTime startDate,
    required DateTime endDate,
    required int branchId,
    int? workerId,
    String type = 'interval',
    String groupingType = '0',
    bool includeBenchmarking = true,
  }) async {
    final token = ref.read(tokenProvider);
    final organizationId = ref.read(organizationIdProvider);

    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }
    if (branchId <= 0) {
      throw CustomException(causedError: Exception('Branch is missing'));
    }

    try {
      final url = ApiConsts().createUrl('mobile/v1/analytics/summary/');
      final response = await createAppDio().get<Map<String, dynamic>>(
        url,
        queryParameters: {
          'organization_id': organizationId,
          'branch_id': branchId,
          'datetime__gte': _isoDateTime(startDate, endOfDay: false),
          'datetime__lte': _isoDateTime(endDate, endOfDay: true),
          'type': type,
          'grouping_type': groupingType,
          'include_benchmarking': includeBenchmarking ? 1 : 0,
          if (workerId != null && workerId > 0) 'worker': workerId,
        },
        options: Options(headers: {'Authorization': 'JWT $token'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final payload = _normalizePayload(response.data!);
        return AnalyticsSummary.fromJson(payload);
      }

      throw CustomException(
        causedError: Exception(
          'Failed to load analytics summary: ${response.statusCode}',
        ),
      );
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }
}
