import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_exams.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/providers/lazy/exam_provider.dart';
import 'package:uni/session/flows/base/session.dart';
import 'package:uni/view/exams/exams.dart';

import '../../mocks/integration/src/exams_page_test.mocks.dart';
import '../../test_widget.dart';

@GenerateNiceMocks([MockSpec<http.Client>(), MockSpec<http.Response>()])
void main() async {
  await initTestEnvironment();

  group('ExamsPage Second Integration Tests', () {
    final mockClient = MockClient();
    final mockResponse = MockResponse();
    final fis3022CourseUnit = CourseUnit(
      abbreviation: 'FIS3022',
      name: 'Métodos Computacionais em Engenharia',
      occurrId: 0,
      status: 'V',
    );
    final m2030CourseUnit = CourseUnit(
      abbreviation: 'M2030',
      name: 'Probabilidade e Estatística',
      occurrId: 0,
      status: 'V',
    );

    final beginFis3022Exam = DateTime.parse('2099-06-09 00:00');
    final endFis3022Exam = DateTime.parse('2099-06-09 00:00');
    final fis3022Exam = Exam(
      '33999',
      beginFis3022Exam,
      endFis3022Exam,
      'FIS3022',
      [],
      'EN',
      'fcup',
    );
    final beginM2030Exam = DateTime.parse('2099-06-17 09:30');
    final endM2030Exam = DateTime.parse('2099-06-17 12:30');
    final m2030Exam = Exam(
      '34053',
      beginM2030Exam,
      endM2030Exam,
      'M2030',
      ['FC1122', 'FC1219'],
      'EN',
      'fcup',
    );
    final beginQ1004Exam = DateTime.parse('2099-06-07 00:00');
    final endQ1004Exam = DateTime.parse('2099-06-07 00:00');
    final q1004Exam =
        Exam('34085', beginQ1004Exam, endQ1004Exam, 'Q1004', [], 'EN', 'fcup');

    final filteredExams = <String, bool>{};
    for (final type in Exam.displayedTypes) {
      filteredExams[type] = true;
    }

    final profile = Profile()..courses = [Course(id: 9113, faculty: 'fcup')];

    testWidgets('Exams', (tester) async {
      NetworkRouter.httpClient = mockClient;
      final mockHtml = File('test/integration/resources/exam2_example.html')
          .readAsStringSync(encoding: latin1);
      when(mockResponse.body).thenReturn(mockHtml);
      when(mockResponse.statusCode).thenReturn(200);
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => mockResponse);

      final examProvider = ExamProvider();

      const widget = ExamsPageView();

      final providers = [
        ChangeNotifierProvider(create: (_) => examProvider),
      ];
      await tester.pumpWidget(testableWidget(widget, providers: providers));

      expect(find.byKey(Key('$fis3022Exam-exam')), findsNothing);
      expect(find.byKey(Key('$m2030Exam-exam')), findsNothing);
      expect(find.byKey(Key('$q1004Exam-exam')), findsNothing);

      final exams = await examProvider.fetchUserExams(
        ParserExams(),
        profile,
        Session(username: '', cookies: '', faculties: ['fcup']),
        [fis3022CourseUnit, m2030CourseUnit],
      );

      examProvider.setState(exams);

      expect(examProvider.state!.contains(fis3022Exam), true);
      expect(examProvider.state!.contains(m2030Exam), true);

      await tester.pumpAndSettle();

      expect(find.byKey(Key('$fis3022Exam-exam')), findsOneWidget);
      expect(find.byKey(Key('$m2030Exam-exam')), findsOneWidget);
      expect(find.byKey(Key('$q1004Exam-exam')), findsNothing);
    });
  });
}
