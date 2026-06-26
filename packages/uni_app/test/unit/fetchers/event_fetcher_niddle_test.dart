import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:uni/controller/fetchers/events_fetcher/event_fetcher_niddle.dart';

/// A fake http.BaseClient that returns a fixed status code and body.
class _FakeHttpClient extends http.BaseClient {
  _FakeHttpClient(this.statusCode, this.body);

  final int statusCode;
  final String body;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    return http.StreamedResponse(
      http.ByteStream.fromBytes(utf8.encode(body)),
      statusCode,
    );
  }
}

void main() {
  group('EventFetcherNiddle', () {
    test('parses a full API response with dates', () async {
      final client = _FakeHttpClient(
        200,
        json.encode([
          {
            'id': 1,
            'name': 'Christmas Break',
            'startDate': '2024-12-23T00:00:00.000Z',
            'endDate': '2024-12-31T00:00:00.000Z',
          },
        ]),
      );

      final fetcher = EventFetcherNiddle(httpClient: client);
      final events = await fetcher.fetchEvents(
        year: 2024,
        facultyId: 1,
        courseId: 123,
      );

      expect(events.length, 1);
      expect(events.first.name, 'Christmas Break');
      expect(
        events.first.startDate,
        DateTime.parse('2024-12-23T00:00:00.000Z'),
      );
      expect(events.first.endDate, DateTime.parse('2024-12-31T00:00:00.000Z'));
    });

    test('handles null dates gracefully', () async {
      final client = _FakeHttpClient(
        200,
        json.encode([
          {
            'id': 2,
            'name': 'Event without dates',
            'startDate': null,
            'endDate': null,
          },
        ]),
      );

      final fetcher = EventFetcherNiddle(httpClient: client);
      final events = await fetcher.fetchEvents(
        year: 2024,
        facultyId: 1,
        courseId: 123,
      );

      expect(events.length, 1);
      expect(events.first.name, 'Event without dates');
      expect(events.first.startDate, isNull);
      expect(events.first.endDate, isNull);
    });

    test('handles empty string dates gracefully', () async {
      final client = _FakeHttpClient(
        200,
        json.encode([
          {'id': 3, 'name': 'Empty dates', 'startDate': '', 'endDate': ''},
        ]),
      );

      final fetcher = EventFetcherNiddle(httpClient: client);
      final events = await fetcher.fetchEvents(
        year: 2024,
        facultyId: 1,
        courseId: 123,
      );

      expect(events.length, 1);
      expect(events.first.startDate, isNull);
      expect(events.first.endDate, isNull);
    });

    test('handles missing optional fields in response', () async {
      final client = _FakeHttpClient(
        200,
        json.encode([
          {'id': 4, 'name': 'Minimal event'},
        ]),
      );

      final fetcher = EventFetcherNiddle(httpClient: client);
      final events = await fetcher.fetchEvents(
        year: 2024,
        facultyId: 1,
        courseId: 123,
      );

      expect(events.length, 1);
      expect(events.first.name, 'Minimal event');
      expect(events.first.startDate, isNull);
      expect(events.first.endDate, isNull);
    });

    test('uses empty string fallback when name is null', () async {
      final client = _FakeHttpClient(
        200,
        json.encode([
          {'id': 5, 'name': null},
        ]),
      );

      final fetcher = EventFetcherNiddle(httpClient: client);
      final events = await fetcher.fetchEvents(
        year: 2024,
        facultyId: 1,
        courseId: 123,
      );

      expect(events.length, 1);
      expect(events.first.name, isEmpty);
    });

    test('throws on non-200 status code', () async {
      final client = _FakeHttpClient(404, 'Not Found');

      final fetcher = EventFetcherNiddle(httpClient: client);
      await expectLater(
        fetcher.fetchEvents(year: 2024, facultyId: 1, courseId: 123),
        throwsException,
      );
    });

    test('throws on empty response body', () async {
      final client = _FakeHttpClient(200, '');

      final fetcher = EventFetcherNiddle(httpClient: client);
      await expectLater(
        fetcher.fetchEvents(year: 2024, facultyId: 1, courseId: 123),
        throwsException,
      );
    });
  });
}
