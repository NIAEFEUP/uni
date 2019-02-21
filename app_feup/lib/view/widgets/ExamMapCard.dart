import 'TitleCard.dart';
import '../../model/AppState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'ScheduleRow.dart';

class ExamMapCard extends StatelessWidget{

  final double borderRadius = 15.0;

  ExamMapCard({
    Key key
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StoreConnector<AppState, List<dynamic>>(
      converter: (store) => store.state.content['exams'],
      builder: (context, exams){
        return Container(
          child: new Column(
            mainAxisSize: MainAxisSize.max,
            children: this.createExamsColumn(context, exams),
          ),
        );
      },
    );
  }

  List<Widget> createExamsColumn(context, exams){
    List<Widget> columns = new List<Widget>();
    for(int i = 0; i < exams.length; i++)
      {
        columns.add(this.createExamCard(context, exams[i]));
      }
    return columns;
  }

  Widget createExamCard(context, exam){
    return new Container(
      margin: EdgeInsets.only(bottom: 8),
      child: new Column(children: <Widget>[
        new TitleCard(day: exam.day, weekDay: exam.weekDay, month: exam.month),
        this.createExamContext(context, exam)
      ],
      ),
    );
  }

  Widget createExamContext(context, exam){
    return new Card(
        margin: EdgeInsets.fromLTRB(12, 4, 12, 0),
        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(this.borderRadius)),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(width: 0.5, color: Color.fromARGB(64, 0x46, 0x46, 0x46)),
              borderRadius: BorderRadius.all(Radius.circular(this.borderRadius))),
          child: new ScheduleRow(subject: exam.subject, rooms: exam.rooms, begin: exam.begin, end: exam.end)
      )
    );
  }
}