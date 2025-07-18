// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../model/entities/floor_occupation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FloorOccupation _$FloorOccupationFromJson(Map<String, dynamic> json) =>
    FloorOccupation(
      (json['number'] as num).toInt(),
      (json['occupation'] as num).toInt(),
      (json['capacity'] as num).toInt(),
    );

Map<String, dynamic> _$FloorOccupationToJson(FloorOccupation instance) =>
    <String, dynamic>{
      'number': instance.number,
      'occupation': instance.occupation,
      'capacity': instance.capacity,
    };
