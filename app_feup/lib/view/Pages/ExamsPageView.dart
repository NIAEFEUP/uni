import 'package:app_feup/model/entities/Exam.dart';
import 'package:app_feup/view/Widgets/PageTitle.dart';
import 'package:flutter/material.dart';
import '../Pages/SecondaryPageView.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../Widgets/TitleCard.dart';
import '../../model/AppState.dart';
import '../Widgets/ScheduleRow.dart';

class ExamsPageView extends SecondaryPageView {

  ExamsPageView({
    Key key
  });

  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, List<dynamic>>(
      converter: (store) => store.state.content['exams'],
      builder: (context, exams){
        return new ExamsList(exams: exams, now: DateTime.now(),);
      },
    );
  }
}

class ExamsList extends StatelessWidget {
  final double borderRadius = 15.0;
  final DateTime now;
  final List<Exam> exams;

  ExamsList({
    Key key,
    @required this.exams,
    @required this.now,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          child: new Column(
          mainAxisSize: MainAxisSize.max,
          children: this.parseExamsByDate(context, this.exams),
          ),
        )
      ],
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

    if(exams.length == 1){
      return [this.createExamCard(context, [exams[0]])];
    }

    List<Widget> columns = new List<Widget>();
    columns.add(new PageTitle(name: 'Exams',));
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
    final keyValue = exams.map((exam) => exam.toString()).join();
    return new Container(
      key: new Key(keyValue),  
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
    final keyValue = '${exam.toString()}-exam';
        return Container(
        key: new Key(keyValue)  ,
        margin: EdgeInsets.fromLTRB(12, 4, 12, 0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(this.borderRadius))),
        child: new ScheduleRow(subject: exam.subject, rooms: exam.rooms, begin: exam.begin, end: exam.end)
    );
  }
}