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
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ScheduleTimeInterval(
                                  begin: begin, end: end)
                            ]),
                        ScheduleEventRectangle(
                            subject: subject, type: type),
                        IconButton(
                            icon: const Icon(MdiIcons.calendarPlus, size: 30),
                            onPressed: () => Add2Calendar.addEvent2Cal(createExamEvent())),
                      ],
                    )),
                Container(
                    key: Key(roomsKey),
                    alignment: Alignment.topLeft,
                    child: getScheduleRooms(context))
              ],
            )));
  }

  Widget? getScheduleRooms(context) {
    if (rooms[0] == '') return null;
    return Wrap(
        alignment: WrapAlignment.start,
        spacing: 13,
        children: rooms
            .map((room) =>
                Text(room.trim(), style: Theme.of(context).textTheme.bodyText2))
            .toList());
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
