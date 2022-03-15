import 'package:flutter/material.dart';
import 'package:uni/view/Widgets/schedule_event_rectangle.dart';
import 'package:uni/view/Widgets/schedule_time_interval.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ScheduleRow extends StatelessWidget {
  final String subject;
  final List<String> rooms;
  final String begin;
  final String end;
  final DateTime date;
  final String teacher;
  final String type;

  ScheduleRow(
      {Key key,
      @required this.subject,
      @required this.rooms,
      @required this.begin,
      @required this.end,
      this.date,
      this.teacher,
      this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final roomsKey = '$subject-$rooms-$begin-$end';
    return Center(
        child: Container(
      padding: EdgeInsets.only(left: 12.0, bottom: 8.0, right: 12),
      margin: EdgeInsets.only(top: 8.0),
      child: IntrinsicHeight(
          child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(top: 4.0, bottom: 12.0),
              child: Stack(children: [
                IconButton(
                  padding: EdgeInsets.only(top: 5.0, bottom: 12.0),
                  alignment: Alignment.topLeft,
                  icon: Icon(MdiIcons.calendarPlus, size: 30),
                  onPressed: () {
                    Add2Calendar.addEvent2Cal(this.createExamEvent());
                  },
                ),
                Container(
                    margin: EdgeInsets.only(top: 60.0, bottom: 45.0),
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ScheduleTimeInterval(begin: this.begin, end: this.end)
                        ])),
              ])),
          Container(
              margin: EdgeInsets.only(top: 60.0, bottom: 45.0),
              child: ScheduleEventRectangle(
                  subject: this.subject, type: this.type)),
          Container(
              margin: EdgeInsets.only(top: 12.0, bottom: 12.0),
              child: Column(
                  key: Key(roomsKey),
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: getScheduleRooms(context)))
        ],
      )),
    ));
  }

  List<Widget> getScheduleRooms(context) {
    if (this.rooms[0] == '') {
      return [
        Text(
          'sem\nsalas',
          textAlign: TextAlign.right,
          style: Theme.of(context).textTheme.headline4.apply(fontSizeDelta: -4),
        )
      ];
    }
    final List<Widget> rooms = [];
    for (String room in this.rooms) {
      rooms.add(
        Text(
          room,
          style: Theme.of(context).textTheme.headline4.apply(fontSizeDelta: -4),
        ),
      );
    }

    return rooms;
  }

  Event createExamEvent() {
    final List<String> partsBegin = begin.split(':');
    final int hoursBegin = int.parse(partsBegin[0]);
    final int minutesBegin = int.parse(partsBegin[1]);
    final List<String> partsEnd = end.split(':');
    final int hoursEnd = int.parse(partsEnd[0]);
    final int minutesEnd = int.parse(partsBegin[1]);
    return Event(
      title: type.toString() + ' ' + (subject).toString(),
      location: rooms.toString(),
      startDate: date.add(Duration(hours: hoursBegin, minutes: minutesBegin)),
      endDate: date.add(Duration(hours: hoursEnd, minutes: minutesEnd)),
    );
  }
}
