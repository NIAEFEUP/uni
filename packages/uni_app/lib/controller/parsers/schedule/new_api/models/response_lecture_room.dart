import 'package:json_annotation/json_annotation.dart';

part '../../../../../generated/controller/parsers/schedule/new_api/models/response_lecture_room.g.dart';

@JsonSerializable(explicitToJson: true)
class ResponseLectureRoom {
  ResponseLectureRoom(this.name);
  factory ResponseLectureRoom.fromJson(Map<String, dynamic> json) =>
      _$ResponseLectureRoomFromJson(json);

  String name;

  Map<String, dynamic> toJson() => _$ResponseLectureRoomToJson(this);
}
