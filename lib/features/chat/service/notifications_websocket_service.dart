import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/utils/const/api_consts.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/chat/view/providers/push_history_provider.dart';
import 'package:rient_app/features/schedule/utils/schedule_ws_notification.dart';
import 'package:rient_app/features/schedule/view/providers/work_schedule_provider.dart';

/// Сигнал для перезагрузки списка на [ChatPage] после WS/FCM.
final pushHistoryRefreshTokenProvider = StateProvider<int>((ref) => 0);

/// Обновляет счётчики/кэш истории и список сообщений (из [TabBarPage] / FCM).
void refreshPushHistoryFromRealtime(WidgetRef ref) {
  invalidatePushHistory(ref);
  ref.read(pushHistoryRefreshTokenProvider.notifier).update((v) => v + 1);
}

final notificationsWebSocketControllerProvider =
    Provider<NotificationsWebSocketController>((ref) {
  final controller = NotificationsWebSocketController(ref);
  ref.onDispose(controller.dispose);
  return controller;
});

class NotificationsWebSocketController {
  NotificationsWebSocketController(this._ref);

  final Ref _ref;
  WebSocket? _socket;
  Timer? _reconnectTimer;
  Timer? _debounceTimer;
  bool _enabled = true;

  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    _debounceTimer?.cancel();
    await _socket?.close();
    _socket = null;
  }

  Future<void> ensureConnected() async {
    if (!_enabled) return;
    _reconnectTimer?.cancel();
    final organizationId = _ref.read(organizationIdProvider);
    final token = _ref.read(tokenProvider);
    if (organizationId <= 0 || token == null || token.isEmpty) return;

    try {
      await _socket?.close();
      final socket = await WebSocket.connect(
        ApiConsts().createNotificationsWebSocketUrl(
          organizationId: organizationId,
          token: token,
        ),
      ).timeout(const Duration(seconds: 8));
      if (!_enabled) {
        await socket.close();
        return;
      }
      _socket = socket;
      socket.listen(
        _onSocketMessage,
        onError: (_) => _scheduleReconnect(),
        onDone: _scheduleReconnect,
        cancelOnError: true,
      );
    } catch (_) {
      _scheduleReconnect();
    }
  }

  void dispose() {
    _enabled = false;
    _debounceTimer?.cancel();
    _reconnectTimer?.cancel();
    unawaited(_socket?.close());
    _socket = null;
  }

  void _scheduleReconnect() {
    if (!_enabled) return;
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 3), () {
      if (!_enabled) return;
      unawaited(ensureConnected());
    });
  }

  void _onSocketMessage(dynamic raw) {
    if (!_enabled) return;
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 700), () {
      _ref.invalidate(pushHistoryCountProvider);
      _ref.invalidate(pushHistoryListProvider);
      _ref.read(pushHistoryRefreshTokenProvider.notifier).update((v) => v + 1);
      if (isScheduleAppointmentWsMessage(raw)) {
        _ref.read(workScheduleReloadTokenProvider.notifier).update((v) => v + 1);
      }
    });
  }
}
