// @dart=2.10

import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';

import 'package:uni/model/providers/lecture_provider.dart';
import 'package:uni/model/request_status.dart';

import 'mocks.dart';

void main() {
  group('Schedule Action Creator', () {
    final fetcherMock = ScheduleFetcherMock();
    final mockClient = MockClient();
    final mockResponse = MockResponse();
    const Tuple2<String, String> userPersistentInfo = Tuple2('', '');
    final profile = Profile();
    profile.courses = [Course(id: 7474)];
    final session = Session(authenticated: true);

    final lecture1 = Lecture.fromHtml(
        'SOPE', 'T', 0, '10:00', 4, 'B315', 'JAS', 'MIEIC03', 484378);
    final lecture2 = Lecture.fromHtml(
        'SDIS', 'T', 0, '13:00', 4, 'B315', 'PMMS', 'MIEIC03', 484381);

    NetworkRouter.httpClient = mockClient;
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => mockResponse);
    when(mockResponse.statusCode).thenReturn(200);

    LectureProvider provider;
    setUp(() {
      provider = LectureProvider();
      expect(provider.status, RequestStatus.none);
    });

    test('When given a single schedule', () async {
      final Completer<void> action = Completer();

      when(fetcherMock.getLectures(any, any))
          .thenAnswer((_) async => [lecture1, lecture2]);

      provider.getUserLectures(action, userPersistentInfo, session, profile,
          fetcher: fetcherMock);
      expect(provider.status, RequestStatus.busy);

      await action.future;

      expect(provider.lectures, [lecture1, lecture2]);
      expect(provider.status, RequestStatus.successful);
    });

    test('When an error occurs while trying to obtain the schedule', () async {
      final Completer<void> action = Completer();

      when(fetcherMock.getLectures(any, any))
          .thenAnswer((_) async => throw Exception('💥'));

      provider.getUserLectures(action, userPersistentInfo, session, profile);
      expect(provider.status, RequestStatus.busy);

      await action.future;

      expect(provider.status, RequestStatus.failed);
    });
  });
}
