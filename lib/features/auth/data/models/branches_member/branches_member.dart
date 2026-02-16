import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rient_app/features/auth/data/models/branches/branches.dart';
import 'package:rient_app/features/auth/data/models/user_role/user_role.dart';

part 'branches_member.freezed.dart';
part 'branches_member.g.dart';

typedef BranchesMembers = List<BranchesMember>;

@freezed
sealed class BranchesMember with _$BranchesMember {
  const factory BranchesMember({
    @JsonKey(fromJson: _roleFromJson, toJson: _roleToJson)
    required UserRole role,
    required Branches branches,
  }) = _BranchesMember;

  factory BranchesMember.fromJson(Map<String, dynamic> json) =>
      _$BranchesMemberFromJson(json);
}

UserRole _roleFromJson(int v) => UserRole.fromInt(v);
int _roleToJson(UserRole r) => r.value;
