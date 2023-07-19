// @dart=2.10

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/lazy/exam_provider.dart';
import 'package:uni/model/request_status.dart';

import 'mocks.dart';

void main() {
  group('ExamProvider', () {
    final mockClient = MockClient();
    final parserExams = ParserExamsMock();
    final mockResponse = MockResponse();

    final sopeCourseUnit = CourseUnit(
        abbreviation: 'SOPE',
        occurrId: 0,
        name: 'Sistemas Operativos',
        status: 'V');
    final sdisCourseUnit = CourseUnit(
        abbreviation: 'SDIS',
        occurrId: 0,
        name: 'Sistemas Distribuídos',
        status: 'V');

    final List<String> rooms = ['B119', 'B107', 'B205'];
    final DateTime beginSopeExam = DateTime.parse('2800-09-12 12:00');
    final DateTime endSopeExam = DateTime.parse('2800-09-12 15:00');
    final sopeExam = Exam('1229', beginSopeExam, endSopeExam, 'SOPE', rooms,
        'Recurso - Época Recurso (2ºS)', 'feup');
    final DateTime beginSdisExam = DateTime.parse('2800-09-12 12:00');
    final DateTime endSdisExam = DateTime.parse('2800-09-12 15:00');
    final sdisExam = Exam('1230', beginSdisExam, endSdisExam, 'SDIS', rooms,
        'Recurso - Época Recurso (2ºS)', 'feup');

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
      expect(provider.status, RequestStatus.busy);
    });

    test('When given one exam', () async {
      when(parserExams.parseExams(any, any))
          .thenAnswer((_) async => {sopeExam});

      await provider.fetchUserExams(
          parserExams, userPersistentInfo, profile, session, userUcs);

      expect(provider.exams.isNotEmpty, true);
      expect(provider.exams, [sopeExam]);
      expect(provider.status, RequestStatus.successful);
    });

    test('When given two exams', () async {
      when(parserExams.parseExams(any, any))
          .thenAnswer((_) async => {sopeExam, sdisExam});

      await provider.fetchUserExams(
          parserExams, userPersistentInfo, profile, session, userUcs);

      expect(provider.status, RequestStatus.successful);
      expect(provider.exams, [sopeExam, sdisExam]);
    });

    test('''When given three exams but one is to be parsed out,
                 since it is a Special Season Exam''', () async {
      final DateTime begin = DateTime.parse('2800-09-12 12:00');
      final DateTime end = DateTime.parse('2800-09-12 15:00');
      final specialExam = Exam(
          '1231',
          begin,
          end,
          'SDIS',
          rooms,
          'Exames ao abrigo de estatutos especiais - Port.Est.Especiais',
          'feup');

      when(parserExams.parseExams(any, any))
          .thenAnswer((_) async => {sopeExam, sdisExam, specialExam});

      await provider.fetchUserExams(
          parserExams, userPersistentInfo, profile, session, userUcs);

      expect(provider.status, RequestStatus.successful);
      expect(provider.exams, [sopeExam, sdisExam]);
    });

    test('When an error occurs while trying to obtain the exams', () async {
      when(parserExams.parseExams(any, any))
          .thenAnswer((_) async => throw Exception('RIP'));

      await provider.fetchUserExams(
          parserExams, userPersistentInfo, profile, session, userUcs);

      expect(provider.status, RequestStatus.failed);
    });

    test('When Exam is today in one hour', () async {
      final DateTime begin = DateTime.now().add(const Duration(hours: 1));
      final DateTime end = DateTime.now().add(const Duration(hours: 2));
      final todayExam = Exam('1232', begin, end, 'SDIS', rooms,
          'Recurso - Época Recurso (1ºS)', 'feup');

      when(parserExams.parseExams(any, any))
          .thenAnswer((_) async => {todayExam});

      await provider.fetchUserExams(
          parserExams, userPersistentInfo, profile, session, userUcs);

      expect(provider.status, RequestStatus.successful);
      expect(provider.exams, [todayExam]);
    });

    test('When Exam was one hour ago', () async {
      final DateTime end = DateTime.now().subtract(const Duration(hours: 1));
      final DateTime begin = DateTime.now().subtract(const Duration(hours: 2));
      final todayExam = Exam('1233', begin, end, 'SDIS', rooms,
          'Recurso - Época Recurso (1ºS)', 'feup');

      when(parserExams.parseExams(any, any))
          .thenAnswer((_) async => {todayExam});

      await provider.fetchUserExams(
          parserExams, userPersistentInfo, profile, session, userUcs);

      expect(provider.status, RequestStatus.successful);
      expect(provider.exams, []);
    });

    test('When Exam is ocurring', () async {
      final DateTime before = DateTime.now().subtract(const Duration(hours: 1));
      final DateTime after = DateTime.now().add(const Duration(hours: 1));
      final todayExam = Exam('1234', before, after, 'SDIS', rooms,
          'Recurso - Época Recurso (1ºS)', 'feup');

      when(parserExams.parseExams(any, any))
          .thenAnswer((_) async => {todayExam});

      await provider.fetchUserExams(
          parserExams, userPersistentInfo, profile, session, userUcs);

      expect(provider.status, RequestStatus.successful);
      expect(provider.exams, [todayExam]);
    });
  });
}
