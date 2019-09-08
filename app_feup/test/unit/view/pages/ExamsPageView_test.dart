import 'package:app_feup/model/entities/Exam.dart';
import 'package:app_feup/view/Pages/ExamsPageView.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import '../../TestableWidget.dart';

void main() {
  group('ExamsPage', () {
    testWidgets('When given an empty list', (WidgetTester tester) async {
      final widget = makeTestableWidget(child: ExamsList(exams: <Exam>[]));
      await tester.pumpWidget(widget);
      final containerFinder = find.byKey(new Key('exam-card'));

      expect(containerFinder, findsNothing);
    });
  });
}