// @dart=2.10

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/controller/middleware.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/utils/datetime.dart';
import 'package:uni/view/schedule/schedule.dart';
import 'package:uni/redux/action_creators.dart';
import 'package:uni/redux/reducers.dart';

import '../../testable_redux_widget.dart';
import '../../unit/view/Widgets/schedule_slot_test.dart';

class MockClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class UriMatcher extends CustomMatcher {
  UriMatcher(matcher) : super('Uri that has', 'string', matcher);

  @override
  Object featureValueOf(actual) => (actual as Uri).toString();
}

void main() {
  group('SchedulePage Integration Tests', () {
    final mockClient = MockClient();
    final mockResponse = MockResponse();
    final badMockResponse = MockResponse();
    const subject1 = 'ASSO';
    final startTime1 = DateTime(1, 1, 1, 11, 0);
    final endTime1 = DateTime(1, 1, 1, 13, 0);
    const room1 = 'EaD';
    const typeClass1 = 'TP';
    const teacher1 = 'DRP';

    const subject2 = 'IOPE';
    final startTime2 = DateTime(1, 1, 1, 14, 0);
    final endTime2 = DateTime(1, 1, 1, 16, 0);
    const room2 = 'EaD';
    const typeClass2 = 'TE';
    const teacher2 = 'MTD';

    const htmlFetcherIdentifier = 'hor_geral.estudantes_view';
    const jsonFetcherIdentifier = 'mob_hor_geral.estudante';

    Future testSchedule(WidgetTester tester) async {
      final profile = Profile();
      profile.courses = [Course(id: 7474)];
      final store = Store<AppState>(appReducers,
          initialState: AppState({
            'session': Session(authenticated: true),
            'scheduleStatus': RequestStatus.none,
            'schedule': <Lecture>[],
            'profile': profile
          }),
          middleware: [generalMiddleware]);
      NetworkRouter.httpClient = mockClient;
      when(badMockResponse.statusCode).thenReturn(500);
      final Completer<void> completer = Completer();
      final actionCreator = getUserSchedule(completer, const Tuple2('', ''));

      final widget =
          testableReduxWidget(child: const SchedulePage(), store: store);

      await tester.pumpWidget(widget);


      final begin1 = readableTime(startTime1);
      final end1 = readableTime(endTime1);
      final begin2 = readableTime(startTime2);
      final end2 = readableTime(endTime2);

      final scheduleSlotTimeKey1 = 'schedule-slot-time-$begin1-$end1';
      final scheduleSlotTimeKey2 = 'schedule-slot-time-$begin2-$end2';

      expect(find.byKey(Key(scheduleSlotTimeKey1)), findsNothing);
      expect(find.byKey(Key(scheduleSlotTimeKey2)), findsNothing);

      actionCreator(store);

      await completer.future;

      await tester.tap(find.byKey(const Key('schedule-page-tab-2')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('schedule-page-tab-1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('schedule-page-tab-0')));
      await tester.pumpAndSettle();

      testScheduleSlot(
          subject1, startTime1, endTime1, room1, typeClass1, teacher1);

      await tester.tap(find.byKey(const Key('schedule-page-tab-2')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('schedule-page-tab-3')));
      await tester.pumpAndSettle();

      testScheduleSlot(
          subject2, startTime2, endTime2, room2, typeClass2, teacher2);
    }

    testWidgets('Schedule with JSON Fetcher', (WidgetTester tester) async {
      NetworkRouter.httpClient = mockClient;
      final mockJson = File('test/integration/resources/schedule_example.json')
          .readAsStringSync(encoding: const Latin1Codec());
      when(mockResponse.body).thenReturn(mockJson);
      when(mockResponse.statusCode).thenReturn(200);
      when(mockClient.get(argThat(UriMatcher(contains(htmlFetcherIdentifier))),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => badMockResponse);

      when(mockClient.get(argThat(UriMatcher(contains(jsonFetcherIdentifier))),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => mockResponse);

      await testSchedule(tester);
    });

    testWidgets('Schedule with HTML Fetcher', (WidgetTester tester) async {
      final mockHtml = File('test/integration/resources/schedule_example.html')
          .readAsStringSync(encoding: const Latin1Codec());
      when(mockResponse.body).thenReturn(mockHtml);
      when(mockResponse.statusCode).thenReturn(200);
      when(mockClient.get(argThat(UriMatcher(contains(htmlFetcherIdentifier))),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => mockResponse);

      when(mockClient.get(argThat(UriMatcher(contains(jsonFetcherIdentifier))),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => badMockResponse);

      await testSchedule(tester);
    });
  });
}
