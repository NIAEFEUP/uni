import '../../controller/parsers/parser-exams.dart';
import '../../model/AppState.dart';
import 'package:flutter/material.dart';
import 'ScheduleRow.dart';
import 'package:flutter_redux/flutter_redux.dart';


class ExamCard extends StatelessWidget{

  final double leftPadding = 12.0;

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
                  this.createDateContainer(context, exams[0]),
                  new ScheduleRow(
                      subject: exams[0].subject,
                      rooms: exams[0].rooms,
                      begin: exams[0].begin,
                      end: exams[0].end
                  ),
                  this.createDateContainer(context, exams[1]),
                  new ScheduleRow(
                      subject: exams[1].subject,
                      rooms: exams[1].rooms,
                      begin: exams[1].begin,
                      end: exams[1].end
                  )

                ],
              )
          );
        }else {
          return Text("No exams to show at the moment");
        }
      },
    );
  }

  Widget createDateContainer(context, exam){
    return new Container(
            padding: EdgeInsets.only(left: this.leftPadding),
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
                    )
                )
            ),
          );
  }
}
