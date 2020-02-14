import 'package:app_feup/model/entities/Exam.dart';
import 'package:app_feup/view/Widgets/PageTitle.dart';
import 'package:app_feup/view/Widgets/RowContainer.dart';
import 'package:flutter/material.dart';
import '../Pages/SecondaryPageView.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../Widgets/TitleCard.dart';
import '../../model/AppState.dart';
import '../Widgets/ScheduleRow.dart';

class ExamsPageView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ExamsPageViewState();

}
class ExamsPageViewState extends SecondaryPageViewState {

  final double borderRadius = 10.0;

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
              children: this.createExamsColumn(context, exams),
          ),
        )
        ],
        );
      },
    );
  }

  List<Widget> createExamsColumn(context, exams){

    List<Widget> columns = new List<Widget>();
    columns.add(new PageTitle(name: 'Exames',));

    if(exams.length == 1){
      columns.add(this.createExamCard(context, [exams[0]]));
      return columns;
    }

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
      child: this.createExamsCards(context, exams),
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
        child: RowContainer(
          child: new ScheduleRow(subject: exam.subject, rooms: exam.rooms, begin: exam.begin, end: exam.end)
        )
    );
  }
}