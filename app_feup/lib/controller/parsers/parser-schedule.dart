import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

Future<List<Lecture>> scheduleGet(String link) async {

  var response = await http.get(
      link);

  var document = parse(response.body);

  var semana = [0,0,0,0,0,0];

  List<Lecture> lecturesList = new List();
  document.querySelectorAll('.horario > tbody > tr').forEach((Element element){
      if (element.getElementsByClassName('horas').length > 0){
        var day = 0;
        List<Element> children = element.children;
        for (var i = 1; i < children.length; i++){
          for (var d = day; d < semana.length; d++){
            if (semana[d] == 0)
              break;
            day++;
          }
          var clsName = children[i].className;
          if (clsName == 'TE' || clsName == 'TP' || clsName == 'PL'){
            Lecture lect = new Lecture();
            lect.subject = children[i].querySelector('b > acronym > a').text;
            lect.typeClass = clsName;
            lect.day = day;
            lect.blocks = int.parse(children[i].attributes['rowspan']);
            lect.startTime = children[0].text.substring(0, 5);

            semana[day] += lect.blocks;
            lecturesList.add(lect);
          }
          day++;
        }
        semana = semana.expand((i) => [(i-1) < 0? 0 : i - 1]).toList();
      }
    });
    lecturesList.sort((a, b) => a.compare(b));
    return lecturesList;
}

class Lecture {
  static var dayName = ["Segunda", "Terca", "Quarta", "Quinta", "Sexta", "Sabado"];
  String subject;
  String startTime;
  String typeClass;
  int day;
  int blocks;

  printLecture(){
    print(subject + " " + typeClass);
    print(dayName[day] + " " + startTime + " " + blocks.toString() + " blocos\n");
  }

  int compare(Lecture other) {
    if (day == other.day){
      return startTime.compareTo(other.startTime);
    } else {
      return day.compareTo(other.day);
    }
  }
}
