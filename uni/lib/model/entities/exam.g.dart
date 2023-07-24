// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Exam _$ExamFromJson(Map<String, dynamic> json) => Exam(
      json['id'] as String,
      const DateTimeConverter().fromJson(json['begin'] as String),
      const DateTimeConverter().fromJson(json['end'] as String),
      json['subject'] as String,
      (json['rooms'] as List<dynamic>).map((e) => e as String).toList(),
      json['type'] as String,
      json['faculty'] as String,
    );

Map<String, dynamic> _$ExamToJson(Exam instance) => <String, dynamic>{
      'begin': const DateTimeConverter().toJson(instance.begin),
      'end': const DateTimeConverter().toJson(instance.end),
      'id': instance.id,
      'subject': instance.subject,
      'rooms': instance.rooms,
      'type': instance.type,
      'faculty': instance.faculty,
    };
