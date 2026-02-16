import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/email_storage.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/features/auth/data/models/organization_member/organization_member.dart';

final getAuthOrganiztionsProvider = FutureProvider<OrganizationMembers>(
  (ref) => _GetAuthOrganiztionsImpl(ref).getOrganizations(),
);

abstract class GetAuthOrganiztionsFetcher {
  Future<OrganizationMembers> getOrganizations();
}

class _GetAuthOrganiztionsImpl implements GetAuthOrganiztionsFetcher {
  _GetAuthOrganiztionsImpl(this.ref);

  final Ref ref;

  @override
  Future<OrganizationMembers> getOrganizations() async {
    final token = ref.read(tokenProvider);
    final email = ref.read(emailStorageProvider);

    try {
      final url = ApiConsts().createUrl(
        'accounts/organizations/?token=$token&email=$email&page_size=100',
      );

      final response = await Dio().get<Map<String, dynamic>>(url);

      final results = response.data?['results'] as List<dynamic>? ?? [];

      return results
          .map((e) => OrganizationMember.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CustomException(causedError: e);
    }
  }
}
