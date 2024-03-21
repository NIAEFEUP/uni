import 'dart:async';

import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/utils/time/week.dart';
import 'package:uni/model/utils/time/weekday_mapper.dart';

Future<List<Lecture>> getOverlappedClasses(
  Session session,
  Document document,
  String faculty,
  Week week,
) async {
  final lecturesList = <Lecture>[];

  final overlappingClasses = document.querySelectorAll('.dados > tbody > .d');
  for (final element in overlappingClasses) {
    final subject = element.querySelector('acronym > a')?.text;
    final typeClass = element
        .querySelector('td[headers=t1]')
        ?.nodes[1]
        .text
        ?.trim()
        .replaceAll(RegExp('[()]+'), '');
    final textDay = element.querySelector('td[headers=t2]')?.text;
    final aDay = document
        .querySelector('.horario > tbody > tr:first-child')
        ?.children
        .indexWhere((element) => element.text == textDay);
    final day = week.getWeekday(
      aDay != null
          ? WeekdayMapper.fromSigarraToDart.map(aDay)
          : DateTime.monday,
    );
    final startTime = element.querySelector('td[headers=t3]')?.text;
    final room = element.querySelector('td[headers=t4] > a')?.text;
    final teacher = element.querySelector('td[headers=t5] > a')?.text;
    final classNumber = element.querySelector('td[headers=t6] > a')?.text;

    try {
      final startTimeList = startTime?.split(':') ?? [];
      if (startTimeList.isEmpty) {
        throw FormatException(
          'Overlapping class $subject has invalid startTime',
        );
      }
      final fullStartTime = day.add(
        Duration(
          hours: int.parse(startTimeList[0]),
          minutes: int.parse(startTimeList[1]),
        ),
      );

      final href =
          element.querySelector('td[headers=t6] > a')?.attributes['href'];

      if (href == null) {
        throw Exception();
      }
      final response = await NetworkRouter.getWithCookies(
        '$faculty$href',
        {},
        session,
      );

      final classLectures = await getScheduleFromHtml(
        (week, response),
        session,
        faculty,
      );

      lecturesList.add(
        classLectures
            .where(
              (element) =>
                  element.subject == subject &&
                  element.startTime == fullStartTime,
            )
            .first,
      );
    } catch (e) {
      final lect = Lecture.fromHtml(
        subject!,
        typeClass!,
        day,
        startTime!,
        0,
        room!,
        teacher!,
        classNumber!,
        -1,
      );
      lecturesList.add(lect);
    }
  }

  return lecturesList;
}

/// Extracts the user's lectures from a Week-HTTP pair in [responsePerWeek] and
/// sorts them by date.
///
/// This function parses the schedule's HTML page.
Future<List<Lecture>> getScheduleFromHtml(
  (Week, http.Response) responsePerWeek,
  Session session,
  String faculty,
) async {
  final (week, response) = responsePerWeek;
  final document = parse(response.body);
  var semana = [0, 0, 0, 0, 0, 0];

  final lecturesList = <Lecture>[];

  document.querySelectorAll('.horario > tbody > tr').forEach((element) {
    if (element.getElementsByClassName('horas').isNotEmpty) {
      var dayIndex = 0;
      final children = element.children;
      for (var i = 1; i < children.length; i++) {
        for (var d = dayIndex; d < semana.length; d++) {
          if (semana[d] == 0) {
            break;
          }
          dayIndex++;
        }
        final clsName = children[i].className;
        if (clsName == 'TE' || clsName == 'TP' || clsName == 'PL') {
          final subject = children[i].querySelector('b > acronym > a')?.text;
          if (subject == null) {
            return;
          }
          String? classNumber;

          if (clsName == 'TP' || clsName == 'PL') {
            classNumber = children[i].querySelector('span > a')?.text;
            if (classNumber == null) {
              return;
            }
          }

          final rowSmall = children[i].querySelector('table > tbody > tr');
          final room = rowSmall?.querySelector('td > a')?.text;
          final teacher = rowSmall?.querySelector('td.textod a')?.text;

          final typeClass = clsName;
          final blocks = int.parse(children[i].attributes['rowspan']!);
          final startTime = children[0].text.substring(0, 5);

          semana[dayIndex] += blocks;

          final lect = Lecture.fromHtml(
            subject,
            typeClass,
            week.getWeekday(
              WeekdayMapper.fromDartToIndex.inverse.map(dayIndex),
            ),
            startTime,
            blocks,
            room ?? '',
            teacher ?? '',
            classNumber ?? '',
            -1,
          );
          lecturesList.add(lect);
        }
        dayIndex++;
      }
      semana = semana.expand((i) => [if ((i - 1) < 0) 0 else i - 1]).toList();
    }
  });

  lecturesList
    ..addAll(
      await getOverlappedClasses(session, document, faculty, week),
    )
    ..sort((a, b) => a.compare(b));

  return lecturesList;
}
