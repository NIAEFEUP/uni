import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/model/providers/lazy/exam_provider.dart';
import 'package:uni/view/exams/widgets/exam_time.dart';
import 'package:uni/view/exams/widgets/exam_title.dart';

class ExamRow extends StatefulWidget {
  const ExamRow({
    required this.exam,
    required this.teacher,
    required this.mainPage,
    super.key,
  });
  final Exam exam;
  final String teacher;
  final bool mainPage;

  @override
  State<StatefulWidget> createState() {
    return _ExamRowState();
  }
}

class _ExamRowState extends State<ExamRow> {
  @override
  Widget build(BuildContext context) {
    final isHidden =
        Provider.of<ExamProvider>(context).hiddenExams.contains(widget.exam.id);
    final roomsKey =
        '${widget.exam.subject}-${widget.exam.rooms}-${widget.exam.beginTime}-'
        '${widget.exam.endTime}';
    return Center(
      child: Container(
        padding: const EdgeInsets.only(left: 12, bottom: 8, right: 12),
        margin: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ExamTime(
                        begin: widget.exam.beginTime,
                      )
                    ],
                  ),
                  ExamTitle(
                    subject: widget.exam.subject,
                    type: widget.exam.type,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      if (!widget.mainPage)
                        IconButton(
                          icon: !isHidden
                              ? const Icon(Icons.visibility, size: 30)
                              : const Icon(
                                  Icons.visibility_off,
                                  size: 30,
                                ),
                          tooltip: isHidden
                              ? 'Mostrar na Área Pessoal'
                              : 'Ocultar da Área Pessoal',
                          onPressed: () => setState(() {
                            Provider.of<ExamProvider>(
                              context,
                              listen: false,
                            ).toggleHiddenExam(widget.exam.id);
                          }),
                        ),
                      IconButton(
                        icon: Icon(MdiIcons.calendarPlus, size: 30),
                        onPressed: () => Add2Calendar.addEvent2Cal(
                          createExamEvent(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              key: Key(roomsKey),
              alignment: Alignment.topLeft,
              child: getExamRooms(context),
            )
          ],
        ),
      ),
    );
  }

  Widget? getExamRooms(BuildContext context) {
    if (widget.exam.rooms[0] == '') return null;
    return Wrap(
      spacing: 13,
      children: roomsList(context, widget.exam.rooms),
    );
  }

  List<Text> roomsList(BuildContext context, List<String> rooms) {
    return rooms
        .map(
          (room) =>
              Text(room.trim(), style: Theme.of(context).textTheme.bodyMedium),
        )
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
