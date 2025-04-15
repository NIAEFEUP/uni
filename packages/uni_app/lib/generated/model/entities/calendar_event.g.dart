// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../model/entities/calendar_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalendarEvent _$CalendarEventFromJson(Map<String, dynamic> json) =>
    CalendarEvent(
      json['name'] as String,
      json['date'] as String,
    )
      ..start =
          json['start'] == null ? null : DateTime.parse(json['start'] as String)
      ..finish = json['finish'] == null
          ? null
          : DateTime.parse(json['finish'] as String)
      ..id = (json['id'] as num?)?.toInt();

Map<String, dynamic> _$CalendarEventToJson(CalendarEvent instance) =>
    <String, dynamic>{
      'name': instance.name,
      'date': instance.date,
      'start': instance.start?.toIso8601String(),
      'finish': instance.finish?.toIso8601String(),
      'id': instance.id,
    };
