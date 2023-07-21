/// An event in the school calendar
class CalendarEvent {
  /// Creates an instance of the class [CalendarEvent]
  CalendarEvent(this.name, this.date);
  String name;
  String date;

  /// Converts the event into a map
  Map<String, dynamic> toMap() {
    return {'name': name, 'date': date};
  }
}
