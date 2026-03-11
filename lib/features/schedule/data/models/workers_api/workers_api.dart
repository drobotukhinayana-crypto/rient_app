// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'workers_api.freezed.dart';
part 'workers_api.g.dart';

@freezed
sealed class WorkersApiResponse with _$WorkersApiResponse {
  const factory WorkersApiResponse({
    required int count,
    required String? next,
    required String? previous,
    required List<WorkerApi> results,
  }) = _WorkersApiResponse;

  factory WorkersApiResponse.fromJson(Map<String, dynamic> json) =>
      _$WorkersApiResponseFromJson(json);
}

@freezed
sealed class WorkerApi with _$WorkerApi {
  const factory WorkerApi({
    required int id,
    @JsonKey(name: 'first_name') required String? firstName,
    @JsonKey(name: 'last_name') required String? lastName,
    required String? specialization,
    required String? picture,
    @JsonKey(name: 'picture_thumbnail') required String? pictureThumbnail,
  }) = _WorkerApi;

  factory WorkerApi.fromJson(Map<String, dynamic> json) =>
      _$WorkerApiFromJson(json);
}
