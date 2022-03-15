import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
//import 'package:flutter/material.dart';

import 'package:uni/view/Widgets/schedule_slot.dart';
import '../../../testable_widget.dart';

void testScheduleSlot(String subject, String begin, String end, String rooms,
    String typeClass, String teacher) {
  final scheduleSlotTimeKey = 'schedule-slot-time-$begin-$end';
  expect(
      find.descendant(
          of: find.byKey(Key(scheduleSlotTimeKey)), matching: find.text(begin)),
      findsOneWidget);
  expect(
      find.descendant(
          of: find.byKey(Key(scheduleSlotTimeKey)), matching: find.text(end)),
      findsOneWidget);
  expect(
      find.descendant(
          of: find.byKey(Key(scheduleSlotTimeKey)),
          matching: find.text(subject)),
      findsOneWidget);
  expect(
      find.descendant(
          of: find.byKey(Key(scheduleSlotTimeKey)),
          matching: find.text(' ($typeClass)')),
      findsOneWidget);
  expect(
      find.descendant(
          of: find.byKey(Key(scheduleSlotTimeKey)),
          matching: find.text(teacher)),
      findsOneWidget);
  expect(true, true);
}

void main() {
  group('ScheduleSlot', () {
    final subject = 'SOPE';
    final begin = '10:00';
    final end = '12:00';
    final rooms = 'B315';
    final typeClass = 'T';
    final teacher = 'JAS';

    testWidgets('When given a single room', (WidgetTester tester) async {
      final widget = makeTestableWidget(
          child: ScheduleSlot(
        subject: subject,
        typeClass: typeClass,
        rooms: rooms,
        begin: begin,
        end: end,
        teacher: teacher,
      ));

      await tester.pumpWidget(widget);
      testScheduleSlot(subject, begin, end, rooms, typeClass, teacher);
    });
  });
}
