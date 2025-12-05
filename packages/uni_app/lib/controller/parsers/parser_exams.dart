import 'dart:async';

import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/exam.dart';

/// Parses information about the user's exams.
class ParserExams {
  /// Returns the abbreviature of the exam season.
  ///
  /// If an abbreviature doesn't exist, a '?' is returned.
  String getExamSeasonAbbr(String seasonStr) {
    for (final type in Exam.types.keys) {
      if (seasonStr.contains(type)) {
        return Exam.types[type]!;
      }
    }
    return '?';
  }

  /// Extracts a list of exams from an HTTP [response].
  Future<Set<Exam>> parseExams(http.Response response, Course course) async {
    final document = parse(response.body);

    final examsList = <Exam>{};
    final dates = <String>[];
    final examTypes = <String>[];
    var rooms = <String>[];
    String? subjectAcronym;
    String? subject;
    var id = '0';
    var days = 0;
    var tableNum = 0;
    document.querySelectorAll('h3').forEach((examType) {
      examTypes.add(getExamSeasonAbbr(examType.text));
    });

    final tdElements = document.querySelectorAll(
      'div > table > tbody > tr > td',
    );
    for (final element in tdElements) {
      final tables = element.querySelectorAll('table:not(.mapa)');
      for (final table in tables) {
        final dateSpans = table.querySelectorAll('span.exame-data');
        for (final date in dateSpans) {
          dates.add(date.text);
        }
        final examTds = table.querySelectorAll('td.l.k');
        for (final exams in examTds) {
          if (exams.querySelector('td.exame') != null) {
            final examsDays = exams.querySelectorAll('td.exame');
            for (final examsDay in examsDays) {
              String? localOccurrId;
              if (examsDay.querySelector('a') != null) {
                subjectAcronym = examsDay.querySelector('a')!.text;
                subject = examsDay.querySelector('a')!.attributes['title'];
                final href = examsDay.querySelector('a')!.attributes['href']!;
                id = Uri.parse(href).queryParameters['p_exa_id']!;
                try {
                  final detailsUrl =
                      '${NetworkRouter.getBaseUrl(course.faculty!)}exa_geral.exame_view?p_exa_id=$id';
                  final detailsResponse = await http.get(Uri.parse(detailsUrl));
                  final detailsDoc = parse(detailsResponse.body);
                  final matchingRows = detailsDoc
                      .querySelectorAll('td.formulario-legenda')
                      .where((td) => td.text.trim() == 'Código:');
                  final codigoRow =
                      matchingRows.isNotEmpty ? matchingRows.first : null;
                  if (codigoRow != null) {
                    final codeTd = codigoRow.nextElementSibling;
                    if (codeTd != null) {
                      final codeLink = codeTd.querySelector('a');
                      if (codeLink != null) {
                        final codeHref = codeLink.attributes['href'];
                        final occurrMatch = RegExp(
                          r'pv_ocorrencia_id=(\d+)',
                        ).firstMatch(codeHref ?? '');
                        if (occurrMatch != null) {
                          localOccurrId = occurrMatch.group(1);
                        }
                      }
                    }
                  }
                } catch (e) {
                  localOccurrId = null;
                }
              }
              if (examsDay.querySelector('span.exame-sala') != null) {
                rooms =
                    examsDay
                        .querySelector('span.exame-sala')!
                        .text
                        .split(',')
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty)
                        .toList();
              }
              final DateTime begin;
              final DateTime end;
              if (!examsDay.text.endsWith('-')) {
                final rx = RegExp(r'(\d{2}:\d{2})-(\d{2}:\d{2})');
                final match = rx.allMatches(examsDay.text).first;
                begin = DateTime.parse('${dates[days]} ${match.group(1)!}');
                end = DateTime.parse('${dates[days]} ${match.group(2)!}');
              } else {
                begin = DateTime.parse('${dates[days]} 00:00');
                end = DateTime.parse('${dates[days]} 00:00');
              }
              final exam = Exam(
                id,
                begin,
                end,
                subjectAcronym ?? '',
                subject ?? '',
                rooms,
                examTypes[tableNum],
                course.faculty!,
                occurrId: localOccurrId,
              );
              examsList.add(exam);
            }
          }
          days++;
        }
      }
      tableNum++;
    }
    return examsList;
  }
}
