import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_exams.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/providers/lazy/exam_provider.dart';
import 'package:uni/model/request_status.dart';
import 'package:uni/session/flows/base/session.dart';

import '../../mocks/unit/providers/exams_provider_test.mocks.dart';
import '../../test_widget.dart';

@GenerateNiceMocks(
  [MockSpec<Client>(), MockSpec<ParserExams>(), MockSpec<Response>()],
)
void main() async {
  await initTestEnvironment();

  group('ExamProvider', () {
    final mockClient = MockClient();
    final parserExams = MockParserExams();
    final mockResponse = MockResponse();

    final sopeCourseUnit = CourseUnit(
      abbreviation: 'SOPE',
      occurrId: 0,
      name: 'Sistemas Operativos',
      status: 'V',
    );
    final sdisCourseUnit = CourseUnit(
      abbreviation: 'SDIS',
      occurrId: 0,
      name: 'Sistemas Distribuídos',
      status: 'V',
    );

    final rooms = <String>['B119', 'B107', 'B205'];
    final beginSopeExam = DateTime.parse('2800-09-12 12:00');
    final endSopeExam = DateTime.parse('2800-09-12 15:00');
    final sopeExam = Exam(
      '1229',
      beginSopeExam,
      endSopeExam,
      'SOPE',
      rooms,
      'Recurso - Época Recurso (2ºS)',
      'feup',
    );
    final beginSdisExam = DateTime.parse('2800-09-12 12:00');
    final endSdisExam = DateTime.parse('2800-09-12 15:00');
    final sdisExam = Exam(
      '1230',
      beginSdisExam,
      endSdisExam,
      'SDIS',
      rooms,
      'Recurso - Época Recurso (2ºS)',
      'feup',
    );

    final profile = Profile()..courses = [Course(id: 7474)];
    final session = Session(username: '', cookies: '', faculties: ['feup']);
    final userUcs = [sopeCourseUnit, sdisCourseUnit];

    NetworkRouter.httpClient = mockClient;
    when(mockClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => mockResponse);
    when(mockResponse.statusCode).thenReturn(200);

    late ExamProvider provider;

    setUp(() {
      provider = ExamProvider();
      expect(provider.requestStatus, RequestStatus.busy);
    });

    test('When given one exam', () async {
      when(parserExams.parseExams(any, any))
          .thenAnswer((_) async => {sopeExam});

      final exams = await provider.fetchUserExams(
        parserExams,
        profile,
        session,
        userUcs,
      );

      provider.setState(exams);

      expect(provider.state!.isNotEmpty, true);
      expect(provider.state, [sopeExam]);
    });

    test('When given two exams', () async {
      when(parserExams.parseExams(any, any))
          .thenAnswer((_) async => {sopeExam, sdisExam});

      final exams = await provider.fetchUserExams(
        parserExams,
        profile,
        session,
        userUcs,
      );

      provider.setState(exams);

      expect(provider.state, [sopeExam, sdisExam]);
    });

    test('''
When given three exams but one is to be parsed out,
                 since it is a Special Season Exam''', () async {
      final begin = DateTime.parse('2800-09-12 12:00');
      final end = DateTime.parse('2800-09-12 15:00');
      final specialExam = Exam(
        '1231',
        begin,
        end,
        'SDIS',
        rooms,
        'Exames ao abrigo de estatutos especiais - Port.Est.Especiais',
        'feup',
      );

      when(parserExams.parseExams(any, any))
          .thenAnswer((_) async => {sopeExam, sdisExam, specialExam});

      final exams = await provider.fetchUserExams(
        parserExams,
        profile,
        session,
        userUcs,
      );

      provider.setState(exams);

      expect(provider.state, [sopeExam, sdisExam]);
    });

    test('When an error occurs while trying to obtain the exams', () async {
      when(parserExams.parseExams(any, any))
          .thenAnswer((_) async => throw Exception('RIP'));

      throwsA(
        () async => provider.fetchUserExams(
          parserExams,
          profile,
          session,
          userUcs,
        ),
      );
    });

    test('When Exam is today in one hour', () async {
      final begin = DateTime.now().add(const Duration(hours: 1));
      final end = DateTime.now().add(const Duration(hours: 2));
      final todayExam = Exam(
        '1232',
        begin,
        end,
        'SDIS',
        rooms,
        'Recurso - Época Recurso (1ºS)',
        'feup',
      );

      when(parserExams.parseExams(any, any))
          .thenAnswer((_) async => {todayExam});

      final exams = await provider.fetchUserExams(
        parserExams,
        profile,
        session,
        userUcs,
      );

      provider.setState(exams);

      expect(provider.state, [todayExam]);
    });

    test('When Exam was one hour ago', () async {
      final end = DateTime.now().subtract(const Duration(hours: 1));
      final begin = DateTime.now().subtract(const Duration(hours: 2));
      final todayExam = Exam(
        '1233',
        begin,
        end,
        'SDIS',
        rooms,
        'Recurso - Época Recurso (1ºS)',
        'feup',
      );

      when(parserExams.parseExams(any, any))
          .thenAnswer((_) async => {todayExam});

      final exams = await provider.fetchUserExams(
        parserExams,
        profile,
        session,
        userUcs,
      );

      provider.setState(exams);

      expect(provider.state, <Exam>[]);
    });

    test('When Exam is ocurring', () async {
      final before = DateTime.now().subtract(const Duration(hours: 1));
      final after = DateTime.now().add(const Duration(hours: 1));
      final todayExam = Exam(
        '1234',
        before,
        after,
        'SDIS',
        rooms,
        'Recurso - Época Recurso (1ºS)',
        'feup',
      );

      when(parserExams.parseExams(any, any))
          .thenAnswer((_) async => {todayExam});

      final exams = await provider.fetchUserExams(
        parserExams,
        profile,
        session,
        userUcs,
      );

      provider.setState(exams);

      expect(provider.state, [todayExam]);
    });
  });
}
