import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:http/http.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/lecture.dart';

import 'package:uni/model/entities/session.dart';

Future<List<Lecture>> getOverlappedClasses(
    Session session, Document document) async {
  final List<Lecture> lecturesList = [];

  final overlappingClasses = document.querySelectorAll('.dados > tbody > .d');
  for (final element in overlappingClasses) {
    final String? subject = element.querySelector('acronym > a')?.text;
    final String? typeClass = element
        .querySelector('td[headers=t1]')
        ?.nodes[2]
        .text
        ?.trim()
        .replaceAll(RegExp(r'[()]+'), '');
    final String? textDay = element.querySelector('td[headers=t2]')?.text;
    final int? aDay = document
        .querySelector('.horario > tbody > tr:first-child')
        ?.children
        .indexWhere((element) => element.text == textDay);
    final int day = aDay != null ? aDay - 1 : 0;
    final String? startTime = element.querySelector('td[headers=t3]')?.text;
    final String? room = element.querySelector('td[headers=t4] > a')?.text;
    final String? teacher = element.querySelector('td[headers=t5] > a')?.text;
    final String? classNumber =
        element.querySelector('td[headers=t6] > a')?.text;

    try {
      final String? link =
          element.querySelector('td[headers=t6] > a')?.attributes['href'];

      if (link == null) {
        throw Exception();
      }
      final Response response =
          await NetworkRouter.getWithCookies(link, {}, session);

      final classLectures = await getScheduleFromHtml(response, session);
      lecturesList.add(classLectures
          .where((element) =>
              element.subject == subject &&
              startTime?.replaceFirst(':', 'h') == element.startTime &&
              element.day == day)
          .first);
    } catch (e) {
      final Lecture lect = Lecture.fromHtml(subject!, typeClass!, day,
          startTime!, 0, room!, teacher!, classNumber!, -1);
      lecturesList.add(lect);
    }
  }

  return lecturesList;
}

/// Extracts the user's lectures from an HTTP [response] and sorts them by date.
///
/// This function parses the schedule's HTML page.
Future<List<Lecture>> getScheduleFromHtml(
    http.Response response, Session session) async {
  final document = parse(response.body);
  var semana = [0, 0, 0, 0, 0, 0];

  final List<Lecture> lecturesList = [];

  DateTime monday = DateTime.now();
  monday = monday.subtract(Duration(hours: monday.hour, minutes: monday.minute, seconds: monday.second));
  //get closest monday
  if(monday.weekday >=1 && monday.weekday <= 5){
    monday = monday.subtract(Duration(days:monday.weekday-1));
  } else {
    monday = monday.add(Duration(days: DateTime.daysPerWeek - monday.weekday + 1));
  }

  document.querySelectorAll('.horario > tbody > tr').forEach((Element element) {
    if (element.getElementsByClassName('horas').isNotEmpty) {
      var day = 0;
      final List<Element> children = element.children;
      for (var i = 1; i < children.length; i++) {
        for (var d = day; d < semana.length; d++) {
          if (semana[d] == 0) {
            break;
          }
          day++;
        }
        final clsName = children[i].className;
        if (clsName == 'TE' || clsName == 'TP' || clsName == 'PL') {
          final String? subject =
              children[i].querySelector('b > acronym > a')?.text;
          if (subject == null) return;
          String? classNumber;

          if (clsName == 'TP' || clsName == 'PL') {
            classNumber = children[i].querySelector('span > a')?.text;
            if (classNumber == null) return;
          }

          final Element? rowSmall =
              children[i].querySelector('table > tbody > tr');
          final String? room = rowSmall?.querySelector('td > a')?.text;
          final String? teacher = rowSmall?.querySelector('td.textod a')?.text;

          final String typeClass = clsName;
          final int blocks = int.parse(children[i].attributes['rowspan']!);
          final String startTime = children[0].text.substring(0, 5);

          semana[day] += blocks;

          final Lecture lect = Lecture.fromHtml(
              subject,
              typeClass,
              monday.add(Duration(days: day)),
              startTime,
              blocks,
              room ?? '',
              teacher ?? '',
              classNumber ?? '',
              -1);
          lecturesList.add(lect);
        }
        day++;
      }
      semana = semana.expand((i) => [(i - 1) < 0 ? 0 : i - 1]).toList();
    }
  });

  lecturesList.addAll(await getOverlappedClasses(session, document));
  lecturesList.sort((a, b) => a.compare(b));

  return lecturesList;
}
