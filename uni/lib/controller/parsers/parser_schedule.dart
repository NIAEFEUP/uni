import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uni/model/entities/lecture.dart';

Future<List<Lecture>> parseScheduleMultipleRequests(responses) async {
  List<Lecture> lectures = [];
  for (var response in responses) {
    lectures += await parseSchedule(response);
  }
  return lectures;
}
/// Extracts the user's lectures from an HTTP [response] and sorts them by
/// date.
///
/// This function parses a JSON object.
Future<List<Lecture>> parseSchedule(http.Response response) async {
  final Set<Lecture> lectures = {};

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
    final int occurrId = lecture['ocorrencia_id'];

    lectures.add(Lecture.fromApi(subject, typeClass, day, secBegin, blocks,
        room, teacher, classNumber, occurrId));
  }

  final lecturesList = lectures.toList();

  lecturesList.sort((a, b) => a.compare(b));

  if (lecturesList.isEmpty) {
    return Future.error(Exception('Found empty schedule'));
  } else {
    return lecturesList;
  }
}
