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
    final sopeCourseUnit = CourseUnit(abbreviation: 'SOPE');
    final sdisCourseUnit = CourseUnit(abbreviation: 'SDIS');
    NetworkRouter.httpClient = MockClient();
    final sopeExam = Exam('09:00-12:00', 'SOPE', 'B119, B107, B205',
        '2800-09-11', 'Recurso - Época Recurso (2ºS)', 'Quarta');
    final sdisExam = Exam('12:00-15:00', 'SDIS', 'B119, B107, B205',
        '2800-09-12', 'Recurso - Época Recurso (2ºS)', 'Quarta');
    final parserMock = ParserMock();
    final Tuple2<String, String> userPersistentInfo = Tuple2('', '');
    final mockStore = MockStore();
    final mockResponse = MockResponse();

    final profile = Profile();
    profile.courses = [Course(id: 7474)];
    final content = {
      'session': Session(authenticated: true),
      'currUcs': [sopeCourseUnit, sdisCourseUnit],
      'profile': profile,
    };

    when(NetworkRouter.httpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => mockResponse);
    when(mockResponse.statusCode).thenReturn(200);
    when(mockStore.state).thenReturn(AppState(content));
    test('When given a single exam', () async {
      final Completer<Null> completer = Completer();
      final actionCreator =
          getUserExams(completer, parserMock, userPersistentInfo);
      when(parserMock.parseExams(any))
          .thenAnswer((_) async => [sopeExam].toSet());

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
      final Completer<Null> completer = Completer();
      final actionCreator =
          getUserExams(completer, parserMock, userPersistentInfo);
      when(parserMock.parseExams(any))
          .thenAnswer((_) async => [sopeExam, sdisExam].toSet());

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
      final specialExam = Exam(
          '12:00-15:00',
          'SDIS',
          'B119, B107, B205',
          '2800-09-12',
          'Exames ao abrigo de estatutos especiais - Port.Est.Especiais',
          'Quarta');
      final Completer<Null> completer = Completer();
      final actionCreator =
          getUserExams(completer, parserMock, userPersistentInfo);
      when(parserMock.parseExams(any))
          .thenAnswer((_) async => [sopeExam, sdisExam, specialExam].toSet());

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
      final Completer<Null> completer = Completer();
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
      final DateTime begin = DateTime.now().add(Duration(hours: 1));
      final DateTime end = DateTime.now().add(Duration(hours: 2));
      final String formatedDate = DateFormat('yyyy-MM-dd').format(begin);
      final String formatedHourBegin = DateFormat('kk:mm').format(begin);
      final String formatedHourEnd = DateFormat('kk:mm').format(end);
      final todayExam = Exam(
          formatedHourBegin + '-' + formatedHourEnd,
          'SDIS',
          'B119, B107, B205',
          formatedDate,
          'Recurso - Época Recurso (1ºS)',
          'Quarta');
      final Completer<Null> completer = Completer();
      final actionCreator =
          getUserExams(completer, parserMock, userPersistentInfo);
      when(parserMock.parseExams(any))
          .thenAnswer((_) async => [todayExam].toSet());

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
      final DateTime end = DateTime.now().subtract(Duration(hours: 1));
      final DateTime begin = DateTime.now().subtract(Duration(hours: 2));
      final String formatedDate = DateFormat('yyyy-MM-dd').format(begin);
      final String formatedHourBegin = DateFormat('kk:mm').format(begin);
      final String formatedHourEnd = DateFormat('kk:mm').format(end);
      final todayExam = Exam(
          formatedHourBegin + '-' + formatedHourEnd,
          'SDIS',
          'B119, B107, B205',
          formatedDate,
          'Recurso - Época Recurso (1ºS)',
          'Quarta');
      final Completer<Null> completer = Completer();
      final actionCreator =
          getUserExams(completer, parserMock, userPersistentInfo);
      when(parserMock.parseExams(any))
          .thenAnswer((_) async => [todayExam].toSet());

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
      final DateTime before = DateTime.now().subtract(Duration(hours: 1));
      final DateTime after = DateTime.now().add(Duration(hours: 1));
      final String formatedDate = DateFormat('yyyy-MM-dd').format(before);
      final String formatedHourBefore = DateFormat('kk:mm').format(before);
      final String formatedHourAfter = DateFormat('kk:mm').format(after);
      final todayExam = Exam(
          formatedHourBefore + '-' + formatedHourAfter,
          'SDIS',
          'B119, B107, B205',
          formatedDate,
          'Recurso - Época Recurso (1ºS)',
          'Quarta');
      final Completer<Null> completer = Completer();
      final actionCreator =
          getUserExams(completer, parserMock, userPersistentInfo);
      when(parserMock.parseExams(any))
          .thenAnswer((_) async => [todayExam].toSet());

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
