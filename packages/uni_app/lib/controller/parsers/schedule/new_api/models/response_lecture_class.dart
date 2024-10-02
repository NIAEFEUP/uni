import 'package:json_annotation/json_annotation.dart';

part '../../../../../generated/controller/parsers/schedule/new_api/models/response_lecture_class.g.dart';

@JsonSerializable(explicitToJson: true)
class ResponseLectureClass {
  ResponseLectureClass(this.acronym);
  factory ResponseLectureClass.fromJson(Map<String, dynamic> json) =>
      _$ResponseLectureClassFromJson(json);

  String acronym;

  Map<String, dynamic> toJson() => _$ResponseLectureClassToJson(this);
}
