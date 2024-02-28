import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:logger/logger.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/entities/lecture.dart';

Future<List<Lecture>> parseScheduleMultipleRequests(
  List<Tuple2<Tuple2<DateTime, DateTime>, Response>> responses,
) async {
  var lectures = <Lecture>[];
  for (final response in responses) {
    lectures += await parseSchedule(response.item2, response.item1);
  }
  return lectures;
}

/// Extracts the user's lectures from an HTTP [response] and sorts them by
/// date.
///
/// This function parses a JSON object.
Future<List<Lecture>> parseSchedule(
  http.Response response,
  Tuple2<DateTime, DateTime> week,
) async {
  final lectures = <Lecture>{};

  final json = jsonDecode(response.body) as Map<String, dynamic>;

  final schedule = json['horario'] as List<dynamic>;
  for (var lecture in schedule) {
    lecture = lecture as Map<String, dynamic>;

    final startTime = week.item1.add(
      Duration(
        days: (lecture['dia'] as int) - 1,
        seconds: lecture['hora_inicio'] as int,
      ),
    );

    final subject = lecture['ucurr_sigla'] as String;
    final typeClass = lecture['tipo'] as String;

    // Note: aula_duracao is an integer when the lecture is 1 hour long
    // or 2 hours long and so on. When the lecture is 1.5 hours long, it
    // returns a double, with the value 1.5.
    final lectureDuration = lecture['aula_duracao'];
    final blocks = lectureDuration is double
        ? (lectureDuration * 2).toInt()
        : (lectureDuration as int) * 2;

    final room =
        (lecture['sala_sigla'] as String).replaceAll(RegExp(r'\+'), '\n');
    final teacher = lecture['doc_sigla'] as String;
    final classNumber = lecture['turma_sigla'] as String;
    final occurrId = lecture['ocorrencia_id'] as int;

    final lec = Lecture.fromApi(
      subject,
      typeClass,
      startTime,
      blocks,
      room,
      teacher,
      classNumber,
      occurrId,
    );

    Logger().d('On week $week, found $lec');

    lectures.add(lec);
  }

  final lecturesList = lectures.toList()..sort((a, b) => a.compare(b));

  if (lecturesList.isEmpty) {
    return Future.error(Exception('Found empty schedule'));
  }

  return lecturesList;
}
