import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uni/view/Exams/widgets/schedule_row.dart';

import '../../../testable_widget.dart';

void main() {
  group('ScheduleRow', () {
    const subject = 'SOPE';
    const begin = '10:00';
    const end = '12:00';
    testWidgets('When given a single room', (WidgetTester tester) async {
      final rooms = ['B315'];
      final widget = makeTestableWidget(
          child: ScheduleRow(
        subject: subject,
        rooms: rooms,
        begin: begin,
        end: end,
        date: DateTime.now(),
        teacher: '',
        type: '',
      ));

      await tester.pumpWidget(widget);
      final roomsKey = '$subject-$rooms-$begin-$end';

      expect(
          find.descendant(
              of: find.byKey(Key(roomsKey)), matching: find.byType(Text)),
          findsOneWidget);
    });

    testWidgets('When given a single room', (WidgetTester tester) async {
      final rooms = ['B315', 'B316', 'B330'];
      final widget = makeTestableWidget(
          child: ScheduleRow(
        subject: subject,
        rooms: rooms,
        begin: begin,
        end: end,
        date: DateTime.now(),
        teacher: '',
        type: '',
      ));

      await tester.pumpWidget(widget);
      final roomsKey = '$subject-$rooms-$begin-$end';

      expect(
          find.descendant(
              of: find.byKey(Key(roomsKey)), matching: find.byType(Text)),
          findsNWidgets(3));
    });
  });
}
