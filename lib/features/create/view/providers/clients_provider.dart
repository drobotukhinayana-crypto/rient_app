import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/network/network_failure.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/features/create/data/models/clients_api.dart';
import 'package:rient_app/features/create/service/clients_service.dart';
import 'package:rient_app/features/home/view/providers/worker_permissions_provider.dart';

String _normalizePhoneSearch(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return '';
  final digitsOnly = trimmed.replaceAll(RegExp(r'\D'), '');
  if (digitsOnly.isEmpty) return '';
  if (trimmed.startsWith('+')) {
    return '+$digitsOnly';
  }
  return digitsOnly;
}

final clientsByPhoneSearchProvider = FutureProvider.autoDispose
    .family<List<ClientItem>, String>((ref, phoneQuery) async {
      final query = _normalizePhoneSearch(phoneQuery);
      if (query.isEmpty) return const [];
      final service = ref.watch(clientsServiceProvider);
      try {
        final response = await service.getClients(search: query);
        return response.results;
      } catch (e) {
        final caused = e is CustomException ? e.causedError : e;
        if (isPermissionDenied(caused ?? e)) {
          markSeeContactDataBlocked(ref);
          return const [];
        }
        rethrow;
      }
    });
