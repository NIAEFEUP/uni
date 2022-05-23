import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/redux/action_creators.dart';

import 'action_creators.dart';

void main() {
  group('Schedule Action Creator', () {
    final fetcherMock = MockScheduleFetcher();
    final Tuple2<String, String> userPersistentInfo = Tuple2('', '');
    final mockStore = MockStore();

    final profile = Profile();
    profile.courses = [Course(id: 7474)];
    final content = {
      'session': Session(authenticated: true),
      'profile': profile,
    };
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

    when(mockStore.state).thenReturn(AppState(content));
    test('When given a single schedule', () async {
      final Completer<Null> completer = Completer();
      final actionCreator =
          getUserSchedule(completer, userPersistentInfo, fetcher: fetcherMock);
      when(fetcherMock.getLectures(any))
          .thenAnswer((_) async => [lecture1, lecture2]);

      actionCreator(mockStore);
      await completer.future;
      final List<dynamic> actions =
          verify(mockStore.dispatch(captureAny)).captured;
      expect(actions.length, 3);
      expect(actions[0].status, RequestStatus.busy);
      expect(actions[1].lectures, [lecture1, lecture2]);
      expect(actions[2].status, RequestStatus.successful);
    });
    test('When an error occurs while trying to obtain the schedule', () async {
      final Completer<Null> completer = Completer();
      final actionCreator =
          getUserSchedule(completer, userPersistentInfo, fetcher: fetcherMock);
      when(fetcherMock.getLectures(any))
          .thenAnswer((_) async => throw Exception('💥'));

      actionCreator(mockStore);
      await completer.future;
      final List<dynamic> actions =
          verify(mockStore.dispatch(captureAny)).captured;
      expect(actions.length, 2);
      expect(actions[0].status, RequestStatus.busy);
      expect(actions[1].status, RequestStatus.failed);
    });
  });
}
