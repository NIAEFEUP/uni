import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/controller/middleware.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/schedule_page_model.dart';
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
    final subject1 = 'ASSO';
    final startTime1 = '11h00';
    final endTime1 = '13h00';
    final room1 = 'EaD';
    final typeClass1 = 'TP';
    final teacher1 = 'DRP';

    final subject2 = 'IOPE';
    final startTime2 = '14h00';
    final endTime2 = '16h00';
    final room2 = 'EaD';
    final typeClass2 = 'TE';
    final teacher2 = 'MTD';

    final htmlFetcherIdentifier = 'hor_geral.estudantes_view';
    final jsonFetcherIdentifier = 'mob_hor_geral.estudante?pv_codigo';

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
      final Completer<Null> completer = Completer();
      final actionCreator = getUserSchedule(completer, Tuple2('', ''));

      final widget = testableReduxWidget(child: SchedulePage(), store: store);

      await tester.pumpWidget(widget);

      final scheduleSlotTimeKey1 = 'schedule-slot-time-$startTime1-$endTime1';
      final scheduleSlotTimeKey2 = 'schedule-slot-time-$startTime2-$endTime2';

      expect(find.byKey(Key(scheduleSlotTimeKey1)), findsNothing);
      expect(find.byKey(Key(scheduleSlotTimeKey2)), findsNothing);

      actionCreator(store);

      await completer.future;

      await tester.tap(find.byKey(Key('schedule-page-tab-2')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('schedule-page-tab-1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('schedule-page-tab-0')));
      await tester.pumpAndSettle();

      testScheduleSlot(
          subject1, startTime1, endTime1, room1, typeClass1, teacher1);

      await tester.tap(find.byKey(Key('schedule-page-tab-2')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(Key('schedule-page-tab-3')));
      await tester.pumpAndSettle();

      testScheduleSlot(
          subject2, startTime2, endTime2, room2, typeClass2, teacher2);
    }

    testWidgets('Schedule with JSON Fetcher', (WidgetTester tester) async {
      NetworkRouter.httpClient = mockClient;
      when(badMockResponse.statusCode).thenReturn(500);
      final mockHtml = File('test/integration/resources/schedule_example.json')
          .readAsStringSync(encoding: Latin1Codec());
      when(mockResponse.body).thenReturn(mockHtml);
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
          .readAsStringSync(encoding: Latin1Codec());
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
