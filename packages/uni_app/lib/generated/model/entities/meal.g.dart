// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../model/entities/meal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meal _$MealFromJson(Map<String, dynamic> json) => Meal(
      json['type'] as String,
      json['namePt'] as String,
      json['nameEn'] as String,
      const DateTimeConverter().fromJson(json['date'] as String),
      dbDayOfWeek: (json['dbDayOfWeek'] as num?)?.toInt(),
    )..id = (json['id'] as num?)?.toInt();

Map<String, dynamic> _$MealToJson(Meal instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'namePt': instance.namePt,
      'nameEn': instance.nameEn,
      'dbDayOfWeek': instance.dbDayOfWeek,
      'date': const DateTimeConverter().toJson(instance.date),
    };
