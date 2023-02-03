import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/view/exams/exams.dart';

import '../../../testable_widget.dart';

void main() {
  group('ExamsPage', () {
    const firstExamSubject = 'SOPE';
    const firstExamDate = '2019-09-11';
    const secondExamSubject = 'SDIS';
    const secondExamDate = '2019-09-12';
    testWidgets('When given an empty list', (WidgetTester tester) async {
      final widget =
          makeTestableWidget(child: const ExamsList(exams: <Exam>[]));
      await tester.pumpWidget(widget);

      expect(find.byType(Card), findsNothing);
    });

    testWidgets('When given a single exam', (WidgetTester tester) async {
      final DateTime firstExamBegin = DateTime.parse('$firstExamDate 09:00');
      final DateTime firstExamEnd = DateTime.parse('$firstExamDate 12:00');
      final firstExam = Exam('1230',firstExamBegin, firstExamEnd, firstExamSubject,
          ['B119', 'B107', 'B205'], 'ER','feup');
      final examList = [
        firstExam,
      ];
      final widget = makeTestableWidget(
          child: ExamsList(
        exams: examList,
      ));

      await tester.pumpWidget(widget);

      expect(find.byKey(Key(firstExam.toString())), findsOneWidget);
      expect(find.byKey(Key('${firstExam.toString()}-exam')), findsOneWidget);
    });

    testWidgets('When given two exams from the same date',
        (WidgetTester tester) async {
      final DateTime firstExamBegin = DateTime.parse('$firstExamDate 09:00');
      final DateTime firstExamEnd = DateTime.parse('$firstExamDate 12:00');
      final firstExam = Exam('1231',firstExamBegin, firstExamEnd, firstExamSubject,
          ['B119', 'B107', 'B205'], 'ER', 'feup');
      final DateTime secondExamBegin = DateTime.parse('$firstExamDate 12:00');
      final DateTime secondExamEnd = DateTime.parse('$firstExamDate 15:00');
      final secondExam = Exam('1232',secondExamBegin, secondExamEnd, secondExamSubject,
          ['B119', 'B107', 'B205'], 'ER', 'feup');
      final examList = [
        firstExam,
        secondExam,
      ];
      final widget = makeTestableWidget(child: ExamsList(exams: examList));

      await tester.pumpWidget(widget);

      expect(find.byKey(Key(examList.map((ex) => ex.toString()).join())),
          findsOneWidget);
      expect(find.byKey(Key('${firstExam.toString()}-exam')), findsOneWidget);
      expect(find.byKey(Key('${secondExam.toString()}-exam')), findsOneWidget);
    });

    testWidgets('When given two exams from different dates',
        (WidgetTester tester) async {
      final DateTime firstExamBegin = DateTime.parse('$firstExamDate 09:00');
      final DateTime firstExamEnd = DateTime.parse('$firstExamDate 12:00');
      final firstExam = Exam('1233',firstExamBegin, firstExamEnd, firstExamSubject,
          ['B119', 'B107', 'B205'], 'ER','feup');
      final DateTime secondExamBegin = DateTime.parse('$secondExamDate 12:00');
      final DateTime secondExamEnd = DateTime.parse('$secondExamDate 15:00');
      final secondExam = Exam('1234',secondExamBegin, secondExamEnd, secondExamSubject,
          ['B119', 'B107', 'B205'], 'ER','feup');
      final List<Exam> examList = [
        firstExam,
        secondExam,
      ];
      final widget = makeTestableWidget(child: ExamsList(exams: examList));

      await tester.pumpWidget(widget);
      expect(find.byKey(Key(firstExam.toString())), findsOneWidget);
      expect(find.byKey(Key(secondExam.toString())), findsOneWidget);
      expect(find.byKey(Key('${firstExam.toString()}-exam')), findsOneWidget);
      expect(find.byKey(Key('${secondExam.toString()}-exam')), findsOneWidget);
    });

    testWidgets('When given four exams from two different dates',
        (WidgetTester tester) async {
      final List<String> rooms = ['B119', 'B107', 'B205'];
      final DateTime firstExamBegin = DateTime.parse('$firstExamDate 09:00');
      final DateTime firstExamEnd = DateTime.parse('$firstExamDate 12:00');
      final firstExam = Exam('1235',firstExamBegin, firstExamEnd, firstExamSubject,
          rooms, 'ER', 'feup');
      final DateTime secondExamBegin = DateTime.parse('$firstExamDate 10:00');
      final DateTime secondExamEnd = DateTime.parse('$firstExamDate 12:00');
      final secondExam = Exam('1236',secondExamBegin, secondExamEnd, firstExamSubject,
          rooms, 'ER', 'feup');
      final DateTime thirdExamBegin = DateTime.parse('$secondExamDate 12:00');
      final DateTime thirdExamEnd = DateTime.parse('$secondExamDate 15:00');
      final thirdExam = Exam('1237',thirdExamBegin, thirdExamEnd, secondExamSubject,
          rooms, 'ER', 'feup');
      final DateTime fourthExamBegin = DateTime.parse('$secondExamDate 13:00');
      final DateTime fourthExamEnd = DateTime.parse('$secondExamDate 14:00');
      final fourthExam = Exam('1238',fourthExamBegin, fourthExamEnd, secondExamSubject,
          rooms, 'ER', 'feup');
      final examList = [firstExam, secondExam, thirdExam, fourthExam];
      final widget = makeTestableWidget(child: ExamsList(exams: examList));

      final firstDayKey =
          [firstExam, secondExam].map((ex) => ex.toString()).join();
      final secondDayKey =
          [thirdExam, fourthExam].map((ex) => ex.toString()).join();

      await tester.pumpWidget(widget);
      expect(find.byKey(Key(firstDayKey)), findsOneWidget);
      expect(find.byKey(Key(secondDayKey)), findsOneWidget);
      expect(find.byKey(Key('${firstExam.toString()}-exam')), findsOneWidget);
      expect(find.byKey(Key('${secondExam.toString()}-exam')), findsOneWidget);
      expect(find.byKey(Key('${thirdExam.toString()}-exam')), findsOneWidget);
      expect(find.byKey(Key('${fourthExam.toString()}-exam')), findsOneWidget);
    });
  });
}
