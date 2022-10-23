// @dart=2.10




void main() {
  // group('Exams Action Creator', () {
  //   final sopeCourseUnit = CourseUnit(
  //       abbreviation: 'SOPE', occurrId: 0, name: 'Sistemas Operativos');
  //   final sdisCourseUnit = CourseUnit(
  //       abbreviation: 'SDIS', occurrId: 0, name: 'Sistemas Distribuídos');
  //   NetworkRouter.httpClient = MockClient();
  //   final sopeExam = Exam('09:00-12:00', 'SOPE', 'B119, B107, B205',
  //       '2800-09-11', 'Recurso - Época Recurso (2ºS)', 'Quarta');
  //   final sdisExam = Exam('12:00-15:00', 'SDIS', 'B119, B107, B205',
  //       '2800-09-12', 'Recurso - Época Recurso (2ºS)', 'Quarta');
  //   final parserMock = ParserMock();
  //   const Tuple2<String, String> userPersistentInfo = Tuple2('', '');
  //   final mockStore = MockStore();
  //   final mockResponse = MockResponse();
  //
  //   final profile = Profile();
  //   profile.courses = [Course(id: 7474)];
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
  //   test('When given a single exam', () async {
  //     final Completer<void> completer = Completer();
  //     final actionCreator =
  //         getUserExams(completer, parserMock, userPersistentInfo);
  //     when(parserMock.parseExams(any)).thenAnswer((_) async => {sopeExam});
  //
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
  //     when(parserMock.parseExams(any))
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
  //     final specialExam = Exam(
  //         '12:00-15:00',
  //         'SDIS',
  //         'B119, B107, B205',
  //         '2800-09-12',
  //         'Exames ao abrigo de estatutos especiais - Port.Est.Especiais',
  //         'Quarta');
  //     final Completer<void> completer = Completer();
  //     final actionCreator =
  //         getUserExams(completer, parserMock, userPersistentInfo);
  //     when(parserMock.parseExams(any))
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
  //     when(parserMock.parseExams(any))
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
  //     final String formattedDate = DateFormat('yyyy-MM-dd').format(begin);
  //     final String formattedHourBegin = DateFormat('kk:mm').format(begin);
  //     final String formattedHourEnd = DateFormat('kk:mm').format(end);
  //     final todayExam = Exam(
  //         '$formattedHourBegin-$formattedHourEnd',
  //         'SDIS',
  //         'B119, B107, B205',
  //         formattedDate,
  //         'Recurso - Época Recurso (1ºS)',
  //         'Quarta');
  //     final Completer<void> completer = Completer();
  //     final actionCreator =
  //         getUserExams(completer, parserMock, userPersistentInfo);
  //     when(parserMock.parseExams(any)).thenAnswer((_) async => {todayExam});
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
  //     final String formattedDate = DateFormat('yyyy-MM-dd').format(begin);
  //     final String formattedHourBegin = DateFormat('kk:mm').format(begin);
  //     final String formattedHourEnd = DateFormat('kk:mm').format(end);
  //     final todayExam = Exam(
  //         '$formattedHourBegin-$formattedHourEnd',
  //         'SDIS',
  //         'B119, B107, B205',
  //         formattedDate,
  //         'Recurso - Época Recurso (1ºS)',
  //         'Quarta');
  //     final Completer<void> completer = Completer();
  //     final actionCreator =
  //         getUserExams(completer, parserMock, userPersistentInfo);
  //     when(parserMock.parseExams(any)).thenAnswer((_) async => {todayExam});
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
  //     final String formattedDate = DateFormat('yyyy-MM-dd').format(before);
  //     final String formattedHourBefore = DateFormat('kk:mm').format(before);
  //     final String formattedHourAfter = DateFormat('kk:mm').format(after);
  //     final todayExam = Exam(
  //         '$formattedHourBefore-$formattedHourAfter',
  //         'SDIS',
  //         'B119, B107, B205',
  //         formattedDate,
  //         'Recurso - Época Recurso (1ºS)',
  //         'Quarta');
  //     final Completer<void> completer = Completer();
  //     final actionCreator =
  //         getUserExams(completer, parserMock, userPersistentInfo);
  //     when(parserMock.parseExams(any)).thenAnswer((_) async => {todayExam});
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
