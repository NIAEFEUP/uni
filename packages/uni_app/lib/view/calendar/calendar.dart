import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/localized_events.dart';
import 'package:uni/model/providers/lazy/calendar_provider.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/calendar/widgets/row_format.dart';
import 'package:uni/view/common_widgets/pages_layouts/secondary/secondary.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/locale_notifier.dart';

class CalendarPageView extends StatefulWidget {
  const CalendarPageView({super.key});

  @override
  State<StatefulWidget> createState() => CalendarPageViewState();
}

class CalendarPageViewState extends SecondaryPageViewState<CalendarPageView> {
  @override
  Widget getBody(BuildContext context) {
    return LazyConsumer<CalendarProvider, LocalizedEvents>(
      builder: getTimeline,
      hasContent: (localizedEvents) => localizedEvents.hasAnyEvents,
      onNullContent: Center(
        child: Text(
          S.of(context).no_events,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
    );
  }

  Widget getTimeline(BuildContext context, LocalizedEvents localizedEvents) {
    final locale = Provider.of<LocaleNotifier>(context).getLocale();
    final calendar = localizedEvents.getEvents(locale);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          children: calendar
              .map((event) => RowFormat(event: event, locale: locale))
              .toList(),
        ),
      ),
    );
  }

  @override
  Future<void> onRefresh(BuildContext context) {
    return Provider.of<CalendarProvider>(context, listen: false)
        .forceRefresh(context);
  }

  @override
  String? getTitle() =>
      S.of(context).nav_title(NavigationItem.navCalendar.route);
}
