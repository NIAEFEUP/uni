import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/view/Widgets/schedule_event_rectangle.dart';
import 'package:uni/view/Widgets/schedule_time_interval.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:uni/model/entities/exam.dart';

import 'package:uni/model/app_state.dart';
import 'package:uni/redux/action_creators.dart';

class ScheduleRow extends StatefulWidget {
  final Exam exam;
  final bool isHidden;
  final bool mainPage;

  const ScheduleRow({
    Key? key,
    required this.exam,
    required this.isHidden,
    required this.mainPage,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ScheduleRowState();
  }
}

class _ScheduleRowState extends State<ScheduleRow> {
  @override
  Widget build(BuildContext context) {
    final roomsKey =
        '${widget.exam.subject}-${widget.exam.rooms}-${widget.exam.begin}-${widget.exam.end}';
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
                                  begin: widget.exam.begin,
                                  end: widget.exam.end)
                            ]),
                        ScheduleEventRectangle(
                            subject: widget.exam.subject,
                            type: widget.exam.examType),
                        Column(children: [
                          IconButton(
                              icon: const Icon(MdiIcons.calendarPlus, size: 30),
                              onPressed: () =>
                                  Add2Calendar.addEvent2Cal(createExamEvent())),
                          if (!widget.mainPage)
                            IconButton(
                                icon: widget.isHidden
                                    ? const Icon(Icons.remove_red_eye_outlined,
                                        size: 30)
                                    : const Icon(Icons.remove_red_eye,
                                        size: 30),
                                tooltip: widget.isHidden
                                    ? "Mostrar na Área Pessoal"
                                    : "Ocultar da Área Pessoal",
                                onPressed: () => setState(() {
                                      StoreProvider.of<AppState>(context)
                                          .dispatch(setHiddenExams(
                                              widget.exam, Completer()));
                                    })),
                        ])
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
    if (widget.exam.rooms[0] == '') return null;
    return Wrap(
        alignment: WrapAlignment.start,
        spacing: 13,
        children: roomsList(context, widget.exam.rooms));
  }

  List<Text> roomsList(BuildContext context, List rooms) {
    return rooms
        .map((room) =>
            Text(room.trim(), style: Theme.of(context).textTheme.bodyText2))
        .toList();
  }

  Event createExamEvent() {
    final List<String> partsBegin = widget.exam.begin.split(':');
    final int hoursBegin = int.parse(partsBegin[0]);
    final int minutesBegin = int.parse(partsBegin[1]);
    final List<String> partsEnd = widget.exam.end.split(':');
    final int hoursEnd = int.parse(partsEnd[0]);
    final int minutesEnd = int.parse(partsBegin[1]);
    return Event(
      title: '${widget.exam.examType} ${widget.exam.subject}',
      location: widget.exam.rooms.toString(),
      startDate: widget.exam.date
          .add(Duration(hours: hoursBegin, minutes: minutesBegin)),
      endDate:
          widget.exam.date.add(Duration(hours: hoursEnd, minutes: minutesEnd)),
    );
  }
}
