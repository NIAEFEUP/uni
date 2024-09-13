// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../model/entities/lecture.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lecture _$LectureFromJson(Map<String, dynamic> json) => Lecture(
      json['subject'] as String,
      json['typeClass'] as String,
      const DateTimeConverter().fromJson(json['startTime'] as String),
      const DateTimeConverter().fromJson(json['endTime'] as String),
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
      'startTime': const DateTimeConverter().toJson(instance.startTime),
      'endTime': const DateTimeConverter().toJson(instance.endTime),
      'occurrId': instance.occurrId,
    };
