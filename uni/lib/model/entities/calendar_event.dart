import 'package:json_annotation/json_annotation.dart';

part 'calendar_event.g.dart';

/// An event in the school calendar
@JsonSerializable()
class CalendarEvent {
  /// Creates an instance of the class [CalendarEvent]
  CalendarEvent(this.name, this.date);
  String name;
  String date;

  factory CalendarEvent.fromJson(Map<String, dynamic> json) =>
      _$CalendarEventFromJson(json);
  Map<String, dynamic> toJson() => _$CalendarEventToJson(this);
}
