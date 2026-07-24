import 'dart:async';

import 'package:dio/dio.dart';
import 'package:rient_app/core/network/app_dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/email_storage.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';
import 'package:rient_app/core/utils/exstensions/custom_exstension.dart';
import 'package:rient_app/features/auth/data/models/branches_member/branches_member.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/auth/view/providers/password_provider.dart';

final getAuthBranchesProvider = FutureProvider.autoDispose<BranchesMembers>(
  (ref) {
    final email = ref.watch(emailStorageProvider);
    final organizationId = ref.watch(organizationIdProvider);
    final password = ref.watch(passwordProvider);
    return _GetAuthBranchesFetcherImpl().getBranches(
      email: email,
      organizationId: organizationId,
      password: password,
    );
  },
);

abstract class GetAuthBranchesFetcher {
  Future<BranchesMembers> getBranches({
    required String? email,
    required int organizationId,
    required String password,
  });
}

class _GetAuthBranchesFetcherImpl implements GetAuthBranchesFetcher {
  _GetAuthBranchesFetcherImpl();

  @override
  Future<BranchesMembers> getBranches({
    required String? email,
    required int organizationId,
    required String password,
  }) async {
    if (email == null || email.isEmpty || password.isEmpty) {
      throw CustomException(
        causedError: Exception('Email or password is missing'),
      );
    }
    try {
      final url = ApiConsts().createUrl('accounts/branches/');

      final response = await createAppDio().post<Map<String, dynamic>>(
        url,
        data: FormData.fromMap({
          'email': email,
          'captcha': '0cAFcWeA5CVv...Hd4jjnjP6igECB-RndwLqpKbelHe8G',
          'password': password,
          'organization': organizationId,
          'remember_me': true,
        }),
      );

      // Ответ приходит как один объект: {"role": 1, "branches": [...]}
      final data = response.data;
      if (data == null) return [];
      final member = BranchesMember.fromJson(data);
      // Делаем по одному BranchesMember на каждый филиал, чтобы список показывал все филиалы
      if (member.branches.isEmpty) return [];
      return member.branches
          .map((branch) => BranchesMember(role: member.role, branches: [branch]))
          .toList();
    } catch (e) {
      throw CustomException(causedError: e);
    }
  }
}
