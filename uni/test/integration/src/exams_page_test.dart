// @dart=2.10

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_exams.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/course_units/course_unit.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/model/providers/exam_provider.dart';
import 'package:uni/view/exams/exams.dart';

import '../../test_widget.dart';

class MockClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

void main() {
  group('ExamsPage Integration Tests', () {
    final mockClient = MockClient();
    final mockResponse = MockResponse();
    final sopeCourseUnit = CourseUnit(
        abbreviation: 'SOPE',
        occurrId: 0,
        name: 'Sistemas Operativos',
        status: 'V');
    final sdisCourseUnit = CourseUnit(
        abbreviation: 'SDIS',
        name: 'Sistemas Distribuídos',
        occurrId: 0,
        status: 'V');

    final DateTime beginSopeExam = DateTime.parse('2099-11-18 17:00');
    final DateTime endSopeExam = DateTime.parse('2099-11-18 19:00');
    final sopeExam =
        Exam('44426', beginSopeExam, endSopeExam, 'SOPE', [], 'MT', 'feup');
    final DateTime beginSdisExam = DateTime.parse('2099-10-21 17:00');
    final DateTime endSdisExam = DateTime.parse('2099-10-21 19:00');
    final sdisExam =
        Exam('44425', beginSdisExam, endSdisExam, 'SDIS', [], 'MT', 'feup');
    final DateTime beginMdisExam = DateTime.parse('2099-10-22 17:00');
    final DateTime endMdisExam = DateTime.parse('2099-10-22 19:00');
    final mdisExam =
        Exam('44429', beginMdisExam, endMdisExam, 'MDIS', [], 'MT', 'feup');

    final Map<String, bool> filteredExams = {};
    for (String type in Exam.displayedTypes) {
      filteredExams[type] = true;
    }

    final profile = Profile();
    profile.courses = [Course(id: 7474, faculty: 'feup')];

    testWidgets('Exams', (WidgetTester tester) async {
      NetworkRouter.httpClient = mockClient;
      final mockHtml = File('test/integration/resources/exam_example.html')
          .readAsStringSync();
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

      expect(find.byKey(Key('$sdisExam-exam')), findsNothing);
      expect(find.byKey(Key('$sopeExam-exam')), findsNothing);
      expect(find.byKey(Key('$mdisExam-exam')), findsNothing);

      final Completer<void> completer = Completer();
      examProvider.getUserExams(
          completer,
          ParserExams(),
          const Tuple2('', ''),
          profile,
          Session(authenticated: true),
          [sopeCourseUnit, sdisCourseUnit]);

      await completer.future;

      await tester.pumpAndSettle();
      expect(find.byKey(Key('$sdisExam-exam')), findsOneWidget);
      expect(find.byKey(Key('$sopeExam-exam')), findsOneWidget);
      expect(find.byKey(Key('$mdisExam-exam')), findsNothing);
    });

    testWidgets('Filtered Exams', (WidgetTester tester) async {
      NetworkRouter.httpClient = mockClient;
      final mockHtml = File('test/integration/resources/exam_example.html')
          .readAsStringSync();
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

      expect(find.byKey(Key('$sdisExam-exam')), findsNothing);
      expect(find.byKey(Key('$sopeExam-exam')), findsNothing);

      final Completer<void> completer = Completer();
      examProvider.getUserExams(
          completer,
          ParserExams(),
          const Tuple2('', ''),
          profile,
          Session(authenticated: true),
          [sopeCourseUnit, sdisCourseUnit]);

      await completer.future;

      await tester.pumpAndSettle();
      expect(find.byKey(Key('$sdisExam-exam')), findsOneWidget);
      expect(find.byKey(Key('$sopeExam-exam')), findsOneWidget);
      expect(find.byIcon(Icons.filter_alt), findsOneWidget);

      final Completer<void> settingFilteredExams = Completer();
      filteredExams['ExamDoesNotExist'] = true;
      examProvider.setFilteredExams(filteredExams, settingFilteredExams);

      await settingFilteredExams.future;

      await tester.pumpAndSettle();

      final filterButton = find.widgetWithIcon(IconButton, Icons.filter_alt);
      expect(filterButton, findsOneWidget);

      await tester.tap(filterButton);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);

      final CheckboxListTile mtCheckboxTile = find
          .byKey(const Key('ExamCheck' 'Mini-testes'))
          .evaluate()
          .first
          .widget;

      expect(find.byWidget(mtCheckboxTile), findsOneWidget);
      expect(mtCheckboxTile.value, true);
      await tester.tap(find.byWidget(mtCheckboxTile));
      await tester.pumpAndSettle();

      final okButton = find.widgetWithText(ElevatedButton, 'Confirmar');
      expect(okButton, findsOneWidget);

      await tester.tap(okButton);

      await tester.pumpAndSettle();

      expect(find.byKey(Key('$sdisExam-exam')), findsNothing);
      expect(find.byKey(Key('$sopeExam-exam')), findsNothing);
    });
  });
}
