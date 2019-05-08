import 'package:app_feup/controller/parsers/parser-exams.dart';
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
          padding: EdgeInsets.only(left: 15.0, bottom: 8.0),
          margin: EdgeInsets.only(top: 10.0),
          decoration: new BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Theme.of(context).accentColor, width: 1),
            )
          ),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new SecondaryExamTime(begin: this.exam.begin, day: this.exam.day, month: this.exam.month),
              new Container(
                padding: EdgeInsets.only(left: 10),
                child: new Text(this.exam.subject + ' (' + this.exam.examType + ')', style: Theme.of(context).textTheme.subtitle.apply(fontWeightDelta: 1, fontSizeDelta: -4),),
              ),
              new Container(
                padding: EdgeInsets.only(left: 10),
                child: new Text(this.exam.rooms.isEmpty ? "Salas em breve": this.exam.rooms, style: Theme.of(context).textTheme.subtitle.apply(fontSizeDelta: -15, fontWeightDelta: 2),),
              ),
            ],
          ),
        )
    );
  }
}