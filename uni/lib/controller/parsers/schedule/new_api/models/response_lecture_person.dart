import 'package:json_annotation/json_annotation.dart';

part '../../../../../generated/controller/parsers/schedule/new_api/models/response_lecture_person.g.dart';

@JsonSerializable(explicitToJson: true)
class ResponseLecturePerson {
  ResponseLecturePerson(this.acronym);
  factory ResponseLecturePerson.fromJson(Map<String, dynamic> json) =>
      _$ResponseLecturePersonFromJson(json);

  String acronym;

  Map<String, dynamic> toJson() => _$ResponseLecturePersonToJson(this);
}
