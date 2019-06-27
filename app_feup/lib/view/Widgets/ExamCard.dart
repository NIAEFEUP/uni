import 'package:app_feup/view/Widgets/DateRectangle.dart';
import 'package:app_feup/view/Widgets/GenericCard.dart';
import '../../model/AppState.dart';
import 'package:flutter/material.dart';
import 'ScheduleRow.dart';
import 'package:flutter_redux/flutter_redux.dart';


class ExamCard extends StatelessWidget{

  final double padding = 8.0;

  ExamCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<dynamic>>(
      converter: (store) => store.state.content['exams'],
      builder: (context, exams){
        return GenericCard(
            title: "Exames",
            func: () => Navigator.pushReplacementNamed(context, '/Mapa de Exames'),
            child: getCardContent(context, exams)
        );
      },
    );
  }
      
  Widget getCardContent(BuildContext context, exams){
    switch (StoreProvider.of<AppState>(context).state.content['examsStatus']){
      case RequestStatus.SUCCESSFUL:
        return exams.length >= 1 ?
          Container(
              padding: EdgeInsets.all(this.padding),
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: this.getExamRows(context, exams),
              ))
          : Center(
            child: Text("No exams to show at the moment"),
          );
      case RequestStatus.BUSY:
        return Center(child: CircularProgressIndicator());
        break;
      case RequestStatus.FAILED:
        if(exams.length != 0)
          return Container(
              padding: EdgeInsets.all(this.padding),
              child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: this.getExamRows(context, exams),
              )
          );
        else return Center(child: Text("Comunication error. Please check your internet connection."));
        break;
      default:
        return Container();
    } 
  }

  List<Widget> getExamRows(context, exams){
    List<Widget> rows = new List<Widget>();
    for(int i = 0; i < 1 && i < exams.length; i++){
      rows.add(this.createRowFromExam(context, exams[i]));
    }
    for(int i = 1; i < 4 && i < exams.length; i++){
      rows.add(this.createSecondaryRowFromExam(context, exams[i]));
    }
    return rows;
  }

  Widget createRowFromExam(context, exam){
    return new Column(children: [
                new DateRectangle(date: exam.weekDay + ", " + exam.day + " de " + exam.month),
                new Container(
                    child: new Card(
                      child: ScheduleRow(
                          subject: exam.subject,
                          rooms: exam.rooms,
                          begin: exam.begin,
                          end: exam.end
                      ),
                ),
                padding: EdgeInsets.only(left: this.padding, right: this.padding),)

    ]
    );
  }

  Widget createSecondaryRowFromExam(context, exam) {
    return new Container(
      padding: EdgeInsets.only(left: this.padding, right: this.padding),
      child: new Card(
        child: new Container(
          padding: EdgeInsets.all(11),
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text(
                exam.day + "/" + exam.month,
                style: Theme.of(context).textTheme.display1.apply(fontWeightDelta: -1),
            ),
            new Text(
                exam.subject,
                style: Theme.of(context).textTheme.display2.apply(fontSizeDelta: 5)
            )
          ],
        ),
      ),
      ),
    );
  }
}
