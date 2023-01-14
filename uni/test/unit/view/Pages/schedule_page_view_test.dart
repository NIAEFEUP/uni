import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/last_user_info_provider.dart';
import 'package:uni/model/request_status.dart';
import 'package:uni/view/schedule/schedule.dart';
import 'package:uni/view/schedule/widgets/schedule_slot.dart';

import '../../../test_widget.dart';

void main() {
  group('SchedulePage', () {
    const blocks = 4;
    const classNumber = 'MIEIC03';

    final lecture1 = Lecture.fromHtml(
        'SOPE', 'T', 0, '10:00', blocks, 'B315', 'JAS', classNumber, 484378);
    final lecture2 = Lecture.fromHtml(
        'SDIS', 'T', 0, '13:00', blocks, 'B315', 'PMMS', classNumber, 484381);
    final lecture3 = Lecture.fromHtml(
        'AMAT', 'T', 1, '12:00', blocks, 'B315', 'PMMS', classNumber, 484362);
    final lecture4 = Lecture.fromHtml(
        'PROG', 'T', 2, '10:00', blocks, 'B315', 'JAS', classNumber, 484422);
    final lecture5 = Lecture.fromHtml(
        'PPIN', 'T', 3, '14:00', blocks, 'B315', 'SSN', classNumber, 47775);
    final lecture6 = Lecture.fromHtml(
        'SDIS', 'T', 4, '15:00', blocks, 'B315', 'PMMS', classNumber, 12345);

    final List<String> daysOfTheWeek = [
      'Segunda-feira',
      'Terça-feira',
      'Quarta-feira',
      'Quinta-feira',
      'Sexta-feira'
    ];

    Widget testWidgetWithProviders(Widget child) {
      return MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => LastUserInfoProvider())
      ], child: testWidget(child));
    }

    testWidgets('When given one lecture on a single day',
        (WidgetTester tester) async {
      final widget = SchedulePageView(
          lectures: [lecture1], scheduleStatus: RequestStatus.successful);

      await tester.pumpWidget(testWidgetWithProviders(widget));
      await tester.pumpAndSettle();
      final SchedulePageViewState myWidgetState =
          tester.state(find.byType(SchedulePageView));
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
      final widget = SchedulePageView(
          lectures: [lecture1, lecture2],
          scheduleStatus: RequestStatus.successful);
      await tester.pumpWidget(testWidgetWithProviders(widget));
      await tester.pumpAndSettle();
      final SchedulePageViewState myWidgetState =
          tester.state(find.byType(SchedulePageView));
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
      final widget = DefaultTabController(
          length: daysOfTheWeek.length,
          child: SchedulePageView(lectures: [
            lecture1,
            lecture2,
            lecture3,
            lecture4,
            lecture5,
            lecture6
          ], scheduleStatus: RequestStatus.successful));

      await tester.pumpWidget(testWidgetWithProviders(widget));
      await tester.pumpAndSettle();
      final SchedulePageViewState myWidgetState =
          tester.state(find.byType(SchedulePageView));
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
