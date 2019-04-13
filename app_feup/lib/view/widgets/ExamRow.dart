import 'package:flutter/material.dart';
import 'ExameTime.dart';
import 'ScheduleEventRectangle.dart';


class ExamRow extends StatelessWidget{
  final String subject;
  final String rooms;
  final String begin;
  final String day;
  final String teacher;
  final String type;
  final String month;

  ExamRow({
    Key key,
    @required this.subject,
    @required this.rooms,
    @required this.begin,
    @required this.day,
    @required this.month,
    this.teacher,
    this.type
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Container(
          padding: EdgeInsets.only(left: 15.0, bottom: 8.0),
          margin: EdgeInsets.only(top: 8.0),
          decoration: new BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Theme.of(context).accentColor, width: 1),
            )
          ),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new ExamTime(begin: this.begin, day: this.day, month: this.month,),
              new ScheduleEventRectangle(subject: this.subject, rooms: this.rooms, teacher: this.teacher, type: this.type)
            ],
          ),
        )
    );
  }
}