import 'package:app_feup/model/entities/Exam.dart';
import 'package:flutter/material.dart';
import '../Pages/SecondaryPageView.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../Widgets/TitleCard.dart';
import '../../model/AppState.dart';
import '../Widgets/ScheduleRow.dart';

class ExamsPageView extends SecondaryPageView {

  final double borderRadius = 15.0;
  final DateTime now = new DateTime.now();

  ExamsPageView({
    Key key
  });

  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, List<dynamic>>(
      converter: (store) => store.state.content['exams'],
      builder: (context, exams){
        return ListView(
          children: <Widget>[
            Container(
              child: new Column(
              mainAxisSize: MainAxisSize.max,
              children: this.parseExamsByDate(context, exams),
          ),
        )
        ],
        );
      },
    );
  }

  List<Widget> parseExamsByDate(context, exams){
    List<Exam> currentExams = new List<Exam>();
    for (int i = 0; i < exams.length; i++)
    {
      if(now.compareTo(exams[i].date) <= 0)
        currentExams.add(exams[i]);
    }
    return this.createExamsColumn(context, currentExams);
  }
  List<Widget> createExamsColumn(context, exams){
    List<Widget> columns = new List<Widget>();
    List<Exam> currentDayExams = new List<Exam>();
    for(int i = 0; i < exams.length; i++)
    {
      if (i + 1 >= exams.length){
        if(exams[i].day == exams[i - 1].day && exams[i].month == exams[i - 1].month) {
          currentDayExams.add(exams[i]);
        }
        else{
          if(currentDayExams.length > 0)
            columns.add(this.createExamCard(context, currentDayExams));
          currentDayExams.clear();
          currentDayExams.add(exams[i]);
        }
        columns.add(this.createExamCard(context, currentDayExams));
        break;
      }
      if(exams[i].day == exams[i + 1].day && exams[i].month == exams[i + 1].month) {
        currentDayExams.add(exams[i]);
      }
      else {
        currentDayExams.add(exams[i]);
        columns.add(this.createExamCard(context, currentDayExams));
        currentDayExams.clear();
      }
    }
    return columns;
  }

  Widget createExamCard(context, exams){
    return new Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(8),
      child: new Card(child: this.createExamsCards(context, exams)
      ),
    );
  }

  Widget createExamsCards(context, exams){
    List<Widget> examCards = new List<Widget>();
    examCards.add(new TitleCard(day: exams[0].day, weekDay: exams[0].weekDay, month: exams[0].month));
    for(int i = 0; i < exams.length; i++)
    {
      examCards.add(this.createExamContext(context, exams[i]));
    }
    return new Column(children: examCards);
  }

  Widget createExamContext(context, exam){
    return Container(
        margin: EdgeInsets.fromLTRB(12, 4, 12, 0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(this.borderRadius))),
        child: new ScheduleRow(subject: exam.subject, rooms: exam.rooms, begin: exam.begin, end: exam.end)
    );
  }
}