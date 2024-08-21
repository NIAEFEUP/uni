import 'package:json_annotation/json_annotation.dart';

part '../../../../../generated/controller/parsers/schedule/new_api/models/response_lecture_unit.g.dart';

@JsonSerializable(explicitToJson: true)
class ResponseLectureUnit {
  ResponseLectureUnit(this.acronym, this.sigarraId);
  factory ResponseLectureUnit.fromJson(Map<String, dynamic> json) =>
      _$ResponseLectureUnitFromJson(json);

  String acronym;
  @JsonKey(name: 'sigarra_id')
  int sigarraId;

  Map<String, dynamic> toJson() => _$ResponseLectureUnitToJson(this);
}
