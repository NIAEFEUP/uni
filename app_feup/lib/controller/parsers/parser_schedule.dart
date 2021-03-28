import 'package:uni/model/entities/lecture.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Lecture>> parseSchedule(http.Response response) async {
  final Set<Lecture> lectures = Set();

  final json = jsonDecode(response.body);

  final schedule = json['horario'];

  for (var lecture in schedule) {
    final int day = (lecture['dia'] - 2) %
        7; // Api: monday = 2, Lecture.dart class: monday = 0
    final int secBegin = lecture['hora_inicio'];
    final String subject = lecture['ucurr_sigla'];
    final String typeClass = lecture['tipo'];
    final int blocks = (lecture['aula_duracao'] * 2).round();
    final String room = lecture['sala_sigla'].replaceAll(RegExp('\\+'), '\n');
    final String teacher = lecture['doc_sigla'];

    lectures
        .add(Lecture(subject, typeClass, day, secBegin, blocks, room, teacher));
  }

  final lecturesList = lectures.toList();

  lecturesList.sort((a, b) => a.compare(b));

  return lecturesList;
}
