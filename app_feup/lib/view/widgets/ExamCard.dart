import '../../controller/parsers/parser-exams.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'ScheduleRow.dart';

class ExamCard extends StatelessWidget{

  final Exam firstExam;
  final Exam secondExam;
  final double leftPadding = 12.0;

  ExamCard({
    Key key,
    @required this.firstExam,
    @required this.secondExam
}): super(key: key);
  List<Widget> parseExam()
  {
    List<Widget> examInfo;
    examInfo.add(new Text(this.firstExam.subject));
    return examInfo;
  }
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        mainAxisSize:  MainAxisSize.min,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.only(left: this.leftPadding),
            child: Text(
                (" " + this.firstExam.weekDay + ", " + this.firstExam.day + " de " + this.firstExam.month),
                style: Theme.of(context).textTheme.subtitle),
            alignment: Alignment.center,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).accentColor,
                  width: 0.5
                )
              )
            ),
          ),
          new ScheduleRow(
              subject: this.firstExam.subject,
              rooms: this.firstExam.rooms,
              begin: this.firstExam.begin,
              end: this.firstExam.end
          ),
          new Container(
            padding: EdgeInsets.only(left: 12.0),
            child: Text(
                (" " + this.secondExam.weekDay + ", " + this.secondExam.day + " de " + this.secondExam.month),
                style: Theme.of(context).textTheme.subtitle),
            alignment: Alignment.center,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).accentColor,
                  width: 0.5
                ),
                top: BorderSide(
                  color: Theme.of(context).accentColor,
                  width: 0.5
                )
              )
            ),
          ),
          new ScheduleRow(
              subject: this.secondExam.subject,
              rooms: this.secondExam.rooms,
              begin: this.secondExam.begin,
              end: this.secondExam.end
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
