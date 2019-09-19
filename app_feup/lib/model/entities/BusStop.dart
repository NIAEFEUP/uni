import 'package:app_feup/model/entities/Trip.dart';

import 'Bus.dart';

class BusStop{
  String stopCode;
  List<Bus> buses;
  List<Trip> trips;

  BusStop(this.stopCode, this.buses) {
    trips = new List();
  }

  @override
  String toString() => this.stopCode;

  void newTrips(List<Trip> trips){
    this.trips = trips;
  }

  Map<String, dynamic> toMap() {
    return {
      'stopCode': stopCode,
    };
  }
}