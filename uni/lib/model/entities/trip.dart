/// Stores information about a bus trip.
class Trip {
  Trip({
    required this.line,
    required this.destination,
    required this.timeRemaining,
  });
  final String line;
  final String destination;
  final int timeRemaining;

  /// Converts this trip to a map.
  Map<String, dynamic> toMap() {
    return {
      'line': line,
      'destination': destination,
      'timeRemaining': timeRemaining,
    };
  }

  /// Compares the remaining time of two trips.
  int compare(Trip other) {
    return timeRemaining.compareTo(other.timeRemaining);
  }
}
