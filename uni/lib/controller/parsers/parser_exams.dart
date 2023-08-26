import 'dart:async';

import 'package:html/dom.dart';
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
      if (seasonStr.contains(type)) return Exam.types[type]!;
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
    String? schedule;
    var id = '0';
    var days = 0;
    var tableNum = 0;
    document.querySelectorAll('h3').forEach((Element examType) {
      examTypes.add(getExamSeasonAbbr(examType.text));
    });

    document
        .querySelectorAll('div > table > tbody > tr > td')
        .forEach((Element element) {
      element.querySelectorAll('table:not(.mapa)').forEach((Element table) {
        table.querySelectorAll('span.exame-data').forEach((Element date) {
          dates.add(date.text);
        });
        table.querySelectorAll('td.l.k').forEach((Element exams) {
          if (exams.querySelector('td.exame') != null) {
            exams.querySelectorAll('td.exame').forEach((Element examsDay) {
              if (examsDay.querySelector('a') != null) {
                subject = examsDay.querySelector('a')!.text;
                id = Uri.parse(examsDay.querySelector('a')!.attributes['href']!)
                    .queryParameters['p_exa_id']!;
              }
              if (examsDay.querySelector('span.exame-sala') != null) {
                rooms =
                    examsDay.querySelector('span.exame-sala')!.text.split(',');
              }
              schedule = examsDay.text.substring(
                examsDay.text.indexOf(':') - 2,
                examsDay.text.indexOf(':') + 9,
              );
              final splittedSchedule = schedule!.split('-');
              final begin =
                  DateTime.parse('${dates[days]} ${splittedSchedule[0]}');
              final end =
                  DateTime.parse('${dates[days]} ${splittedSchedule[1]}');
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
