import 'package:uni/model/entities/trip.dart';

/// Stores information about a bus stop.
class BusStopData {
  final Set<String> configuredBuses;
  bool favorited;
  List<Trip> trips;

  BusStopData(
      {required this.configuredBuses,
      this.favorited = false,
      this.trips = const []});
}
