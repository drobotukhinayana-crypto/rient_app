import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/services/local_storage.dart';
import 'package:rient_app/core/session_data/models/session_data.dart';

final sessionDataStorageProvider = Provider<SessionDataStorage>(
  _SessionDataStorageImpl.new,
);

abstract class SessionDataStorage {
  Future<SessionData?> get();
  Future<void> save(SessionData sessionData);
  Future<void> remove();
}

class _SessionDataStorageImpl implements SessionDataStorage {
  _SessionDataStorageImpl(this.ref);

  final Ref ref;
  LocalStorage get _localStorage => ref.read(localStorageProvider);

  final _key = 'session_data';

  @override
  Future<SessionData?> get() async {
    final str = await _localStorage.getString(_key);
    if (str == null) return null;
    final json = jsonDecode(str) as Map<String, dynamic>;
    final sessionData = SessionData.fromJson(json);
    return sessionData;
  }

  @override
  Future<void> remove() async {
    await _localStorage.removeValue(_key);
  }

  @override
  Future<void> save(SessionData sessionData) async {
    final json = sessionData.toJson();
    final jsonStr = jsonEncode(json);
    await _localStorage.saveString(_key, jsonStr);
  }
}
