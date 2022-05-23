import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uni/model/entities/lecture.dart';

/// Extracts the user's lectures from an HTTP [response] and sorts them by
/// date.
///
/// This function parses a JSON object.
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
    final String classNumber = lecture['turma_sigla'];

    lectures.add(Lecture.fromApi(
        subject, typeClass, day, secBegin, blocks, room, teacher, classNumber));
  }

  final lecturesList = lectures.toList();

  lecturesList.sort((a, b) => a.compare(b));

  if (lecturesList.isEmpty) {
    return Future.error(Exception('Found empty schedule'));
  } else {
    return lecturesList;
  }
}
