import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/course_unit.dart';

List<CourseUnit> parseCourseUnitsAndCourseAverage(
    http.Response response, Course course) {
  final document = parse(response.body);
  final table = document.getElementById('tabelapercurso');
  if (table == null) {
    return [];
  }

  final labels = document.querySelectorAll('.caixa .formulario-legenda');
  if (labels.length >= 2) {
    course.currentAverage ??= num.parse(
        labels[0].nextElementSibling?.innerHtml.replaceFirst(',', '.') ?? '0');
    course.finishedEcts ??= num.parse(
        labels[1].nextElementSibling?.innerHtml.replaceFirst(',', '.') ?? '0');
  }

  final String? firstSchoolYearData =
      table.querySelector('tr')?.children[1].text.trim();
  if (firstSchoolYearData == null) {
    return [];
  }
  final int firstSchoolYear = int.parse(
      firstSchoolYearData.substring(0, firstSchoolYearData.indexOf('/')));

  // Each row contains:
  // ANO PERIODO CODIGO NOME OPCAO/MINOR CREDITOS RESULTADO ESTADO
  final List<CourseUnit> courseUnits = [];
  final rows = table.querySelectorAll('tr.i, tr.p');

  for (final row in rows) {
    final String year = row.children[0].innerHtml;
    final String semester = row.children[1].innerHtml;
    final String? occurId = row.children[2].firstChild?.attributes['href']
        ?.replaceFirst('ucurr_geral.ficha_uc_view?pv_ocorrencia_id=', '');
    final String codeName = row.children[2].children[0].innerHtml;
    final String name = row.children[3].children[0].innerHtml;
    final String ects = row.children[5].innerHtml.replaceAll(',', '.');
    String grade = '-', result = '-';
    int yearIncrement = 0;
    for (var i = 0;; i += 2, yearIncrement++) {
      if (row.children.length <= 6 + i) {
        break;
      }
      grade = row.children[6 + i].innerHtml;
      if (grade.replaceAll('&nbsp;', ' ').trim() != '') {
        result = row.children[7 + i].innerHtml;
        break;
      }
    }

    CourseUnit courseUnit = CourseUnit(
        schoolYear:
            '${firstSchoolYear + yearIncrement}/${firstSchoolYear + yearIncrement + 1}',
        occurrId: occurId != null ? int.parse(occurId) : 0,
        abbreviation: codeName,
        result: result,
        grade: grade,
        ects: double.parse(ects),
        name: name,
        curricularYear: int.parse(year),
        semesterCode: semester);
    courseUnits.add(courseUnit);
  }

  return courseUnits;
}
