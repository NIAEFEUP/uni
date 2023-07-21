import 'package:uni/model/entities/trip.dart';

/// Stores information about a bus stop.
class BusStopData {
  BusStopData(
      {required this.configuredBuses,
      this.favorited = false,
      this.trips = const [],});
  final Set<String> configuredBuses;
  bool favorited;
  List<Trip> trips;
}
