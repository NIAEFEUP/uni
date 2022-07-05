import 'dart:collection';

import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

Map<String, String> parseMultipleCourses(List<http.Response> responses) {
  final Map<String, String> coursesStates = HashMap();
  responses.forEach((response) {
    final map = parseCourses(response);
    coursesStates.addAll(map);
  });
  return coursesStates;
}

/// Extracts a map containing information about the user's courses from an HTTP
/// [response].
///
/// *Note:*
/// * a key in this map is the name of a course
/// * a value in this map is the state of the corresponding course
Map<String, String> parseCourses(http.Response response) {
  final document = parse(response.body);

  final Map<String, String> coursesStates = HashMap();

  final courses =
      document.querySelectorAll('.estudantes-caixa-lista-cursos > div');

  for (int i = 0; i < courses.length; i++) {
    final div = courses[i];
    final course = div.querySelector('.estudante-lista-curso-nome > a').text;
    final state = div.querySelectorAll('.formulario td')[3].text;

    coursesStates.putIfAbsent(course, () => state);
  }

  return coursesStates;
}
