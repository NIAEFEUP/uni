// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../../../../../../controller/parsers/schedule/new_api/models/response_lecture.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResponseLecture _$ResponseLectureFromJson(Map<String, dynamic> json) =>
    ResponseLecture(
      DateTime.parse(json['start'] as String),
      DateTime.parse(json['end'] as String),
      (json['ucs'] as List<dynamic>)
          .map((e) => ResponseLectureUnit.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['classes'] as List<dynamic>)
          .map((e) => ResponseLectureClass.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['persons'] as List<dynamic>)
          .map((e) => ResponseLecturePerson.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['rooms'] as List<dynamic>)
          .map((e) => ResponseLectureRoom.fromJson(e as Map<String, dynamic>))
          .toList(),
      ResponseLectureTypology.fromJson(
          json['typology'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ResponseLectureToJson(ResponseLecture instance) =>
    <String, dynamic>{
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'ucs': instance.units.map((e) => e.toJson()).toList(),
      'classes': instance.classes.map((e) => e.toJson()).toList(),
      'persons': instance.persons.map((e) => e.toJson()).toList(),
      'rooms': instance.rooms.map((e) => e.toJson()).toList(),
      'typology': instance.typology.toJson(),
    };
