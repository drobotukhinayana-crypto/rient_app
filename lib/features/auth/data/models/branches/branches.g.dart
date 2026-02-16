// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branches.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Branch _$BranchFromJson(Map<String, dynamic> json) => _Branch(
  id: (json['id'] as num).toInt(),
  address: json['address'] as String?,
  city: json['city'] as String?,
  country: json['country'] as String?,
  email: json['email'] as String?,
  isAvailable: json['is_available'] as bool,
  isBlocked: json['is_blocked'] as bool,
  name: json['name'] as String?,
  phone: json['phone'] as String?,
  region: json['region'] as String?,
);

Map<String, dynamic> _$BranchToJson(_Branch instance) => <String, dynamic>{
  'id': instance.id,
  'address': instance.address,
  'city': instance.city,
  'country': instance.country,
  'email': instance.email,
  'is_available': instance.isAvailable,
  'is_blocked': instance.isBlocked,
  'name': instance.name,
  'phone': instance.phone,
  'region': instance.region,
};
