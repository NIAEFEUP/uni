import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'dart:async';

class Exam{
  String subject;
  String begin;
  String end;
  String rooms;
  String day;
  String examType;
  String weekDay;
  String month;
  String year;
  DateTime date;

  Exam(String schedule, String subject, String rooms, String date, String examType, String weekDay)
  {
    this.subject = subject;
    this.date = DateTime.parse(date);
    var scheduling = schedule.split('-');
    var dateSepared = date.split('-');
    this.begin = scheduling[0].replaceAll(':', 'h');
    this.end = scheduling[1].replaceAll(':', 'h');
    this.rooms = rooms;
    this.year = dateSepared[0];
    this.day = dateSepared[2];
    this.examType = examType;
    this.weekDay = weekDay;
    switch(dateSepared[1]){
      case '01':{
        this.month = "JAN";
      }
        break;
      case '02':{
        this.month = "FEV";
      }
        break;
      case '03':{
        this.month = "MAR";
      }
        break;
      case '04':{
        this.month = "ABR";
      }
        break;
      case '05':{
        this.month = "MAI";
      }
        break;
      case '06':{
        this.month = "JUN";
      }
        break;
      case '07':{
        this.month = "JUL";
      }
        break;
      case '08':{
        this.month = "AGO";
      }
        break;
      case '09':{
        this.month = "SET";
      }
        break;
      case '10':{
        this.month = "OUT";
      }
        break;
      case '11':{
        this.month = "NOV";
      }
        break;
      case '12':{
        this.month = "DEZ";
      }
        break;
    }
  }
  void printExam()
  {
    print('$subject - $year - $month - $day -  $begin-$end - $examType - $rooms - $weekDay');
  }
}

Future<List<Exam>> examsGet(String link) async{

  var response = await http.get(link);

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

