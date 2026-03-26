import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/create/data/models/clients_api.dart';

final clientsServiceProvider = Provider<ClientsService>((ref) {
  return ClientsService(ref);
});

class ClientsService {
  ClientsService(this.ref);

  final Ref ref;

  Future<ClientsApiResponse> getClients({
    required String search,
    int page = 1,
    int pageSize = 7,
  }) async {
    final organizationId = ref.read(organizationIdProvider);
    final token = ref.read(tokenProvider);
    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    final url = ApiConsts().createUrl('clients/');

    try {
      final response = await Dio().get<Map<String, dynamic>>(
        url,
        queryParameters: {
          'organization': organizationId,
          'search': search,
          'page': page,
          'page_size': pageSize,
        },
        options: Options(headers: {'Authorization': 'JWT $token'}),
      );
      if (response.statusCode == 200 && response.data != null) {
        return ClientsApiResponse.fromJson(response.data!);
      }
      throw CustomException(
        causedError: Exception('Failed to load clients: ${response.statusCode}'),
      );
    } catch (e) {
      throw CustomException(causedError: e);
    }
  }
}
