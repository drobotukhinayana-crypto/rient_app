import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/schedule/data/models/schedules_api/schedules_api.dart';

final schedulesServiceProvider = Provider<SchedulesService>(
  (ref) => SchedulesService(ref),
);

class SchedulesService {
  SchedulesService(this.ref);

  final Ref ref;

  /// API расписаний ожидает даты в формате YYYY-MM-DD.
  static String _dateToApi(DateTime date) {
    final y = date.year;
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Future<SchedulesApiResponse> getSchedules({
    required int branchId,
    required DateTime dateGte,
    required DateTime dateLte,
    int pageSize = 500,
  }) async {
    final organizationId = ref.read(organizationIdProvider);
    final token = ref.read(tokenProvider);

    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    final url = ApiConsts().createUrl(
      'organizations/$organizationId/schedules/',
    );
    final queryParams = <String, dynamic>{
      'date__gte': _dateToApi(dateGte),
      'date__lte': _dateToApi(dateLte),
      'page_size': pageSize,
      'branch': branchId,
    };

    try {
      final response = await Dio().get<Map<String, dynamic>>(
        url,
        queryParameters: queryParams,
        options: Options(headers: {'Authorization': 'JWT $token'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        return SchedulesApiResponse.fromJson(response.data!);
      }
      throw CustomException(
        causedError: Exception(
          'Failed to load schedules: ${response.statusCode}',
        ),
      );
    } catch (e) {
      throw CustomException(causedError: e);
    }
  }
}
