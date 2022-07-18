import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:flutter/services.dart' show rootBundle;

/// Extracts the user's lectures from an HTTP [response] and sorts them by date.
/// 
/// This function parses the schedule's HTML page.
Future<List<Lecture>> getScheduleFromHtml(http.Response response) async {
  final str = await rootBundle.loadString("assets/Teste.html");
  final document = parse(str);
  var semana = [0, 0, 0, 0, 0, 0];

  final List<Lecture> lecturesList = [];
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
          final String subject =
              children[i].querySelector('b > acronym > a').text;
          String classNumber = null;

          if (clsName == 'TP' || clsName == 'PL') {
            classNumber = children[i].querySelector('span > a').text;
          }

          final Element rowSmall =
              children[i].querySelector('table > tbody > tr');
          final String room = rowSmall.querySelector('td > a').text;
          final String teacher = rowSmall.querySelector('td.textod a').text;

          final String typeClass = clsName;
          final int blocks = int.parse(children[i].attributes['rowspan']);
          final String startTime = children[0].text.substring(0, 5);

          semana[day] += blocks;

          final Lecture lect = Lecture.fromHtml(subject, typeClass, day,
              startTime, blocks, room, teacher, classNumber);
          lecturesList.add(lect);
        }
        day++;
      }
      semana = semana.expand((i) => [(i - 1) < 0 ? 0 : i - 1]).toList();
    }
  });

  document.querySelectorAll('.dados > tbody > .d').forEach((Element element) {

    final subject = element.querySelector('acronym > a').text;
    final typeClass = element.querySelector('td[headers=t1]').nodes[2].text
        .trim().replaceAll(RegExp(r'[()]+'), '');
    final textDay = element.querySelector('td[headers=t2]').text;
    final day = document.querySelector('.horario > tbody > tr:first-child')
        .children
        .indexWhere((element) => element.text == textDay) - 1;
    final startTime = element.querySelector('td[headers=t3]').text;
    final room = element.querySelector('td[headers=t4] > a').text;
    final teacher = element.querySelector('td[headers=t5] > a').text;
    final classNumber = element.querySelector('td[headers=t6] > a').text;

    final Lecture lect = Lecture.fromHtml(subject, typeClass, day,
        startTime, 4, room, teacher, classNumber);

    lecturesList.add(lect);
  });


  lecturesList.sort((a, b) => a.compare(b));

  return lecturesList;
}
