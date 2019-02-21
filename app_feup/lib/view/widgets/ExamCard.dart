import 'package:app_feup/view/widgets/DateRectangle.dart';

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
      new DateRectangle(date: exam.weekDay + ", " + exam.day + " de " + exam.month),
      new ScheduleRow(
          subject: exam.subject,
          rooms: exam.rooms,
          begin: exam.begin,
          end: exam.end
      ),]);
  }
}
