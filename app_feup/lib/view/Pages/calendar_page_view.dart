import 'package:flutter/material.dart';
import 'package:uni/view/Pages/general_page_view.dart';
import 'package:timelines/timelines.dart';

class CalendarPageView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CalendarPageViewState();
}

class CalendarPageViewState extends GeneralPageViewState {
  @override
  Widget getBody(BuildContext context) {
    return Timeline.tileBuilder(
      theme: TimelineTheme.of(context).copyWith(
        connectorTheme: TimelineTheme.of(context)
            .connectorTheme
            .copyWith(thickness: 3.0, color: Theme.of(context).dividerColor),
        indicatorTheme: TimelineTheme.of(context)
            .indicatorTheme
            .copyWith(size: 15.0, color: Theme.of(context).primaryColor),
      ),
      builder: TimelineTileBuilder.fromStyle(
        contentsAlign: ContentsAlign.alternating,
        contentsBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            'Timeline Event Crazy $index',
            style: Theme.of(context).textTheme.headline5
            ),
        ),
        oppositeContentsBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '17 a 18 de julho',
            style: Theme.of(context).textTheme.subtitle1.copyWith(
              fontStyle: FontStyle.italic,
            )
          ),
        ),
        itemCount: 10,
      ),
    );
  }
}
