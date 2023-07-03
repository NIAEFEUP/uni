import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/providers/exam_provider.dart';
import 'package:uni/view/exams/widgets/exam_row.dart';

import '../../../test_widget.dart';

void main() {
  group('Exam Row', () {
    const subject = 'SOPE';
    final DateTime begin = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 10, 0);
    final DateTime end = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 12, 0);
    final String beginTime = DateFormat('HH:mm').format(begin);
    final String endTime = DateFormat('HH:mm').format(end);

    testWidgets('When given a single room', (WidgetTester tester) async {
      final rooms = ['B315'];
      final Exam exam = Exam('1230', begin, end, subject, rooms, '', 'feup');
      final widget = ExamRow(exam: exam, teacher: '', mainPage: true);

      final providers = [
        ChangeNotifierProvider<ExamProvider>(create: (_) => ExamProvider())
      ];
      await tester.pumpWidget(testableWidget(widget, providers: providers));
      final roomsKey = '$subject-$rooms-$beginTime-$endTime';

      expect(
          find.descendant(
              of: find.byKey(Key(roomsKey)), matching: find.byType(Text)),
          findsOneWidget);
    });

    testWidgets('When multiple rooms', (WidgetTester tester) async {
      final rooms = ['B315', 'B316', 'B330'];
      final Exam exam = Exam('1230',begin, end, subject, rooms, '', 'feup');
      final widget = ExamRow(exam: exam, teacher: '', mainPage: true);

      final providers = [
        ChangeNotifierProvider<ExamProvider>(create: (_) => ExamProvider())
      ];

      await tester.pumpWidget(testableWidget(widget, providers: providers));
      final roomsKey = '$subject-$rooms-$beginTime-$endTime';

      expect(
          find.descendant(
              of: find.byKey(Key(roomsKey)), matching: find.byType(Text)),
          findsNWidgets(3));
    });
  });
}
