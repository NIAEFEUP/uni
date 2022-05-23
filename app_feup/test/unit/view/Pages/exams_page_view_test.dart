import 'package:uni/model/entities/exam.dart';
import 'package:uni/view/Pages/exams_page_view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import '../../../testable_widget.dart';

void main() {
  group('ExamsPage', () {
    final firstExamSubject = 'SOPE';
    final firstExamDate = '2019-09-11';
    final secondExamSubject = 'SDIS';
    final secondExameDate = '2019-09-12';
    testWidgets('When given an empty list', (WidgetTester tester) async {
      final widget = makeTestableWidget(child: ExamsList(exams: <Exam>[]));
      await tester.pumpWidget(widget);

      expect(find.byType(Card), findsNothing);
    });

    testWidgets('When given a single exam', (WidgetTester tester) async {
      final firstExam = Exam('09:00-12:00', firstExamSubject,
          'B119, B107, B205', firstExamDate, 'ER', 'Quarta');
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
      final firstExam = Exam('09:00-12:00', firstExamSubject,
          'B119, B107, B205', firstExamDate, 'ER', 'Quarta');
      final secondExam = Exam('12:00-15:00', secondExamSubject,
          'B119, B107, B205', firstExamDate, 'ER', 'Quarta');
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
      final firstExam = Exam('09:00-12:00', firstExamSubject,
          'B119, B107, B205', firstExamDate, 'ER', 'Quarta');
      final secondExam = Exam('12:00-15:00', secondExamSubject,
          'B119, B107, B205', secondExameDate, 'ER', 'Quarta');
      final examList = [
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
      final firstExam = Exam('09:00-12:00', firstExamSubject,
          'B119, B107, B205', firstExamDate, 'ER', 'Quarta');
      final secondExam = Exam('10:00-12:00', firstExamSubject,
          'B119, B107, B205', firstExamDate, 'ER', 'Quarta');
      final thirdExam = Exam('12:00-15:00', secondExamSubject,
          'B119, B107, B205', secondExameDate, 'ER', 'Quarta');
      final fourthExam = Exam('13:00-14:00', secondExamSubject,
          'B119, B107, B205', secondExameDate, 'ER', 'Quarta');
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
