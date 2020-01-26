import 'package:app_feup/model/entities/BusStop.dart';
import 'package:flutter/material.dart';
import '../Theme.dart';
import 'TripRow.dart';

class BusStopRow extends StatelessWidget {
  final BusStop busStop;
  final stopCodeShow;
  final singleTrip;

  BusStopRow({
    Key key,
    @required this.busStop,
    this.singleTrip = false,
    this.stopCodeShow = true,
  }) :super(key: key);


  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: EdgeInsets.all(4.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: this.getTrips(context),
      ),
    );
  }

  List<Widget> getTrips(context) {
    List<Widget> row = new List<Widget>();

    if(stopCodeShow){
      row.add(stopCodeRotatedContainer(context));
    }

    if (busStop.trips.length < 1) {
      row.add(noTripsContainer(context));
    } else {
      List<Widget> tripRows = getTripRows();

      row.add(
          new Expanded(
              child: new Column(
                  children: tripRows
              )
          )
      );
    }

    return row;
  }

  Widget noTripsContainer(context) {
    return new Flexible(
      child: Text("Não há viagens planeadas de momento", style: Theme.of(context).textTheme.display1.apply(color: greyTextColor))
    );
  }

  Widget stopCodeRotatedContainer(context) {
    return new Container(
      padding: EdgeInsets.only(left: 4.0),
      child: new RotatedBox (
        child: Text(busStop.stopCode, style: Theme
            .of(context)
            .textTheme
            .display1
            .apply(color: primaryColor)),
        quarterTurns: 3,
      ),
    );
  }

  List<Widget> getTripRows() {
    List<Widget> tripRows = new List<Widget>();

    if (singleTrip) {
      tripRows.add(
          new Container(
              padding: EdgeInsets.all(12.0),
              child: new TripRow(
                  trip: busStop.trips[0]
              )
          )
      );
    } else {
      for (int i = 0; i < busStop.trips.length; i++) {
        tripRows.add(
            new Container(
                padding: EdgeInsets.all(12.0),
                decoration: new BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 0.1, color: primaryColor))),
                child: new TripRow(
                    trip: busStop.trips[i]
                )
            )
        );
      }
    }

    return tripRows;
  }
}