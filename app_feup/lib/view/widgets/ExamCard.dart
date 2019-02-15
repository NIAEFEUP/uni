import '../../controller/parsers/parser-exams.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class ExamCard extends StatelessWidget{
  final Exam exam;
  ExamCard({
    Key key,
    @required this.exam
}): super(key: key);

  List<Widget> parseExam()
  {
    List<Widget> examInfo;
    examInfo.add(new Text(this.exam.schedule));
    examInfo.add(new Text(this.exam.subject));
    return examInfo;
  }
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: GridView.count(
          crossAxisCount: 2,
          children: this.parseExam()
      ),
    );
  }
}
Future<void> getExams() async{
  List<Exam> meias = await examsGet("https://sigarra.up.pt/feup/pt/exa_geral.mapa_de_exames?p_curso_id=742");
  meias[0].printExam();

}
