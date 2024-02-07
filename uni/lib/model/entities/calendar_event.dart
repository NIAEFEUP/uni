import 'package:intl/intl.dart';

/// An event in the school calendar
class CalendarEvent {
  /// Creates an instance of the class [CalendarEvent]
  CalendarEvent(this.name, this.date, {this.closeDate}) {
    name = name;
    date = date;
    closeDate = getDateTime();
  }
  String name;
  String date;
  DateTime? closeDate;

  /// Converts the event into a map
  Map<String, dynamic> toMap() {
    return {'name': name, 'date': date};
  }

  DateTime? getDateTime() {
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
