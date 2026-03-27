import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';
import 'package:rient_app/core/services/local_storage.dart';

final emailStorageProvider =
    StateNotifierProvider<EmailStorageNotifier, String?>((ref) {
      final localStorage = ref.read(localStorageProvider);
      return EmailStorageNotifier(localStorage);
    });

class EmailStorageNotifier extends StateNotifier<String?> {
  EmailStorageNotifier(this.localStorage) : super(null);

  final LocalStorage localStorage;

  static const _emailKey = 'email';

  String? get email => state;

  Future<void> init() async {
    state = await localStorage.getString(_emailKey);
    state;
  }

  Future<void> updateEmail(String value) async {
    await localStorage.saveString(_emailKey, value);
    state = value;
  }

  Future<void> clearEmail() async {
    await localStorage.removeValue(_emailKey);
    state = null;
  }
}
