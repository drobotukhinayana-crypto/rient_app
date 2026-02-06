// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrganizationMember _$OrganizationMemberFromJson(Map<String, dynamic> json) =>
    _OrganizationMember(
      role: _roleFromJson((json['role'] as num).toInt()),
      organization: Organization.fromJson(
        json['organization'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$OrganizationMemberToJson(_OrganizationMember instance) =>
    <String, dynamic>{
      'role': _roleToJson(instance.role),
      'organization': instance.organization,
    };
