import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_history_count.freezed.dart';
part 'push_history_count.g.dart';

@freezed
sealed class PushHistoryCount with _$PushHistoryCount {
  const factory PushHistoryCount({
    required int total,
    required int unread,
  }) = _PushHistoryCount;

  factory PushHistoryCount.fromJson(Map<String, dynamic> json) =>
      _$PushHistoryCountFromJson(json);
}
