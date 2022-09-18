import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/view/schedule/schedule.dart';
import 'package:uni/view/schedule/widgets/schedule_slot.dart';

import '../../../testable_widget.dart';

void main() {
  group('SchedulePage', () {
    const blocks = 4;
    const subject1 = 'SOPE';
    const startTime1 = '10:00';
    const room1 = 'B315';
    const typeClass1 = 'T';
    const teacher1 = 'JAS';
    const day1 = 0;
    const classNumber = 'MIEIC03';
    const occurrId1 = 484378;
    final lecture1 = Lecture.fromHtml(subject1, typeClass1, day1, startTime1,
        blocks, room1, teacher1, classNumber, occurrId1);
    const subject2 = 'SDIS';
    const startTime2 = '13:00';
    const room2 = 'B315';
    const typeClass2 = 'T';
    const teacher2 = 'PMMS';
    const day2 = 0;
    const occurrId2 = 484381;
    final lecture2 = Lecture.fromHtml(subject2, typeClass2, day2, startTime2,
        blocks, room2, teacher2, classNumber, occurrId2);
    const subject3 = 'AMAT';
    const startTime3 = '12:00';
    const room3 = 'B315';
    const typeClass3 = 'T';
    const teacher3 = 'PMMS';
    const day3 = 1;
    const occurrId3 = 484362;
    final lecture3 = Lecture.fromHtml(subject3, typeClass3, day3, startTime3,
        blocks, room3, teacher3, classNumber, occurrId3);
    const subject4 = 'PROG';
    const startTime4 = '10:00';
    const room4 = 'B315';
    const typeClass4 = 'T';
    const teacher4 = 'JAS';
    const day4 = 2;
    const occurrId4 = 484422;
    final lecture4 = Lecture.fromHtml(subject4, typeClass4, day4, startTime4,
        blocks, room4, teacher4, classNumber, occurrId4);
    const subject5 = 'PPIN';
    const startTime5 = '14:00';
    const room5 = 'B315';
    const typeClass5 = 'T';
    const teacher5 = 'SSN';
    const day5 = 3;
    const occurrId5 = 47775;
    final lecture5 = Lecture.fromHtml(subject5, typeClass5, day5, startTime5,
        blocks, room5, teacher5, classNumber, occurrId5);
    const subject6 = 'SDIS';
    const startTime6 = '15:00';
    const room6 = 'B315';
    const typeClass6 = 'T';
    const teacher6 = 'PMMS';
    const day6 = 4;
    const occurrId6 = 12345;
    final lecture6 = Lecture.fromHtml(subject6, typeClass6, day6, startTime6,
        blocks, room6, teacher6, classNumber, occurrId6);

    final List<String> daysOfTheWeek = [
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira'
    ];

    testWidgets('When given one lecture on a single day',
        (WidgetTester tester) async {

      final widget = makeTestableWidget(
          child: SchedulePageView(lectures: [lecture1], scheduleStatus: RequestStatus.successful));
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      final SchedulePageViewState myWidgetState = tester.state(find.byType(SchedulePageView));
      myWidgetState.tabController!.animateTo(0);
      await tester.pumpAndSettle();

      expect(
          find.descendant(
              of: find.byKey(const Key('schedule-page-day-column-0')),
              matching: find.byType(ScheduleSlot)),
          findsOneWidget);
    });
    testWidgets('When given two lectures on a single day',
        (WidgetTester tester) async {

      final widget = makeTestableWidget(
          child: SchedulePageView(lectures: [lecture1, lecture2], scheduleStatus: RequestStatus.successful));
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      final SchedulePageViewState myWidgetState = tester.state(find.byType(SchedulePageView));
      myWidgetState.tabController!.animateTo(0);
      await tester.pumpAndSettle();

      expect(
          find.descendant(
              of: find.byKey(const Key('schedule-page-day-column-0')),
              matching: find.byType(ScheduleSlot)),
          findsNWidgets(2));
    });
    testWidgets('When given lectures on different days',
        (WidgetTester tester) async {

      final widget = makeTestableWidget(
          child: DefaultTabController(
              length: daysOfTheWeek.length,
              child: SchedulePageView(
                  lectures: [lecture1, lecture2, lecture3, lecture4, lecture5, lecture6],
                  scheduleStatus: RequestStatus.successful)));
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      final SchedulePageViewState myWidgetState = tester.state(find.byType(SchedulePageView));
      myWidgetState.tabController!.animateTo(0);
      await tester.pumpAndSettle();

      expect(
          find.descendant(
              of: find.byKey(const Key('schedule-page-day-column-0')),
              matching: find.byType(ScheduleSlot)),
          findsNWidgets(2));

      await tester.tap(find.byKey(const Key('schedule-page-tab-1')));
      await tester.pumpAndSettle();

      expect(
          find.descendant(
              of: find.byKey(const Key('schedule-page-day-column-1')),
              matching: find.byType(ScheduleSlot)),
          findsOneWidget);

      await tester.tap(find.byKey(const Key('schedule-page-tab-2')));
      await tester.pumpAndSettle();

      expect(
          find.descendant(
              of: find.byKey(const Key('schedule-page-day-column-2')),
              matching: find.byType(ScheduleSlot)),
          findsOneWidget);

      await tester.tap(find.byKey(const Key('schedule-page-tab-3')));
      await tester.pumpAndSettle();

      expect(
          find.descendant(
              of: find.byKey(const Key('schedule-page-day-column-3')),
              matching: find.byType(ScheduleSlot)),
          findsOneWidget);

      await tester.tap(find.byKey(const Key('schedule-page-tab-4')));
      await tester.pumpAndSettle();

      expect(
          find.descendant(
              of: find.byKey(const Key('schedule-page-day-column-4')),
              matching: find.byType(ScheduleSlot)),
          findsOneWidget);
    });
  });
}
