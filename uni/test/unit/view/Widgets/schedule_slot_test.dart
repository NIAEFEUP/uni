import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:uni/view/schedule/widgets/schedule_slot.dart';

import '../../../test_widget.dart';

void main() async {
  await initTestEnvironment();

  group('Schedule Slot', () {
    const subject = 'SOPE';
    final begin = DateTime(2021, 06, 01, 10);
    final beginText = DateFormat('HH:mm').format(begin);
    final end = DateTime(2021, 06, 01, 12);
    final endText = DateFormat('HH:mm').format(end);
    const rooms = 'B315';
    const typeClass = 'T';
    const teacher = 'JAS';
    const occurrId = 12345;

    testWidgets('When given a single room', (tester) async {
      final widget = ScheduleSlot(
        subject: subject,
        typeClass: typeClass,
        rooms: rooms,
        begin: begin,
        end: end,
        teacher: teacher,
        occurrId: occurrId,
      );

      await tester.pumpWidget(testableWidget(widget));
      await tester.pump();

      testScheduleSlot(subject, beginText, endText, rooms, typeClass, teacher);
    });
  });
}

void testScheduleSlot(
  String subject,
  String begin,
  String end,
  String rooms,
  String typeClass,
  String teacher,
) {
  final scheduleSlotTimeKey = 'schedule-slot-time-$begin-$end';
  expect(
    find.descendant(
      of: find.byKey(Key(scheduleSlotTimeKey)),
      matching: find.text(begin),
    ),
    findsOneWidget,
  );
  expect(
    find.descendant(
      of: find.byKey(Key(scheduleSlotTimeKey)),
      matching: find.text(end),
    ),
    findsOneWidget,
  );
  expect(
    find.descendant(
      of: find.byKey(Key(scheduleSlotTimeKey)),
      matching: find.text(subject),
    ),
    findsOneWidget,
  );
  expect(
    find.descendant(
      of: find.byKey(Key(scheduleSlotTimeKey)),
      matching: find.text(' ($typeClass)'),
    ),
    findsOneWidget,
  );
}
