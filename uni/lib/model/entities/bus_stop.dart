/// Stores information about a bus stop.
class BusStopData {
  final Set<String> configuredBuses;
  bool favorited;

  BusStopData({required this.configuredBuses, this.favorited = false});
}
