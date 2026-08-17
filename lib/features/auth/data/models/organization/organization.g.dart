// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Organization _$OrganizationFromJson(Map<String, dynamic> json) =>
    _Organization(
      id: (json['id'] as num).toInt(),
      slug: json['slug'] as String?,
      name: json['name'] as String?,
      brand: json['brand'] as String?,
      logo: json['logotype_thumbnail'] as String?,
      isBlocked: json['is_blocked'] as bool? ?? false,
    );

Map<String, dynamic> _$OrganizationToJson(_Organization instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slug': instance.slug,
      'name': instance.name,
      'brand': instance.brand,
      'logotype_thumbnail': instance.logo,
      'is_blocked': instance.isBlocked,
    };
