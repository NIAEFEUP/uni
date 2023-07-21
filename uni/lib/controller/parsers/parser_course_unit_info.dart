import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:uni/model/entities/course_units/course_unit_class.dart';
import 'package:uni/model/entities/course_units/course_unit_sheet.dart';

Future<CourseUnitSheet> parseCourseUnitSheet(http.Response response) async {
  final document = parse(response.body);
  final titles = document.querySelectorAll('#conteudoinner h3');
  final sections = <String, String>{};

  for (final title in titles) {
    try {
      sections[title.text] = _htmlAfterElement(response.body, title.outerHtml);
    } catch (_) {
      continue;
    }
  }

  return CourseUnitSheet(sections);
}

List<CourseUnitClass> parseCourseUnitClasses(
  http.Response response,
  String baseUrl,
) {
  final classes = <CourseUnitClass>[];
  final document = parse(response.body);
  final titles = document.querySelectorAll('#conteudoinner h3').sublist(1);

  for (final title in titles) {
    final table = title.nextElementSibling;
    final className = title.innerHtml.substring(
      title.innerHtml.indexOf(' ') + 1,
      title.innerHtml.indexOf('&'),
    );

    final rows = table?.querySelectorAll('tr');
    if (rows == null || rows.length < 2) {
      continue;
    }

    final studentRows = rows.sublist(1);
    final students = <CourseUnitStudent>[];

    for (final row in studentRows) {
      final columns = row.querySelectorAll('td.k.t');
      final studentName = columns[0].children[0].innerHtml;
      final studentNumber = int.tryParse(columns[1].innerHtml.trim()) ?? 0;
      final studentMail = columns[2].innerHtml;

      final studentPhoto = Uri.parse(
        '${baseUrl}fotografias_service.foto?pct_cod=$studentNumber',
      );
      final studentProfile = Uri.parse(
        '${baseUrl}fest_geral.cursos_list?pv_num_unico=$studentNumber',
      );
      students.add(
        CourseUnitStudent(
          studentName,
          studentNumber,
          studentMail,
          studentPhoto,
          studentProfile,
        ),
      );
    }

    classes.add(CourseUnitClass(className, students));
  }

  return classes;
}

String _htmlAfterElement(String body, String elementOuterHtml) {
  final index = body.indexOf(elementOuterHtml) + elementOuterHtml.length;
  return body.substring(index, body.indexOf('<h3>', index));
}
