import 'package:app_feup/model/entities/BusStop.dart';
import 'package:app_feup/model/entities/Trip.dart';
import 'package:flutter/material.dart';
import '../Theme.dart';
import 'RowContainer.dart';
import 'TripRow.dart';
import 'dart:math' as math;


class BusStopRow extends StatelessWidget {
  final BusStop busStop;

  BusStopRow({
    Key key,
    @required this.busStop
  }) :super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.all(10),
      child: new RowContainer(
          child: new Container(
            padding: EdgeInsets.all(10),
            child: new Row(
              children: this.getTrips(context, this.busStop.getTrips()),
            ),
          ),
      )
    );
  }

  List<Widget> getTrips(context, nextTrips) {
    List<Widget> row = new List<Widget>();

    row.add(
        new Container(
          alignment: Alignment.center,
          child: new Transform (
            child: Text(this.busStop.getStopCode().substring(5), style: Theme
                .of(context)
                .textTheme
                .display1
                .apply(color: primaryColor)),
            transform: new Matrix4.identity()
              ..rotateZ(-math.pi / 2),
          ),
        )
    );

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
                        trip: nextTrips[i],
                        stopCode: this.busStop.getStopCode())
                  )
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