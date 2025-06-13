import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/localized_events.dart';
import 'package:uni/model/providers/riverpod/calendar_provider.dart';
import 'package:uni/model/providers/riverpod/default_consumer.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/calendar/widgets/row_format.dart';
import 'package:uni/view/locale_notifier.dart';
import 'package:uni/view/widgets/pages_layouts/secondary/secondary.dart';

class CalendarPageView extends ConsumerStatefulWidget {
  const CalendarPageView({super.key});

  @override
  ConsumerState<CalendarPageView> createState() => CalendarPageViewState();
}

class CalendarPageViewState extends SecondaryPageViewState<CalendarPageView> {
  @override
  Widget getBody(BuildContext context) {
    return DefaultConsumer<LocalizedEvents>(
      provider: calendarProvider,
      hasContent: (localizedEvents) => localizedEvents.hasAnyEvents,
      nullContentWidget: Center(
        child: Text(
          S.of(context).no_events,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ),
      builder: (context, ref, localizedEvents) {
        final locale = ref.watch(localeProvider.select((value) => value));
        final calendar = localizedEvents.getEvents(locale);

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(
              children:
                  calendar
                      .map((event) => RowFormat(event: event, locale: locale))
                      .toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Future<void> onRefresh() async {
    await ref.read(calendarProvider.notifier).refreshRemote();
  }

  @override
  String? getTitle() =>
      S.of(context).nav_title(NavigationItem.navCalendar.route);
}
