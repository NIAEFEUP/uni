// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../../controller/parsers/schedule/new_api/models/response_lecture_unit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseLectureUnit _$ResponseLectureUnitFromJson(Map<String, dynamic> json) =>
    ResponseLectureUnit(
      json['acronym'] as String,
      json['name'] as String,
      (json['sigarra_id'] as num).toInt(),
    );

Map<String, dynamic> _$ResponseLectureUnitToJson(
        ResponseLectureUnit instance) =>
    <String, dynamic>{
      'acronym': instance.acronym,
      'name': instance.name,
      'sigarra_id': instance.sigarraId,
    };
