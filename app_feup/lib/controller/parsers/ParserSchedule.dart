import 'dart:async';
import 'package:app_feup/model/entities/Lecture.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Lecture>> parseSchedule(http.Response response) async {


  List<Lecture> lecturesList = new List();

  var json = jsonDecode(response.body);

  var schedule = json['horario'];

  for (var lecture in schedule) {
    int day = (lecture['dia'] - 2) % 7;   // Api: monday = 2, Lecture.dart class: monday = 0
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