import 'package:collection/collection.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';

List<CourseUnit> parseCourseUnitsAndCourseAverage(
  http.Response response,
  Course course, {
  List<CourseUnit>? currentCourseUnits,
}) {
  final document = parse(response.body);
  final table = document.getElementById('tabelapercurso');
  if (table == null) {
    return [];
  }

  final labels = document.querySelectorAll('.caixa .formulario-legenda');
  if (labels.length >= 2) {
    course.currentAverage ??= num.tryParse(
      labels[0].nextElementSibling?.innerHtml.replaceFirst(',', '.') ?? '0',
    );
    course.finishedEcts ??= num.tryParse(
      labels[1].nextElementSibling?.innerHtml.replaceFirst(',', '.') ?? '0',
    );
  }

  final firstSchoolYearData =
      table.querySelector('tr')?.children[1].text.trim();
  if (firstSchoolYearData == null) {
    return [];
  }
  final firstSchoolYear = int.parse(
    firstSchoolYearData.substring(0, firstSchoolYearData.indexOf('/')),
  );

  // Each row contains:
  // ANO PERIODO CODIGO NOME OPCAO/MINOR CREDITOS RESULTADO ESTADO
  final courseUnits = <CourseUnit>[];
  final rows = table.querySelectorAll('tr.i, tr.p');

  for (final row in rows) {
    // Skip non regular course units (such as undiscriminated ucs)
    if (int.parse(row.children[0].attributes['colspan'] ?? '1') > 1) {
      continue;
    }

    final year = row.children[0].innerHtml;
    final semester = row.children[1].innerHtml;
    final occurId = Uri.parse(
      row.children[2].firstChild!.attributes['href']!,
    ).queryParameters['pv_ocorrencia_id']!;
    final codeName = row.children[2].children[0].innerHtml;
    final name = row.children[3].children[0].innerHtml;
    final ects = row.children[5].innerHtml.replaceAll(',', '.');

    var yearIncrement = -1;
    for (var i = 0;; i += 2) {
      if (row.children.length <= 6 + i) {
        break;
      }
      yearIncrement++;
      final status =
          row.children[7 + i].innerHtml.replaceAll('&nbsp;', ' ').trim();
      final grade =
          row.children[6 + i].innerHtml.replaceAll('&nbsp;', ' ').trim();

      if (status.isEmpty) {
        continue;
      }

      final matchingCurrentCourseUnit = currentCourseUnits
          ?.firstWhereOrNull((element) => element.code == codeName);

      final courseUnit = CourseUnit(
        schoolYear:
            '${firstSchoolYear + yearIncrement}/${firstSchoolYear + yearIncrement + 1}',
        occurrId: int.parse(occurId),
        code: codeName,
        abbreviation: matchingCurrentCourseUnit?.abbreviation ??
            codeName, // FIXME: this is not the abbreviation
        status: status,
        grade: grade,
        ects: double.tryParse(ects),
        name: name,
        curricularYear: int.tryParse(year),
        semesterCode: semester,
      );
      courseUnits.add(courseUnit);
    }
  }

  return courseUnits;
}
