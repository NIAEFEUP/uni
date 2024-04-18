import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/lazy/lecture_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/view/schedule/schedule.dart';

import '../../mocks/integration/src/schedule_page_test.mocks.dart';
import '../../test_widget.dart';
import '../../unit/view/Widgets/schedule_slot_test.dart';

class UriMatcher extends CustomMatcher {
  UriMatcher(Matcher matcher) : super('Uri that has', 'string', matcher);

  @override
  Object featureValueOf(dynamic actual) => (actual as Uri).toString();
}

@GenerateNiceMocks([
  MockSpec<http.Client>(),
  MockSpec<http.Response>(),
  MockSpec<SessionProvider>(),
])
void main() async {
  await initTestEnvironment();

  group('SchedulePage Integration Tests', () {
    final mockClient = MockClient();
    final mockResponse = MockResponse();
    final badMockResponse = MockResponse();

    const htmlFetcherIdentifier = 'hor_geral.estudantes_view';
    const jsonFetcherIdentifier = 'mob_hor_geral.estudante';

    Future<void> testSchedule(WidgetTester tester) async {
      final profile = Profile()..courses = [Course(id: 7474)];

      NetworkRouter.httpClient = mockClient;
      when(badMockResponse.statusCode).thenReturn(500);

      final scheduleProvider = LectureProvider();
      final sessionProvider = MockSessionProvider();

      when(sessionProvider.state).thenReturn(
        Session(username: 'up1234', cookies: 'cookie', faculties: ['feup']),
      );

      final widget = SchedulePage();

      final providers = [
        ChangeNotifierProvider(create: (_) => scheduleProvider),
        ChangeNotifierProvider(create: (_) => sessionProvider),
      ];

      await tester.pumpWidget(testableWidget(widget, providers: providers));
      await tester.pump();

      const scheduleSlotTimeKey1 = 'schedule-slot-time-11:00-13:00';
      const scheduleSlotTimeKey2 = 'schedule-slot-time-14:00-16:00';

      expect(find.byKey(const Key(scheduleSlotTimeKey1)), findsNothing);
      expect(find.byKey(const Key(scheduleSlotTimeKey2)), findsNothing);

      final lectures = await scheduleProvider.fetchUserLectures(
        Session(username: '', cookies: '', faculties: ['feup']),
        profile,
        persistentSession: false,
      );

      scheduleProvider.setState(lectures);

      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byKey(const Key('schedule-page-tab-2')));
      await tester.tap(find.byKey(const Key('schedule-page-tab-2')));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key('schedule-page-tab-1')));
      await tester.tap(find.byKey(const Key('schedule-page-tab-1')));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key('schedule-page-tab-0')));
      await tester.tap(find.byKey(const Key('schedule-page-tab-0')));
      await tester.pumpAndSettle();

      testScheduleSlot('ASSO', '11:00', '13:00', 'EaD', 'TP', 'DRP');

      await tester.ensureVisible(find.byKey(const Key('schedule-page-tab-2')));
      await tester.tap(find.byKey(const Key('schedule-page-tab-2')));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const Key('schedule-page-tab-3')));
      await tester.tap(find.byKey(const Key('schedule-page-tab-3')));
      await tester.pumpAndSettle();

      testScheduleSlot('IOPE', '14:00', '16:00', 'EaD', 'TE', 'MTD');
    }

    testWidgets('Schedule with JSON Fetcher', (tester) async {
      NetworkRouter.httpClient = mockClient;
      final mockJson = File('test/integration/resources/schedule_example.json')
          .readAsStringSync(encoding: const Latin1Codec());
      when(mockResponse.body).thenReturn(mockJson);
      when(mockResponse.statusCode).thenReturn(200);
      when(
        mockClient.get(
          argThat(UriMatcher(contains(htmlFetcherIdentifier))),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer((_) async => badMockResponse);

      when(
        mockClient.get(
          argThat(UriMatcher(contains(jsonFetcherIdentifier))),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer((_) async => mockResponse);

      await testSchedule(tester);
    });

    testWidgets('Schedule with HTML Fetcher', (tester) async {
      final mockHtml = File('test/integration/resources/schedule_example.html')
          .readAsStringSync(encoding: const Latin1Codec());
      when(mockResponse.body).thenReturn(mockHtml);
      when(mockResponse.statusCode).thenReturn(200);
      when(
        mockClient.get(
          argThat(UriMatcher(contains(htmlFetcherIdentifier))),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer((_) async => mockResponse);

      when(
        mockClient.get(
          argThat(UriMatcher(contains(jsonFetcherIdentifier))),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer((_) async => badMockResponse);

      await testSchedule(tester);
    });
  });
}
