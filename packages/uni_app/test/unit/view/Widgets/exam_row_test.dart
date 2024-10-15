import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/providers/lazy/exam_provider.dart';
import 'package:uni/view/exams/widgets/exam_row.dart';

import '../../../test_widget.dart';

void main() async {
  await initTestEnvironment();

  group('Exam Row', () {
    const subject = 'SOPE';
    final start = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      10,
    );
    final finish = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      12,
    );
    final startTime = DateFormat('HH:mm').format(start);
    final finishTime = DateFormat('HH:mm').format(finish);

    testWidgets('When given a single room', (tester) async {
      final rooms = ['B315'];
      final exam = Exam('1230', start, finish, subject, rooms, '', 'feup');
      final widget = ExamRow(
        exam: exam,
        teacher: '',
        mainPage: true,
        onChangeVisibility: () {},
      );

      final providers = [
        ChangeNotifierProvider<ExamProvider>(create: (_) => ExamProvider()),
      ];
      await tester.pumpWidget(testableWidget(widget, providers: providers));
      await tester.pump();

      final roomsKey = '$subject-$rooms-$startTime-$finishTime';

      expect(
        find.descendant(
          of: find.byKey(Key(roomsKey)),
          matching: find.byType(Text),
        ),
        findsOneWidget,
      );
    });

    testWidgets('When multiple rooms', (tester) async {
      final rooms = ['B315', 'B316', 'B330'];
      final exam = Exam('1230', start, finish, subject, rooms, '', 'feup');
      final widget = ExamRow(
        exam: exam,
        teacher: '',
        mainPage: true,
        onChangeVisibility: () {},
      );

      final providers = [
        ChangeNotifierProvider<ExamProvider>(create: (_) => ExamProvider()),
      ];

      await tester.pumpWidget(testableWidget(widget, providers: providers));
      await tester.pump();

      final roomsKey = '$subject-$rooms-$startTime-$finishTime';

      expect(
        find.descendant(
          of: find.byKey(Key(roomsKey)),
          matching: find.byType(Text),
        ),
        findsNWidgets(3),
      );
    });
  });
}
