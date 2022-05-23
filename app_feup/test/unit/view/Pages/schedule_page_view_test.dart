import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/Pages/schedule_page_view.dart';
import 'package:uni/view/Widgets/schedule_slot.dart';

import '../../../testable_widget.dart';

void main() {
  group('ExamsPage', () {
    final blocks = 4;
    final subject1 = 'SOPE';
    final startTime1 = '10:00';
    final room1 = 'B315';
    final typeClass1 = 'T';
    final teacher1 = 'JAS';
    final day1 = 0;
    final classNumber = 'MIEIC03';
    final lecture1 = Lecture.fromHtml(subject1, typeClass1, day1, startTime1,
        blocks, room1, teacher1, classNumber);
    final subject2 = 'SDIS';
    final startTime2 = '13:00';
    final room2 = 'B315';
    final typeClass2 = 'T';
    final teacher2 = 'PMMS';
    final day2 = 0;
    final lecture2 = Lecture.fromHtml(subject2, typeClass2, day2, startTime2,
        blocks, room2, teacher2, classNumber);
    final subject3 = 'AMAT';
    final startTime3 = '12:00';
    final room3 = 'B315';
    final typeClass3 = 'T';
    final teacher3 = 'PMMS';
    final day3 = 1;
    final lecture3 = Lecture.fromHtml(subject3, typeClass3, day3, startTime3,
        blocks, room3, teacher3, classNumber);
    final subject4 = 'PROG';
    final startTime4 = '10:00';
    final room4 = 'B315';
    final typeClass4 = 'T';
    final teacher4 = 'JAS';
    final day4 = 2;
    final lecture4 = Lecture.fromHtml(subject4, typeClass4, day4, startTime4,
        blocks, room4, teacher4, classNumber);
    final subject5 = 'PPIN';
    final startTime5 = '14:00';
    final room5 = 'B315';
    final typeClass5 = 'T';
    final teacher5 = 'SSN';
    final day5 = 3;
    final lecture5 = Lecture.fromHtml(subject5, typeClass5, day5, startTime5,
        blocks, room5, teacher5, classNumber);
    final subject6 = 'SDIS';
    final startTime6 = '15:00';
    final room6 = 'B315';
    final typeClass6 = 'T';
    final teacher6 = 'PMMS';
    final day6 = 4;
    final lecture6 = Lecture.fromHtml(subject6, typeClass6, day6, startTime6,
        blocks, room6, teacher6, classNumber);

    final List<String> daysOfTheWeek = [
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira'
    ];

    testWidgets('When given one lecture on a single day',
        (WidgetTester tester) async {
      final List<List<Lecture>> aggLectures = [
        [lecture1],
        [],
        [],
        [],
        []
      ];

      final widget = makeTestableWidget(
          child: DefaultTabController(
              length: daysOfTheWeek.length,
              child: SchedulePageView(
                daysOfTheWeek: daysOfTheWeek,
                aggLectures: aggLectures,
                scheduleStatus: RequestStatus.successful,
                tabController: null,
              )));
      await tester.pumpWidget(widget);

      expect(
          find.descendant(
              of: find.byKey(Key('schedule-page-day-column-0')),
              matching: find.byType(ScheduleSlot)),
          findsOneWidget);
    });
    testWidgets('When given two lectures on a single day',
        (WidgetTester tester) async {
      final List<List<Lecture>> aggLectures = [
        [lecture1, lecture2],
        [],
        [],
        [],
        []
      ];

      final widget = makeTestableWidget(
          child: DefaultTabController(
              length: daysOfTheWeek.length,
              child: SchedulePageView(
                daysOfTheWeek: daysOfTheWeek,
                aggLectures: aggLectures,
                scheduleStatus: RequestStatus.successful,
                tabController: null,
              )));
      await tester.pumpWidget(widget);

      expect(
          find.descendant(
              of: find.byKey(Key('schedule-page-day-column-0')),
              matching: find.byType(ScheduleSlot)),
          findsNWidgets(2));
    });
    testWidgets('When given lectures on different days',
        (WidgetTester tester) async {
      final List<List<Lecture>> aggLectures = [
        [lecture1, lecture2],
        [lecture3],
        [lecture4],
        [lecture5],
        [lecture6]
      ];

      final widget = makeTestableWidget(
          child: DefaultTabController(
              length: daysOfTheWeek.length,
              child: SchedulePageView(
                daysOfTheWeek: daysOfTheWeek,
                aggLectures: aggLectures,
                scheduleStatus: RequestStatus.successful,
                tabController: null,
              )));
      await tester.pumpWidget(widget);

      expect(
          find.descendant(
              of: find.byKey(Key('schedule-page-day-column-0')),
              matching: find.byType(ScheduleSlot)),
          findsNWidgets(2));

      await tester.tap(find.byKey(Key('schedule-page-tab-1')));
      await tester.pumpAndSettle();

      expect(
          find.descendant(
              of: find.byKey(Key('schedule-page-day-column-1')),
              matching: find.byType(ScheduleSlot)),
          findsOneWidget);

      await tester.tap(find.byKey(Key('schedule-page-tab-2')));
      await tester.pumpAndSettle();

      expect(
          find.descendant(
              of: find.byKey(Key('schedule-page-day-column-2')),
              matching: find.byType(ScheduleSlot)),
          findsOneWidget);

      await tester.tap(find.byKey(Key('schedule-page-tab-3')));
      await tester.pumpAndSettle();

      expect(
          find.descendant(
              of: find.byKey(Key('schedule-page-day-column-3')),
              matching: find.byType(ScheduleSlot)),
          findsOneWidget);

      await tester.tap(find.byKey(Key('schedule-page-tab-4')));
      await tester.pumpAndSettle();

      expect(
          find.descendant(
              of: find.byKey(Key('schedule-page-day-column-4')),
              matching: find.byType(ScheduleSlot)),
          findsOneWidget);
    });
  });
}
