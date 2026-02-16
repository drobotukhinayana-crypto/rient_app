import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/email_storage.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/features/auth/data/models/branches_member/branches_member.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/auth/view/providers/password_provider.dart';

final getAuthBranchesProvider = FutureProvider<BranchesMembers>(
  (ref) => _GetAuthBranchesFetcherImpl(ref).getBranches(),
);

abstract class GetAuthBranchesFetcher {
  Future<BranchesMembers> getBranches();
}

class _GetAuthBranchesFetcherImpl implements GetAuthBranchesFetcher {
  _GetAuthBranchesFetcherImpl(this.ref);

  final Ref ref;

  @override
  Future<BranchesMembers> getBranches() async {
    final email = ref.read(emailStorageProvider);
    final organizationId = ref.read(organizationIdProvider);
    final password = ref.read(passwordProvider);

    if (email == null || email.isEmpty || password.isEmpty) {
      throw CustomException(
        causedError: Exception('Email or password is missing'),
      );
    }
    try {
      final url = ApiConsts().createUrl('accounts/branches/');

      final response = await Dio().post<Map<String, dynamic>>(
        url,
        data: FormData.fromMap({
          'email': email,
          'captcha': '0cAFcWeA5CVv...Hd4jjnjP6igECB-RndwLqpKbelHe8G',
          'password': password,
          'organization': organizationId,
          'remember_me': true,
        }),
      );

      final results = response.data?['results'] as List<dynamic>? ?? [];

      return results
          .map((e) => BranchesMember.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw CustomException(causedError: e);
    }
  }
}
