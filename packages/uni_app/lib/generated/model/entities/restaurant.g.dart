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
      meals: (json['meals'] as List<dynamic>)
          .map((e) => Meal.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RestaurantToJson(Restaurant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'namePt': instance.namePt,
      'nameEn': instance.nameEn,
      'period': instance.period,
      'ref': instance.reference,
      'meals':
          instance.meals.map((k, e) => MapEntry(_$DayOfWeekEnumMap[k]!, e)),
    };

const _$DayOfWeekEnumMap = {
  DayOfWeek.monday: 'monday',
  DayOfWeek.tuesday: 'tuesday',
  DayOfWeek.wednesday: 'wednesday',
  DayOfWeek.thursday: 'thursday',
  DayOfWeek.friday: 'friday',
  DayOfWeek.saturday: 'saturday',
  DayOfWeek.sunday: 'sunday',
};
