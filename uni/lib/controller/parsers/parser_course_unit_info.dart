import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:uni/model/entities/course_units/course_unit_class.dart';
import 'package:uni/model/entities/course_units/course_unit_sheet.dart';

Future<CourseUnitSheet> parseCourseUnitSheet(http.Response response) async {
  final document = parse(response.body);
  final titles = document.querySelectorAll('#conteudoinner h3');
  final Map<String, String> sections = {};

  for (var title in titles) {
    try {
      sections[title.text] = _htmlAfterElement(response.body, title.outerHtml);
    } catch (_) {
      continue;
    }
  }

  return CourseUnitSheet(sections);
}

Future<List<CourseUnitClass>> parseCourseUnitClasses(
    http.Response response) async {
  return [
    CourseUnitClass(["José", "Gomes"]),
    CourseUnitClass(["Mendes", "Pereira"]),
  ];
}

/*String _parseGeneralDescription(Element titleElement, String body) {
  final String htmlDescription =
      _htmlAfterElement(body, titleElement.outerHtml);
  final doc = parse(htmlDescription);
  return parse(doc.body.text).documentElement.text;
}*/

String _htmlAfterElement(String body, String elementOuterHtml) {
  final int index = body.indexOf(elementOuterHtml) + elementOuterHtml.length;
  return body.substring(index, body.indexOf('<h3>', index));
}
