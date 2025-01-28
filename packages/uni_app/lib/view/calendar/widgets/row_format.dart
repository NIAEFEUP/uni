import 'package:flutter/material.dart';
import 'package:uni/model/entities/calendar_event.dart';
import 'package:uni/view/calendar/widgets/event_tile.dart';
import 'package:uni/view/calendar/widgets/dates_tile.dart';
import 'package:uni/model/entities/app_locale.dart';
class RowFormat extends StatelessWidget {
  const RowFormat({super.key,required this.event,required this.locale});
  final CalendarEvent event;
  final AppLocale locale;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 100,
          alignment: Alignment.center,
          child: DatesTile(date:event.date,start:event.start,end:event.finish,locale:locale),
        ),
        Column(
          children: [
            Container(
              margin: EdgeInsets.all(5),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 4.0,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom:7),
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(2),
                    bottomRight: Radius.circular(2)),
                shape: BoxShape.rectangle,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
          EventTile(text: event.name),
      ],
    );
  }
}
