import 'dart:convert';

import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:uni/controller/parsers/schedule/new_api/models/response_lecture.dart';
import 'package:uni/model/entities/lecture.dart';

/// Extracts the user's lecture API URL.
///
/// This function parses the schedule's HTML page.
String? getScheduleApiUrlFromHtml(
  http.Response response,
) {
  final document = parse(response.body);

  final scheduleElement = document.querySelector('#cal-shadow-container');
  final apiUrl = scheduleElement?.attributes['data-evt-source-url'];

  return apiUrl;
}

List<Lecture> getLecturesFromApiResponse(
  http.Response response,
) {
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  final data = json['data'] as List<dynamic>;

  return data
      .cast<Map<String, dynamic>>()
      .map(ResponseLecture.fromJson)
      .map(
        (lecture) => Lecture(
          lecture.units.first.acronym,
          lecture.typology.acronym,
          lecture.start,
          lecture.end,
          lecture.rooms.first.name,
          lecture.persons.map((person) => person.acronym).join('+'),
          lecture.classes.length > 1
              ? '${lecture.classes.first.acronym} + ${lecture.classes.length - 1}'
              : lecture.classes.first.acronym,
          lecture.units.first.sigarraId,
        ),
      )
      .toList();
}
