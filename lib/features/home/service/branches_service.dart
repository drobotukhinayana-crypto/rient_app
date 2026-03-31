import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/services/unauthorized_handler.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/home/data/models/branches_api/branches_api.dart';

final branchesServiceProvider = Provider<BranchesService>(
  (ref) => BranchesService(ref),
);

class BranchesService {
  BranchesService(this.ref);

  final Ref ref;

  Future<BranchesApiResponse> getBranches() async {
    final organizationId = ref.read(organizationIdProvider);
    final token = ref.read(tokenProvider);

    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    try {
      final url = ApiConsts().createUrl(
        'organizations/$organizationId/branches/',
      );

      final response = await Dio().get<Map<String, dynamic>>(
        url,
        queryParameters: {
          'page_size': 100, // Получаем все филиалы за один запрос
        },
        options: Options(headers: {'Authorization': 'JWT $token'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        return BranchesApiResponse.fromJson(response.data!);
      } else {
        throw CustomException(
          causedError: Exception(
            'Failed to load branches: ${response.statusCode}',
          ),
        );
      }
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }
}
