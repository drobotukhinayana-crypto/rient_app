import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/services/unauthorized_handler.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/home/view/providers/current_worker_id_provider.dart';
import 'package:rient_app/features/link/data/models/widget_links_api/widget_links_api.dart';

final widgetLinksServiceProvider = Provider<WidgetLinksService>(
  (ref) => WidgetLinksService(ref),
);

class WidgetLinksService {
  WidgetLinksService(this.ref);

  final Ref ref;

  Future<String> getWidgetUrl() async {
    final organizationId = ref.read(organizationIdProvider);
    if (organizationId <= 0) {
      throw CustomException(
        causedError: Exception('Organization id is missing'),
      );
    }

    final token = ref.read(tokenProvider);
    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    final roleId = ref.read(roleProvider);
    final queryParameters = <String, dynamic>{
      'organization': organizationId,
    };

    if (roleId == UserRole.worker.value) {
      final workerId = await ref.read(currentWorkerIdProvider.future);
      if (workerId == null || workerId <= 0) {
        throw CustomException(
          causedError: Exception('Worker id is missing'),
        );
      }
      queryParameters['type'] = 1;
      queryParameters['worker'] = workerId;
    } else {
      queryParameters['type'] = 2;
    }

    try {
      final url = ApiConsts().createUrl(
        'forms/scripts/appointments/widget_links/',
      );

      final response = await Dio().get<Map<String, dynamic>>(
        url,
        queryParameters: queryParameters,
        options: Options(headers: {'Authorization': 'JWT $token'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final parsed = WidgetLinksApiResponse.fromJson(response.data!);
        if (parsed.results.isEmpty) {
          throw CustomException(
            causedError: Exception('Widget link is not available'),
          );
        }
        final widgetUrl = parsed.results.first.widgetUrl.trim();
        if (widgetUrl.isEmpty) {
          throw CustomException(
            causedError: Exception('Widget link is empty'),
          );
        }
        return widgetUrl;
      }

      throw CustomException(
        causedError: Exception(
          'Failed to load widget link: ${response.statusCode}',
        ),
      );
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }
}
