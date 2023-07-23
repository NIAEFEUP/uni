import 'package:json_annotation/json_annotation.dart';
import 'package:uni/model/entities/trip.dart';

part 'bus_stop.g.dart';

/// Stores information about a bus stop.
@JsonSerializable()
class BusStopData {
  final Set<String> configuredBuses;
  bool favorited;
  List<Trip> trips;

  BusStopData(
      {required this.configuredBuses,
      this.favorited = false,
      this.trips = const []});

  factory BusStopData.fromJson(Map<String, dynamic> json) =>
      _$BusStopDataFromJson(json);
  Map<String, dynamic> toJson() => _$BusStopDataToJson(this);
}
