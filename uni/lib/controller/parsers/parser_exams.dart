import 'dart:async';

import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:uni/model/entities/exam.dart';

/// Parses information about the user's exams.
class ParserExams {
  /// Returns the abbreviature of the exam season.
  ///
  /// If an abbreviature doesn't exist, a '?' is returned.
  String getExamSeasonAbbr(String seasonStr) {
    for (String type in Exam.types.keys) {
      if (seasonStr.contains(type)) return Exam.types[type]!;
    }
    return '?';
  }

  /// Extracts a list of exams from an HTTP [response].
  Future<Set<Exam>> parseExams(http.Response response) async {
    final document = parse(response.body);

    final Set<Exam> examsList = {};
    final List<String> dates = [];
    final List<String> examTypes = [];
    List<String> rooms = [];
    String? subject, schedule;
    int days = 0;
    int tableNum = 0;
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
              }
              if (examsDay.querySelector('span.exame-sala') != null) {
                rooms =
                    examsDay.querySelector('span.exame-sala')!.text.split(',');
              }
              schedule = examsDay.text.substring(examsDay.text.indexOf(':') - 2,
                  examsDay.text.indexOf(':') + 9);
              final List<String> splittedSchedule = schedule!.split('-');
              final DateTime begin =
                  DateTime.parse('${dates[days]} ${splittedSchedule[0]}');
              final DateTime end =
                  DateTime.parse('${dates[days]} ${splittedSchedule[1]}');
              final Exam exam =
                  Exam(begin, end, subject ?? '', rooms, examTypes[tableNum]);
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
