import 'package:freezed_annotation/freezed_annotation.dart';

part 'branches.freezed.dart';
part 'branches.g.dart';

typedef Branches = List<Branch>;

@freezed
sealed class Branch with _$Branch {
  const factory Branch({
    required int id,
    required String? address,
    required String? city,
    required String? country,
    required String? email,
    @JsonKey(name: 'is_available') required bool isAvailable,
    @JsonKey(name: 'is_blocked') required bool isBlocked,
    required String? name,
    required String? phone,
    required String? region,
  }) = _Branch;

  factory Branch.fromJson(Map<String, dynamic> json) => _$BranchFromJson(json);
}
