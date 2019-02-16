import '../../controller/parsers/parser-exams.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class ExamCard extends StatelessWidget{
  final Exam exam;
  ExamCard({
    Key key,
    @required this.exam
}): super(key: key);
  List<Widget> parseExam()
  {
    List<Widget> examInfo;
    examInfo.add(new Text(this.exam.subject));
    return examInfo;
  }
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        mainAxisSize:  MainAxisSize.min,
        children: <Widget>[
          new Container(
            child: Text(
                (" " + this.exam.weekDay + ", " + this.exam.day + " de " + this.exam.month),
                style: Theme.of(context).textTheme.subtitle),
            alignment: Alignment.center,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).accentColor,
                  width: 1.0
                )
              )
            ),
          ),
          new Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Column(
                children: <Widget>[
                  new Container(
                    child: Text(this.exam.begin,style: Theme.of(context).textTheme.body2),
                    margin: EdgeInsets.only(top: 5.0),
                  ),new Container(
                    child: Text(this.exam.end,style: Theme.of(context).textTheme.body2),
                    margin: EdgeInsets.only(top: 24.0),
                  ),
                ],
              ),
              new Container(
                margin: EdgeInsets.only(left: 24.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor
                ),
                child: new Text(this.exam.subject, style: TextStyle(color: Theme.of(context).accentColor),),
              )
            ],
          )
        ],
      )
    );
  }
}
Future<void> getExams() async{
  List<Exam> meias = await examsGet("https://sigarra.up.pt/feup/pt/exa_geral.mapa_de_exames?p_curso_id=742");
  meias[0].printExam();

}
