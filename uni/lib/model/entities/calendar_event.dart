import 'package:json_annotation/json_annotation.dart';

part '../../generated/model/entities/calendar_event.g.dart';

/// An event in the school calendar
@JsonSerializable()
class CalendarEvent {
  CalendarEvent(this.name, this.date);
  factory CalendarEvent.fromJson(Map<String, dynamic> json) =>
      _$CalendarEventFromJson(json);

  /// Creates an instance of the class [CalendarEvent]
  ///
  String name;
  String date;
  Map<String, dynamic> toJson() => _$CalendarEventToJson(this);
}
