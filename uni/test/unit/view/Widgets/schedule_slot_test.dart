import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uni/model/utils/datetime.dart';
import 'package:uni/view/schedule/widgets/schedule_slot.dart';

import '../../../testable_widget.dart';

void testScheduleSlot(String subject, DateTime beginTime, DateTime endTime, String rooms,
    String typeClass, String teacher) {
    final begin = readableTime(beginTime);
    final end = readableTime(endTime);
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
    final begin = DateTime(1, 1, 1, 10, 0);
    final end = DateTime(1, 1, 1, 12, 0);
    const rooms = 'B315';
    const typeClass = 'T';
    const teacher = 'JAS';
    const occurrId = 12345;

    testWidgets('When given a single room', (WidgetTester tester) async {
      final widget = makeTestableWidget(
          child: ScheduleSlot(
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
