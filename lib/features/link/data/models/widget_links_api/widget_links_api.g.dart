// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'widget_links_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WidgetLinksApiResponse _$WidgetLinksApiResponseFromJson(
  Map<String, dynamic> json,
) => _WidgetLinksApiResponse(
  count: (json['count'] as num).toInt(),
  next: json['next'] as String?,
  previous: json['previous'] as String?,
  results: (json['results'] as List<dynamic>)
      .map((e) => WidgetLinkApi.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$WidgetLinksApiResponseToJson(
  _WidgetLinksApiResponse instance,
) => <String, dynamic>{
  'count': instance.count,
  'next': instance.next,
  'previous': instance.previous,
  'results': instance.results,
};

_WidgetLinkApi _$WidgetLinkApiFromJson(Map<String, dynamic> json) =>
    _WidgetLinkApi(
      id: (json['id'] as num).toInt(),
      type: (json['type'] as num).toInt(),
      organization: (json['organization'] as num?)?.toInt(),
      branch: (json['branch'] as num?)?.toInt(),
      worker: (json['worker'] as num?)?.toInt(),
      service: (json['service'] as num?)?.toInt(),
      token: json['token'] as String?,
      widgetUrl: json['widget_url'] as String,
    );

Map<String, dynamic> _$WidgetLinkApiToJson(_WidgetLinkApi instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'organization': instance.organization,
      'branch': instance.branch,
      'worker': instance.worker,
      'service': instance.service,
      'token': instance.token,
      'widget_url': instance.widgetUrl,
    };
