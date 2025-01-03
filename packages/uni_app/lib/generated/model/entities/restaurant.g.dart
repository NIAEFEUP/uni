// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../model/entities/restaurant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Restaurant _$RestaurantFromJson(Map<String, dynamic> json) => Restaurant(
      (json['id'] as num?)?.toInt(),
      json['namePt'] as String,
      json['nameEn'] as String,
      json['period'] as String,
      json['ref'] as String,
      const _MealRelToManyConverter()
          .fromJson(json['meals'] as List<Map<String, dynamic>>?),
    )..uniqueId = (json['uniqueId'] as num?)?.toInt();

Map<String, dynamic> _$RestaurantToJson(Restaurant instance) =>
    <String, dynamic>{
      'uniqueId': instance.uniqueId,
      'id': instance.id,
      'namePt': instance.namePt,
      'nameEn': instance.nameEn,
      'period': instance.period,
      'ref': instance.reference,
      'meals': const _MealRelToManyConverter().toJson(instance.meals),
    };
