// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_unit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseUnit _$CourseUnitFromJson(Map<String, dynamic> json) => CourseUnit(
      id: json['id'] as int? ?? 0,
      code: json['code'] as String? ?? '',
      abbreviation: json['abbreviation'] as String,
      name: json['name'] as String,
      curricularYear: json['curricularYear'] as int?,
      occurrId: json['occurrId'] as int,
      semesterCode: json['semesterCode'] as String?,
      semesterName: json['semesterName'] as String?,
      type: json['type'] as String?,
      status: json['status'] as String?,
      grade: json['grade'] as String?,
      ectsGrade: json['ectsGrade'] as String?,
      result: json['result'] as String?,
      ects: json['ects'] as num?,
      schoolYear: json['schoolYear'] as String?,
    );

Map<String, dynamic> _$CourseUnitToJson(CourseUnit instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'abbreviation': instance.abbreviation,
      'name': instance.name,
      'curricularYear': instance.curricularYear,
      'occurrId': instance.occurrId,
      'semesterCode': instance.semesterCode,
      'semesterName': instance.semesterName,
      'type': instance.type,
      'status': instance.status,
      'grade': instance.grade,
      'ectsGrade': instance.ectsGrade,
      'result': instance.result,
      'ects': instance.ects,
      'schoolYear': instance.schoolYear,
    };
