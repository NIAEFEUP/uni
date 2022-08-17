import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/calendar_event.dart';
import 'package:uni/view/Pages/general_page_view.dart';
import 'package:timelines/timelines.dart';

class CalendarPageView extends StatefulWidget {
  const CalendarPageView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CalendarPageViewState();
}

class CalendarPageViewState extends GeneralPageViewState {
  @override
  Widget getBody(BuildContext context) {
    return StoreConnector<AppState, List<CalendarEvent>>(
      converter: (store) {
        return store.state.content['calendar'];
      },
      builder: (context, calendar) => getTimeline(context, calendar)
    );
  }

  Widget getTimeline(BuildContext context, List<CalendarEvent> calendar) {
    return Timeline.tileBuilder(
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
          child: Text(
            calendar[index].name,
            style: Theme.of(context).textTheme.headline6?.copyWith(
              fontWeight: FontWeight.w500
            )
            ),
        ),
        oppositeContentsBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            calendar[index].date,
            style: Theme.of(context).textTheme.subtitle1?.copyWith(
              fontStyle: FontStyle.italic,
            )
          ),
        ),
        itemCount: calendar.length,
      ),
    );
  }
}
