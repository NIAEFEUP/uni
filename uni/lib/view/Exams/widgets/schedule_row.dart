import 'package:flutter/material.dart';
import 'package:uni/view/Exams/widgets/schedule_event_rectangle.dart';
import 'package:uni/view/Exams/widgets/schedule_time_interval.dart';
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

  const ScheduleRow(
      {Key? key,
      required this.subject,
      required this.rooms,
      required this.begin,
      required this.end,
      required this.date,
      required this.teacher,
      required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final roomsKey = '$subject-$rooms-$begin-$end';
    return Center(
        child: Container(
      padding: const EdgeInsets.only(left: 12.0, bottom: 8.0, right: 12),
      margin: const EdgeInsets.only(top: 8.0),
      child: IntrinsicHeight(
          child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              margin: const EdgeInsets.only(top: 4.0, bottom: 12.0),
              child: Stack(children: [
                IconButton(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 12.0),
                  alignment: Alignment.topLeft,
                  icon: const Icon(MdiIcons.calendarPlus, size: 30),
                  onPressed: () {
                    Add2Calendar.addEvent2Cal(createExamEvent());
                  },
                ),
                Container(
                    margin: const EdgeInsets.only(top: 60.0, bottom: 45.0),
                    child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ScheduleTimeInterval(begin: begin, end: end)
                        ])),
              ])),
          Container(
              margin: const EdgeInsets.only(top: 60.0, bottom: 45.0),
              child: ScheduleEventRectangle(subject: subject, type: type)),
          Container(
              margin: const EdgeInsets.only(top: 12.0, bottom: 12.0),
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
          style: Theme.of(context).textTheme.bodyText2,
        )
      ];
    }
    final List<Widget> rooms = [];
    for (String room in this.rooms) {
      rooms.add(
        Text(
          room,
          style: Theme.of(context).textTheme.bodyText2,
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
      title: '$type $subject',
      location: rooms.toString(),
      startDate: date.add(Duration(hours: hoursBegin, minutes: minutesBegin)),
      endDate: date.add(Duration(hours: hoursEnd, minutes: minutesEnd)),
    );
  }
}
