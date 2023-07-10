import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timelines/timelines.dart';
import 'package:uni/model/entities/calendar_event.dart';
import 'package:uni/model/providers/lazy/calendar_provider.dart';
import 'package:uni/view/common_widgets/page_title.dart';
import 'package:uni/view/common_widgets/pages_layouts/general/general.dart';
import 'package:uni/view/common_widgets/request_dependent_widget_builder.dart';
import 'package:uni/view/lazy_consumer.dart';

class CalendarPageView extends StatefulWidget {
  const CalendarPageView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CalendarPageViewState();
}

class CalendarPageViewState extends GeneralPageViewState<CalendarPageView> {
  @override
  Widget getBody(BuildContext context) {
    return LazyConsumer<CalendarProvider>(
        builder: (context, calendarProvider) => ListView(children: [
              _getPageTitle(),
              RequestDependentWidgetBuilder(
                  status: calendarProvider.status,
                  builder: () =>
                      getTimeline(context, calendarProvider.calendar),
                  hasContentPredicate: calendarProvider.calendar.isNotEmpty,
                  onNullContent: const Center(
                      child: Text('Nenhum evento encontrado',
                          style: TextStyle(fontSize: 18.0))))
            ]));
  }

  Widget _getPageTitle() {
    return Container(
        padding: const EdgeInsets.only(bottom: 6.0),
        child: const PageTitle(name: 'Calendário Escolar'));
  }

  Widget getTimeline(BuildContext context, List<CalendarEvent> calendar) {
    return FixedTimeline.tileBuilder(
      theme: TimelineTheme.of(context).copyWith(
        connectorTheme: TimelineTheme.of(context)
            .connectorTheme
            .copyWith(thickness: 2.0, color: Theme.of(context).dividerColor),
        indicatorTheme: TimelineTheme.of(context)
            .indicatorTheme
            .copyWith(size: 15.0, color: Theme.of(context).primaryColor),
      ),
      builder: TimelineTileBuilder.fromStyle(
        contentsAlign: ContentsAlign.alternating,
        contentsBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(calendar[index].name,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w500)),
        ),
        oppositeContentsBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(calendar[index].date,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  )),
        ),
        itemCount: calendar.length,
      ),
    );
  }

  @override
  Future<void> handleRefresh(BuildContext context) {
    return Provider.of<CalendarProvider>(context, listen: false)
        .forceRefresh(context);
  }
}
