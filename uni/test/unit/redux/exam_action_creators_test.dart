// @dart=2.10




void main() {
  // group('Exams Action Creator', () {
  //   final List<String> rooms = ['B119', 'B107', 'B205'];
  //   final sopeCourseUnit = CourseUnit(
  //       abbreviation: 'SOPE', occurrId: 0, name: 'Sistemas Operativos', status: 'V');
  //   final sdisCourseUnit = CourseUnit(
  //       abbreviation: 'SDIS', occurrId: 0, name: 'Sistemas Distribuídos', status: 'V');
  //   NetworkRouter.httpClient = MockClient();
  //   final DateTime beginSopeExam = DateTime.parse('2800-09-12 12:00');
  //   final DateTime endSopeExam = DateTime.parse('2800-09-12 15:00');
  //   final sopeExam = Exam('1229',beginSopeExam, endSopeExam, 'SOPE',
  //       rooms, 'Recurso - Época Recurso (2ºS)', 'feup');
  //   final DateTime beginSdisExam = DateTime.parse('2800-09-12 12:00');
  //   final DateTime endSdisExam = DateTime.parse('2800-09-12 15:00');
  //   final sdisExam = Exam('1230',beginSdisExam, endSdisExam, 'SDIS',
  //       rooms, 'Recurso - Época Recurso (2ºS)', 'feup');
  //   final parserMock = ParserMock();
  //   const Tuple2<String, String> userPersistentInfo = Tuple2('', '');
  //   final mockStore = MockStore();
  //   final mockCourse = MockCourse();
  //   final mockResponse = MockResponse();
  //
  //   final profile = Profile();
  //   profile.courses = [mockCourse];
  //   final content = {
  //     'session': Session(authenticated: true),
  //     'currUcs': [sopeCourseUnit, sdisCourseUnit],
  //     'profile': profile,
  //   };
  //
  //   when(NetworkRouter.httpClient?.get(any, headers: anyNamed('headers')))
  //       .thenAnswer((_) async => mockResponse);
  //   when(mockResponse.statusCode).thenReturn(200);
  //   when(mockStore.state).thenReturn(AppState(content));
  //   when(mockCourse.faculty).thenReturn("feup");
  //   test('When given a single exam', () async {
  //     final Completer<void> completer = Completer();
  //     when(parserMock.parseExams(any, mockCourse)).thenAnswer((_) async => {sopeExam});
  //     final actionCreator =
  //         getUserExams(completer, parserMock, userPersistentInfo);
  //     actionCreator(mockStore);
  //     await completer.future;
  //     final List<dynamic> actions =
  //         verify(mockStore.dispatch(captureAny)).captured;
  //     expect(actions.length, 3);
  //     expect(actions[0].status, RequestStatus.busy);
  //     expect(actions[1].status, RequestStatus.successful);
  //     expect(actions[2].exams, [sopeExam]);
  //   });
  //   test('When given two exams', () async {
  //     final Completer<void> completer = Completer();
  //     final actionCreator =
  //         getUserExams(completer, parserMock, userPersistentInfo);
  //     when(parserMock.parseExams(any, mockCourse))
  //         .thenAnswer((_) async => {sopeExam, sdisExam});
  //
  //     actionCreator(mockStore);
  //     await completer.future;
  //     final List<dynamic> actions =
  //         verify(mockStore.dispatch(captureAny)).captured;
  //     expect(actions.length, 3);
  //     expect(actions[0].status, RequestStatus.busy);
  //     expect(actions[1].status, RequestStatus.successful);
  //     expect(actions[2].exams, [sopeExam, sdisExam]);
  //   });
  //   test('''When given three exams but one is to be parsed out,
  //               since it is a Special Season Exam''', () async {
  //     final DateTime begin = DateTime.parse('2800-09-12 12:00');
  //     final DateTime end = DateTime.parse('2800-09-12 15:00');
  //     final specialExam = Exam('1231',
  //         begin,
  //         end,
  //         'SDIS',
  //         rooms,
  //         'Exames ao abrigo de estatutos especiais - Port.Est.Especiais', 'feup');
  //     final Completer<void> completer = Completer();
  //     final actionCreator =
  //         getUserExams(completer, parserMock, userPersistentInfo);
  //     when(parserMock.parseExams(any, mockCourse))
  //         .thenAnswer((_) async => {sopeExam, sdisExam, specialExam});
  //
  //     actionCreator(mockStore);
  //     await completer.future;
  //     final List<dynamic> actions =
  //         verify(mockStore.dispatch(captureAny)).captured;
  //     expect(actions.length, 3);
  //     expect(actions[0].status, RequestStatus.busy);
  //     expect(actions[1].status, RequestStatus.successful);
  //     expect(actions[2].exams, [sopeExam, sdisExam]);
  //   });
  //   test('When an error occurs while trying to obtain the exams', () async {
  //     final Completer<void> completer = Completer();
  //     final actionCreator =
  //         getUserExams(completer, parserMock, userPersistentInfo);
  //     when(parserMock.parseExams(any, mockCourse))
  //         .thenAnswer((_) async => throw Exception('RIP'));
  //
  //     actionCreator(mockStore);
  //     await completer.future;
  //     final List<dynamic> actions =
  //         verify(mockStore.dispatch(captureAny)).captured;
  //     expect(actions.length, 2);
  //     expect(actions[0].status, RequestStatus.busy);
  //     expect(actions[1].status, RequestStatus.failed);
  //   });
  //   test('When Exam is today in one hour', () async {
  //     final DateTime begin = DateTime.now().add(const Duration(hours: 1));
  //     final DateTime end = DateTime.now().add(const Duration(hours: 2));
  //     final todayExam = Exam('1232',begin, end, 'SDIS', rooms,
  //         'Recurso - Época Recurso (1ºS)', 'feup');
  //     final Completer<void> completer = Completer();
  //     final actionCreator =
  //         getUserExams(completer, parserMock, userPersistentInfo);
  //     when(parserMock.parseExams(any, mockCourse)).thenAnswer((_) async => {todayExam});
  //
  //     actionCreator(mockStore);
  //     await completer.future;
  //     final List<dynamic> actions =
  //         verify(mockStore.dispatch(captureAny)).captured;
  //     expect(actions.length, 3);
  //     expect(actions[0].status, RequestStatus.busy);
  //     expect(actions[1].status, RequestStatus.successful);
  //     expect(actions[2].exams, [todayExam]);
  //   });
  //   test('When Exam was one hour ago', () async {
  //     final DateTime end = DateTime.now().subtract(const Duration(hours: 1));
  //     final DateTime begin = DateTime.now().subtract(const Duration(hours: 2));
  //     final todayExam = Exam('1233',begin, end, 'SDIS', rooms,
  //         'Recurso - Época Recurso (1ºS)', 'feup');
  //     final Completer<void> completer = Completer();
  //     final actionCreator =
  //         getUserExams(completer, parserMock, userPersistentInfo);
  //     when(parserMock.parseExams(any, mockCourse)).thenAnswer((_) async => {todayExam});
  //
  //     actionCreator(mockStore);
  //     await completer.future;
  //     final List<dynamic> actions =
  //         verify(mockStore.dispatch(captureAny)).captured;
  //     expect(actions.length, 3);
  //     expect(actions[0].status, RequestStatus.busy);
  //     expect(actions[1].status, RequestStatus.successful);
  //     expect(actions[2].exams, []);
  //   });
  //   test('When Exam is ocurring', () async {
  //     final DateTime before = DateTime.now().subtract(const Duration(hours: 1));
  //     final DateTime after = DateTime.now().add(const Duration(hours: 1));
  //     final todayExam = Exam('1234',before, after, 'SDIS', rooms,
  //         'Recurso - Época Recurso (1ºS)','feup');
  //     final Completer<void> completer = Completer();
  //     final actionCreator =
  //         getUserExams(completer, parserMock, userPersistentInfo);
  //     when(parserMock.parseExams(any, mockCourse)).thenAnswer((_) async => {todayExam});
  //
  //     actionCreator(mockStore);
  //     await completer.future;
  //     final List<dynamic> actions =
  //         verify(mockStore.dispatch(captureAny)).captured;
  //     expect(actions.length, 3);
  //     expect(actions[0].status, RequestStatus.busy);
  //     expect(actions[1].status, RequestStatus.successful);
  //     expect(actions[2].exams, [todayExam]);
  //   });
  // });
}
