import 'package:collection/collection.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';

Map<String, int> _parseOccurIdsFromCurricularUnits(Document? document) {
  final map = <String, int>{};
  if (document == null) {
    return map;
  }

  final headers = document.querySelectorAll('h3');
  for (final header in headers) {
    final yearText = header.text.trim();
    if (!RegExp(r'\d{4}\s*/\s*\d{4}').hasMatch(yearText)) {
      continue;
    }
    final schoolYear = RegExp(
      r'\d{4}\s*/\s*\d{4}',
    ).firstMatch(yearText)!.group(0)!.replaceAll(' ', '');

    Element? table = header.nextElementSibling;
    while (table != null && table.localName != 'table') {
      table = table.nextElementSibling;
    }
    if (table == null) {
      continue;
    }

    for (final row in table.querySelectorAll('tr')) {
      final codeAnchor = row.querySelector('td a') ?? row.querySelector('a');
      if (codeAnchor == null) {
        continue;
      }
      final codeName = codeAnchor.text.trim();
      final href = codeAnchor.attributes['href'];
      if (href == null) {
        continue;
      }
      final uri = Uri.tryParse(href);
      if (uri == null) {
        continue;
      }
      final occ = uri.queryParameters['pv_ocorrencia_id'];
      if (occ == null) {
        continue;
      }
      final occInt = int.tryParse(occ);
      if (occInt == null) {
        continue;
      }

      final key = '$codeName|$schoolYear';
      map.putIfAbsent(key, () => occInt);
    }
  }

  return map;
}

List<CourseUnit> parseCourseUnitsAndCourseAverage(
  http.Response responseAcademicPath,
  http.Response? responseCurricularUnits,
  Course course, {
  List<CourseUnit>? currentCourseUnits,
}) {
  final documentAcademicPath = parse(responseAcademicPath.body);
  final documentCurricularUnits = parse(responseCurricularUnits?.body);
  final occurIdMap = _parseOccurIdsFromCurricularUnits(documentCurricularUnits);
  final table = documentAcademicPath.getElementById('tabelapercurso');
  if (table == null) {
    return [];
  }

  final labels = documentAcademicPath.querySelectorAll(
    '.caixa .formulario-legenda',
  );
  if (labels.length >= 2) {
    course.currentAverage ??= double.tryParse(
      labels[0].nextElementSibling?.innerHtml.replaceFirst(',', '.') ?? '0',
    );
    course.finishedEcts ??= double.tryParse(
      labels[1].nextElementSibling?.innerHtml.replaceFirst(',', '.') ?? '0',
    );
  }

  final firstSchoolYearData = table
      .querySelector('tr')
      ?.children[1]
      .text
      .trim();
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
    final rawHref = row.children[2].firstChild!.attributes['href']!;
    final originalOccurId = Uri.parse(
      rawHref,
    ).queryParameters['pv_ocorrencia_id']!;
    final codeName = row.children[2].children[0].innerHtml;
    final name = row.children[3].children[0].innerHtml;
    final ects = row.children[5].innerHtml.replaceAll(',', '.');

    var yearIncrement = -1;
    for (var i = 0; ; i += 2) {
      if (row.children.length <= 6 + i) {
        break;
      }
      yearIncrement++;
      final status = row.children[7 + i].innerHtml
          .replaceAll('&nbsp;', ' ')
          .trim();
      final grade = row.children[6 + i].innerHtml
          .replaceAll('&nbsp;', ' ')
          .trim();

      if (status.isEmpty) {
        continue;
      }

      final matchingCurrentCourseUnit = currentCourseUnits?.firstWhereOrNull(
        (element) => element.code == codeName,
      );

      final schoolYear =
          '${firstSchoolYear + yearIncrement}/${firstSchoolYear + yearIncrement + 1}';
      final mappingKey = '$codeName|$schoolYear';
      final finalOccurIdStr =
          occurIdMap[mappingKey]?.toString() ?? originalOccurId;

      final courseUnit = CourseUnit(
        schoolYear: schoolYear,
        occurrId: int.parse(finalOccurIdStr),
        code: codeName,
        abbreviation: matchingCurrentCourseUnit?.abbreviation ?? codeName,
        status: status,
        grade: grade,
        ects: double.tryParse(ects),
        name: name,
        curricularYear: int.tryParse(year),
        semesterCode: semester,
        festId: course.festId,
      );
      courseUnits.add(courseUnit);
    }
  }

  return courseUnits;
}
