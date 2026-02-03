import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';
import 'package:rient_app/core/services/local_storage.dart';

final tokenProvider = StateNotifierProvider<TokenStorageNotifier, String?>((
  ref,
) {
  final localStorage = ref.read(localStorageProvider);
  return TokenStorageNotifier(localStorage);
});

class TokenStorageNotifier extends StateNotifier<String?> {
  TokenStorageNotifier(this.localStorage) : super(null);

  final LocalStorage localStorage;

  static const _tokenKey = 'token';

  String? get token => state;

  Future<void> init() async {
    state = await localStorage.getString(_tokenKey);
    state;
  }

  Future<void> updateToken(String value) async {
    await localStorage.saveString(_tokenKey, value);
    state = value;
  }
}
