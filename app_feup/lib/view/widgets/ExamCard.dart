import '../../controller/parsers/parser-exams.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class ExamCard extends StatelessWidget{

  final Exam firstExam;
  final Exam secondExam;
  final double borderRadius = 12.0;
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
          new Center(
            child: new Container(
              padding: EdgeInsets.only(left: 12.0),
              margin: EdgeInsets.only(top: 5.0),
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      new Container(
                        child: Text(this.firstExam.begin,style: Theme.of(context).textTheme.body2),
                        margin: EdgeInsets.only(top: 5.0),
                      ),new Container(
                        child: Text(this.firstExam.end,style: Theme.of(context).textTheme.body2),
                        margin: EdgeInsets.only(top: 24.0),
                      ),
                    ],
                  ),
                  new ConstrainedBox(
                    constraints: new BoxConstraints(
                        minWidth: 210,
                        minHeight: 30,
                        maxWidth: 300,
                        maxHeight: 65
                    ),
                    child: new Container(
                      margin: EdgeInsets.only(left: 24.0, top: 2.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(this.borderRadius)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Container(
                            margin: EdgeInsets.only(top: 5.0),
                            child: new Text(this.firstExam.subject, style: TextStyle(color: Theme.of(context).accentColor),),
                          ),
                          new Container(
                            margin: EdgeInsets.only(top: 13.0),
                            child: new Text(this.firstExam.rooms, style: TextStyle(color: Theme.of(context).accentColor),),
                          )
                        ],
                      ),
                    ),
                  ),

                ],
              ),
             )
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
          new Center(
            child: new Container(
              padding: EdgeInsets.only(left: 12.0),
              margin: EdgeInsets.only(top: 5.0),
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      new Container(
                        child: Text(this.secondExam.begin,style: Theme.of(context).textTheme.body2),
                        margin: EdgeInsets.only(top: 5.0),
                      ),new Container(
                        child: Text(this.secondExam.end,style: Theme.of(context).textTheme.body2),
                        margin: EdgeInsets.only(top: 24.0),
                      ),
                    ],
                  ),
                  new ConstrainedBox(
                    constraints: new BoxConstraints(
                        minWidth: 210,
                        minHeight: 30,
                        maxWidth: 300,
                        maxHeight: 65
                    ),
                    child: new Container(
                      margin: EdgeInsets.only(left: 24.0, top: 2.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(this.borderRadius)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Container(
                            margin: EdgeInsets.only(top: 5.0),
                            child: new Text(this.secondExam.subject, style: TextStyle(color: Theme.of(context).accentColor),),
                          ),
                          new Container(
                            margin: EdgeInsets.only(top: 13.0),
                            child: new Text(this.secondExam.rooms, style: TextStyle(color: Theme.of(context).accentColor),),
                          )
                        ],
                      ),
                    ),
                  ),

                ],
              ),
             )
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
