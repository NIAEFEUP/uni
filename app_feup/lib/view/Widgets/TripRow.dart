import 'package:app_feup/model/entities/Trip.dart';
import 'package:flutter/material.dart';
import '../Theme.dart';

class TripRow extends StatelessWidget{
  final Trip trip;
  final String stopCode;

  TripRow({
    Key key,
    @required this.trip,
    @required this.stopCode
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return  new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(this.trip.getLine(),style: Theme.of(context).textTheme.display1.apply(color: greyTextColor)),
        Text(this.trip.getDestination(),style: Theme.of(context).textTheme.display1.apply(color: greyTextColor)),
        Text(this.trip.getTimeRemaining(),style: Theme.of(context).textTheme.display1.apply(color: greyTextColor)),
      ],
    );
  }
}