import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uni/controller/fetchers/schedule_fetcher/schedule_fetcher.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/providers/lazy/lecture_provider.dart';
import 'package:uni/model/request_status.dart';
import 'package:uni/session/flows/base/session.dart';

import '../../mocks/unit/providers/lecture_provider_test.mocks.dart';
import '../../test_widget.dart';

@GenerateNiceMocks(
  [MockSpec<ScheduleFetcher>(), MockSpec<Client>(), MockSpec<Response>()],
)
void main() async {
  await initTestEnvironment();

  group('Schedule Action Creator', () {
    final fetcherMock = MockScheduleFetcher();
    final mockClient = MockClient();
    final mockResponse = MockResponse();
    final profile = Profile()..courses = [Course(id: 7474)];
    final session = Session(username: '', cookies: '', faculties: ['feup']);
    final day = DateTime(2021, 06);

    final lecture1 = Lecture.fromHtml(
      'SOPE',
      'T',
      day,
      '10:00',
      4,
      'B315',
      'JAS',
      'MIEIC03',
      484378,
    );
    final lecture2 = Lecture.fromHtml(
      'SDIS',
      'T',
      day,
      '13:00',
      4,
      'B315',
      'PMMS',
      'MIEIC03',
      484381,
    );

    NetworkRouter.httpClient = mockClient;
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => mockResponse);
    when(mockResponse.statusCode).thenReturn(200);

    late LectureProvider provider;
    setUp(() {
      provider = LectureProvider();
      expect(provider.requestStatus, RequestStatus.busy);
    });

    test('When given a single schedule', () async {
      when(fetcherMock.getLectures(any, any))
          .thenAnswer((_) async => [lecture1, lecture2]);

      final lectures = await provider.fetchUserLectures(
        session,
        profile,
        fetcher: fetcherMock,
      );

      provider.setState(lectures);

      expect(provider.state, [lecture1, lecture2]);
    });

    test('When an error occurs while trying to obtain the schedule', () async {
      when(fetcherMock.getLectures(any, any))
          .thenAnswer((_) async => throw Exception('💥'));

      throwsA(
        () async => provider.fetchUserLectures(
          session,
          profile,
          fetcher: fetcherMock,
        ),
      );
    });
  });
}
