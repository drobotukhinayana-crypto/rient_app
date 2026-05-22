// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_history_count.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PushHistoryCount _$PushHistoryCountFromJson(Map<String, dynamic> json) =>
    _PushHistoryCount(
      total: (json['total'] as num).toInt(),
      unread: (json['unread'] as num).toInt(),
    );

Map<String, dynamic> _$PushHistoryCountToJson(_PushHistoryCount instance) =>
    <String, dynamic>{'total': instance.total, 'unread': instance.unread};
