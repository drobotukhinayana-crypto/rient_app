import 'package:dio/dio.dart';
import 'package:rient_app/core/network/app_dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/services/unauthorized_handler.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/create/data/models/worker_services_api.dart';

final workerServicesServiceProvider = Provider<WorkerServicesService>(
  (ref) => WorkerServicesService(ref),
);

class WorkerServicesService {
  WorkerServicesService(this.ref);

  final Ref ref;

  Future<WorkerServicesApiResponse> getWorkerServices({
    required int workerId,
    required int branchId,
    String search = '',
    int page = 1,
    int pageSize = 100,
  }) async {
    final organizationId = ref.read(organizationIdProvider);
    final token = ref.read(tokenProvider);

    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    final url = ApiConsts().createUrl(
      'organizations/$organizationId/workers/$workerId/services/',
    );

    try {
      final response = await createAppDio().get<Map<String, dynamic>>(
        url,
        queryParameters: {
          'branch': branchId,
          'search': search,
          'page': page,
          'page_size': pageSize,
        },
        options: Options(headers: {'Authorization': 'JWT $token'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        return WorkerServicesApiResponse.fromJson(response.data!);
      }
      throw CustomException(
        causedError: Exception(
          'Failed to load worker services: ${response.statusCode}',
        ),
      );
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }
}
