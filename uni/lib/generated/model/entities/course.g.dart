// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../model/entities/course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$CourseToJson(Course instance) => <String, dynamic>{
      'cur_id': instance.id,
      'fest_id ': instance.festId,
      'cur_nome': instance.name,
      'abbreviation': instance.abbreviation,
      'ano_curricular': instance.currYear,
      'fest_a_lect_1_insc': instance.firstEnrollment,
      'inst_sigla': instance.faculty,
      'state': instance.state,
      'finishedEcts': instance.finishedEcts,
      'currentAverage': instance.currentAverage,
    };
