import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/auth/view/providers/organization_id_provider.dart';
import 'package:rient_app/features/chat/data/models/push_history_api/push_history_api.dart';
import 'package:rient_app/features/chat/data/models/push_history_count/push_history_count.dart';
import 'package:rient_app/features/chat/service/mobile_push_service.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';

bool isPushHistoryVisibleForBranch(PushHistoryItemApi item, int branchId) {
  if (branchId <= 0) return true;
  final itemBranch = item.branch;
  return itemBranch == null || itemBranch <= 0 || itemBranch == branchId;
}

PushHistoryApiResponse filterPushHistoryForBranch(
  PushHistoryApiResponse response,
  int branchId,
) {
  if (branchId <= 0) return response;
  final filtered = response.results
      .where((item) => isPushHistoryVisibleForBranch(item, branchId))
      .toList();
  return response.copyWith(results: filtered);
}

Future<int> _countFilteredPushHistoryItems({
  required MobilePushService service,
  required bool isRead,
  required int branchId,
}) async {
  var page = 1;
  var total = 0;
  while (true) {
    final response = await service.getHistory(
      isRead: isRead,
      page: page,
      pageSize: 100,
    );
    total += response.results
        .where((item) => isPushHistoryVisibleForBranch(item, branchId))
        .length;
    if (response.next == null || response.next!.isEmpty) break;
    page++;
  }
  return total;
}

Future<PushHistoryCount> _fetchPushHistoryCount(
  MobilePushService service,
  int branchId,
) async {
  if (branchId <= 0) {
    return service.getHistoryCount();
  }

  final unread = await _countFilteredPushHistoryItems(
    service: service,
    isRead: false,
    branchId: branchId,
  );
  final read = await _countFilteredPushHistoryItems(
    service: service,
    isRead: true,
    branchId: branchId,
  );
  return PushHistoryCount(total: unread + read, unread: unread);
}

class PushHistoryListQuery {
  const PushHistoryListQuery({
    required this.isRead,
    this.branchId,
    this.datetimeGte,
    this.datetimeLte,
    this.page = 1,
    this.pageSize = 20,
  });

  final bool isRead;
  final int? branchId;
  final DateTime? datetimeGte;
  final DateTime? datetimeLte;
  final int page;
  final int pageSize;

  PushHistoryListQuery copyWith({int? page}) {
    return PushHistoryListQuery(
      isRead: isRead,
      branchId: branchId,
      datetimeGte: datetimeGte,
      datetimeLte: datetimeLte,
      page: page ?? this.page,
      pageSize: pageSize,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PushHistoryListQuery &&
        other.isRead == isRead &&
        other.branchId == branchId &&
        other.datetimeGte == datetimeGte &&
        other.datetimeLte == datetimeLte &&
        other.page == page &&
        other.pageSize == pageSize;
  }

  @override
  int get hashCode => Object.hash(
        isRead,
        branchId,
        datetimeGte,
        datetimeLte,
        page,
        pageSize,
      );
}

final pushHistoryCountProvider = FutureProvider<PushHistoryCount>((ref) async {
  final organizationId = ref.watch(organizationIdProvider);
  if (organizationId <= 0) {
    return const PushHistoryCount(total: 0, unread: 0);
  }
  final branchId = ref.watch(currentBranchIdProvider);
  final service = ref.watch(mobilePushServiceProvider);
  return _fetchPushHistoryCount(service, branchId);
});

final pushHistoryListProvider =
    FutureProvider.family<PushHistoryApiResponse, PushHistoryListQuery>((
  ref,
  query,
) async {
  final organizationId = ref.watch(organizationIdProvider);
  if (organizationId <= 0) {
    return const PushHistoryApiResponse(
      count: 0,
      next: null,
      previous: null,
      results: [],
    );
  }
  final int resolvedBranchId =
      query.branchId ?? ref.watch(currentBranchIdProvider);
  final service = ref.watch(mobilePushServiceProvider);
  final response = await service.getHistory(
    isRead: query.isRead,
    datetimeGte: query.datetimeGte,
    datetimeLte: query.datetimeLte,
    page: query.page,
    pageSize: query.pageSize,
  );
  return filterPushHistoryForBranch(response, resolvedBranchId);
});

void invalidatePushHistory(WidgetRef ref) {
  invalidatePushHistoryCache(ref);
}

void invalidatePushHistoryCache(dynamic ref) {
  ref.invalidate(pushHistoryCountProvider);
  ref.invalidate(pushHistoryListProvider);
}
