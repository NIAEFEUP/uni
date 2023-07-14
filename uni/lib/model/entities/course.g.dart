// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Course _$CourseFromJson(Map<String, dynamic> json) => Course(
      id: json['id'] as int,
      festId: json['festId'] as int? ?? 0,
      name: json['name'] as String?,
      abbreviation: json['abbreviation'] as String?,
      currYear: json['currYear'] as String?,
      firstEnrollment: json['firstEnrollment'] as int?,
      state: json['state'] as String?,
      faculty: json['faculty'] as String?,
      finishedEcts: json['finishedEcts'] as num?,
      currentAverage: json['currentAverage'] as num?,
    );

Map<String, dynamic> _$CourseToJson(Course instance) => <String, dynamic>{
      'id': instance.id,
      'festId': instance.festId,
      'name': instance.name,
      'abbreviation': instance.abbreviation,
      'currYear': instance.currYear,
      'firstEnrollment': instance.firstEnrollment,
      'faculty': instance.faculty,
      'state': instance.state,
      'finishedEcts': instance.finishedEcts,
      'currentAverage': instance.currentAverage,
    };
