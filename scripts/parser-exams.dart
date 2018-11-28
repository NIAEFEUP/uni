import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

class Exam{
  String subject;
  String schedule;
  String rooms;
  String date;
  Exam(String schedule, String subject, String rooms, String date)
  {
    this.subject = subject;
    this.schedule = schedule;
    this.rooms = rooms;
    this.date = date;
  }
}

main() async{

  var response = await http.get('https://sigarra.up.pt/feup/pt/exa_geral.mapa_de_exames?p_curso_id=742');

  var document = parse(response.body);

  List<Exam> Exams = new List();
  List<String> dates = new List();
  String subject, schedule, rooms;
  int days = 0;
  document.querySelectorAll('div > table > tbody > tr > td').forEach((Element element){
    element.querySelectorAll('table:not(.mapa)').forEach((Element table) {
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

          schedule = examsDay.text.substring(exams.text.indexOf(':') -2, examsDay.text.indexOf(':') + 9);
          Exam exam = new Exam(schedule, subject, rooms, dates[days]);
          Exams.add(exam);
          });
        }
          days++;
      });
    });
  });
  
}