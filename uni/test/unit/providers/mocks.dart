import 'package:mockito/mockito.dart';
import 'package:uni/controller/fetchers/schedule_fetcher/schedule_fetcher.dart';
import 'package:uni/controller/parsers/parser_exams.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class ParserExamsMock extends Mock implements ParserExams {}

class ScheduleFetcherMock extends Mock implements ScheduleFetcher {}
