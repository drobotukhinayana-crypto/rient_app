// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionData _$SessionDataFromJson(Map<String, dynamic> json) => _SessionData(
  email: json['email'] as String,
  password: json['password'] as String,
  token: json['token'] as String?,
  refreshToken: json['refreshToken'] as String?,
);

Map<String, dynamic> _$SessionDataToJson(_SessionData instance) =>
    <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
      'token': instance.token,
      'refreshToken': instance.refreshToken,
    };
