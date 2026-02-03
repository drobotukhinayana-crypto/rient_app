import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:rient_app/core/session_data/data/session_data_storage.dart';
import 'package:rient_app/core/session_data/models/session_data.dart';

final sessionDataControllerProvider =
    StateNotifierProvider<SessionDataController, SessionData?>((ref) {
      return SessionDataController(ref);
    });

class SessionDataController extends StateNotifier<SessionData?> {
  SessionDataController(this.ref) : super(null);

  final Ref ref;
  Future<bool> init() async {
    final sessionData = await _getSessionData();
    state = sessionData;
    return sessionData != null;
  }

  Future<void> deleteSessionData() async {
    await ref.read(sessionDataStorageProvider).remove();
    state = null;
  }

  Future<void> saveSessionData(SessionData sessionData) async {
    state = sessionData;
    await ref.read(sessionDataStorageProvider).save(sessionData);
  }

  void setWithoutLocalStorage(SessionData sessionData) {
    state = sessionData;
  }

  Future<SessionData?> _getSessionData() async {
    return ref.read(sessionDataStorageProvider).get();
  }
}
