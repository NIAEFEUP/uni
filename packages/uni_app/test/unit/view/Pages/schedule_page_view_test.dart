import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/view/schedule/schedule.dart';
import 'package:uni/view/schedule/widgets/schedule_slot.dart';

import '../../../test_widget.dart';

void main() async {
  await initTestEnvironment();

  group('SchedulePage', () {
    const blocks = 4;
    const classNumber = 'MIEIC03';
    final now = DateTime(2021, 06, 05);
    final day0 = DateTime(2021, 06, 07);
    final day1 = DateTime(2021, 06, 08);
    final day2 = DateTime(2021, 06, 09);
    final day3 = DateTime(2021, 06, 10);
    final day4 = DateTime(2021, 06, 11);

    final lecture1 = Lecture.fromHtml(
      'SOPE',
      'T',
      day0,
      '10:00',
      blocks,
      'B315',
      'JAS',
      classNumber,
      484378,
    );
    final lecture2 = Lecture.fromHtml(
      'SDIS',
      'T',
      day0,
      '13:00',
      blocks,
      'B315',
      'PMMS',
      classNumber,
      484381,
    );
    final lecture3 = Lecture.fromHtml(
      'AMAT',
      'T',
      day1,
      '12:00',
      blocks,
      'B315',
      'PMMS',
      classNumber,
      484362,
    );
    final lecture4 = Lecture.fromHtml(
      'PROG',
      'T',
      day2,
      '10:00',
      blocks,
      'B315',
      'JAS',
      classNumber,
      484422,
    );
    final lecture5 = Lecture.fromHtml(
      'PPIN',
      'T',
      day3,
      '14:00',
      blocks,
      'B315',
      'SSN',
      classNumber,
      47775,
    );
    final lecture6 = Lecture.fromHtml(
      'SDIS',
      'T',
      day4,
      '15:00',
      blocks,
      'B315',
      'PMMS',
      classNumber,
      12345,
    );

    final daysOfTheWeek = <String>[
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira',
    ];

    testWidgets('When given one lecture on a single day', (tester) async {
      final widget = SchedulePageView(
        [lecture1],
        now: now,
      );

      await tester.pumpWidget(testableWidget(widget, providers: []));
      await tester.pumpAndSettle();
      final myWidgetState =
          tester.state(find.byType(SchedulePageView)) as SchedulePageViewState;
      myWidgetState.tabController!.animateTo(0);
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byKey(const Key('schedule-page-day-column-0')),
          matching: find.byType(ScheduleSlot),
        ),
        findsOneWidget,
      );
    });

    testWidgets('When given two lectures on a single day', (tester) async {
      final widget = SchedulePageView(
        [lecture1, lecture2],
        now: now,
      );
      await tester.pumpWidget(testableWidget(widget, providers: []));
      await tester.pumpAndSettle();
      final myWidgetState =
          tester.state(find.byType(SchedulePageView)) as SchedulePageViewState;
      myWidgetState.tabController!.animateTo(0);
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byKey(const Key('schedule-page-day-column-0')),
          matching: find.byType(ScheduleSlot),
        ),
        findsNWidgets(2),
      );
    });

    testWidgets('When given lectures on different days', (tester) async {
      final widget = DefaultTabController(
        length: daysOfTheWeek.length,
        child: SchedulePageView(
          [
            lecture1,
            lecture2,
            lecture3,
            lecture4,
            lecture5,
            lecture6,
          ],
          now: now,
        ),
      );

      await tester.pumpWidget(testableWidget(widget, providers: []));
      await tester.pumpAndSettle();
      final myWidgetState =
          tester.state(find.byType(SchedulePageView)) as SchedulePageViewState;
      myWidgetState.tabController!.animateTo(0);
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byKey(const Key('schedule-page-day-column-0')),
          matching: find.byType(ScheduleSlot),
        ),
        findsNWidgets(2),
      );

      await tester.tap(find.byKey(const Key('schedule-page-tab-1')));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byKey(const Key('schedule-page-day-column-1')),
          matching: find.byType(ScheduleSlot),
        ),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('schedule-page-tab-2')));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byKey(const Key('schedule-page-day-column-2')),
          matching: find.byType(ScheduleSlot),
        ),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('schedule-page-tab-3')));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byKey(const Key('schedule-page-day-column-3')),
          matching: find.byType(ScheduleSlot),
        ),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('schedule-page-tab-4')));
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byKey(const Key('schedule-page-day-column-4')),
          matching: find.byType(ScheduleSlot),
        ),
        findsOneWidget,
      );
    });
  });
}
