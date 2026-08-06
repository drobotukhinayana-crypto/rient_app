import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/network/app_connectivity_provider.dart';
import 'package:rient_app/core/network/app_vpn_provider.dart';
import 'package:rient_app/core/network/post_vpn_grace_provider.dart';
import 'package:rient_app/core/providers/worker_entity_labels_provider.dart';
import 'package:rient_app/features/home/view/providers/statistics_provider.dart';
import 'package:rient_app/features/home/view/providers/today_revenue_metrics_provider.dart';
import 'package:rient_app/features/home/view/providers/worker_permissions_provider.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_network_recovery.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_offline_invalidation.dart';

bool _backOnlineScheduled = false;
bool _vpnDeactivatedHandling = false;

void _invalidateConnectivityDeferred(dynamic ref) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    if (!ref.mounted) return;
    ref.invalidate(connectivityCheckProvider);
  });
}

void _invalidateVpnCheckDeferred(dynamic ref) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    if (!ref.mounted) return;
    ref.invalidate(vpnCheckProvider);
  });
}

void _refreshHomeAfterRecoveryDeferred(dynamic ref) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    if (!ref.mounted) return;
    ref.invalidate(workerEntityLabelsProvider);
    ref.invalidate(statisticsProvider);
    ref.invalidate(todayRevenueMetricsProvider);
    refreshWorkerPermissions(ref);
  });
}

void _scheduleAndroidPostVpnConnectivityRefresh(dynamic ref) {
  if (defaultTargetPlatform != TargetPlatform.android) return;
  for (var tick = 1; tick <= 6; tick++) {
    Future<void>.delayed(Duration(seconds: tick * 2), () async {
      if (!ref.mounted) return;
      if (!isPostVpnConnectivityGraceActive(ref)) return;
      _invalidateConnectivityDeferred(ref);
      _invalidateVpnCheckDeferred(ref);
      await Future<void>.delayed(Duration.zero);
      if (!ref.mounted) return;
      if (ref.read(appNoConnectionProvider)) return;
      await tryRecoverScheduleNetworkAfterVpnOff(ref);
    });
  }
}

void _scheduleVpnDeactivated(dynamic ref, Future<void> Function() handler) {
  SchedulerBinding.instance.addPostFrameCallback((_) {
    unawaited(handler());
  });
}

/// При восстановлении сети проверяет сервер и перезагружает главную.
final connectivityRecoveryListenerProvider = Provider<void>((ref) {
  Future<void> onVpnDeactivated() async {
    if (_vpnDeactivatedHandling) return;
    _vpnDeactivatedHandling = true;
    try {
      await Future<void>.delayed(Duration.zero);
      if (!ref.mounted) return;

      beginPostVpnConnectivityGrace(ref);
      _invalidateVpnCheckDeferred(ref);
      _invalidateConnectivityDeferred(ref);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      if (!ref.mounted) return;

      final isAndroid = defaultTargetPlatform == TargetPlatform.android;
      final maxAttempts = isAndroid ? 6 : 4;
      final retryDelaysMs = isAndroid
          ? const [500, 800, 1200, 1800, 2500, 3500]
          : const [600, 1500, 1500, 1500];

      for (var attempt = 0; attempt < maxAttempts; attempt++) {
        if (attempt > 0) {
          final delayIndex = attempt - 1;
          if (delayIndex < retryDelaysMs.length) {
            await Future.delayed(
              Duration(milliseconds: retryDelaysMs[delayIndex]),
            );
          }
        }
        if (!ref.mounted) return;
        if (await tryRecoverScheduleNetworkAfterVpnOff(ref)) {
          if (!ref.mounted) return;
          _refreshHomeAfterRecoveryDeferred(ref);
          _scheduleAndroidPostVpnConnectivityRefresh(ref);
          return;
        }
      }

      if (!ref.mounted) return;
      if (!ref.read(appVpnActiveProvider)) {
        markScheduleServerReachable(ref);
        beginScheduleNetworkRecovery(ref);
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (!ref.mounted) return;
          invalidateScheduleNetworkProviders(ref);
        });
        _refreshHomeAfterRecoveryDeferred(ref);
      }

      _scheduleAndroidPostVpnConnectivityRefresh(ref);
    } finally {
      _vpnDeactivatedHandling = false;
    }
  }

  void onBackOnline() {
    if (_backOnlineScheduled) return;
    _backOnlineScheduled = true;
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _backOnlineScheduled = false;
      if (!ref.mounted) return;
      if (!await tryRecoverScheduleNetwork(ref)) return;
      if (!ref.mounted) return;
      _refreshHomeAfterRecoveryDeferred(ref);
    });
  }

  ref.listen(connectivityStatusProvider, (previous, next) {
    final wasOnline = previous?.maybeWhen(
          data: connectivityHasNetwork,
          orElse: () => false,
        ) ??
        false;
    next.whenData((results) {
      final isOnline = connectivityHasNetwork(results);
      if (wasOnline != isOnline) {
        _invalidateConnectivityDeferred(ref);
      }
      if (!wasOnline && isOnline) onBackOnline();

      final hadVpn = previous?.maybeWhen(
            data: (prev) => prev.contains(ConnectivityResult.vpn),
            orElse: () => false,
          ) ??
          false;
      final hasVpn = results.contains(ConnectivityResult.vpn);
      if (!hadVpn && hasVpn) {
        _invalidateVpnCheckDeferred(ref);
      }

      // Android: VPN отключили — default network переключился wifi/mobile.
      if (defaultTargetPlatform == TargetPlatform.android) {
        if (hadVpn &&
            !hasVpn &&
            connectivityHasUnderlyingNetwork(results)) {
          _scheduleVpnDeactivated(ref, onVpnDeactivated);
        }
      }
    });
  });

  // Единственный источник для VPN recovery — derived bool (без дубля со stream).
  ref.listen<bool>(appVpnActiveProvider, (previous, next) {
    if (previous == true && next == false) {
      _scheduleVpnDeactivated(ref, onVpnDeactivated);
    }
    if (previous != next) {
      _invalidateVpnCheckDeferred(ref);
    }
  });
});
