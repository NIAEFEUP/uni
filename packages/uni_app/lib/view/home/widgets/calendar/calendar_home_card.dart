import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/app_locale.dart';
import 'package:uni/model/entities/calendar_event.dart';
import 'package:uni/model/providers/lazy/calendar_provider.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/home/widgets/generic_home_card.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/locale_notifier.dart';
import 'package:uni_ui/calendar/calendar.dart';
import 'package:uni_ui/calendar/calendar_item.dart';

class CalendarHomeCard extends GenericHomecard {
  const CalendarHomeCard({
    super.key,
    super.title = 'Calendar',
    super.externalInfo = true,
  });

  @override
  void onClick(BuildContext context) =>
      Navigator.pushNamed(context, '/${NavigationItem.navCalendar.route}');

  @override
  Widget buildCardContent(BuildContext context) {
    return LazyConsumer<CalendarProvider, Map<AppLocale, List<CalendarEvent>>>(
      builder: (context, calendars) {
        final locale =
            Provider.of<LocaleNotifier>(context, listen: false).getLocale();
        final events = calendars[locale] ?? [];
        return Calendar(
          items: events
              .map(
                (event) => CalendarItem(
                  eventPeriod: event.formattedPeriod[0],
                  eventName: event.name,
                ),
              )
              .toList(),
        );
      },
      hasContent: (calendars) =>
          calendars.values.any((list) => list.isNotEmpty),
      onNullContent: Center(
        child: Text(
          S.of(context).no_events,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
    );
  }
}
