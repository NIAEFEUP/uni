import 'package:flutter/material.dart';
import '../widgets/GenericCard.dart';
import '../widgets/ExamCard.dart';
import '../../controller/parsers/parser-exams.dart';

Exam exam = Exam("14:30-16:30", "COMP", "B001", "2019-03-20", "Fuck off", "Sábado");

class HomePageView extends StatelessWidget {
  HomePageView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("App FEUP")),
      body: createScrollableCardView(context),
      floatingActionButton: createActionButton(context),
    );
  }

  Widget createActionButton(BuildContext context){
    return new FloatingActionButton(
      onPressed: () => getExams(), //Add FAB functionality here
      tooltip: 'Increment',
      child: new Icon(Icons.add),
    );
  }

  Widget createScrollableCardView(BuildContext context){
    return new ListView(

        shrinkWrap: false,
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          new GenericCard(
            title: "Exames"
            , child: new ExamCard(firstExam: exam, secondExam: exam,))

          //Cards go here

        ],
      );
  }
}