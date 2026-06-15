import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/routes/router_provider.dart';
import 'package:rient_app/core/services/app_lock/app_lock_service.dart';
import 'package:rient_app/core/services/email_storage.dart';
import 'package:rient_app/core/services/local_storage.dart';
import 'package:rient_app/core/services/token_storage.dart';
import 'package:rient_app/core/session_data/view/controller/session_data_controller.dart';
import 'package:rient_app/features/auth/service/get_auth_branches.dart';
import 'package:rient_app/features/auth/service/get_auth_company.dart';
import 'package:rient_app/features/auth/view/auth_page.dart';
import 'package:rient_app/features/auth/view/providers/branches_id_provider.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/auth/view/providers/password_provider.dart';
import 'package:rient_app/features/auth/view/providers/role_provider.dart';
import 'package:rient_app/features/auth/view/providers/role_storage_provider.dart';
import 'package:rient_app/features/auth/view/providers/selected_organization_member_provider.dart';
import 'package:rient_app/features/auth/view/providers/app_lock_provider.dart';
import 'package:rient_app/features/chat/service/notifications_websocket_service.dart';
import 'package:rient_app/features/chat/service/push_registration_service.dart';
import 'package:rient_app/features/chat/view/providers/push_history_provider.dart';
import 'package:rient_app/features/home/view/providers/account_profile_provider.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/home/view/providers/current_worker_id_provider.dart';
import 'package:rient_app/features/home/view/providers/statistics_provider.dart';
import 'package:rient_app/features/home/view/providers/today_revenue_metrics_provider.dart';
import 'package:rient_app/features/home/view/providers/worker_permissions_provider.dart';
import 'package:rient_app/features/schedule/data/schedule_appointments_cache.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_offline_provider.dart';

Future<void> _remoteLogoutCleanup(dynamic ref) async {
  try {
    await ref
        .read(notificationsWebSocketControllerProvider)
        .disconnect()
        .timeout(const Duration(seconds: 2));
  } catch (_) {}

  try {
    await ref
        .read(pushRegistrationServiceProvider)
        .deactivateCurrentDevice()
        .timeout(const Duration(seconds: 3));
  } catch (_) {}
}

/// Полная очистка сессии перед входом другого пользователя.
Future<void> clearUserSession(dynamic ref) async {
  final branchStorageKey = ref.read(selectedBranchStorageKeyProvider);

  await _remoteLogoutCleanup(ref);

  await ref.read(sessionDataControllerProvider.notifier).deleteSessionData();
  await ref.read(tokenProvider.notifier).clearToken();
  await ref.read(emailStorageProvider.notifier).clearEmail();
  await ref.read(organizationIdProvider.notifier).clearOrganizationId();
  ref.read(roleProvider.notifier).state = 0;
  await ref.read(roleStorageProvider.notifier).clearRole();
  ref.read(branchesIdProvider.notifier).state = 0;
  ref.read(passwordProvider.notifier).state = '';
  ref.read(selectedOrganizationMemberProvider.notifier).state = null;
  ref.read(selectedBranchProvider.notifier).state = null;

  final storage = ref.read(localStorageProvider);
  await storage.removeValue(branchStorageKey);
  await storage.removeValue(selectedBranchIdStorageKey);
  await storage.removeValue(scheduleOfflineCacheStorageKey);
  await storage.removeValue(scheduleOfflineCurrentWorkerIdKey);

  await ref.read(appLockServiceProvider).clearAll();
  await ref.read(appLockUiProvider.notifier).onSessionEnded();

  resetScheduleNetworkStateForSession(ref);
  invalidateScheduleNetworkProviders(ref);

  ref.invalidate(branchesProvider);
  ref.invalidate(accountProfileProvider);
  ref.invalidate(statisticsProvider);
  ref.invalidate(todayRevenueMetricsProvider);
  ref.invalidate(currentWorkerIdProvider);
  refreshWorkerPermissions(ref);
  ref.invalidate(pushHistoryCountProvider);
  ref.invalidate(pushHistoryListProvider);
  ref.invalidate(getAuthOrganiztionsProvider);
  ref.invalidate(getAuthBranchesProvider);
}

/// Минимальная локальная очистка, если полный logout не успел завершиться.
Future<void> _clearUserSessionLocalFallback(dynamic ref) async {
  try {
    final branchStorageKey = ref.read(selectedBranchStorageKeyProvider);
    final storage = ref.read(localStorageProvider);

    await ref.read(sessionDataControllerProvider.notifier).deleteSessionData();
    await ref.read(tokenProvider.notifier).clearToken();
    await ref.read(emailStorageProvider.notifier).clearEmail();
    await ref.read(organizationIdProvider.notifier).clearOrganizationId();
    ref.read(roleProvider.notifier).state = 0;
    await ref.read(roleStorageProvider.notifier).clearRole();
    ref.read(branchesIdProvider.notifier).state = 0;
    ref.read(passwordProvider.notifier).state = '';
    ref.read(selectedOrganizationMemberProvider.notifier).state = null;
    ref.read(selectedBranchProvider.notifier).state = null;

    await storage.removeValue(branchStorageKey);
    await storage.removeValue(selectedBranchIdStorageKey);
    await storage.removeValue(scheduleOfflineCacheStorageKey);
    await storage.removeValue(scheduleOfflineCurrentWorkerIdKey);

    resetScheduleNetworkStateForSession(ref);
    invalidateScheduleNetworkProviders(ref);
    ref.invalidate(branchesProvider);
    ref.invalidate(accountProfileProvider);
  } catch (_) {}
}

/// Очистка сессии из UI-слоя (WidgetRef) и переход на экран входа.
Future<void> performLogout(WidgetRef ref) async {
  final router = ref.read(routerProvider);
  try {
    await clearUserSession(ref).timeout(const Duration(seconds: 6));
  } on TimeoutException {
    await _clearUserSessionLocalFallback(ref);
  } catch (_) {
    await _clearUserSessionLocalFallback(ref);
  } finally {
    router.goNamed(AuthPage.name);
  }
}

/// Очистка сессии из сервисов/провайдеров (Ref) и переход на экран входа.
Future<void> performLogoutWithRef(Ref ref) async {
  final router = ref.read(routerProvider);
  try {
    await clearUserSession(ref).timeout(const Duration(seconds: 6));
  } on TimeoutException {
    await _clearUserSessionLocalFallback(ref);
  } catch (_) {
    await _clearUserSessionLocalFallback(ref);
  } finally {
    router.goNamed(AuthPage.name);
  }
}
