import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/providers/lazy/exam_provider.dart';
import 'package:uni/view/exams/exams.dart';

import '../../../test_widget.dart';

class MockExamProvider extends Mock implements ExamProvider {}

void main() async {
  await initTestEnvironment();

  group('ExamsPage', () {
    const firstExamSubject = 'SOPE';
    const firstExamDate = '2019-09-11';
    const secondExamSubject = 'SDIS';
    const secondExamDate = '2019-09-12';

    testWidgets('When given an empty list', (tester) async {
      const widget = ExamsPageView();
      final examProvider = ExamProvider()..setState([]);

      final providers = [ChangeNotifierProvider(create: (_) => examProvider)];

      await tester.pumpWidget(testableWidget(widget, providers: providers));

      expect(find.byType(Card), findsNothing);
    });

    testWidgets('When given a single exam', (tester) async {
      final firstExamBegin = DateTime.parse('$firstExamDate 09:00');
      final firstExamEnd = DateTime.parse('$firstExamDate 12:00');
      final firstExam = Exam(
        '1230',
        firstExamBegin,
        firstExamEnd,
        firstExamSubject,
        ['B119', 'B107', 'B205'],
        'ER',
        'feup',
      );

      const widget = ExamsPageView();

      final examProvider = ExamProvider()..setState([firstExam]);

      final providers = [ChangeNotifierProvider(create: (_) => examProvider)];

      await tester.pumpWidget(testableWidget(widget, providers: providers));
      await tester.pumpAndSettle();

      expect(find.byKey(Key(firstExam.toString())), findsOneWidget);
      expect(find.byKey(Key('$firstExam-exam')), findsOneWidget);
    });

    testWidgets('When given two exams from the same date', (tester) async {
      final firstExamBegin = DateTime.parse('$firstExamDate 09:00');
      final firstExamEnd = DateTime.parse('$firstExamDate 12:00');
      final firstExam = Exam(
        '1231',
        firstExamBegin,
        firstExamEnd,
        firstExamSubject,
        ['B119', 'B107', 'B205'],
        'ER',
        'feup',
      );
      final secondExamBegin = DateTime.parse('$firstExamDate 12:00');
      final secondExamEnd = DateTime.parse('$firstExamDate 15:00');
      final secondExam = Exam(
        '1232',
        secondExamBegin,
        secondExamEnd,
        secondExamSubject,
        ['B119', 'B107', 'B205'],
        'ER',
        'feup',
      );

      final examList = [
        firstExam,
        secondExam,
      ];

      const widget = ExamsPageView();

      final examProvider = ExamProvider()..setState(examList);

      final providers = [ChangeNotifierProvider(create: (_) => examProvider)];

      await tester.pumpWidget(testableWidget(widget, providers: providers));
      await tester.pumpAndSettle();

      expect(
        find.byKey(Key(examList.map((ex) => ex.toString()).join())),
        findsOneWidget,
      );
      expect(find.byKey(Key('$firstExam-exam')), findsOneWidget);
      expect(find.byKey(Key('$secondExam-exam')), findsOneWidget);
    });

    testWidgets('When given two exams from different dates', (tester) async {
      final firstExamBegin = DateTime.parse('$firstExamDate 09:00');
      final firstExamEnd = DateTime.parse('$firstExamDate 12:00');
      final firstExam = Exam(
        '1233',
        firstExamBegin,
        firstExamEnd,
        firstExamSubject,
        ['B119', 'B107', 'B205'],
        'ER',
        'feup',
      );
      final secondExamBegin = DateTime.parse('$secondExamDate 12:00');
      final secondExamEnd = DateTime.parse('$secondExamDate 15:00');
      final secondExam = Exam(
        '1234',
        secondExamBegin,
        secondExamEnd,
        secondExamSubject,
        ['B119', 'B107', 'B205'],
        'ER',
        'feup',
      );
      final examList = [
        firstExam,
        secondExam,
      ];

      const widget = ExamsPageView();

      final examProvider = ExamProvider()..setState(examList);

      final providers = [ChangeNotifierProvider(create: (_) => examProvider)];

      await tester.pumpWidget(testableWidget(widget, providers: providers));
      await tester.pumpAndSettle();

      expect(find.byKey(Key(firstExam.toString())), findsOneWidget);
      expect(find.byKey(Key(secondExam.toString())), findsOneWidget);
      expect(find.byKey(Key('$firstExam-exam')), findsOneWidget);
      expect(find.byKey(Key('$secondExam-exam')), findsOneWidget);
    });

    testWidgets('When given four exams from two different dates',
        (tester) async {
      final rooms = <String>['B119', 'B107', 'B205'];
      final firstExamBegin = DateTime.parse('$firstExamDate 09:00');
      final firstExamEnd = DateTime.parse('$firstExamDate 12:00');
      final firstExam = Exam(
        '1235',
        firstExamBegin,
        firstExamEnd,
        firstExamSubject,
        rooms,
        'ER',
        'feup',
      );
      final secondExamBegin = DateTime.parse('$firstExamDate 10:00');
      final secondExamEnd = DateTime.parse('$firstExamDate 12:00');
      final secondExam = Exam(
        '1236',
        secondExamBegin,
        secondExamEnd,
        firstExamSubject,
        rooms,
        'ER',
        'feup',
      );
      final thirdExamBegin = DateTime.parse('$secondExamDate 12:00');
      final thirdExamEnd = DateTime.parse('$secondExamDate 15:00');
      final thirdExam = Exam(
        '1237',
        thirdExamBegin,
        thirdExamEnd,
        secondExamSubject,
        rooms,
        'ER',
        'feup',
      );
      final fourthExamBegin = DateTime.parse('$secondExamDate 13:00');
      final fourthExamEnd = DateTime.parse('$secondExamDate 14:00');
      final fourthExam = Exam(
        '1238',
        fourthExamBegin,
        fourthExamEnd,
        secondExamSubject,
        rooms,
        'ER',
        'feup',
      );
      final examList = [firstExam, secondExam, thirdExam, fourthExam];

      const widget = ExamsPageView();

      final examProvider = ExamProvider()..setState(examList);

      final firstDayKey =
          [firstExam, secondExam].map((ex) => ex.toString()).join();
      final secondDayKey =
          [thirdExam, fourthExam].map((ex) => ex.toString()).join();

      final providers = [ChangeNotifierProvider(create: (_) => examProvider)];

      await tester.pumpWidget(testableWidget(widget, providers: providers));
      await tester.pumpAndSettle();

      expect(find.byKey(Key(firstDayKey)), findsOneWidget);
      expect(find.byKey(Key(secondDayKey)), findsOneWidget);
      expect(find.byKey(Key('$firstExam-exam')), findsOneWidget);
      expect(find.byKey(Key('$secondExam-exam')), findsOneWidget);
      expect(find.byKey(Key('$thirdExam-exam')), findsOneWidget);
      expect(find.byKey(Key('$fourthExam-exam')), findsOneWidget);
    });
  });
}
