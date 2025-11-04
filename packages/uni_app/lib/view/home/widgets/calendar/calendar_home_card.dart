import 'package:flutter/material.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/localized_events.dart';
import 'package:uni/model/providers/riverpod/calendar_provider.dart';
import 'package:uni/model/providers/riverpod/default_consumer.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/home/widgets/generic_home_card.dart';
import 'package:uni/view/locale_notifier.dart';
import 'package:uni_ui/calendar/calendar.dart';
import 'package:uni_ui/calendar/calendar_item.dart';

class CalendarHomeCard extends GenericHomecard {
  const CalendarHomeCard({super.key});

  @override
  String getTitle(BuildContext context) {
    return S.of(context).calendar;
  }

  @override
  void onCardClick(BuildContext context) =>
      Navigator.pushNamed(context, '/${NavigationItem.navCalendar.route}');

  @override
  Widget buildCardContent(BuildContext context) {
    return DefaultConsumer<LocalizedEvents>(
      provider: calendarProvider,
      builder: (context, ref, localizedEvents) {
        final locale = ref.watch(localeProvider);
        final events = localizedEvents.getEvents(locale);
        final today = DateTime.now();

        final calendarItems =
            events.map((event) {
              final start = event.startDate;
              final end = event.endDate ?? event.startDate;
              final isToday =
                  start != null &&
                      today.year == start.year &&
                      today.month == start.month &&
                      today.day == start.day ||
                  (end != null &&
                      today.isAfter(start ?? end) &&
                      today.isBefore(end.add(const Duration(days: 1))));
              return CalendarItem(
                eventPeriod: event.formattedPeriod[0],
                endYear: event.formattedPeriod[1],
                eventName: event.name,
                isToday: isToday,
              );
            }).toList();

        // current event or next if no current
        final currentIndex = events.indexWhere((event) {
          final end = event.endDate ?? event.startDate;
          return end == null || !end.isBefore(today);
        });

        return Calendar(
          items: calendarItems,
          initialScrollIndex: currentIndex != -1 ? currentIndex : 0,
        );
      },
      nullContentWidget: Center(
        child: Text(
          S.of(context).no_events,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      hasContent: (localizedEvents) => localizedEvents.hasAnyEvents,
    );
  }
}
