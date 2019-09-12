import 'package:app_feup/model/entities/BusStop.dart';
import 'package:app_feup/model/entities/Trip.dart';
import 'package:flutter/material.dart';
import '../Theme.dart';
import 'RowContainer.dart';
import 'TripRow.dart';
import 'dart:math' as math;


class BusStopRow extends StatelessWidget {
  final String stopCode;
  final List<Trip> nextTrips;
  var stopCodeShow;

  BusStopRow({
    Key key,
    @required this.stopCode,
    this.stopCodeShow = true,
    @required this.nextTrips,
  }) :super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.only(top: 12.0),
      child: new RowContainer(
          child: new Container(
            padding: EdgeInsets.all(4.0),
            child: new Row(
              children: this.getTrips(context),
            ),
          ),
      )
    );
  }

  List<Widget> getTrips(context) {
    List<Widget> row = new List<Widget>();

    if(stopCodeShow){
      row.add(
          new Container(
            padding: EdgeInsets.only(left: 4.0),
            alignment: Alignment.center,
            child: new Transform (
              child: Text(this.stopCode.substring(5), style: Theme
                  .of(context)
                  .textTheme
                  .display1
                  .apply(color: primaryColor)),
              transform: new Matrix4.identity()
                ..rotateZ(-math.pi / 2),
            ),
          )
      );
    }

    if (nextTrips.length == 0) {
      row.add(
          new Container(
            child: Text("No planned arrivals at the moment", style: Theme.of(context).textTheme.display1.apply(color: Colors.black)),
          )
      );
    } else {
      List<Widget> tripRows = new List<Widget>();

      for (int i = 0; i < nextTrips.length; i++) {
        tripRows.add(
                  new Container(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      child: new TripRow(
                        trip: nextTrips[i]
                  ))
        );
      }

      row.add(
           new Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: tripRows
           )
      );
    }

    return row;
  }
}