import 'package:intl/intl.dart';

/// An event in the school calendar
class CalendarEvent {
  /// Creates an instance of the class [CalendarEvent]
  CalendarEvent(this.name, this.date) {
    name = name;
    date = date;
  }
  String name;
  String date;

  /// Converts the event into a map
  Map<String, dynamic> toMap() {
    return {'name': name, 'date': date};
  }

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
    } catch (e) {
      return null;
    }
  }
}
