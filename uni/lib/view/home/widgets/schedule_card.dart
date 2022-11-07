import 'package:logger/logger.dart';
import 'package:uni/model/app_state.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:uni/view/common_widgets/date_rectangle.dart';
import 'package:uni/view/common_widgets/request_dependent_widget_builder.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/schedule/widgets/schedule_slot.dart';
import 'package:uni/utils/drawer_items.dart';



class ScheduleCard extends GenericCard {
  ScheduleCard({Key? key}) : super(key: key);

  ScheduleCard.fromEditingInformation(
      Key key, bool editingMode, Function()? onDelete)
      : super.fromEditingInformation(key, editingMode, onDelete);

  final double borderRadius = 12.0;
  final double leftPadding = 12.0;
  final List<Lecture> lectures = <Lecture>[];

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
              contentChecker: lecturesInfo.item1.isNotEmpty,
              onNullContent: Center(
                  child: Text('Não existem aulas para apresentar',
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center)));
        });
  }

  Widget generateSchedule(lectures, context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: getScheduleRows(context, lectures),
    );
  }

  List<Widget> getScheduleRows(context, List<Lecture> lectures) {
    if (lectures.length >= 2) {
      // In order to display lectures of the next week
      final Lecture lecturefirstCycle = Lecture.clone(lectures[0]);
      lecturefirstCycle.day += 7;
      final Lecture lecturesecondCycle = Lecture.clone(lectures[1]);
      lecturesecondCycle.day += 7;
      lectures.add(lecturefirstCycle);
      lectures.add(lecturesecondCycle);
    }
    final List<Widget> rows = <Widget>[];

    var added = 0;  // Lectures added to widget
    var lastDayAdded = -1;  // Day of last added lecture
    
    for (int i = 0; i < lectures.length && added < 2; i++) {
      final int currLectureDay = lectures[i].compareEndTimeWithNow();

      if (currLectureDay == lastDayAdded) {
        rows.add(createRowFromLecture(context, lectures[i]));
        added++;

      } else if (currLectureDay > lastDayAdded) {
        rows.add(DateRectangle(date: Lecture.dayName[currLectureDay % 7]));
        rows.add(createRowFromLecture(context, lectures[i]));
        lastDayAdded = currLectureDay;
        added++;
      }
      
    }

    if (rows.isEmpty) {
      rows.add(DateRectangle(date: Lecture.dayName[lectures[0].day % 7]));
      rows.add(createRowFromLecture(context, lectures[0]));
    }
    return rows;
  }

  Widget createRowFromLecture(context, Lecture lecture) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: ScheduleSlot(
            subject: lecture.subject,
            rooms: lecture.room,
            begin: lecture.startTime,
            end: lecture.endTime,
            teacher: lecture.teacher,
            typeClass: lecture.typeClass,
            classNumber: lecture.classNumber,
            occurrId: lecture.occurrId,));
  }

  @override
  String getTitle() => 'Horário';

  @override
  onClick(BuildContext context) =>
      Navigator.pushNamed(context, '/${DrawerItem.navSchedule.title}');
}
