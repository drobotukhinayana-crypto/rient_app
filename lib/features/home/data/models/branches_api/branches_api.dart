import 'package:freezed_annotation/freezed_annotation.dart';

part 'branches_api.freezed.dart';
part 'branches_api.g.dart';

@freezed
sealed class BranchesApiResponse with _$BranchesApiResponse {
  const factory BranchesApiResponse({
    required int count,
    required String? next,
    required String? previous,
    required List<BranchApi> results,
  }) = _BranchesApiResponse;

  factory BranchesApiResponse.fromJson(Map<String, dynamic> json) =>
      _$BranchesApiResponseFromJson(json);
}

@freezed
sealed class BranchApi with _$BranchApi {
  const factory BranchApi({
    required int id,
    @JsonKey(name: 'is_main') required bool? isMain,
    required String? name,
    required String? country,
    required String? region,
    required String? city,
    required String? address,
    required Location? location,
    required String? timezone,
    required int? workspaces,
    required String? phone,
    required String? email,
    @JsonKey(name: 'schedule_patterns') required List<SchedulePattern>? schedulePatterns,
    @JsonKey(name: 'has_chat_settings') required bool? hasChatSettings,
    @JsonKey(name: 'is_blocked') required bool? isBlocked,
    @JsonKey(name: 'is_available') required bool? isAvailable,
    required bool? yandexable,
    @JsonKey(name: 'number_of_workers') required int? numberOfWorkers,
    @JsonKey(name: 'has_chat_push_settings') required bool? hasChatPushSettings,
  }) = _BranchApi;

  factory BranchApi.fromJson(Map<String, dynamic> json) =>
      _$BranchApiFromJson(json);
}

/// Минимальный филиал для оффлайн-старта (только id из локального кэша).
BranchApi offlineStubBranch({required int id, String? name}) => BranchApi(
      id: id,
      isMain: null,
      name: name,
      country: null,
      region: null,
      city: null,
      address: null,
      location: null,
      timezone: null,
      workspaces: null,
      phone: null,
      email: null,
      schedulePatterns: null,
      hasChatSettings: null,
      isBlocked: null,
      isAvailable: null,
      yandexable: null,
      numberOfWorkers: null,
      hasChatPushSettings: null,
    );

@freezed
sealed class Location with _$Location {
  const factory Location({required double lat, required double lon}) =
      _Location;

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
}

@freezed
sealed class SchedulePattern with _$SchedulePattern {
  const factory SchedulePattern({
    required int? id,
    required int? branch,
    required String? day,
    @JsonKey(name: 'time_start') required String? timeStart,
    @JsonKey(name: 'time_end') required String? timeEnd,
    required bool? active,
  }) = _SchedulePattern;

  factory SchedulePattern.fromJson(Map<String, dynamic> json) =>
      _$SchedulePatternFromJson(json);
}
