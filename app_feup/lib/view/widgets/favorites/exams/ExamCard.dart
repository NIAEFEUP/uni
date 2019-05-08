import 'package:app_feup/view/widgets/GenericCard.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:flutter/material.dart';
import 'ExamRow.dart';
import 'SecondaryExamRow.dart';
import 'package:flutter_redux/flutter_redux.dart';


class ExamCard extends StatelessWidget{

  final double padding = 4.0;

  ExamCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<dynamic>>(
      converter: (store) => store.state.content['exams'],
      builder: (context, exams){
        return GenericCard(
            title: "Exames",
            func: () => Navigator.pushReplacementNamed(context, '/Mapa de Exames'),
            child:
                exams.length >= 1 ?
                Container(
                    child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      children: this.getExamRows(context, exams),
                    ))
                : Center(
                  child: Text("No exams to show at the moment"),
                ));
      },
    );
  }

  List<Widget> getExamRows(context, exams){
    List<Widget> rows = new List<Widget>();
    int i = 0;
    for(; i < 1 && i < exams.length; i++){
      rows.add(this.createRowFromExam(context, exams[i]));
    }
    for(; i < 4 && i < exams.length; i++){
      rows.add(this.createSecondaryRowFromExam(context, exams[i]));
    }
    return rows;
  }

  Widget createRowFromExam(context, exam){
    return new ExamRow(
          exam: exam,
      );
  }

  Widget createSecondaryRowFromExam(context, exam){
    return new SecondaryExamRow(
          exam: exam,
      );
  }
}
