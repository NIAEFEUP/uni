import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/view/exams/widgets/exam_title.dart';
import 'package:uni/view/exams/widgets/exam_time.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/redux/action_creators.dart';

class ExamRow extends StatefulWidget {
  final Exam exam;
  final String teacher;
  final bool mainPage;

  const ExamRow({
    Key? key,
    required this.exam,
    required this.teacher,
    required this.mainPage,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ExamRowState();
  }
}


class _ExamRowState extends State<ExamRow> {
  @override
  Widget build(BuildContext context) {
    final roomsKey =
        '${widget.exam.subject}-${widget.exam.rooms}-${widget.exam.beginTime}-${widget.exam.endTime}';
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
                              ExamTime(
                                  begin: widget.exam.beginTime,
                                  end: widget.exam.endTime)
                            ]),
                        ExamTitle(
                            subject: widget.exam.subject,
                            type: widget.exam.type),
                        Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              if (!widget.mainPage)
                                IconButton(
                                    icon: !widget.exam.isHidden
                                        ? const Icon(Icons.visibility, size: 30)
                                        : const Icon(Icons.visibility_off,
                                            size: 30),
                                    tooltip: widget.exam.isHidden
                                        ? "Mostrar na Área Pessoal"
                                        : "Ocultar da Área Pessoal",
                                    onPressed: () => setState(() {
                                          widget.exam.isHidden =
                                              !widget.exam.isHidden;
                                          StoreProvider.of<AppState>(context)
                                              .dispatch(toggleHiddenExam(
                                                  widget.exam.id, Completer()));
                                        })),
                              IconButton(
                                  icon: const Icon(MdiIcons.calendarPlus,
                                      size: 30),
                                  onPressed: () => Add2Calendar.addEvent2Cal(
                                      createExamEvent())),
                            ]),
                      ],
                    )),
                Container(
                    key: Key(roomsKey),
                    alignment: Alignment.topLeft,
                    child: getExamRooms(context))
              ],
            )));
  }

  Widget? getExamRooms(context) {
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
    return Event(
      title: '${widget.exam.type} ${widget.exam.subject}',
      location: widget.exam.rooms.toString(),
      startDate: widget.exam.begin,
      endDate: widget.exam.end,
    );
  }
}
