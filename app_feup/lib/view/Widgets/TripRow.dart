import 'package:app_feup/model/entities/Trip.dart';
import 'package:flutter/material.dart';
import '../Theme.dart';
import 'EstimatedArrivalTimeStamp.dart';

class TripRow extends StatelessWidget{
  final Trip trip;

  TripRow({
    Key key,
    @required this.trip,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return  new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(this.trip.getLine(),style: new TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), //Theme.of(context).textTheme.display1.apply(color: Colors.black, fontWeight: FontWeight.bold)),
            Text(this.trip.getDestination(),style: Theme.of(context).textTheme.display1.apply(color: greyTextColor)),
          ],
        ),
        new Column(
          children: <Widget>[
            Text(this.trip.getTimeRemaining(),style: new TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), // Theme.of(context).textTheme.display1.apply(color: Colors.black, fontWeightDelta: -3))
            new EstimatedArrivalTimeStamp(
                timeRemaining: this.trip.getTimeRemaining()
            ),
          ]
        )
      ],
    );
  }
}
