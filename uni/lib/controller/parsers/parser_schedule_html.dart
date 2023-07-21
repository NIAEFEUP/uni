import 'dart:async';

import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/entities/time_utilities.dart';

Future<List<Lecture>> getOverlappedClasses(
  Session session,
  Document document,
) async {
  final lecturesList = <Lecture>[];

  final monday = DateTime.now().getClosestMonday();

  final overlappingClasses = document.querySelectorAll('.dados > tbody > .d');
  for (final element in overlappingClasses) {
    final subject = element.querySelector('acronym > a')?.text;
    final typeClass = element
        .querySelector('td[headers=t1]')
        ?.nodes[2]
        .text
        ?.trim()
        .replaceAll(RegExp('[()]+'), '');
    final textDay = element.querySelector('td[headers=t2]')?.text;
    final aDay = document
        .querySelector('.horario > tbody > tr:first-child')
        ?.children
        .indexWhere((element) => element.text == textDay);
    final day = aDay != null ? aDay - 1 : 0;
    final startTime = element.querySelector('td[headers=t3]')?.text;
    final room = element.querySelector('td[headers=t4] > a')?.text;
    final teacher = element.querySelector('td[headers=t5] > a')?.text;
    final classNumber = element.querySelector('td[headers=t6] > a')?.text;

    try {
      final fullStartTime = monday.add(
        Duration(
          days: day,
          hours: int.parse(startTime!.substring(0, 2)),
          minutes: int.parse(startTime.substring(3, 5)),
        ),
      );
      final link =
          element.querySelector('td[headers=t6] > a')?.attributes['href'];

      if (link == null) {
        throw Exception();
      }
      final response = await NetworkRouter.getWithCookies(link, {}, session);

      final classLectures = await getScheduleFromHtml(response, session);

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
        monday.add(Duration(days: day)),
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

/// Extracts the user's lectures from an HTTP [response] and sorts them by date.
///
/// This function parses the schedule's HTML page.
Future<List<Lecture>> getScheduleFromHtml(
  http.Response response,
  Session session,
) async {
  final document = parse(response.body);
  var semana = [0, 0, 0, 0, 0, 0];

  final lecturesList = <Lecture>[];

  final monday = DateTime.now().getClosestMonday();

  document.querySelectorAll('.horario > tbody > tr').forEach((Element element) {
    if (element.getElementsByClassName('horas').isNotEmpty) {
      var day = 0;
      final children = element.children;
      for (var i = 1; i < children.length; i++) {
        for (var d = day; d < semana.length; d++) {
          if (semana[d] == 0) {
            break;
          }
          day++;
        }
        final clsName = children[i].className;
        if (clsName == 'TE' || clsName == 'TP' || clsName == 'PL') {
          final subject = children[i].querySelector('b > acronym > a')?.text;
          if (subject == null) return;
          String? classNumber;

          if (clsName == 'TP' || clsName == 'PL') {
            classNumber = children[i].querySelector('span > a')?.text;
            if (classNumber == null) return;
          }

          final rowSmall = children[i].querySelector('table > tbody > tr');
          final room = rowSmall?.querySelector('td > a')?.text;
          final teacher = rowSmall?.querySelector('td.textod a')?.text;

          final typeClass = clsName;
          final blocks = int.parse(children[i].attributes['rowspan']!);
          final startTime = children[0].text.substring(0, 5);

          semana[day] += blocks;

          final lect = Lecture.fromHtml(
            subject,
            typeClass,
            monday.add(Duration(days: day)),
            startTime,
            blocks,
            room ?? '',
            teacher ?? '',
            classNumber ?? '',
            -1,
          );
          lecturesList.add(lect);
        }
        day++;
      }
      semana = semana.expand((i) => [if ((i - 1) < 0) 0 else i - 1]).toList();
    }
  });

  lecturesList
    ..addAll(await getOverlappedClasses(session, document))
    ..sort((a, b) => a.compare(b));

  return lecturesList;
}
