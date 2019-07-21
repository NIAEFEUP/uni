import 'package:app_feup/model/entities/BusStop.dart';
import 'package:app_feup/model/entities/Trip.dart';
import 'package:flutter/material.dart';
import '../Theme.dart';
import 'TripRow.dart';


class BusStopRow extends StatelessWidget{
  final BusStop busStop;

  BusStopRow({
    Key key,
    @required this.busStop
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Container(
          padding: EdgeInsets.only(bottom: 8.0),
          margin: EdgeInsets.only(top: 8.0),
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children : this.getTripRows(context, this.busStop.getTrips()),
          ),
        )
    );
  }

  List<Widget> getTripRows(context, nextTrips){
    List<Widget> rows = new List<Widget>();

    rows.add(
        new Container(
          child: Text(this.busStop.getStopCode().substring(5),style: Theme.of(context).textTheme.display1.apply(color: primaryColor)),
    ));

    for(int i = 0; i < nextTrips.length; i++){
      rows.add(this.createRowFromTrips(context, nextTrips[i]));
    }
    return rows;
  }

  Widget createRowFromTrips(context, Trip nextTrip) {
    return new TripRow(
            trip : nextTrip,
            stopCode: this.busStop.getStopCode()
        );
  }
}