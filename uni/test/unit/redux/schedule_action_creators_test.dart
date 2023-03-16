// @dart=2.10




void main() {
  // group('Schedule Action Creator', () {
  //   final fetcherMock = MockScheduleFetcher();
  //   const Tuple2<String, String> userPersistentInfo = Tuple2('', '');
  //   final mockStore = MockStore();
  //
  //   final profile = Profile();
  //   profile.courses = [Course(id: 7474)];
  //   final content = {
  //     'session': Session(authenticated: true),
  //     'profile': profile,
  //   };
  //   const blocks = 4;
  //   const subject1 = 'SOPE';
  //   const startTime1 = '10:00';
  //   const room1 = 'B315';
  //   const typeClass1 = 'T';
  //   const teacher1 = 'JAS';
  //   const day1 = 0;
  //   const classNumber = 'MIEIC03';
  //   const occurrId1 = 484378;
  //   final lecture1 = Lecture.fromHtml(subject1, typeClass1, day1, startTime1,
  //       blocks, room1, teacher1, classNumber, occurrId1);
  //   const subject2 = 'SDIS';
  //   const startTime2 = '13:00';
  //   const room2 = 'B315';
  //   const typeClass2 = 'T';
  //   const teacher2 = 'PMMS';
  //   const day2 = 0;
  //   const occurrId2 = 484381;
  //   final lecture2 = Lecture.fromHtml(subject2, typeClass2, day2, startTime2,
  //       blocks, room2, teacher2, classNumber, occurrId2);
  //
  //   when(mockStore.state).thenReturn(AppState(content));
  //
  //   test('When given a single schedule', () async {
  //     final Completer<void> completer = Completer();
  //     final actionCreator =
  //         getUserSchedule(completer, userPersistentInfo, fetcher: fetcherMock);
  //     when(fetcherMock.getLectures(any, any))
  //         .thenAnswer((_) async => [lecture1, lecture2]);
  //
  //     actionCreator(mockStore);
  //     await completer.future;
  //     final List<dynamic> actions =
  //         verify(mockStore.dispatch(captureAny)).captured;
  //     expect(actions.length, 3);
  //     expect(actions[0].status, RequestStatus.busy);
  //     expect(actions[1].lectures, [lecture1, lecture2]);
  //     expect(actions[2].status, RequestStatus.successful);
  //   });
  //
  //   test('When an error occurs while trying to obtain the schedule', () async {
  //     final Completer<void> completer = Completer();
  //     final actionCreator =
  //         getUserSchedule(completer, userPersistentInfo, fetcher: fetcherMock);
  //     when(fetcherMock.getLectures(any, any))
  //         .thenAnswer((_) async => throw Exception('💥'));
  //
  //     actionCreator(mockStore);
  //     await completer.future;
  //     final List<dynamic> actions =
  //         verify(mockStore.dispatch(captureAny)).captured;
  //     expect(actions.length, 2);
  //     expect(actions[0].status, RequestStatus.busy);
  //     expect(actions[1].status, RequestStatus.failed);
  //   });
  // });
}
