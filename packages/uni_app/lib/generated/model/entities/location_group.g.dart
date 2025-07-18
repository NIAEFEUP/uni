// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../model/entities/location_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationGroup _$LocationGroupFromJson(Map<String, dynamic> json) =>
    LocationGroup(
      LatLng.fromJson(json['latlng'] as Map<String, dynamic>),
      isFloorless: json['isFloorless'] as bool? ?? false,
      id: (json['id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LocationGroupToJson(LocationGroup instance) =>
    <String, dynamic>{
      'isFloorless': instance.isFloorless,
      'latlng': instance.latlng,
      'id': instance.id,
    };
