// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workers_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkersApiResponse _$WorkersApiResponseFromJson(Map<String, dynamic> json) =>
    _WorkersApiResponse(
      count: (json['count'] as num).toInt(),
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>)
          .map((e) => WorkerApi.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WorkersApiResponseToJson(_WorkersApiResponse instance) =>
    <String, dynamic>{
      'count': instance.count,
      'next': instance.next,
      'previous': instance.previous,
      'results': instance.results,
    };

_WorkerApi _$WorkerApiFromJson(Map<String, dynamic> json) => _WorkerApi(
  id: (json['id'] as num).toInt(),
  firstName: json['first_name'] as String?,
  lastName: json['last_name'] as String?,
  specialization: json['specialization'] as String?,
  picture: json['picture'] as String?,
  pictureThumbnail: json['picture_thumbnail'] as String?,
);

Map<String, dynamic> _$WorkerApiToJson(_WorkerApi instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'specialization': instance.specialization,
      'picture': instance.picture,
      'picture_thumbnail': instance.pictureThumbnail,
    };
