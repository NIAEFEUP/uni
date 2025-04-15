import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:uni/utils/calendar_service.dart';
import 'package:uni_ui/modal/modal.dart';

Future<void> showCalendarModal({
  required BuildContext context,
  required List<Calendar> writableCalendars,
  required CalendarService calendarService,
  required List<EventDraft> eventDrafts,
}) async {
  Calendar? selectedCalendar;

  return showDialog<void>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return ModalDialog(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Select Calendar',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 10),
              if (writableCalendars.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Align(
                    child: Text(
                      'No calendars available',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                )
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: writableCalendars.length,
                    itemBuilder: (context, index) {
                      final calendar = writableCalendars[index];
                      return ListTile(
                        title: Text(calendar.name ?? 'Unnamed Calendar'),
                        selected: selectedCalendar?.id == calendar.id,
                        selectedTileColor:
                            Theme.of(context).primaryColor.withOpacity(0.2),
                        tileColor: Theme.of(context).colorScheme.surface,
                        onTap: () {
                          setModalState(() {
                            selectedCalendar = calendar;
                          });
                        },
                      );
                    },
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: selectedCalendar == null
                      ? null
                      : () async {
                          await calendarService.addEventsToCalendar(
                            selectedCalendar!,
                            eventDrafts,
                          );
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                  child: const Text('Add to calendar'),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}
