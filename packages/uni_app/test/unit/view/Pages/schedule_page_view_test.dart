import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/view/schedule/schedule.dart';
import 'package:uni/view/schedule/widgets/schedule_slot.dart';

import '../../../test_widget.dart';

void main() async {
  await initTestEnvironment();

  group('SchedulePage', () {
    const classNumber = 'MIEIC03';
    final now = DateTime(2021, 06, 05);

    final lecture1 = Lecture(
      'SOPE',
      'Sistemas Operativos',
      'T',
      DateTime(2021, 06, 07, 10),
      DateTime(2021, 06, 07, 12),
      'B315',
      'JAS',
      '',
      0,
      classNumber,
      484378,
    );
    final lecture2 = Lecture(
      'Sistemas',
      'SDIS',
      'T',
      DateTime(2021, 06, 07, 13),
      DateTime(2021, 06, 07, 15),
      'B315',
      'PMMS',
      '',
      0,
      classNumber,
      484381,
    );
    final lecture3 = Lecture(
      'Análise Matemática',
      'AMAT',
      'T',
      DateTime(2021, 06, 08, 12),
      DateTime(2021, 06, 08, 14),
      'B315',
      'PMMS',
      '',
      0,
      classNumber,
      484362,
    );
    final lecture4 = Lecture(
      'Programação',
      'PROG',
      'T',
      DateTime(2021, 06, 09, 10),
      DateTime(2021, 06, 09, 12),
      'B315',
      'JAS',
      '',
      0,
      classNumber,
      484422,
    );
    final lecture5 = Lecture(
      'Programação para Informáticos',
      'PPIN',
      'T',
      DateTime(2021, 06, 10, 14),
      DateTime(2021, 06, 10, 16),
      'B315',
      'SSN',
      '',
      0,
      classNumber,
      47775,
    );
    final lecture6 = Lecture(
      'Sistemas',
      'SDIS',
      'T',
      DateTime(2021, 06, 11, 15),
      DateTime(2021, 06, 11, 17),
      'B315',
      'PMMS',
      '',
      0,
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
