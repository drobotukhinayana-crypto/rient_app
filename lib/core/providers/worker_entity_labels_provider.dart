import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/models/worker_entity_labels.dart';
import 'package:rient_app/core/network/app_dio.dart';
import 'package:rient_app/core/network/network_failure.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/services/unauthorized_handler.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';

final workerEntityLabelsProvider = FutureProvider<WorkerEntityLabels>((
  ref,
) async {
  ref.watch(tokenProvider);
  ref.watch(organizationIdProvider);

  final token = ref.read(tokenProvider);
  if (token == null || token.isEmpty) {
    return WorkerEntityLabels.defaults;
  }

  final url = ApiConsts().createUrl('accounts/');
  try {
    final response = await createAppDio().get<Map<String, dynamic>>(
      url,
      options: Options(headers: {'Authorization': 'JWT $token'}),
    );
    final data = response.data;
    if (response.statusCode != 200 || data == null) {
      return WorkerEntityLabels.defaults;
    }

    final organization = data['organization'];
    if (organization is! Map) {
      return WorkerEntityLabels.defaults;
    }

    final workerName = organization['worker_name'];
    if (workerName is! Map) {
      return WorkerEntityLabels.defaults;
    }

    return WorkerEntityLabels.fromJson(
      workerName.map((k, v) => MapEntry(k.toString(), v)),
    );
  } catch (e) {
    if (!isNetworkFailure(e)) {
      await handleUnauthorizedIfNeeded(ref, e);
    }
    return WorkerEntityLabels.defaults;
  }
});
