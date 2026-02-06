import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rient_app/features/auth/data/models/organization.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';

part 'organization_member.freezed.dart';
part 'organization_member.g.dart';

typedef OrganizationMembers = List<OrganizationMember>;

@freezed
sealed class OrganizationMember with _$OrganizationMember {
  const factory OrganizationMember({
    @JsonKey(fromJson: _roleFromJson, toJson: _roleToJson)
    required UserRole role,
    required Organization organization,
  }) = _OrganizationMember;

  factory OrganizationMember.fromJson(Map<String, dynamic> json) =>
      _$OrganizationMemberFromJson(json);
}

UserRole _roleFromJson(int v) => UserRole.fromInt(v);
int _roleToJson(UserRole r) => r.value;
