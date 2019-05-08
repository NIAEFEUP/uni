import 'package:app_feup/model/entities/Exam.dart';
import 'package:flutter/material.dart';
import 'ExamTime.dart';
import '../../ScheduleEventRectangle.dart';


class ExamRow extends StatelessWidget{
  final Exam exam;

  ExamRow({
    Key key,
    @required this.exam
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
              new ExamTime(begin: this.exam.begin, day: this.exam.day, month: this.exam.month,),
              new ScheduleEventRectangle(subject: this.exam.subject, rooms: this.exam.rooms, teacher: null, type: this.exam.examType)
            ],
          ),
        )
    );
  }
}