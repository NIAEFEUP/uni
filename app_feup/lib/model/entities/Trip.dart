import 'dart:convert';

class Trip{
  String line;
  String destination;
  int timeRemaining;

  Trip({this.line, this.destination, this.timeRemaining});

  Map<String, dynamic> toMap() {
    return {
      'line': line,
      'destination': destination,
      'timeRemaining': timeRemaining
    };
  }

  void printTrip()
  {
    print('$line ($destination) - $timeRemaining');
  }

  String getTrip()
  {
    return '$line ($destination) - $timeRemaining';
  }

  int compare(Trip other) {
    return (timeRemaining.compareTo(other.timeRemaining));
  }
}