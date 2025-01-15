import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/calendar_event.dart';
import 'package:uni/model/providers/lazy/calendar_provider.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/calendar/widgets/dates_tile.dart';
import 'package:uni/view/calendar/widgets/event_tile.dart';
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
    return LazyConsumer<CalendarProvider, List<CalendarEvent>>(
      builder: getTimeline,
      hasContent: (calendar) => calendar.isNotEmpty,
      onNullContent: const Center(
        child: Text(
          'Nenhum evento encontrado',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Widget getTimeline(BuildContext context, List<CalendarEvent> calendar) {
    final locale = Provider.of<LocaleNotifier>(context).getLocale();
    return SingleChildScrollView(
      child: FixedTimeline.tileBuilder(
        theme: TimelineTheme.of(context).copyWith(
          connectorTheme: TimelineTheme.of(context)
              .connectorTheme
              .copyWith(thickness: 2, color: Theme.of(context).primaryColor),
          indicatorTheme: TimelineTheme.of(context)
              .indicatorTheme
              .copyWith(size: 15, color: Theme.of(context).primaryColor),

        ),

        builder: TimelineTileBuilder.fromStyle(
          indicatorStyle: IndicatorStyle.outlined,
          connectorStyle: ConnectorStyle.solidLine,
          contentsBuilder: (_, index) =>EventTile(text: calendar[index].name),
          oppositeContentsBuilder: (_, index) => DatesTile(date:calendar[index].date,start:calendar[index].start,end:calendar[index].finish,locale:locale),
          itemCount: calendar.length,
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

