// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../model/entities/course_units/course_unit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseUnit _$CourseUnitFromJson(Map<String, dynamic> json) => CourseUnit(
      abbreviation: json['ucurr_sigla'] as String,
      name: json['ucurr_nome'] as String,
      occurrId: json['ocorr_id'] as int?,
      id: json['ucurr_id'] as int? ?? 0,
      code: json['ucurr_codigo'] as String? ?? '',
      curricularYear: json['ano'] as int?,
      semesterCode: json['per_codigo'] as String?,
      semesterName: json['per_nome'] as String?,
      type: json['tipo'] as String?,
      status: json['estado'] as String?,
      grade: json['resultado_melhor'] as String?,
      ectsGrade: json['resultado_ects'] as String?,
      result: json['resultado_insc'] as String?,
      ects: json['creditos_ects'] as num?,
      schoolYear: json['schoolYear'] as String?,
    );

Map<String, dynamic> _$CourseUnitToJson(CourseUnit instance) =>
    <String, dynamic>{
      'ucurr_id': instance.id,
      'ucurr_codigo': instance.code,
      'ucurr_sigla': instance.abbreviation,
      'ucurr_nome': instance.name,
      'ano': instance.curricularYear,
      'ocorr_id': instance.occurrId,
      'per_codigo': instance.semesterCode,
      'per_nome': instance.semesterName,
      'tipo': instance.type,
      'estado': instance.status,
      'resultado_melhor': instance.grade,
      'resultado_ects': instance.ectsGrade,
      'resultado_insc': instance.result,
      'creditos_ects': instance.ects,
      'schoolYear': instance.schoolYear,
    };
