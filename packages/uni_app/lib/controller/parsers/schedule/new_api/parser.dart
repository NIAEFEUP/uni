import 'dart:convert';

import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:uni/controller/parsers/schedule/new_api/models/response_lecture.dart';
import 'package:uni/model/entities/lecture.dart';

/// Extracts the user's lecture API URL.
///
/// This function parses the schedule's HTML page.
String? getScheduleApiUrlFromHtml(http.Response response) {
  final document = parse(response.body);

  final scheduleElement = document.querySelector('#cal-shadow-container');
  final apiUrl = scheduleElement?.attributes['data-evt-source-url'];

  return apiUrl;
}

List<Lecture> getLecturesFromApiResponse(http.Response response) {
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  final data = json['data'] as List<dynamic>;

  return data
      .cast<Map<String, dynamic>>()
      .map(ResponseLecture.fromJson)
      .map(
        (lecture) => Lecture(
          lecture.units.first.acronym,
          _filterSubjectName(lecture.units.first.name),
          lecture.typology.acronym,
          lecture.start,
          lecture.end,
          lecture.rooms.first.name,
          lecture.persons.map((person) => person.acronym).join('+'),
          _filterTeacherName(lecture.persons.first.name),
          _filterTeacherCode(lecture.persons.first.name),
          lecture.classes.length > 1
              ? '${lecture.classes.first.acronym} + ${lecture.classes.length - 1}'
              : lecture.classes.first.acronym,
          lecture.units.first.sigarraId,
        ),
      )
      .toList();
}

String _filterSubjectName(String subject) {
  return RegExp(r' - ([^()]*)(?: \(|$)').firstMatch(subject)?.group(1) ??
      subject;
}

int _filterTeacherCode(String name) {
  final match = RegExp(r'^(\d+)').firstMatch(name);
  return match != null ? int.parse(match.group(1)!) : 0;
}

String _filterTeacherName(String name) {
  final match = RegExp(r' - (.+)$').firstMatch(name);
  return match != null ? match.group(1)! : name;
}
