import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/localized_events.dart';
import 'package:uni/model/providers/lazy/calendar_provider.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/calendar/widgets/calendar_shimmer.dart';
import 'package:uni/view/home/widgets/generic_home_card.dart';
import 'package:uni/view/lazy_consumer.dart';
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
    return LazyConsumer<CalendarProvider, LocalizedEvents>(
      builder: (context, localizedEvents) {
        final locale =
            Provider.of<LocaleNotifier>(context, listen: false).getLocale();
        final events = localizedEvents.getEvents(locale);
        return Calendar(
          items:
              events
                  .map(
                    (event) => CalendarItem(
                      eventPeriod: event.formattedPeriod[0],
                      eventName: event.name,
                    ),
                  )
                  .toList(),
        );
      },
      hasContent: (localizedEvents) => localizedEvents.hasAnyEvents,
      onNullContent: Center(
        child: Text(
          S.of(context).no_events,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      contentLoadingWidget: const ShimmerCalendarItem(),
    );
  }
}
