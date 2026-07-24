import 'dart:async';

import 'package:dio/dio.dart';
import 'package:rient_app/core/network/app_dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/email_storage.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/features/auth/data/models/organization_member/organization_member.dart';

final getAuthOrganiztionsProvider = FutureProvider.autoDispose<OrganizationMembers>(
  (ref) {
    final token = ref.watch(tokenProvider);
    final email = ref.watch(emailStorageProvider);
    return _GetAuthOrganiztionsImpl().getOrganizations(token: token, email: email);
  },
);

abstract class GetAuthOrganiztionsFetcher {
  Future<OrganizationMembers> getOrganizations({
    required String? token,
    required String? email,
  });
}

class _GetAuthOrganiztionsImpl implements GetAuthOrganiztionsFetcher {
  _GetAuthOrganiztionsImpl();

  @override
  Future<OrganizationMembers> getOrganizations({
    required String? token,
    required String? email,
  }) async {
    if (token == null || token.isEmpty || email == null || email.isEmpty) {
      return [];
    }
    try {
      final url = ApiConsts().createUrl(
        'accounts/organizations/?token=$token&email=$email&page_size=100',
      );

      final response = await createAppDio().get<Map<String, dynamic>>(url);

      final results = response.data?['results'] as List<dynamic>? ?? [];

      return results
          .map((e) => OrganizationMember.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CustomException(causedError: e);
    }
  }
}
