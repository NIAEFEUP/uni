import 'package:flutter/material.dart';
import 'package:uni/view/Widgets/schedule_event_rectangle.dart';
import 'package:uni/view/Widgets/schedule_time_interval.dart';

class ScheduleRow extends StatelessWidget {
  final String subject;
  final List<String> rooms;
  final String begin;
  final String end;
  final String teacher;
  final String type;

  ScheduleRow(
      {Key key,
      @required this.subject,
      @required this.rooms,
      @required this.begin,
      @required this.end,
      this.teacher,
      this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final roomsKey = '$subject-$rooms-$begin-$end';
    return  Center(
        child:  Container(
      padding: EdgeInsets.only(left: 12.0, bottom: 8.0, right: 12),
      margin: EdgeInsets.only(top: 8.0),
      child:  Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
           ScheduleTimeInterval(begin: this.begin, end: this.end),
           ScheduleEventRectangle(subject: this.subject, type: this.type),
           Container(
              margin: EdgeInsets.only(top: 12.0, bottom: 12.0),
              child:  Column(
                  key: Key(roomsKey),
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: getScheduleRooms(context)))
        ],
      ),
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

    final List<Widget> rooms =  [];
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
}
