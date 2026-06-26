import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:uni/controller/fetchers/events_fetcher/events_fetcher_constants.dart';
import 'package:uni/model/entities/calendar_event.dart';

class EventFetcherNiddle {
  EventFetcherNiddle({http.Client? httpClient}) : _httpClient = httpClient;

  final http.Client? _httpClient;

  http.Client get _client => _httpClient ?? http.Client();

  /// Fetches calendar events from the Niddle REST API for a given academic
  /// [year], [facultyId], and [courseId].
  Future<List<CalendarEvent>> fetchEvents({
    required int year,
    required int facultyId,
    required int courseId,
  }) async {
    final uri = Uri.parse('${EventsFetcherConstants.baseUrl}/events').replace(
      queryParameters: {
        'year': year.toString(),
        'facultyId': facultyId.toString(),
        'courseId': courseId.toString(),
      },
    );

    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Niddle API returned status ${response.statusCode}: ${response.body}',
      );
    }

    final data = json.decode(response.body) as List<dynamic>;

    return data.map((item) {
      final map = item as Map<String, dynamic>;

      final startDateRaw = map['startDate'];
      final endDateRaw = map['endDate'];

      final mapped = <String, dynamic>{
        'name': map['name'] ?? '',
        'start_date':
            (startDateRaw != null && startDateRaw.toString().isNotEmpty)
            ? startDateRaw.toString()
            : null,
        'end_date': (endDateRaw != null && endDateRaw.toString().isNotEmpty)
            ? endDateRaw.toString()
            : null,
      };

      return CalendarEvent.fromJson(mapped);
    }).toList();
  }
}
