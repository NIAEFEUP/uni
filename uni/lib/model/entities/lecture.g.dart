// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lecture.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lecture _$LectureFromJson(Map<String, dynamic> json) => Lecture(
      json['subject'] as String,
      json['typeClass'] as String,
      DateTime.parse(json['startTime'] as String),
      DateTime.parse(json['endTime'] as String),
      json['blocks'] as int,
      json['room'] as String,
      json['teacher'] as String,
      json['classNumber'] as String,
      json['occurrId'] as int,
    );

Map<String, dynamic> _$LectureToJson(Lecture instance) => <String, dynamic>{
      'subject': instance.subject,
      'typeClass': instance.typeClass,
      'room': instance.room,
      'teacher': instance.teacher,
      'classNumber': instance.classNumber,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'blocks': instance.blocks,
      'occurrId': instance.occurrId,
    };
