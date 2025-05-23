import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:uni/model/entities/calendar_event.dart';

class CalendarFetcherJson {
  /// Fetches the calendar events from the local JSON file.
  Future<List<CalendarEvent>> getCalendar(String locale) async {
    final filePath = 'assets/text/calendar/${locale}Calendar.json';
    final response = await rootBundle.loadString(filePath);

    final data = json.decode(response) as List<dynamic>;

    final events = <CalendarEvent>[];
    for (final item in data) {
      final map = item as Map<String, dynamic>;

      final startDateStr = map['start_date']?.toString();
      final endDateStr = map['end_date']?.toString();

      map['start_date'] =
          (startDateStr != null && startDateStr.isNotEmpty)
              ? startDateStr
              : null;
      map['end_date'] =
          (endDateStr != null && endDateStr.isNotEmpty) ? endDateStr : null;

      events.add(CalendarEvent.fromJson(map));
    }

    return events;
  }
}
