import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/utils/time/week.dart';
import 'package:uni/model/utils/time/weekday_mapper.dart';

Future<List<Lecture>> parseScheduleMultipleRequests(
  List<(Week, http.Response)> responsesPerWeeks,
) async {
  var lectures = <Lecture>[];
  for (final (week, response) in responsesPerWeeks) {
    lectures += await parseSchedule(response, week);
  }

  if (lectures.isEmpty) {
    return Future.error(Exception('Found empty schedule'));
  }

  return lectures;
}

/// Extracts the user's lectures from an HTTP [response] and sorts them by
/// date.
///
/// This function parses a JSON object.
Future<List<Lecture>> parseSchedule(
  http.Response response,
  Week week,
) async {
  final lectures = <Lecture>{};

  final json = jsonDecode(response.body) as Map<String, dynamic>;

  final schedule = json['horario'] as List<dynamic>;
  for (var lecture in schedule) {
    lecture = lecture as Map<String, dynamic>;

    final startTime = week
        .getWeekday(WeekdayMapper.fromSigarraToDart.map(lecture['dia'] as int))
        .add(
          Duration(
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

    lectures.add(lec);
  }

  return lectures.toList()..sort((a, b) => a.compare(b));
}
