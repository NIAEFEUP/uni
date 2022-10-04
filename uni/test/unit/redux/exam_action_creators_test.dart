// @dart=2.10

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/redux/action_creators.dart';

import 'action_creators.dart';

void main() {
  group('Exams Action Creator', () {
    final sopeCourseUnit = CourseUnit(
        abbreviation: 'SOPE', occurrId: 0, name: 'Sistemas Operativos');
    final sdisCourseUnit = CourseUnit(
        abbreviation: 'SDIS', occurrId: 0, name: 'Sistemas Distribuídos');
    NetworkRouter.httpClient = MockClient();
    final DateTime beginSopeExam = DateTime.parse('2800-09-12 12:00');
    final DateTime endSopeExam = DateTime.parse('2800-09-12 15:00');
    final sopeExam = Exam(beginSopeExam, endSopeExam, 'SOPE',
        'B119, B107, B205', 'Recurso - Época Recurso (2ºS)', 'Quarta');
    final DateTime beginSdisExam = DateTime.parse('2800-09-12 12:00');
    final DateTime endSdisExam = DateTime.parse('2800-09-12 15:00');
    final sdisExam = Exam(beginSdisExam, endSdisExam, 'SDIS',
        'B119, B107, B205', 'Recurso - Época Recurso (2ºS)', 'Quarta');
    final parserMock = ParserMock();
    const Tuple2<String, String> userPersistentInfo = Tuple2('', '');
    final mockStore = MockStore();
    final mockResponse = MockResponse();

    final profile = Profile();
    profile.courses = [Course(id: 7474)];
    final content = {
      'session': Session(authenticated: true),
      'currUcs': [sopeCourseUnit, sdisCourseUnit],
      'profile': profile,
    };

    when(NetworkRouter.httpClient?.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => mockResponse);
    when(mockResponse.statusCode).thenReturn(200);
    when(mockStore.state).thenReturn(AppState(content));
    test('When given a single exam', () async {
      final Completer<void> completer = Completer();
      final actionCreator =
          getUserExams(completer, parserMock, userPersistentInfo);
      when(parserMock.parseExams(any)).thenAnswer((_) async => {sopeExam});

      actionCreator(mockStore);
      await completer.future;
      final List<dynamic> actions =
          verify(mockStore.dispatch(captureAny)).captured;
      expect(actions.length, 3);
      expect(actions[0].status, RequestStatus.busy);
      expect(actions[1].status, RequestStatus.successful);
      expect(actions[2].exams, [sopeExam]);
    });
    test('When given two exams', () async {
      final Completer<void> completer = Completer();
      final actionCreator =
          getUserExams(completer, parserMock, userPersistentInfo);
      when(parserMock.parseExams(any))
          .thenAnswer((_) async => {sopeExam, sdisExam});

      actionCreator(mockStore);
      await completer.future;
      final List<dynamic> actions =
          verify(mockStore.dispatch(captureAny)).captured;
      expect(actions.length, 3);
      expect(actions[0].status, RequestStatus.busy);
      expect(actions[1].status, RequestStatus.successful);
      expect(actions[2].exams, [sopeExam, sdisExam]);
    });
    test('''When given three exams but one is to be parsed out,
                since it is a Special Season Exam''', () async {
      final DateTime begin = DateTime.parse('2800-09-12 12:00');
      final DateTime end = DateTime.parse('2800-09-12 15:00');
      final specialExam = Exam(
          begin,
          end,
          'SDIS',
          'B119, B107, B205',
          'Exames ao abrigo de estatutos especiais - Port.Est.Especiais',
          'Quarta');
      final Completer<void> completer = Completer();
      final actionCreator =
          getUserExams(completer, parserMock, userPersistentInfo);
      when(parserMock.parseExams(any))
          .thenAnswer((_) async => {sopeExam, sdisExam, specialExam});

      actionCreator(mockStore);
      await completer.future;
      final List<dynamic> actions =
          verify(mockStore.dispatch(captureAny)).captured;
      expect(actions.length, 3);
      expect(actions[0].status, RequestStatus.busy);
      expect(actions[1].status, RequestStatus.successful);
      expect(actions[2].exams, [sopeExam, sdisExam]);
    });
    test('When an error occurs while trying to obtain the exams', () async {
      final Completer<void> completer = Completer();
      final actionCreator =
          getUserExams(completer, parserMock, userPersistentInfo);
      when(parserMock.parseExams(any))
          .thenAnswer((_) async => throw Exception('RIP'));

      actionCreator(mockStore);
      await completer.future;
      final List<dynamic> actions =
          verify(mockStore.dispatch(captureAny)).captured;
      expect(actions.length, 2);
      expect(actions[0].status, RequestStatus.busy);
      expect(actions[1].status, RequestStatus.failed);
    });
    test('When Exam is today in one hour', () async {
      final DateTime begin = DateTime.now().add(const Duration(hours: 1));
      final DateTime end = DateTime.now().add(const Duration(hours: 2));
      final todayExam = Exam(begin, end, 'SDIS', 'B119, B107, B205',
          'Recurso - Época Recurso (1ºS)', 'Quarta');
      final Completer<void> completer = Completer();
      final actionCreator =
          getUserExams(completer, parserMock, userPersistentInfo);
      when(parserMock.parseExams(any)).thenAnswer((_) async => {todayExam});

      actionCreator(mockStore);
      await completer.future;
      final List<dynamic> actions =
          verify(mockStore.dispatch(captureAny)).captured;
      expect(actions.length, 3);
      expect(actions[0].status, RequestStatus.busy);
      expect(actions[1].status, RequestStatus.successful);
      expect(actions[2].exams, [todayExam]);
    });
    test('When Exam was one hour ago', () async {
      final DateTime end = DateTime.now().subtract(const Duration(hours: 1));
      final DateTime begin = DateTime.now().subtract(const Duration(hours: 2));
      final todayExam = Exam(begin, end, 'SDIS', 'B119, B107, B205',
          'Recurso - Época Recurso (1ºS)', 'Quarta');
      final Completer<void> completer = Completer();
      final actionCreator =
          getUserExams(completer, parserMock, userPersistentInfo);
      when(parserMock.parseExams(any)).thenAnswer((_) async => {todayExam});

      actionCreator(mockStore);
      await completer.future;
      final List<dynamic> actions =
          verify(mockStore.dispatch(captureAny)).captured;
      expect(actions.length, 3);
      expect(actions[0].status, RequestStatus.busy);
      expect(actions[1].status, RequestStatus.successful);
      expect(actions[2].exams, []);
    });
    test('When Exam is ocurring', () async {
      //      final DateTime before = DateTime.now().subtract(const Duration(hours: 1));
      //      final DateTime after = DateTime.now()(const Duration(hours: 1));

      final DateTime time = DateTime.parse('2800-09-12 23:10');
      final DateTime before = time.subtract(const Duration(hours: 1));
      final DateTime after = time.add(const Duration(hours: 1));
      final todayExam = Exam(before, after, 'SDIS', 'B119, B107, B205',
          'Recurso - Época Recurso (1ºS)', 'Quarta');
      final Completer<void> completer = Completer();
      final actionCreator =
          getUserExams(completer, parserMock, userPersistentInfo);
      when(parserMock.parseExams(any)).thenAnswer((_) async => {todayExam});

      actionCreator(mockStore);
      await completer.future;
      final List<dynamic> actions =
          verify(mockStore.dispatch(captureAny)).captured;
      expect(actions.length, 3);
      expect(actions[0].status, RequestStatus.busy);
      expect(actions[1].status, RequestStatus.successful);
      expect(actions[2].exams, [todayExam]);
    });
  });
}
