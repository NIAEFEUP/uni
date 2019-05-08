import 'package:app_feup/model/entities/Exam.dart';
import 'package:flutter/material.dart';
import 'SecondaryExamTime.dart';

class SecondaryExamRow extends StatelessWidget{
  final Exam exam;

  SecondaryExamRow({
    Key key,
    @required this.exam
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Center(
        child: new Container(
          padding: EdgeInsets.only(right: 15.0, left: 15.0, bottom: 8.0),
          margin: EdgeInsets.only(top: 10.0),
          decoration: new BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Theme.of(context).accentColor, width: 1),
            )
          ),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new SecondaryExamTime(begin: this.exam.begin, day: this.exam.day, month: this.exam.month),
              new Container(
                child: new Text(this.exam.subject + ' (' + this.exam.examType + ')', style: Theme.of(context).textTheme.subtitle.apply(fontWeightDelta: 1, fontSizeFactor: 0.8),),
              ),
              new Container(
                width: 40.0,
                child: new Text(this.exam.rooms.isEmpty ? "------": this.exam.rooms, style: Theme.of(context).textTheme.subtitle.apply(fontSizeFactor: 0.55, fontWeightDelta: 2), textAlign: TextAlign.right),
              ),
            ],
          ),
        )
    );
  }
}