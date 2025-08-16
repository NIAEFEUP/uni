import 'package:uni/model/entities/app_locale.dart';
import 'package:uni/model/entities/calendar_event.dart';

class LocalizedEvents {
  LocalizedEvents({required this.events});

  final Map<AppLocale, List<CalendarEvent>> events;

  List<CalendarEvent> getEvents(AppLocale locale) => events[locale] ?? [];

  bool get hasAnyEvents => events.values.any((list) => list.isNotEmpty);
}
