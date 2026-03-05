import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/token_storage.dart';
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

      final response = await Dio().get<Map<String, dynamic>>(
        url,
        queryParameters: {
          'datetime__gte': startDateStr,
          'datetime__lte': endDateStr,
        },
        options: Options(headers: {'Authorization': 'JWT $token'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final statistics = Statistics.fromJson(response.data!);
        return statistics;
      } else {
        throw CustomException(
          causedError: Exception(
            'Failed to load statistics: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      throw CustomException(causedError: e);
    }
  }
}
