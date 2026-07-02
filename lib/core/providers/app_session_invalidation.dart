import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/core/providers/worker_entity_labels_provider.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/home/view/providers/account_profile_provider.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';
import 'package:rient_app/features/home/view/providers/current_worker_id_provider.dart';
import 'package:rient_app/features/home/view/providers/organization_settings_provider.dart';
import 'package:rient_app/features/home/view/providers/statistics_provider.dart';
import 'package:rient_app/features/home/view/providers/today_revenue_metrics_provider.dart';
import 'package:rient_app/features/home/view/providers/worker_permissions_provider.dart';
import 'package:rient_app/features/analytics/view/providers/analytics_statistics_provider.dart';
import 'package:rient_app/features/chat/view/providers/push_history_provider.dart';
import 'package:rient_app/features/link/view/providers/widget_link_provider.dart';
import 'package:rient_app/features/schedule/view/providers/schedule_offline_provider.dart';
import 'package:rient_app/features/schedule/view/providers/work_schedule_provider.dart';
import 'package:rient_app/features/schedule/view/providers/workers_provider.dart';

bool _branchInvalidationScheduled = false;

void _bumpWorkScheduleReload(dynamic ref) {
  ref.read(workScheduleReloadTokenProvider.notifier).update((v) => v + 1);
}

void _resetScheduleSelectionState(dynamic ref) {
  ref.read(selectedSpecialistIdProvider.notifier).state = null;
  ref.read(restoredSpecialistSelectionProvider.notifier).state = false;
}

/// Смена филиала (пилюля в шапке) — перезагрузить расписание, главную, аналитику.
void invalidateAppDataForBranchChange(dynamic ref) {
  _resetScheduleSelectionState(ref);
  invalidateScheduleNetworkProviders(ref);
  ref.invalidate(statisticsProvider);
  ref.invalidate(todayRevenueMetricsProvider);
  ref.invalidate(analyticsSummaryProvider);
  ref.invalidate(currentWorkerIdProvider);
  refreshWorkerPermissions(ref);
  _bumpWorkScheduleReload(ref);
  invalidatePushHistoryCache(ref);
}

void invalidateAppDataForBranchChangeDeferred(dynamic ref) {
  if (_branchInvalidationScheduled) return;
  _branchInvalidationScheduled = true;
  SchedulerBinding.instance.addPostFrameCallback((_) {
    _branchInvalidationScheduled = false;
    if (!ref.mounted) return;
    invalidateAppDataForBranchChange(ref);
  });
}

/// Смена организации — сбросить филиал и все данные сессии.
void invalidateAppDataForOrganizationChange(dynamic ref) {
  ref.read(selectedBranchProvider.notifier).state = null;
  _resetScheduleSelectionState(ref);

  resetScheduleNetworkStateForSession(ref);
  invalidateScheduleNetworkProviders(ref);

  ref.invalidate(branchesProvider);
  ref.invalidate(accountProfileProvider);
  ref.invalidate(organizationSettingsProvider);
  ref.invalidate(statisticsProvider);
  ref.invalidate(todayRevenueMetricsProvider);
  ref.invalidate(analyticsSummaryProvider);
  ref.invalidate(currentWorkerIdProvider);
  ref.invalidate(widgetLinkUrlProvider);
  ref.invalidate(workerEntityLabelsProvider);
  refreshWorkerPermissions(ref);
  _bumpWorkScheduleReload(ref);
  invalidatePushHistoryCache(ref);
}

/// Слушает смену организации / филиала и сбрасывает зависимые провайдеры.
final appSessionContextListenerProvider = Provider<void>((ref) {
  ref.listen<int>(organizationIdProvider, (previous, next) {
    if (previous == null || previous <= 0 || next <= 0 || previous == next) {
      return;
    }
    invalidateAppDataForOrganizationChange(ref);
  });

  ref.listen<int>(currentBranchIdProvider, (previous, next) {
    if (previous == null || previous <= 0 || next <= 0 || previous == next) {
      return;
    }
    invalidateAppDataForBranchChangeDeferred(ref);
  });
});
