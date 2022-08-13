import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:uni/model/entities/course.dart';
import 'package:uni/utils/url_parser.dart';

List<Course> parseMultipleCourses(List<http.Response> responses) {
  final List<Course> courses = [];
  for (var response in responses) {
    courses.addAll(_parseCourses(response));
  }
  return courses;
}

List<Course> _parseCourses(http.Response response) {
  final document = parse(response.body);
  final List<Course> courses = [];

  String? faculty = response.request?.url.toString();
  faculty =
      faculty?.substring(faculty.indexOf('up.pt/')).replaceFirst('up.pt/', '');
  faculty = faculty?.substring(0, faculty.indexOf('/')).trim();

  final currentCourses =
      document.querySelectorAll('.estudantes-caixa-lista-cursos > div');
  for (int i = 0; i < currentCourses.length; i++) {
    final div = currentCourses[i];
    final courseName =
        div.querySelector('.estudante-lista-curso-nome > a')?.text;
    final courseUrl = div
        .querySelector('.estudante-lista-curso-nome > a')
        ?.attributes['href'];
    final courseId = getUrlQueryParameters(courseUrl ?? '')['pv_curso_id'];
    final courseState = div.querySelectorAll('.formulario td')[3].text;
    final courseFestId = div
        .querySelector('.estudante-lista-curso-detalhes > a')
        ?.attributes['href']
        ?.replaceFirst(
            'fest_geral.curso_percurso_academico_view?pv_fest_id=', '')
        .trim();
    courses.add(Course(
        faculty: faculty,
        id: int.parse(courseId ?? '0'),
        state: courseState,
        name: courseName ?? '',
        festId: int.parse(courseFestId ?? '0')));
  }

  final oldCourses =
      document.querySelectorAll('.tabela-longa .i, .tabela-longa .p');
  for (int i = 0; i < oldCourses.length; i++) {
    final div = oldCourses[i];
    final courseName = div.children[0].firstChild?.text?.trim();
    final courseUrl = div.querySelector('a')?.attributes['href'];
    final courseId = getUrlQueryParameters(courseUrl ?? '')['pv_curso_id'];
    var courseFirstEnrollment = div.children[4].text;
    courseFirstEnrollment = courseFirstEnrollment
        .substring(0, courseFirstEnrollment.indexOf('/'))
        .trim();
    final courseState = div.children[5].text;
    final courseFestId = getUrlQueryParameters(
        div.children[6].firstChild?.attributes['href'] ?? '')['pv_fest_id'];
    courses.add(Course(
        firstEnrollment: int.parse(courseFirstEnrollment),
        faculty: faculty,
        id: int.parse(courseId ?? '0'),
        state: courseState,
        name: courseName ?? '',
        festId: int.parse(courseFestId ?? '0')));
  }

  return courses;
}
