/// An event in the school calendar
class CalendarEvent {
  String name;
  String date;

  /// Creates an instance of the class [CalendarEvent]
  CalendarEvent(String name, String date) {
    this.name = name;
    this.date = date;
  }

  /// Converts the event into a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'date': date
    };
  }
}
