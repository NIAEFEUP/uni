// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meal _$MealFromJson(Map<String, dynamic> json) => Meal(
      json['type'] as String,
      json['name'] as String,
      $enumDecode(_$DayOfWeekEnumMap, json['dayOfWeek']),
      DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$MealToJson(Meal instance) => <String, dynamic>{
      'type': instance.type,
      'name': instance.name,
      'dayOfWeek': _$DayOfWeekEnumMap[instance.dayOfWeek]!,
      'date': instance.date.toIso8601String(),
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
