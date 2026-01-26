import 'dart:async';

import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/exam.dart';

/// Parses information about the user's exams.
class ParserExams {
  static final _timeRangeRegex = RegExp(r'(\d{2}:\d{2})-(\d{2}:\d{2})');

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
  Future<Set<Exam>> parseExams(http.Response response, CourseUnit uc) async {
    final document = parse(response.body);

    final parsedExams = <Exam>[];
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
              if (examsDay.querySelector('a') != null) {
                subjectAcronym = examsDay.querySelector('a')!.text;
                subject = examsDay.querySelector('a')!.attributes['title'];
                final href = examsDay.querySelector('a')!.attributes['href']!;
                id = Uri.parse(href).queryParameters['p_exa_id']!;
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
                final match = _timeRangeRegex.allMatches(examsDay.text).first;
                begin = DateTime.parse('${dates[days]} ${match.group(1)!}');
                end = DateTime.parse('${dates[days]} ${match.group(2)!}');
              } else {
                begin = DateTime.parse('${dates[days]} 00:00');
                end = DateTime.parse('${dates[days]} 00:00');
              }
              parsedExams.add(
                Exam(
                  id,
                  begin,
                  end,
                  subjectAcronym ?? '',
                  subject ?? '',
                  List.from(rooms),
                  examTypes[tableNum],
                  uc.occurrId.toString()
                ),
              );
            }
          }
          days++;
        }
      }
      tableNum++;
    }

    final occurrIdFutures = <String, Future<String?>>{};
    final occurrIdResults = <String, String?>{};
    await Future.wait(
      occurrIdFutures.entries.map((entry) async {
        occurrIdResults[entry.key] = await entry.value;
      }),
    );

    final examsList = <Exam>{};
    for (final exam in parsedExams) {
      examsList.add(
        Exam(
          exam.id,
          exam.start,
          exam.finish,
          exam.subjectAcronym,
          exam.subject,
          exam.rooms,
          exam.examType,
          exam.occurrId,
        ),
      );
    }

    return examsList;
  }
}
