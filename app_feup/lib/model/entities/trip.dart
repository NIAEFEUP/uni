import 'package:logger/logger.dart';

class Trip {
  final String line;
  final String destination;
  final int timeRemaining;

  Trip({this.line, this.destination, this.timeRemaining});

  Map<String, dynamic> toMap() {
    return {
      'line': line,
      'destination': destination,
      'timeRemaining': timeRemaining
    };
  }

  void printTrip() {
    Logger().i('$line ($destination) - $timeRemaining');
  }

  @override
  String toString() {
    return '$line ($destination) - $timeRemaining';
  }

  int compare(Trip other) {
    return (timeRemaining.compareTo(other.timeRemaining));
  }
}
