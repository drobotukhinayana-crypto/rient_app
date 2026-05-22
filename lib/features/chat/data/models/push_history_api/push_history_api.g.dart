// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_history_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PushHistoryApiResponse _$PushHistoryApiResponseFromJson(
  Map<String, dynamic> json,
) => _PushHistoryApiResponse(
  count: (json['count'] as num).toInt(),
  next: json['next'] as String?,
  previous: json['previous'] as String?,
  results: (json['results'] as List<dynamic>)
      .map((e) => PushHistoryItemApi.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PushHistoryApiResponseToJson(
  _PushHistoryApiResponse instance,
) => <String, dynamic>{
  'count': instance.count,
  'next': instance.next,
  'previous': instance.previous,
  'results': instance.results,
};

_PushHistoryItemApi _$PushHistoryItemApiFromJson(Map<String, dynamic> json) =>
    _PushHistoryItemApi(
      id: (json['id'] as num).toInt(),
      type: json['type'] as String?,
      title: json['title'] as String?,
      body: json['body'] as String?,
      payload: json['payload'] as Map<String, dynamic>?,
      status: json['status'] as String?,
      error: json['error'] as String?,
      appointment: (json['appointment'] as num?)?.toInt(),
      branch: (json['branch'] as num?)?.toInt(),
      isRead: json['is_read'] as bool,
      readAt: json['read_at'] as String?,
      sentAt: json['sent_at'] as String?,
      reportDate: json['report_date'] as String?,
      deliveredDevicesCount: (json['delivered_devices_count'] as num?)?.toInt(),
      failedDevicesCount: (json['failed_devices_count'] as num?)?.toInt(),
      created: json['created'] as String?,
    );

Map<String, dynamic> _$PushHistoryItemApiToJson(_PushHistoryItemApi instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'title': instance.title,
      'body': instance.body,
      'payload': instance.payload,
      'status': instance.status,
      'error': instance.error,
      'appointment': instance.appointment,
      'branch': instance.branch,
      'is_read': instance.isRead,
      'read_at': instance.readAt,
      'sent_at': instance.sentAt,
      'report_date': instance.reportDate,
      'delivered_devices_count': instance.deliveredDevicesCount,
      'failed_devices_count': instance.failedDevicesCount,
      'created': instance.created,
    };
