import 'package:intl/intl.dart';
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

  DateTime? get parsedStartDate {
    final splitDate = date.split(' ');
    final month = splitDate.firstWhere(
      (element) =>
          DateFormat.MMMM('pt').dateSymbols.MONTHS.contains(element) ||
          element == 'TBD',
    );

    try {
      return DateFormat('dd MMMM yyyy', 'pt')
          .parse('${splitDate[0]} $month ${splitDate.last}');
    } catch (_) {
      return null;
    }
  }
}
