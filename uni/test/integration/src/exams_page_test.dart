// @dart=2.10

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:redux/redux.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/controller/middleware.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_exams.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/redux/action_creators.dart';
import 'package:uni/redux/reducers.dart';
import 'package:uni/view/exams/exams.dart';

import '../../testable_redux_widget.dart';
import '../../unit/redux/action_creators.dart';

class MockClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

void main() {
  group('ExamsPage Integration Tests', () {
    final mockClient = MockClient();
    final mockResponse = MockResponse();
    final sopeCourseUnit = CourseUnit(
        abbreviation: 'SOPE', occurrId: 0, name: 'Sistemas Operativos', status: 'V');
    final sdisCourseUnit = CourseUnit(
        abbreviation: 'SDIS', name: 'Sistemas Distribuídos', occurrId: 0, status: 'V');
    final mdisCourseUnit = CourseUnit(
        abbreviation: 'MDIS', name: 'Matemática Discreta', occurrId: 0, status: 'A');

    final DateTime beginSopeExam = DateTime.parse('2099-11-18 17:00');
    final DateTime endSopeExam = DateTime.parse('2099-11-18 19:00');
    final sopeExam = Exam('44426', beginSopeExam, endSopeExam, 'SOPE', [], 'MT', 'feup');
    final DateTime beginSdisExam = DateTime.parse('2099-10-21 17:00');
    final DateTime endSdisExam = DateTime.parse('2099-10-21 19:00');
    final sdisExam = Exam('44425', beginSdisExam, endSdisExam, 'SDIS',[], 'MT', 'feup');
    final DateTime beginMdisExam = DateTime.parse('2099-10-22 17:00');
    final DateTime endMdisExam = DateTime.parse('2099-10-22 19:00');
    final mdisExam = Exam('44429', beginMdisExam, endMdisExam, 'MDIS',[], 'MT', 'feup');

    final Map<String, bool> filteredExams = {};
    Exam.types
        .keys
        .toList()
        .forEach((type) => filteredExams[type] = true);

    final profile = Profile();
    final MockCourse mockCourse = MockCourse();
    when(mockCourse.faculty).thenReturn("feup");
    profile.courses = [mockCourse];

    testWidgets('Exams', (WidgetTester tester) async {
      final store = Store<AppState>(appReducers,
          initialState: AppState({
            'session': Session(authenticated: true),
            'currUcs': [sopeCourseUnit, sdisCourseUnit, mdisCourseUnit],
            'exams': <Exam>[],
            'profile': profile,
            'filteredExams': filteredExams,
            'hiddenExams': <String>[], 
          }),
          middleware: [generalMiddleware]);
      NetworkRouter.httpClient = mockClient;
      final mockHtml = File('test/integration/resources/exam_example.html')
          .readAsStringSync();
      when(mockResponse.body).thenReturn(mockHtml);
      when(mockResponse.statusCode).thenReturn(200);
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => mockResponse);

      final Completer<void> completer = Completer();
      final actionCreator =
          getUserExams(completer, ParserExams(), const Tuple2('', ''));

      final widget =
          testableReduxWidget(child: const ExamsPageView(), store: store);

      await tester.pumpWidget(widget);

      expect(find.byKey(Key(sdisExam.toString())), findsNothing);
      expect(find.byKey(Key(sopeExam.toString())), findsNothing);
      expect(find.byKey(Key(mdisExam.toString())), findsNothing);

      actionCreator(store);

      await completer.future;

      await tester.pumpAndSettle();
      expect(find.byKey(Key(sdisExam.toString())), findsOneWidget);
      expect(find.byKey(Key(sopeExam.toString())), findsOneWidget);
      expect(find.byKey(Key(mdisExam.toString())), findsNothing);
    });

    testWidgets('Filtered Exams', (WidgetTester tester) async {
      final store = Store<AppState>(appReducers,
          initialState: AppState({
            'session': Session(authenticated: true),
            'currUcs': [sopeCourseUnit, sdisCourseUnit],
            'exams': <Exam>[],
            'profile': profile,
            'filteredExams': filteredExams,
            'hiddenExams': <String>[],
          }),
          middleware: [generalMiddleware]);

      NetworkRouter.httpClient = mockClient;

      final mockHtml = File('test/integration/resources/exam_example.html')
          .readAsStringSync();
      when(mockResponse.body).thenReturn(mockHtml);
      when(mockResponse.statusCode).thenReturn(200);
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => mockResponse);

      final Completer<void> completer = Completer();
      final actionCreator =
          getUserExams(completer, ParserExams(), const Tuple2('', ''));

      final widget =
          testableReduxWidget(child: const ExamsPageView(), store: store);

      await tester.pumpWidget(widget);

      expect(find.byKey(Key(sdisExam.toString())), findsNothing);
      expect(find.byKey(Key(sopeExam.toString())), findsNothing);

      actionCreator(store);

      await completer.future;

      await tester.pumpAndSettle();
      expect(find.byKey(Key(sdisExam.toString())), findsOneWidget);
      expect(find.byKey(Key(sopeExam.toString())), findsOneWidget);

      final filterIcon = find.byIcon(Icons.filter_alt);
      expect(filterIcon, findsOneWidget);

      filteredExams['ExamDoesNotExist'] = true;

      await tester.pumpAndSettle();
      final IconButton filterButton = find
          .widgetWithIcon(IconButton, Icons.filter_alt)
          .evaluate()
          .first
          .widget;
      filterButton.onPressed();
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      //This checks if the ExamDoesNotExist is not displayed
      expect(find.byType(CheckboxListTile),
          findsNWidgets(Exam.types.length));

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
