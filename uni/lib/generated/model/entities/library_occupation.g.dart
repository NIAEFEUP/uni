// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../model/entities/library_occupation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LibraryOccupation _$LibraryOccupationFromJson(Map<String, dynamic> json) =>
    LibraryOccupation(
      json['occupation'] as int,
      json['capacity'] as int,
    )..floors = (json['floors'] as List<dynamic>)
        .map((e) => FloorOccupation.fromJson(e as Map<String, dynamic>))
        .toList();

Map<String, dynamic> _$LibraryOccupationToJson(LibraryOccupation instance) =>
    <String, dynamic>{
      'occupation': instance.occupation,
      'capacity': instance.capacity,
      'floors': instance.floors,
    };

FloorOccupation _$FloorOccupationFromJson(Map<String, dynamic> json) =>
    FloorOccupation(
      json['number'] as int,
      json['occupation'] as int,
      json['capacity'] as int,
    );

Map<String, dynamic> _$FloorOccupationToJson(FloorOccupation instance) =>
    <String, dynamic>{
      'number': instance.number,
      'occupation': instance.occupation,
      'capacity': instance.capacity,
    };
