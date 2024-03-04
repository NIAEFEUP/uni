import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/lazy/lecture_provider.dart';
import 'package:uni/model/utils/time/week.dart';
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/common_widgets/date_rectangle.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/home/widgets/schedule_card_shimmer.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/locale_notifier.dart';
import 'package:uni/view/schedule/widgets/schedule_slot.dart';

class ScheduleCard extends GenericCard {
  ScheduleCard({super.key});

  ScheduleCard.fromEditingInformation(
    super.key, {
    required super.editingMode,
    super.onDelete,
  }) : super.fromEditingInformation();

  final double borderRadius = 12;
  final double leftPadding = 12;
  final List<Lecture> lectures = <Lecture>[];

  @override
  void onRefresh(BuildContext context) {
    Provider.of<LectureProvider>(context, listen: false).forceRefresh(context);
  }

  @override
  Widget buildCardContent(BuildContext context) {
    return LazyConsumer<LectureProvider, List<Lecture>>(
      builder: (context, lectures) => Column(
        mainAxisSize: MainAxisSize.min,
        children: getScheduleRows(context, lectures),
      ),
      hasContent: (lectures) => lectures.isNotEmpty,
      onNullContent: Center(
        child: Text(
          S.of(context).no_classes,
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
      ),
      contentLoadingWidget: const ScheduleCardShimmer().build(context),
    );
  }

  List<Widget> getScheduleRows(BuildContext context, List<Lecture> lectures) {
    final now = DateTime.now();
    final week = Week(start: now);

    final rows = <Widget>[];

    final lecturesByDay = lectures
        .where((lecture) => week.contains(lecture.startTime))
        .groupListsBy(
          (lecture) => lecture.startTime.weekday,
        )
        .entries
        .toList()
        .sortedBy<DateTime>((element) => week.getWeekday(element.key))
        .toList();

    for (final dayLectures
        in lecturesByDay.sublist(0, min(2, lecturesByDay.length))) {
      final day = dayLectures.key;
      final lectures = dayLectures.value
          .where(
            (element) =>
                // Hide finished lectures from today
                element.startTime.weekday != DateTime.now().weekday ||
                element.endTime.isAfter(DateTime.now()),
          )
          .toList();

      if (lectures.isEmpty) {
        continue;
      }

      rows.add(
        DateRectangle(
          date: Provider.of<LocaleNotifier>(context)
              .getWeekdaysWithLocale()[(day - 1) % 7],
        ),
      );

      for (final lecture in lectures) {
        rows.add(createRowFromLecture(context, lecture));
      }

      if (lectures.length >= 2) {
        break;
      }
    }

    return rows;
  }

  Widget createRowFromLecture(BuildContext context, Lecture lecture) {
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
      ),
    );
  }

  @override
  String getTitle(BuildContext context) =>
      S.of(context).nav_title(NavigationItem.navSchedule.route);

  @override
  Future<Object?> onClick(BuildContext context) =>
      Navigator.pushNamed(context, '/${NavigationItem.navSchedule.route}');
}
