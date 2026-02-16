// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branches_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BranchesMember _$BranchesMemberFromJson(Map<String, dynamic> json) =>
    _BranchesMember(
      role: _roleFromJson((json['role'] as num).toInt()),
      branches: (json['branches'] as List<dynamic>)
          .map((e) => Branch.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BranchesMemberToJson(_BranchesMember instance) =>
    <String, dynamic>{
      'role': _roleToJson(instance.role),
      'branches': instance.branches,
    };
