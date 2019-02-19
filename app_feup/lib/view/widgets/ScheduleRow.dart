import 'package:flutter/material.dart';
import 'ScheduleTimeInterval.dart';
import 'ScheduleEventRectangle.dart';


class ScheduleRow extends StatelessWidget{
  final String subject;
  final String rooms;
  final String begin;
  final String end;
  ScheduleRow({
    Key key,
    @required this.subject,
    @required this.rooms,
    @required this.begin,
    @required this.end,
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Container(
          padding: EdgeInsets.only(left: 12.0),
          margin: EdgeInsets.only(top: 5.0),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new ScheduleTimeInterval(begin: this.begin, end: this.end),
              new ScheduleEventRectangle(subject: this.subject, rooms: this.rooms)
            ],
          ),
        )
    );
  }
}