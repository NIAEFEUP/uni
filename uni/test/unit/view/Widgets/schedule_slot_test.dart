import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uni/view/schedule/widgets/schedule_slot.dart';

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
  expect(true, true);
}

void main() {
  group('ScheduleSlot', () {
    const subject = 'SOPE';
    const begin = '10:00';
    const end = '12:00';
    const rooms = 'B315';
    const typeClass = 'T';
    const teacher = 'JAS';
    const occurrId = 12345;

    testWidgets('When given a single room', (WidgetTester tester) async {
      final widget = makeTestableWidget(
          child: const ScheduleSlot(
        subject: subject,
        typeClass: typeClass,
        rooms: rooms,
        begin: begin,
        end: end,
        teacher: teacher,
        occurrId: occurrId,
      ));

      await tester.pumpWidget(widget);
      testScheduleSlot(subject, begin, end, rooms, typeClass, teacher);
    });
  });
}
