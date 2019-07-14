import 'dart:async';
import 'package:app_feup/model/entities/Trip.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Trip>> parseTrips(http.Response response) async {
  List<Trip> tripList = new List();

  var json = jsonDecode(response.body);

  var trips = json['Value'];

  for (var trip in trips) {
    String line = trip[0];
    String destination = trip[1];
    int timeRemaining = trip[2];
    print(line);
    tripList.add(Trip(line: line, destination: destination, timeRemaining: timeRemaining));
  }

  tripList.sort((a, b) => a.compare(b));

  return tripList;
}