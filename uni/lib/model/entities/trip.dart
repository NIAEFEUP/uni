import 'package:json_annotation/json_annotation.dart';

part 'trip.g.dart';

/// Stores information about a bus trip.
@JsonSerializable()
class Trip {
  Trip({
    required this.line,
    required this.destination,
    required this.timeRemaining,
  });

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);
  final String line;
  final String destination;
  final int timeRemaining;
  Map<String, dynamic> toJson() => _$TripToJson(this);

  /// Compares the remaining time of two trips.
  int compare(Trip other) {
    return timeRemaining.compareTo(other.timeRemaining);
  }
}
