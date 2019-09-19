import 'dart:async';
import 'dart:io';

import 'package:app_feup/controller/Middleware.dart';
import 'package:app_feup/controller/networking/NetworkRouter.dart';
import 'package:app_feup/controller/parsers/ParserExams.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/model/entities/CourseUnit.dart';
import 'package:app_feup/model/entities/Exam.dart';
import 'package:app_feup/model/entities/Session.dart';
import 'package:app_feup/redux/ActionCreators.dart';
import 'package:app_feup/redux/Reducers.dart';
import 'package:app_feup/view/Pages/ExamsPageView.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';
import 'package:tuple/tuple.dart';

import '../../TestableReduxWidget.dart';

class MockClient extends Mock implements http.Client {}
class MockResponse extends Mock implements http.Response {}

void main() {
  group('ExamsPage Integration Tests', () {
    final mockClient = MockClient();
    final mockResponse = MockResponse();
    final sopeCourseUnit = new CourseUnit(abbreviation: 'SOPE');
    final sdisCourseUnit = new CourseUnit(abbreviation: 'SDIS');
    final sopeExam = new Exam(
        '17:00-19:00',
        'SOPE',
        '',
        '2019-11-18',
        'Exames ao abrigo de estatutos especiais - Mini-testes (1�S)',
        'Segunda');
    final sdisExam = new Exam(
        '17:00-19:00',
        'SDIS',
        '',
        '2019-10-21',
        'Exames ao abrigo de estatutos especiais - Mini-testes (1�S)',
        'Segunda');
    final store = Store<AppState>(appReducers,
                initialState: new AppState({
                  "session": new Session(authenticated: true),
                  "currUcs": [sopeCourseUnit, sdisCourseUnit],
                  "exams": List<Exam>(),
                }),
                middleware: [generalMiddleware]);
    NetworkRouter.httpClient = mockClient;  
    testWidgets('Exams', (WidgetTester tester) async {
      final mockHtml = File('test/integration/resources/exam_example.html').readAsStringSync();
      when(mockResponse.body)
        .thenReturn(mockHtml);
      when(mockClient.get(any, headers: anyNamed('headers')))
            .thenAnswer((_) async => mockResponse);
  
      final Completer<Null> completer = new Completer();
      final actionCreator = getUserExams(completer, ParserExams(), Tuple2("", ""));

      final widget = TestableReduxWidget(child: ExamsPageView(), store: store);

      await tester.pumpWidget(widget);

      expect(find.byKey(Key(sdisExam.toString())), findsNothing);
      expect(find.byKey(Key(sopeExam.toString())), findsNothing);

      actionCreator(store);

      await completer.future;

      await tester.pump();


      expect(find.byKey(Key(sdisExam.toString())), findsOneWidget);
      expect(find.byKey(Key(sopeExam.toString())), findsOneWidget);
    });
  });
}
