import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:uni/model/entities/exam.dart';
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

  EventDraft createLectureEventDraft(
    Lecture lecture,
  ) {
    return EventDraft(
      title: '${lecture.subject} (${lecture.typeClass})',
      location: lecture.room,
      start: tz.TZDateTime.from(lecture.startTime, tz.local),
      end: tz.TZDateTime.from(lecture.endTime, tz.local),
    );
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

  Future<void> addEventsToCalendar(
    Calendar selectedCalendar,
    List<EventDraft> eventDrafts,
  ) async {
    for (final draft in eventDrafts) {
      final event = draft.toEvent(selectedCalendar.id!);
      try {
        await _calendarPlugin.createOrUpdateEvent(event);
      } catch (err, st) {
        debugPrint('Failed to add event: $err\n$st');
      }
    }
  }
}

class EventDraft {
  EventDraft({
    this.title,
    this.description,
    this.start,
    this.end,
    this.allDay = false,
    this.location,
    this.url,
    this.attendees,
    this.recurrenceRule,
    this.reminders,
    this.availability = Availability.Busy,
    this.status,
  });

  String? title;
  String? description;
  TZDateTime? start;
  TZDateTime? end;
  bool allDay;
  String? location;
  Uri? url;
  List<Attendee?>? attendees;
  RecurrenceRule? recurrenceRule;
  List<Reminder>? reminders;
  Availability availability;
  EventStatus? status;

  Event toEvent(String calendarId) {
    return Event(
      calendarId,
      title: title,
      description: description,
      start: start,
      end: end,
      allDay: allDay,
      location: location,
      url: url,
      attendees: attendees,
      recurrenceRule: recurrenceRule,
      reminders: reminders,
      availability: availability,
      status: status,
    );
  }
}
