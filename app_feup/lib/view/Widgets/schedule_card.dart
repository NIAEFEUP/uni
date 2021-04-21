import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/view/Widgets/date_rectangle.dart';
import 'package:uni/view/Widgets/request_dependent_widget_builder.dart';
import 'package:uni/view/Widgets/schedule_slot.dart';
import 'package:uni/model/entities/time_utilities.dart';

import '../../utils/constants.dart' as Constants;
import 'generic_card.dart';

class ScheduleCard extends GenericCard {
  ScheduleCard({Key key}) : super(key: key);

  ScheduleCard.fromEditingInformation(
      Key key, bool editingMode, Function onDelete)
      : super.fromEditingInformation(key, editingMode, onDelete);

  final double borderRadius = 12.0;
  final double leftPadding = 12.0;
  final List<Lecture> lectures =  <Lecture>[];

  @override
  Widget buildCardContent(BuildContext context) {
    return StoreConnector<AppState, Tuple2<List<Lecture>, RequestStatus>>(
        converter: (store) => Tuple2(store.state.content['schedule'],
            store.state.content['scheduleStatus']),
        builder: (context, lecturesInfo) {
          return RequestDependentWidgetBuilder(
              context: context,
              status: lecturesInfo.item2,
              contentGenerator: generateSchedule,
              content: lecturesInfo.item1,
              contentChecker:
                  lecturesInfo.item1 != null && lecturesInfo.item1.isNotEmpty,
              onNullContent: Center(
                  child: Text('Não existem aulas para apresentar',
                      style: Theme.of(context).textTheme.headline4,
                      textAlign: TextAlign.center)));
        });
  }

  Widget generateSchedule(lectures, context) {
    return Container(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: getScheduleRows(context, lectures),
    ));
  }

  List<Widget> getScheduleRows(context, List<Lecture> lectures) {
    if (lectures.length >= 2) {
      // In order to display lectures of the next week
      final Lecture lecturefirstCycle = Lecture.cloneHtml(lectures[0]);
      lecturefirstCycle.day += 7;
      final Lecture lecturesecondCycle = Lecture.cloneHtml(lectures[1]);
      lecturesecondCycle.day += 7;
      lectures.add(lecturefirstCycle);
      lectures.add(lecturesecondCycle);
    }
    final List<Widget> rows =  <Widget>[];

    final now = DateTime.now();
    var added = 0; // Lectures added to widget
    var lastDayAdded = 0; // Day of last added lecture
    final stringTimeNow = (now.weekday - 1).toString().padLeft(2, '0') +
        now.toTimeHourMinString(); // String with current time within the week

    for (int i = 0; added < 2 && i < lectures.length; i++) {
      final stringEndTimeLecture = lectures[i].day.toString().padLeft(2, '0') +
          lectures[i].endTime; // String with end time of lecture

      if (stringTimeNow.compareTo(stringEndTimeLecture) < 0) {
        if (now.weekday - 1 != lectures[i].day &&
            lastDayAdded < lectures[i].day) {
          rows.add(DateRectangle(date: Lecture.dayName[lectures[i].day % 7]));
        }

        rows.add(createRowFromLecture(context, lectures[i]));
        lastDayAdded = lectures[i].day;
        added++;
      }
    }

    if (rows.isEmpty) {
      rows.add(DateRectangle(date: Lecture.dayName[lectures[0].day % 7]));
      rows.add(createRowFromLecture(context, lectures[0]));
    }
    return rows;
  }

  Widget createRowFromLecture(context, lecture) {
    return Container(
        margin: EdgeInsets.only(bottom: 10),
        child: ScheduleSlot(
            subject: lecture.subject,
            rooms: lecture.room,
            begin: lecture.startTime,
            end: lecture.endTime,
            teacher: lecture.teacher,
            typeClass: lecture.typeClass,
            classNumber: lecture.classNumber));
  }

  @override
  String getTitle() => 'Horário';

  @override
  onClick(BuildContext context) =>
      Navigator.pushNamed(context, '/' + Constants.navSchedule);
}
