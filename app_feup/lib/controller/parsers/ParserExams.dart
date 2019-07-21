import 'package:app_feup/model/entities/Exam.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'dart:async';

Future<List<Exam>> parseExams(http.Response response) async{

  var document = await parse(response.body);

  List<Exam> Exams = new List();
  List<String> dates = new List();
  List<String> examTypes = new List();
  List<String> weekDays = new List();
  String subject, schedule, rooms;
  int days = 0;
  int tableNum = 0;
  document.querySelectorAll('h3').forEach((Element examType){
    examTypes.add(examType.text);
  });
  
  document.querySelectorAll('div > table > tbody > tr > td').forEach((Element element){
    element.querySelectorAll('table:not(.mapa)').forEach((Element table) {
      table.querySelectorAll('th').forEach((Element week){
        weekDays.add(week.text.substring(0, week.text.indexOf('2')));
      });
      table.querySelectorAll('span.exame-data').forEach((Element date) {
        dates.add(date.text);
      });

      table.querySelectorAll('td.l.k').forEach((Element exams) {
        if(exams.querySelector('td.exame') != null)
        {
          exams.querySelectorAll('td.exame').forEach((Element examsDay) {
          if(examsDay.querySelector('a') != null)
          {
            subject = examsDay.querySelector('a').text;
          }
          if(examsDay.querySelector('span.exame-sala') != null) 
          {
            rooms = examsDay.querySelector('span.exame-sala').text;
          }

          schedule = examsDay.text.substring(examsDay.text.indexOf(':') -2, examsDay.text.indexOf(':') + 9);
          Exam exam = new Exam(schedule, subject, rooms, dates[days], examTypes[tableNum], weekDays[days]);
          Exams.add(exam);
          });
        }
          days++;
      });
    });
    tableNum++;
  });
  return Exams;
}

