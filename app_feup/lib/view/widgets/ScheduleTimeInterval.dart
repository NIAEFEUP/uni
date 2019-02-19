import 'package:flutter/material.dart';

class ScheduleTimeInterval extends StatelessWidget{
  final String begin;
  final String end;
  ScheduleTimeInterval({
    Key key,
    @required this.begin,
    @required this.end
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return  new Column(
      children: <Widget>[
        new Container(
          child: Text(this.begin,style: Theme.of(context).textTheme.body2),
          margin: EdgeInsets.only(top: 5.0),
        ),new Container(
          child: Text(this.end,style: Theme.of(context).textTheme.body2),
          margin: EdgeInsets.only(top: 24.0),
        ),
      ],
    );
  }
}