import 'package:json_annotation/json_annotation.dart';
import 'package:uni/controller/parsers/schedule/new_api/models/response_lecture_class.dart';
import 'package:uni/controller/parsers/schedule/new_api/models/response_lecture_person.dart';
import 'package:uni/controller/parsers/schedule/new_api/models/response_lecture_room.dart';
import 'package:uni/controller/parsers/schedule/new_api/models/response_lecture_typology.dart';
import 'package:uni/controller/parsers/schedule/new_api/models/response_lecture_unit.dart';

part '../../../../../generated/controller/parsers/schedule/new_api/models/response_lecture.g.dart';

@JsonSerializable(explicitToJson: true)
class ResponseLecture {
  ResponseLecture(
    this.start,
    this.end,
    this.units,
    this.classes,
    this.persons,
    this.rooms,
    this.typology,
  );

  factory ResponseLecture.fromJson(Map<String, dynamic> json) =>
      _$ResponseLectureFromJson(json);

  DateTime start;
  DateTime end;
  @JsonKey(name: 'ucs')
  List<ResponseLectureUnit> units;
  List<ResponseLectureClass> classes;
  List<ResponseLecturePerson> persons;
  List<ResponseLectureRoom> rooms;
  ResponseLectureTypology typology;

  Map<String, dynamic> toJson() => _$ResponseLectureToJson(this);
}
