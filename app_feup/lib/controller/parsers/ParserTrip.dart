import 'dart:async';
import 'package:app_feup/model/entities/Trip.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Trip>> parseTrips(http.Response response) async {
  List<Trip> tripList = new List();

  var json = jsonDecode(response.body);

  for (var TripKey in json) {
    var trip = TripKey['Value'];
    String line = trip[0];
    String destination = trip[1];
    int timeRemaining = int.parse(trip[2]);
    Trip newTrip = Trip(line:line, destination:destination, timeRemaining:timeRemaining);
    newTrip.printTrip();
    tripList.add(newTrip);
  }

  tripList.sort((a, b) => a.compare(b));
  return tripList;
}
