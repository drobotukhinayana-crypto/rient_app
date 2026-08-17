import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization.freezed.dart';
part 'organization.g.dart';

typedef Organizations = List<Organization>;

@freezed
sealed class Organization with _$Organization {
  const factory Organization({
    required int id,
    required String? slug,
    required String? name,
    required String? brand,
    @JsonKey(name: 'logotype_thumbnail') required String? logo,
    @JsonKey(name: 'is_blocked') @Default(false) bool isBlocked,
  }) = _Organization;

  factory Organization.fromJson(Map<String, dynamic> json) =>
      _$OrganizationFromJson(json);
}
