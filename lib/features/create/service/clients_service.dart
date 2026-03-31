import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/services/unauthorized_handler.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/create/data/models/clients_api.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';

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
    String selection = 'general',
  }) async {
    final organizationId = ref.read(organizationIdProvider);
    final branchId = ref.read(currentBranchIdProvider);
    final token = ref.read(tokenProvider);
    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    final url = ApiConsts().createUrl('clients/clients-full/');

    try {
      final response = await Dio().get<Map<String, dynamic>>(
        url,
        queryParameters: {
          'organization': organizationId,
          'search': search,
          'page': page,
          'page_size': pageSize,
          'selection': selection,
          'branch_id': branchId,
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
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }

  Future<ClientItem> createClient({
    required String phone,
    required String firstName,
    required String lastName,
    String? commentText,
    int status = 0,
  }) async {
    final organizationId = ref.read(organizationIdProvider);
    final token = ref.read(tokenProvider);
    if (token == null || token.isEmpty) {
      throw CustomException(causedError: Exception('Token is missing'));
    }

    final url = ApiConsts().createUrl('clients/');
    final payload = <String, dynamic>{
      'organization': organizationId,
      'phone': phone,
      'first_name': firstName,
      'last_name': lastName,
      'comment': {
        'id': null,
        'user': null,
        'text': commentText?.trim() ?? '',
      },
      'status': status,
      'transactions_sum': 0,
      'appointment_sum_avg': 0,
      'number_of_visits': 0,
      'reliability_factor': 0,
      'discount': 0,
      'balance': 0,
      'custom_fields': const [],
      'is_new': true,
    };

    try {
      final response = await Dio().post<Map<String, dynamic>>(
        url,
        data: payload,
        options: Options(
          headers: {
            'Authorization': 'JWT $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      if ((response.statusCode == 201 || response.statusCode == 200) &&
          response.data != null) {
        return ClientItem.fromJson(response.data!);
      }
      throw CustomException(
        causedError: Exception('Failed to create client: ${response.statusCode}'),
      );
    } catch (e) {
      await handleUnauthorizedIfNeeded(ref, e);
      throw CustomException(causedError: e);
    }
  }
}
