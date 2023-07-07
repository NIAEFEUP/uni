import 'package:flutter/material.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/entities/time_utilities.dart';
import 'package:uni/model/providers/lecture_provider.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/common_widgets/date_rectangle.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/common_widgets/request_dependent_widget_builder.dart';
import 'package:uni/view/home/widgets/schedule_card_shimmer.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/schedule/widgets/schedule_slot.dart';

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
    return LazyConsumer<LectureProvider>(
        builder: (context, lectureProvider) => RequestDependentWidgetBuilder(
            context: context,
            status: lectureProvider.status,
            contentGenerator: generateSchedule,
            content: lectureProvider.lectures,
            contentChecker: lectureProvider.lectures.isNotEmpty,
            onNullContent: Center(
                child: Text('Não existem aulas para apresentar',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center)),
            contentLoadingWidget: const ScheduleCardShimmer().build(context)));
  }

  Widget generateSchedule(lectures, BuildContext context) {
    final lectureList = List<Lecture>.of(lectures);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: getScheduleRows(context, lectureList),
    );
  }

  List<Widget> getScheduleRows(BuildContext context, List<Lecture> lectures) {
    final List<Widget> rows = <Widget>[];

    final now = DateTime.now();
    var added = 0; // Lectures added to widget
    DateTime lastAddedLectureDate = DateTime.now(); // Day of last added lecture

    for (int i = 0; added < 2 && i < lectures.length; i++) {
      if (now.compareTo(lectures[i].endTime) < 0) {
        if (lastAddedLectureDate.weekday != lectures[i].startTime.weekday &&
            lastAddedLectureDate.compareTo(lectures[i].startTime) <= 0) {
          rows.add(DateRectangle(
              date: TimeString.getWeekdaysStrings()[
                  (lectures[i].startTime.weekday - 1) % 7]));
        }

        rows.add(createRowFromLecture(context, lectures[i]));
        lastAddedLectureDate = lectures[i].startTime;
        added++;
      }
    }

    if (rows.isEmpty) {
      rows.add(DateRectangle(
          date: TimeString.getWeekdaysStrings()[
              lectures[0].startTime.weekday % 7]));
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
          occurrId: lecture.occurrId,
        ));
  }

  @override
  String getTitle() => 'Horário';

  @override
  onClick(BuildContext context) =>
      Navigator.pushNamed(context, '/${DrawerItem.navSchedule.title}');
}
