import 'dart:async';

import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
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
    String? subject;
    var id = '0';
    var days = 0;
    var tableNum = 0;
    document.querySelectorAll('h3').forEach((examType) {
      examTypes.add(getExamSeasonAbbr(examType.text));
    });

    document
        .querySelectorAll('div > table > tbody > tr > td')
        .forEach((element) {
      element.querySelectorAll('table:not(.mapa)').forEach((table) {
        table.querySelectorAll('span.exame-data').forEach((date) {
          dates.add(date.text);
        });
        table.querySelectorAll('td.l.k').forEach((exams) {
          if (exams.querySelector('td.exame') != null) {
            exams.querySelectorAll('td.exame').forEach((examsDay) {
              if (examsDay.querySelector('a') != null) {
                subject = examsDay.querySelector('a')!.text;
                id = Uri.parse(examsDay.querySelector('a')!.attributes['href']!)
                    .queryParameters['p_exa_id']!;
              }
              if (examsDay.querySelector('span.exame-sala') != null) {
                rooms = examsDay
                    .querySelector('span.exame-sala')!
                    .text
                    .split(',')
                    .map((e) => e.trim())
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
                subject ?? '',
                rooms,
                examTypes[tableNum],
                course.faculty!,
              );
              examsList.add(exam);
            });
          }
          days++;
        });
      });
      tableNum++;
    });
    return examsList;
  }
}
