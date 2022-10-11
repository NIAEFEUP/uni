import 'package:flutter/material.dart';
import 'package:uni/model/entities/exam.dart';
import 'package:uni/view/exams/widgets/exam_title.dart';
import 'package:uni/view/exams/widgets/exam_time.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ExamRow extends StatelessWidget {
  final Exam exam;
  final String teacher;

  const ExamRow({
    Key? key,
    required this.exam,
    required this.teacher,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final roomsKey = '${exam.subject}-${exam.rooms}-${exam.beginTime()} - ${exam.endTime()}';
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
                              ExamTime(begin: exam.beginTime(), end: exam.endTime())
                            ]),
                        ExamTitle(subject: exam.subject, type: exam.examType),
                        IconButton(
                            icon: const Icon(MdiIcons.calendarPlus, size: 30),
                            onPressed: () =>
                                Add2Calendar.addEvent2Cal(createExamEvent())),
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
    if (exam.rooms[0] == '') return null;
    return Wrap(
        alignment: WrapAlignment.start,
        spacing: 13,
        children: roomsList(context, exam.rooms));
  }

  List<Text> roomsList(BuildContext context, List rooms) {
    return rooms
        .map((room) =>
            Text(room.trim(), style: Theme.of(context).textTheme.bodyText2))
        .toList();
  }

  Event createExamEvent() {
    return Event(
      title: '${exam.examType} ${exam.subject}',
      location: exam.rooms.toString(),
      startDate: exam.begin,
      endDate: exam.end,
    );
  }
}
