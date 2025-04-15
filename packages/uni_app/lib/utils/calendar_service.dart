import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:uni/model/entities/lecture.dart';

class CalendarService {
  final DeviceCalendarPlugin _calendarPlugin = DeviceCalendarPlugin();

  Future<List<Calendar>> retrieveWritableCalendars() async {
    try {
      var permissionsGranted = await _calendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess &&
          (permissionsGranted.data == null || !permissionsGranted.data!)) {
        permissionsGranted = await _calendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess ||
            permissionsGranted.data == null ||
            !permissionsGranted.data!) {
          return [];
        }
      }

      final calendarsResult = await _calendarPlugin.retrieveCalendars();
      return calendarsResult.data
              ?.where((calendar) => calendar.isReadOnly == false)
              .toList() ??
          [];
    } on PlatformException catch (e, st) {
      debugPrint('RETRIEVE_CALENDARS ERROR: $e\n$st');
      return [];
    }
  }

  Future<void> addLecturesToCalendar(
    Calendar selectedCalendar,
    List<Lecture> lectures,
  ) async {
    final now = DateTime.now();
    lectures
        .where((lecture) => lecture.endTime.isAfter(now))
        .forEach((lecture) {
      final event = Event(
        selectedCalendar.id,
        title: '${lecture.subject} (${lecture.typeClass})',
        location: lecture.room,
        start: tz.TZDateTime.from(lecture.startTime, tz.local),
        end: tz.TZDateTime.from(lecture.endTime, tz.local),
      );

      _calendarPlugin.createOrUpdateEvent(event);
    });
  }
}
