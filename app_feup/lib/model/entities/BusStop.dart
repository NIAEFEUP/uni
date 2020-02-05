import 'package:app_feup/model/entities/Trip.dart';
import 'package:flutter/material.dart';

import 'Bus.dart';

class BusStop{
  final String stopCode;
  final List<Bus> buses;
  bool favorited;
  List<Trip> trips;

  BusStop({@required this.stopCode, this.buses, this.favorited = false}) {
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

  @override
  int get hashCode => stopCode.hashCode;

  @override
  bool operator ==(other) {
    return other is BusStop && this.stopCode == other.stopCode;
  }
}