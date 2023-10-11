import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/lazy/lecture_provider.dart';
import 'package:uni/utils/drawer_items.dart';
import 'package:uni/view/common_widgets/date_rectangle.dart';
import 'package:uni/view/common_widgets/generic_card.dart';
import 'package:uni/view/common_widgets/request_dependent_widget_builder.dart';
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
    return LazyConsumer<LectureProvider>(
      builder: (context, lectureProvider) => RequestDependentWidgetBuilder(
        status: lectureProvider.status,
        builder: () => Column(
          mainAxisSize: MainAxisSize.min,
          children: getScheduleRows(context, lectureProvider.lectures),
        ),
        hasContentPredicate: lectureProvider.lectures.isNotEmpty,
        onNullContent: Center(
          child: Text(
            S.of(context).no_classes,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
        contentLoadingWidget: const ScheduleCardShimmer().build(context),
      ),
    );
  }

  List<Widget> getScheduleRows(BuildContext context, List<Lecture> lectures) {
    final rows = <Widget>[];

    final lecturesByDay = lectures
        .groupListsBy(
          (lecture) => lecture.startTime.weekday,
        )
        .entries
        .toList()
        .sortedBy<num>((element) {
      // Sort by day of the week, but next days come first
      final dayDiff = element.key - DateTime.now().weekday;
      return dayDiff >= 0 ? dayDiff - 7 : dayDiff;
    }).toList();

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
      S.of(context).nav_title(DrawerItem.navSchedule.title);

  @override
  Future<Object?> onClick(BuildContext context) =>
      Navigator.pushNamed(context, '/${DrawerItem.navSchedule.title}');
}
