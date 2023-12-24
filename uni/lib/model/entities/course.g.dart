// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Course _$CourseFromJson(Map<String, dynamic> json) => Course(
      id: json['cur_id'] as int,
      festId: json['fest_id'] as int? ?? 0,
      name: json['cur_nome'] as String?,
      abbreviation: json['abbreviation'] as String?,
      currYear: json['ano_curricular'] as String?,
      firstEnrollment: json['fest_a_lect_1_insc'] as int?,
      state: json['state'] as String?,
      faculty: json['inst_sigla'] as String?,
      finishedEcts: json['finishedEcts'] as num?,
      currentAverage: json['currentAverage'] as num?,
    );

Map<String, dynamic> _$CourseToJson(Course instance) => <String, dynamic>{
      'cur_id': instance.id,
      'fest_id': instance.festId,
      'cur_nome': instance.name,
      'abbreviation': instance.abbreviation,
      'ano_curricular': instance.currYear,
      'fest_a_lect_1_insc': instance.firstEnrollment,
      'inst_sigla': instance.faculty,
      'state': instance.state,
      'finishedEcts': instance.finishedEcts,
      'currentAverage': instance.currentAverage,
    };
