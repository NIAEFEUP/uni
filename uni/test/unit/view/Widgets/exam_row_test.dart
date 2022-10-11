import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/view/exams/widgets/exam_row.dart';

import '../../../testable_widget.dart';

void main() {
  group('ExamRow', () {
    const subject = 'SOPE';
    final DateTime begin = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 10, 0);
    final DateTime end = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 12, 0);
    final String beginTime = DateFormat('HH:mm').format(begin);
    final String endTime = DateFormat('HH:mm').format(end);
    testWidgets('When given a single room', (WidgetTester tester) async {
      final rooms = ['B315'];
      final Exam exam =
          Exam(begin, end, subject, rooms, '', begin.weekday.toString());
      final widget = makeTestableWidget(
          child: ExamRow(
        exam: exam,
        teacher: '',
      ));

      await tester.pumpWidget(widget);
      final roomsKey =
          '${exam.subject}-${exam.rooms}-${exam.beginTime()} - ${exam.endTime()}';

      expect(
          find.descendant(
              of: find.byKey(Key(roomsKey)), matching: find.byType(Text)),
          findsOneWidget);
    });

    testWidgets('When given multiple rooms', (WidgetTester tester) async {
      final rooms = ['B315', 'B316', 'B317'];
      final Exam exam =
          Exam(begin, end, subject, rooms, '', begin.weekday.toString());
      final widget = makeTestableWidget(
          child: ExamRow(
        exam: exam,
        teacher: '',
      ));

      await tester.pumpWidget(widget);
      //final roomsKey = '$subject-$rooms-$begin-$end';
      //Tenta tambem mudar o exam.beginTime para a begin.format() ...
      //para remover todas as instancias de exam da key a baixo
      final roomsKey = '$subject-$rooms-$beginTime - $endTime';

      expect(
          find.descendant(
              of: find.byKey(Key(roomsKey)), matching: find.byType(Text)),
          findsNWidgets(3));
    });
  });
}
