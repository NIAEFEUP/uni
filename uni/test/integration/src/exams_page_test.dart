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
import 'package:uni/model/entities/course_unit.dart';
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
        abbreviation: 'SOPE', occurrId: 0, name: 'Sistemas Operativos');
    final sdisCourseUnit = CourseUnit(
        abbreviation: 'SDIS', name: 'Sistemas Distribuídos', occurrId: 0);
    final sopeExam =
        Exam('17:00-19:00', 'SOPE', '', '2099-11-18', 'MT', 'Segunda');
    final sdisExam =
        Exam('17:00-19:00', 'SDIS', '', '2099-10-21', 'MT', 'Segunda');

    final Map<String, bool> filteredExams = {};
    Exam.getExamTypes()
        .keys
        .toList()
        .forEach((type) => filteredExams[type] = true);

    final profile = Profile();
    profile.courses = [Course(id: 7474)];

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

      final fatherWidget = MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => examProvider),
      ], child: widget);

      await tester.pumpWidget(testWidget(fatherWidget));

      expect(find.byKey(Key(sdisExam.toString())), findsNothing);
      expect(find.byKey(Key(sopeExam.toString())), findsNothing);

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
      expect(find.byKey(Key(sdisExam.toString())), findsOneWidget);
      expect(find.byKey(Key(sopeExam.toString())), findsOneWidget);
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

      final fatherWidget = MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => examProvider),
          ],
          child: Consumer<ExamProvider>(
            builder: (context, examProvider, _) {
              return ExamsList(exams: examProvider.getFilteredExams());
            },
          ));

      await tester.pumpWidget(testWidget(fatherWidget));

      expect(find.byKey(Key(sdisExam.toString())), findsNothing);
      expect(find.byKey(Key(sopeExam.toString())), findsNothing);

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
      expect(find.byKey(Key(sdisExam.toString())), findsOneWidget);
      expect(find.byKey(Key(sopeExam.toString())), findsOneWidget);

      final filterIcon = find.byIcon(Icons.settings);
      expect(filterIcon, findsOneWidget);

      final Completer<void> settingFilteredExams = Completer();
      filteredExams['ExamDoesNotExist'] = true;
      examProvider.setFilteredExams(filteredExams, settingFilteredExams);

      await settingFilteredExams.future;
      await tester.pumpAndSettle();

      final IconButton filterButton = find
          .widgetWithIcon(IconButton, Icons.settings)
          .evaluate()
          .first
          .widget;

      
      filterButton.onPressed(); //TODO: FIX THS ERROR
      await tester.pumpAndSettle();

      return;

      expect(find.byType(AlertDialog), findsOneWidget);
      //This checks if the ExamDoesNotExist is not displayed
      expect(find.byType(CheckboxListTile),
          findsNWidgets(Exam.getExamTypes().length));

      return;

      final CheckboxListTile mtCheckboxTile = find
          .byKey(const Key('ExamCheck' 'Mini-testes'))
          .evaluate()
          .first
          .widget;

      expect(find.byWidget(mtCheckboxTile), findsOneWidget);
      expect(mtCheckboxTile.value, true);
      await tester.tap(find.byWidget(mtCheckboxTile));
      await completer.future;

      await tester.pumpAndSettle();

      final ElevatedButton okButton = find
          .widgetWithText(ElevatedButton, 'Confirmar')
          .evaluate()
          .first
          .widget;
      expect(find.byWidget(okButton), findsOneWidget);

      okButton.onPressed();
      await tester.pumpAndSettle();

      expect(find.byKey(Key(sdisExam.toString())), findsNothing);
      expect(find.byKey(Key(sopeExam.toString())), findsNothing);
    });
  });
}
