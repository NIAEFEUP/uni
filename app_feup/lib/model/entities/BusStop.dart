import 'package:app_feup/model/entities/Trip.dart';

class BusStop{
  String id;

  List<Trip> trips;

  BusStop.secConstructor(String id){
    this.id =  id;

    trips = new List();
  }

  void newTrips(List<Trip> trips){
    this.trips = trips;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      //devo adicionar aqui as trips?
    };
  }

  @override
  String toString()
  {
    var result = '- $id :';

    for (Trip trip in trips){
      result += trip.getTrip();
    }

    result += '---';

    return result;
  }
}