// @dart=2.10

import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mockito/mockito.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';

import 'package:uni/model/providers/exam_provider.dart';
import 'package:uni/model/request_status.dart';

import 'mocks.dart';

void main() {
  group('ExamProvider', () {
    final mockClient = MockClient();
    final parserExams = ParserExamsMock();
    final mockResponse = MockResponse();

    final sopeCourseUnit = CourseUnit(
        abbreviation: 'SOPE', occurrId: 0, name: 'Sistemas Operativos');
    final sdisCourseUnit = CourseUnit(
        abbreviation: 'SDIS', occurrId: 0, name: 'Sistemas Distribuídos');

    final sopeExam = Exam('09:00-12:00', 'SOPE', 'B119, B107, B205',
        '2800-09-11', 'Recurso - Época Recurso (2ºS)', 'Quarta');
    final sdisExam = Exam('12:00-15:00', 'SDIS', 'B119, B107, B205',
        '2800-09-12', 'Recurso - Época Recurso (2ºS)', 'Quarta');

    const Tuple2<String, String> userPersistentInfo = Tuple2('', '');

    final profile = Profile();
    profile.courses = [Course(id: 7474)];
    final session = Session(authenticated: true);
    final userUcs = [sopeCourseUnit, sdisCourseUnit];

    NetworkRouter.httpClient = mockClient;
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => mockResponse);
    when(mockResponse.statusCode).thenReturn(200);

    ExamProvider provider;

    setUp(() {
      provider = ExamProvider();
      expect(provider.status, RequestStatus.none);
    });

    test('When given one exam', () async {
      when(parserExams.parseExams(any)).thenAnswer((_) async => {sopeExam});

      final action = Completer();

      provider.getUserExams(
          action, parserExams, userPersistentInfo, profile, session, userUcs);

      expect(provider.status, RequestStatus.busy);

      await action.future;

      expect(provider.exams.isNotEmpty, true);
      expect(provider.status, RequestStatus.successful);
    });

    test('When given two exams', () async {
      when(parserExams.parseExams(any))
          .thenAnswer((_) async => {sopeExam, sdisExam});

      final Completer<void> action = Completer();

      provider.getUserExams(
          action, parserExams, userPersistentInfo, profile, session, userUcs);

      expect(provider.status, RequestStatus.busy);

      await action.future;

      expect(provider.status, RequestStatus.successful);
      expect(provider.exams, [sopeExam, sdisExam]);
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

      final Completer<void> action = Completer();

      when(parserExams.parseExams(any))
          .thenAnswer((_) async => {sopeExam, sdisExam, specialExam});

      provider.getUserExams(
          action, parserExams, userPersistentInfo, profile, session, userUcs);

      expect(provider.status, RequestStatus.busy);

      await action.future;

      expect(provider.status, RequestStatus.successful);
      expect(provider.exams, [sopeExam, sdisExam]);
    });

    test('When an error occurs while trying to obtain the exams', () async {
      final Completer<void> action = Completer();
      when(parserExams.parseExams(any))
          .thenAnswer((_) async => throw Exception('RIP'));

      provider.getUserExams(
          action, parserExams, userPersistentInfo, profile, session, userUcs);

      expect(provider.status, RequestStatus.busy);

      await action.future;

      expect(provider.status, RequestStatus.failed);
    });

    test('When Exam is today in one hour', () async {
      final DateTime begin = DateTime.now().add(const Duration(hours: 1));
      final DateTime end = DateTime.now().add(const Duration(hours: 2));
      final String formattedDate = DateFormat('yyyy-MM-dd').format(begin);
      final String formattedHourBegin = DateFormat('kk:mm').format(begin);
      final String formattedHourEnd = DateFormat('kk:mm').format(end);
      final todayExam = Exam(
          '$formattedHourBegin-$formattedHourEnd',
          'SDIS',
          'B119, B107, B205',
          formattedDate,
          'Recurso - Época Recurso (1ºS)',
          'Quarta');

      when(parserExams.parseExams(any)).thenAnswer((_) async => {todayExam});

      final Completer<void> action = Completer();

      provider.getUserExams(
          action, parserExams, userPersistentInfo, profile, session, userUcs);
      expect(provider.status, RequestStatus.busy);

      await action.future;

      expect(provider.status, RequestStatus.successful);
      expect(provider.exams, [todayExam]);
    });

    test('When Exam was one hour ago', () async {
      final DateTime end = DateTime.now().subtract(const Duration(hours: 1));
      final DateTime begin = DateTime.now().subtract(const Duration(hours: 2));
      final String formattedDate = DateFormat('yyyy-MM-dd').format(begin);
      final String formattedHourBegin = DateFormat('kk:mm').format(begin);
      final String formattedHourEnd = DateFormat('kk:mm').format(end);
      final todayExam = Exam(
          '$formattedHourBegin-$formattedHourEnd',
          'SDIS',
          'B119, B107, B205',
          formattedDate,
          'Recurso - Época Recurso (1ºS)',
          'Quarta');

      when(parserExams.parseExams(any)).thenAnswer((_) async => {todayExam});

      final Completer<void> action = Completer();

      provider.getUserExams(
          action, parserExams, userPersistentInfo, profile, session, userUcs);
      expect(provider.status, RequestStatus.busy);

      await action.future;

      expect(provider.status, RequestStatus.successful);
      expect(provider.exams, []);
    });

    test('When Exam is ocurring', () async {
      final DateTime before = DateTime.now().subtract(const Duration(hours: 1));
      final DateTime after = DateTime.now().add(const Duration(hours: 1));
      final String formattedDate = DateFormat('yyyy-MM-dd').format(before);
      final String formattedHourBefore = DateFormat('kk:mm').format(before);
      final String formattedHourAfter = DateFormat('kk:mm').format(after);
      final todayExam = Exam(
          '$formattedHourBefore-$formattedHourAfter',
          'SDIS',
          'B119, B107, B205',
          formattedDate,
          'Recurso - Época Recurso (1ºS)',
          'Quarta');

      when(parserExams.parseExams(any)).thenAnswer((_) async => {todayExam});

      final Completer<void> action = Completer();

      provider.getUserExams(
          action, parserExams, userPersistentInfo, profile, session, userUcs);
      expect(provider.status, RequestStatus.busy);

      await action.future;

      expect(provider.status, RequestStatus.successful);
      expect(provider.exams, [todayExam]);
    });
  });
}
