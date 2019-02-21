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

          String subject = children[i].querySelector('b > acronym > a').text;

          Element rowSmall = children[i].querySelector('table > tbody > tr');
          String room = rowSmall.querySelector('td > a').text;
          String teacher = rowSmall.querySelector('td > acronym > a').text;

          String typeClass = clsName;
          int blocks  = int.parse(children[i].attributes['rowspan']);
          String startTime = children[0].text.substring(0, 5);

          semana[day] += blocks;

          Lecture lect = new Lecture(subject, typeClass, day, startTime, blocks, room, teacher);
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
  static var dayName = ["Segunda-feira", "Terça-feira", "Quarta-feira", "Quinta-feira", "Sexta-feira", "Sábado", "Domingo"];
  String subject;
  String startTime;
  String endTime;
  String typeClass;
  String room;
  String teacher;
  int day;
  int blocks;

  Lecture(String subject, String typeClass, int day, String startTime, int blocks, String room, String teacher){
    this.subject = subject;
    this.typeClass = typeClass;
    this.room = room;
    this.teacher = teacher;
    this.day = day;
    this.blocks = blocks;

    int hour = int.parse(startTime.substring(0,2));
    int min = int.parse(startTime.substring(3,5));
    this.startTime = hour.toString().padLeft(2, '0') + 'h' + min.toString().padLeft(2, '0');
    min += blocks*30;
    hour += min~/60;
    min %= 60;
    this.endTime = hour.toString().padLeft(2, '0') + 'h' + min.toString().padLeft(2, '0');
  }

  static Lecture clone(Lecture lec){
    return Lecture(lec.subject, lec.typeClass, lec.day, lec.startTime, lec.blocks, lec.room, lec.teacher);
  }

  printLecture(){
    print(subject + " " + typeClass);
    print(dayName[day] + " " + startTime + " " + endTime + " " + blocks.toString() + " blocos");
    print(room + "  " + teacher + "\n");
  }

  int compare(Lecture other) {
    if (day == other.day){
      return startTime.compareTo(other.startTime);
    } else {
      return day.compareTo(other.day);
    }
  }
}
