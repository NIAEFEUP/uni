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
      mainAxisAlignment: MainAxisAlignment.spaceBetween ,
      children: <Widget>[
        new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(this.trip.line,style: Theme.of(context).textTheme.display1.apply(color: lightGreyTextColor, fontWeightDelta: 2)), //Theme.of(context).textTheme.display1.apply(color: Colors.black, fontWeight: FontWeight.bold)),
            Text(this.trip.destination, style: Theme.of(context).textTheme.display1.apply(color: greyTextColor)),
          ],
        ),
        new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(this.trip.timeRemaining.toString(), style: Theme.of(context).textTheme.display1.apply(color: lightGreyTextColor, fontWeightDelta: 2)), // Theme.of(context).textTheme.display1.apply(color: Colors.black, fontWeightDelta: -3))
            new EstimatedArrivalTimeStamp(
                timeRemaining: this.trip.timeRemaining.toString()
            ),
          ]
        )
      ],
    );
  }
}
