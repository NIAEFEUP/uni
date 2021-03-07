import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/controller/middleware.dart';
import 'package:uni/controller/networking/network_router.dart';
import 'package:uni/controller/parsers/parser_exams.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/course.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/entities/profile.dart';
import 'package:uni/model/entities/session.dart';
import 'package:uni/redux/action_creators.dart';
import 'package:uni/redux/reducers.dart';
import 'package:uni/view/Pages/exams_page_view.dart';

import '../../testable_redux_widget.dart';

class MockClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

void main() {
  group('ExamsPage Integration Tests', () {
    final mockClient = MockClient();
    final mockResponse = MockResponse();
    final sopeCourseUnit = CourseUnit(abbreviation: 'SOPE');
    final sdisCourseUnit = CourseUnit(abbreviation: 'SDIS');
    final sopeExam = Exam(
        '17:00-19:00',
        'SOPE',
        '',
        '2099-11-18',
        'MT',
        'Segunda');
    final sdisExam = Exam(
        '17:00-19:00',
        'SDIS',
        '',
        '2099-10-21',
        'MT',
        'Segunda');

    final profile = Profile();
    profile.courses = [Course(id: 7474)];
    final store = Store<AppState>(appReducers,
        initialState: AppState({
          'session': Session(authenticated: true),
          'currUcs': [sopeCourseUnit, sdisCourseUnit],
          'exams': <Exam>[],
          'profile': profile
        }),
        middleware: [generalMiddleware]);
    NetworkRouter.httpClient = mockClient;
    testWidgets('Exams', (WidgetTester tester) async {
      final mockHtml = File('test/integration/resources/exam_example.html')
          .readAsStringSync();
      when(mockResponse.body).thenReturn(mockHtml);
      when(mockResponse.statusCode).thenReturn(200);
      when(mockClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => mockResponse);

      final Completer<Null> completer = Completer();
      final actionCreator =
          getUserExams(completer, ParserExams(), Tuple2('', ''));

      final widget = testableReduxWidget(child: ExamsPageView(), store: store);

      await tester.pumpWidget(widget);

      expect(find.byKey(Key(sdisExam.toString())), findsNothing);
      expect(find.byKey(Key(sopeExam.toString())), findsNothing);

      actionCreator(store);

      await completer.future;

      await tester.pumpAndSettle();

      expect(find.byKey(Key(sdisExam.toString())), findsOneWidget);
      expect(find.byKey(Key(sopeExam.toString())), findsOneWidget);
    });
  });
}
