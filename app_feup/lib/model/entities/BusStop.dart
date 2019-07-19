import 'package:app_feup/model/entities/Trip.dart';

class BusStop{
  String stopCode;

  List<Trip> trips;

  BusStop.secConstructor(String stopCode){
    this.stopCode =  stopCode;

    trips = new List();
  }

  void newTrips(List<Trip> trips){
    this.trips = trips;
  }

  Map<String, dynamic> toMap() {
    return {
      'stopCode': stopCode,
    };
  }

  String getStopCode(){
    return stopCode;
  }

  List<Trip> getTrips(){
    return trips;
  }
}