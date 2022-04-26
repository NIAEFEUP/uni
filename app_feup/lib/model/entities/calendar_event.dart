/// An event in the school calendar
class CalendarEvent {
  String name;
  List<DateTime> dates;

  /// Creates an instance of the class [CalendarEvent]
  CalendarEvent(String name, List<DateTime> dates) {
    this.name = name;
    this.dates = dates;
  }

  /// Converts the event into a map
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'name': name,
      'startDate': 0,
      'endDate': 0
    };
    if (dates.isNotEmpty) {
      map['startDate'] = dates[0].millisecondsSinceEpoch;
    }
    if (dates.length > 1) {
      map['endDate'] = dates[1].millisecondsSinceEpoch;
    }
    return map;
  }
}
