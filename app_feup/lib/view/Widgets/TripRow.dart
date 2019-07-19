import 'package:app_feup/model/entities/Trip.dart';
import 'package:flutter/material.dart';
import '../Theme.dart';

class TripRow extends StatelessWidget{
  final Trip trip;

  TripRow({
    Key key,
    @required this.trip
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return  new Row(
      children: <Widget>[
        new Container(
          child: Text(this.trip.getLine(),style: Theme.of(context).textTheme.display1.apply(color: greyTextColor)),
          margin: EdgeInsets.only(top: 8.0),
        ), new Container(
          child: Text(this.trip.getDestination(),style: Theme.of(context).textTheme.display1.apply(color: greyTextColor)),
          margin: EdgeInsets.only(top: 22.0, bottom: 8.0),
        ), new Container(
          child: Text(this.trip.getTimeRemaining(),style: Theme.of(context).textTheme.display1.apply(color: greyTextColor)),
          margin: EdgeInsets.only(top: 22.0, bottom: 8.0),
        ),
      ],
    );
  }
}