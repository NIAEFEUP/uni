import 'package:json_annotation/json_annotation.dart';

part '../../../../../generated/controller/parsers/schedule/new_api/models/response_lecture_typology.g.dart';

@JsonSerializable(explicitToJson: true)
class ResponseLectureTypology {
  ResponseLectureTypology(this.acronym);
  factory ResponseLectureTypology.fromJson(Map<String, dynamic> json) =>
      _$ResponseLectureTypologyFromJson(json);

  String acronym;

  Map<String, dynamic> toJson() => _$ResponseLectureTypologyToJson(this);
}
