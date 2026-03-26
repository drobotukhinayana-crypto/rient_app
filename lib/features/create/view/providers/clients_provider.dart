import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/create/data/models/clients_api.dart';
import 'package:rient_app/features/create/service/clients_service.dart';

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

final clientsByPhoneSearchProvider =
    FutureProvider.family<List<ClientItem>, String>((ref, phoneQuery) async {
      final query = _normalizePhoneSearch(phoneQuery);
      if (query.isEmpty) return const [];
      final service = ref.watch(clientsServiceProvider);
      final response = await service.getClients(search: query);
      return response.results;
    });
