import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/network/app_dio.dart';
import 'package:rient_app/core/network/app_offline.dart';
import 'package:rient_app/core/network/ensure_network_for_request.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/services/unauthorized_handler.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';

class TodayRevenueMetrics {
  const TodayRevenueMetrics({
    required this.projectedIncomeToday,
    required this.factualIncomeNow,
    required this.averageCheckToday,
  });

  final double projectedIncomeToday;
  final double factualIncomeNow;
  final double averageCheckToday;
}

final todayRevenueMetricsProvider = FutureProvider<TodayRevenueMetrics>((
  ref,
) async {
  try {
    await ensureNetworkForRequest(ref);

    final token = ref.watch(tokenProvider);
    final organizationId = ref.watch(organizationIdProvider);
    final branchId = ref.watch(currentBranchIdProvider);
    if (token == null ||
        token.isEmpty ||
        organizationId <= 0 ||
        branchId == 0) {
      return const TodayRevenueMetrics(
        projectedIncomeToday: 0,
        factualIncomeNow: 0,
        averageCheckToday: 0,
      );
    }

    final now = DateTime.now();
    final dayStart =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}T00:00:00+03:00';
    final dayEnd =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}T23:59:00+03:00';

    final url = ApiConsts().createUrl(
      'organizations/$organizationId/branches/$branchId/statistics_one/',
    );
    final response = await createAppDio().get<dynamic>(
      url,
      queryParameters: {
        'datetime__gte': dayStart,
        'datetime__lte': dayEnd,
      },
      options: Options(headers: {'Authorization': 'JWT $token'}),
    );
    final data = response.data;
    final payload = data is Map<String, dynamic>
        ? data
        : (data is List && data.isNotEmpty && data.first is Map
              ? Map<String, dynamic>.from(data.first as Map)
              : <String, dynamic>{});

    return TodayRevenueMetrics(
      projectedIncomeToday:
          ((payload['projected_income_today'] as num?) ?? 0).toDouble(),
      factualIncomeNow:
          ((payload['factual_income_now'] as num?) ?? 0).toDouble(),
      averageCheckToday:
          ((payload['average_check_today'] as num?) ?? 0).toDouble(),
    );
  } on AppOfflineException {
    rethrow;
  } catch (e) {
    await handleUnauthorizedIfNeeded(ref, e);
    rethrow;
  }
});
