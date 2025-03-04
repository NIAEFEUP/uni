import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/lazy/lecture_provider.dart';
import 'package:uni/model/utils/time/week.dart';
import 'package:uni/view/home/widgets/generic_home_card.dart';
import 'package:uni/view/home/widgets/schedule/timeline_shimmer.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni_ui/cards/schedule_card.dart';
import 'package:uni_ui/cards/timeline_card.dart';

class ScheduleHomeCard extends GenericHomecard {
  const ScheduleHomeCard({
    super.key,
    super.title = 'Schedule',
  });

  @override
  Widget buildCardContent(BuildContext context) {
    return LazyConsumer<LectureProvider, List<Lecture>>(
      builder: (context, lectures) => CardTimeline(
        items: buildTimelineItems(lectures).sublist(0, 2),
      ),
      hasContent: (lectures) => lectures.isNotEmpty,
      onNullContent: Text(
        'Sem aulas',
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
      mapper: (lectures) => lectures
          .where((lecture) => lecture.endTime.isAfter(DateTime.now()))
          .toList(),
      contentLoadingWidget: const ShimmerCardTimeline(),
    );
  }

  @override
  void onClick(BuildContext context) => {};

  List<TimelineItem> buildTimelineItems(List<Lecture> lectures) {
    final now = DateTime.now();
    final week = Week(start: now);

    final sortedLectures = lectures
        .where((lecture) => week.contains(lecture.startTime))
        .toList()
        .sortedBy((lecture) => week.getWeekday(lecture.startTime.weekday));

    final items = sortedLectures
        .map(
          (element) => TimelineItem(
            isActive:
                now.isAfter(element.startTime) && now.isBefore(element.endTime),
            title: DateFormat('HH:mm').format(element.startTime),
            subtitle: DateFormat('HH:mm').format(element.endTime),
            card: ScheduleCard(
              isActive: now.isAfter(element.startTime) &&
                  now.isBefore(element.endTime),
              name: element.subject,
              acronym: element.acronym, // TODO once schedule is merged
              room: element.room,
              type: element.typeClass,
            ),
          ),
        )
        .toList();

    return items;
  }
}
