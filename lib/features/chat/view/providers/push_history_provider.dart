import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rient_app/features/chat/data/models/push_history_api/push_history_api.dart';
import 'package:rient_app/features/chat/data/models/push_history_count/push_history_count.dart';
import 'package:rient_app/features/chat/service/mobile_push_service.dart';
import 'package:rient_app/features/home/view/providers/branches_provider.dart';

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
  final service = ref.watch(mobilePushServiceProvider);
  return service.getHistoryCount();
});

final pushHistoryListProvider =
    FutureProvider.family<PushHistoryApiResponse, PushHistoryListQuery>((
  ref,
  query,
) async {
  final int resolvedBranchId =
      query.branchId ?? ref.watch(currentBranchIdProvider);
  final service = ref.watch(mobilePushServiceProvider);
  return service.getHistory(
    isRead: query.isRead,
    branchId: resolvedBranchId > 0 ? resolvedBranchId : null,
    datetimeGte: query.datetimeGte,
    datetimeLte: query.datetimeLte,
    page: query.page,
    pageSize: query.pageSize,
  );
});

void invalidatePushHistory(WidgetRef ref) {
  ref.invalidate(pushHistoryCountProvider);
  ref.invalidate(pushHistoryListProvider);
}
