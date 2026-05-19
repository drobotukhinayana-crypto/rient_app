import 'package:freezed_annotation/freezed_annotation.dart';

part 'widget_links_api.freezed.dart';
part 'widget_links_api.g.dart';

@freezed
sealed class WidgetLinksApiResponse with _$WidgetLinksApiResponse {
  const factory WidgetLinksApiResponse({
    required int count,
    required String? next,
    required String? previous,
    required List<WidgetLinkApi> results,
  }) = _WidgetLinksApiResponse;

  factory WidgetLinksApiResponse.fromJson(Map<String, dynamic> json) =>
      _$WidgetLinksApiResponseFromJson(json);
}

@freezed
sealed class WidgetLinkApi with _$WidgetLinkApi {
  const factory WidgetLinkApi({
    required int id,
    required int type,
    required int? organization,
    required int? branch,
    required int? worker,
    required int? service,
    required String? token,
    @JsonKey(name: 'widget_url') required String widgetUrl,
  }) = _WidgetLinkApi;

  factory WidgetLinkApi.fromJson(Map<String, dynamic> json) =>
      _$WidgetLinkApiFromJson(json);
}
