import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Lecture>> parseSchedule(http.Response response) async {


  List<Lecture> lecturesList = new List();

  var json = jsonDecode(response.body);

  var schedule = json['horario'];

  for (var lecture in schedule) {
    int day = (lecture['dia'] - 2) % 7;   // Api: monday = 2, Lecture class: monday = 0
    int secBegin = lecture['hora_inicio'];
    String subject = lecture['ucurr_sigla'];
    String typeClass = lecture['tipo'];
    int blocks = (lecture['aula_duracao'] * 2).round();  // Each block represents 30 minutes, Api uses float representing hours
    String room = lecture['sala_sigla'];
    String teacher = lecture['doc_sigla'];

    lecturesList.add(Lecture(subject, typeClass, day, secBegin, blocks, room, teacher));
  }

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
  int startTimeSeconds;

  Lecture(String subject, String typeClass, int day, int startTimeSeconds, int blocks, String room, String teacher){
    this.subject = subject;
    this.typeClass = typeClass;
    this.room = room;
    this.teacher = teacher;
    this.day = day;
    this.blocks = blocks;
    this.startTimeSeconds = startTimeSeconds;

    this.startTime = (startTimeSeconds~/3600).toString().padLeft(2, '0') + 'h' + ((startTimeSeconds%3600)~/60).toString().padLeft(2, '0');
    startTimeSeconds += 60*30*blocks;
    this.endTime = (startTimeSeconds~/3600).toString().padLeft(2, '0') + 'h' + ((startTimeSeconds%3600)~/60).toString().padLeft(2, '0');
  }

  static Lecture clone(Lecture lec){
    return Lecture(lec.subject, lec.typeClass, lec.day, lec.startTimeSeconds, lec.blocks, lec.room, lec.teacher);
  }

  Map<String, dynamic> toMap() {
    return {
      'subject': subject,
      'typeClass': typeClass,
      'day': day,
      'startTimeSeconds': startTimeSeconds,
      'blocks': blocks,
      'room': room,
      'teacher': teacher,
    };
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
