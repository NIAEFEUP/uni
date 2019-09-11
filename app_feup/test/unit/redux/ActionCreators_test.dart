import 'dart:async';

import 'package:app_feup/controller/networking/NetworkRouter.dart';
import 'package:app_feup/controller/parsers/ParserExams.dart';
import 'package:app_feup/model/AppState.dart';
import 'package:app_feup/model/entities/CourseUnit.dart';
import 'package:app_feup/model/entities/Exam.dart';
import 'package:app_feup/model/entities/Session.dart';
import 'package:app_feup/redux/ActionCreators.dart';
import 'package:redux/redux.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';

class MockStore extends Mock implements Store<AppState> {}
class ParserMock extends Mock implements ParserExams{}
class MockClient extends Mock implements http.Client{}

void main() {
  group('ActionCreators', (){
    group('Exams Action Creator', () {
      final sopeCourseUnit = new CourseUnit(
        abbreviation: 'SOPE'
      );
      final sdisCourseUnit = new CourseUnit(
        abbreviation: 'SDIS'
      );
      NetworkRouter.httpClient = MockClient();
      final sopeExam = new Exam('09:00-12:00', 'SOPE', 'B119, B107, B205', '2019-09-11',
                  'Recurso - Época Recurso (2ºS)', 'Quarta');
      final sdisExam = new Exam('12:00-15:00', 'SDIS', 'B119, B107, B205', '2019-09-12',
                      'Recurso - Época Recurso (2ºS)', 'Quarta');
      final parserMock = new ParserMock();
      Tuple2<String, String> userPersistentInfo = Tuple2("", "");
      final mockStore = MockStore();
      final content = {
        "session": new Session(authenticated: true),
        "currUcs": [sopeCourseUnit, sdisCourseUnit]
      };
      when(mockStore.state)
        .thenReturn(new AppState(content));
      test('When given a single exam',  () async {
        final actionCreator = getUserExams(new Completer(), parserMock, userPersistentInfo);
        when(parserMock.parseExams(any))
          .thenAnswer((_) async => [sopeExam]);

        await actionCreator(mockStore);
        final List<dynamic> actions = verify(mockStore.dispatch(captureAny)).captured;
        expect(actions.length,  3);
        expect(actions[0].status, RequestStatus.BUSY);
        expect(actions[1].status, RequestStatus.SUCCESSFUL);
        expect(actions[2].exams, [sopeExam]);
      });
      test('When given two exams',  () async {
        final actionCreator = getUserExams(new Completer(), parserMock, userPersistentInfo);
        when(parserMock.parseExams(any))
          .thenAnswer((_) async => [sopeExam, sdisExam]);

        await actionCreator(mockStore);
        final List<dynamic> actions = verify(mockStore.dispatch(captureAny)).captured;
        expect(actions.length,  3);
        expect(actions[0].status, RequestStatus.BUSY);
        expect(actions[1].status, RequestStatus.SUCCESSFUL);
        expect(actions[2].exams, [sopeExam, sdisExam]);
      });
      test('When given three exams but one is to be parsed',  () async {
        final specialExam = new Exam('12:00-15:00', 'SDIS', 'B119, B107, B205', '2019-09-12',
                      'Exames ao abrigo de estatutos especiais - Port.Est.Especiais', 'Quarta');
        final actionCreator = getUserExams(new Completer(), parserMock, userPersistentInfo);
        when(parserMock.parseExams(any))
          .thenAnswer((_) async => [sopeExam, sdisExam, specialExam]);

        await actionCreator(mockStore);
        final List<dynamic> actions = verify(mockStore.dispatch(captureAny)).captured;
        expect(actions.length,  3);
        expect(actions[0].status, RequestStatus.BUSY);
        expect(actions[1].status, RequestStatus.SUCCESSFUL);
        expect(actions[2].exams, [sopeExam, sdisExam]);
      });
      test('When given three exams but one is to be parsed',  () async {
        final actionCreator = getUserExams(new Completer(), parserMock, userPersistentInfo);
        when(parserMock.parseExams(any))
          .thenAnswer((_) async => throw new Exception('RIP'));

        await actionCreator(mockStore);
        final List<dynamic> actions = verify(mockStore.dispatch(captureAny)).captured;
        expect(actions.length,  2);
        expect(actions[0].status, RequestStatus.BUSY);
        expect(actions[1].status, RequestStatus.FAILED);
      });
    });
  });
}
