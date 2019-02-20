import '../../controller/parsers/parser-exams.dart';
import '../../model/AppState.dart';
import 'package:flutter/material.dart';
import 'ScheduleRow.dart';
import 'package:flutter_redux/flutter_redux.dart';


class ExamCard extends StatelessWidget{

  final double padding = 4.0;

  ExamCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<dynamic>>(
      converter: (store) => store.state.content['exams'],
      builder: (context, exams){
        if(exams.length >= 2) {
          return Container(
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  this.createRowFromExam(context, exams[0]),
                  this.createRowFromExam(context, exams[1]),
                ],
              )
          );
        }else {
          return Text("No exams to show at the moment");
        }
      },
    );
  }

  Widget createRowFromExam(context, exam){
    return new Column(children: [
      this.createDateContainer(context, exam),
      new ScheduleRow(
          subject: exam.subject,
          rooms: exam.rooms,
          begin: exam.begin,
          end: exam.end
      ),]);
  }

  Widget createDateContainer(context, exam){
    return new Container(
            padding: EdgeInsets.all(this.padding),
            child: Text(
                (" " + exam.weekDay + ", " + exam.day + " de " + exam.month),
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
                    ),
                )
            ),
          );
  }
}
