import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

class Exam{
  String subject;
  String subjectName;
  String schedule;
  String rooms;
  String date;
  int day;
}

main() async{

  var response = await http.get('https://sigarra.up.pt/feup/pt/exa_geral.mapa_de_exames?p_curso_id=742');

  var document = parse(response.body);

  List<Exam> exams = new List();
  List<String> dates = new List();
  String subject, schedule, rooms;
  int days = 0;
  document.querySelectorAll('table > tbody > tr > td').forEach((Element element){
    if(element.querySelectorAll('table') != null)
    {
      element.querySelectorAll('table').forEach((Element table){
        days = 0;
        if(table.querySelectorAll('span.exame-data') != null)
        {
          table.querySelectorAll('span.exame-data').forEach((Element weekDates){
            dates.add(weekDates.text);
          });
        }

        if(table.querySelectorAll('td.exame') != null)
        {
          table.querySelectorAll('table.dados td.exame').forEach((Element classes){
              if(classes.querySelector('a') != null)
              {
                subject = classes.querySelector('a').text;
              }
              if(classes.querySelector('span.exame-sala') != null) 
              {
                rooms = classes.querySelector('span.exame-sala').text;
              }
              print(classes.text);
              // if(classes.querySelector('td')!= null)
              // {
              //   print(classes.querySelector('td.l.exame').text);
              // }
          });
        }
      });
    }
    // if(element.querySelector('a') != null)
    // {
    //   subject = element.querySelector('a').text;
    // }
    // if(element.querySelector('span') != null) 
    // {
    //   rooms = element.querySelector('span').text;
    // }
    // if(element.querySelector('td')!= null)
    // {
    //   // print(element.querySelector('td').text);
    // }
    
  });
  
}