// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../model/entities/library_occupation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LibraryOccupation _$LibraryOccupationFromJson(Map<String, dynamic> json) =>
    LibraryOccupation(
        (json['occupation'] as num).toInt(),
        (json['capacity'] as num).toInt(),
      )
      ..floors =
          (json['floors'] as List<dynamic>)
              .map((e) => FloorOccupation.fromJson(e as Map<String, dynamic>))
              .toList();

Map<String, dynamic> _$LibraryOccupationToJson(LibraryOccupation instance) =>
    <String, dynamic>{
      'occupation': instance.occupation,
      'capacity': instance.capacity,
      'floors': instance.floors,
    };
