import 'package:flutter/material.dart';
import 'SecondaryExamTime.dart';

class SecondaryExamRow extends StatelessWidget{
  final String subject;
  final String rooms;
  final String begin;
  final String day;
  final String teacher;
  final String type;
  final String month;

  SecondaryExamRow({
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
          margin: EdgeInsets.only(top: 24.0),
          decoration: new BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Theme.of(context).accentColor, width: 1),
            )
          ),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new SecondaryExamTime(begin: this.begin, day: this.day, month: this.month),
              new Container(
                padding: EdgeInsets.only(left: 50),
                child: new Text(this.subject, style: Theme.of(context).textTheme.subtitle.apply(fontSizeDelta: 1, fontWeightDelta: 1),),
              ),
              new Container(
                padding: EdgeInsets.only(left: 20),
                child: new Text(this.rooms.isEmpty ? "Salas em breve": this.rooms, style: Theme.of(context).textTheme.subtitle.apply(fontSizeDelta: -7),),
              ),
            ],
          ),
        )
    );
  }
}