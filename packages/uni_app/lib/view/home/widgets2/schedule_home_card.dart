import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/lazy/lecture_provider.dart';
import 'package:uni/model/utils/time/week.dart';
import 'package:uni/view/home/widgets2/generic_home_card.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni_ui/cards/schedule_card.dart';
import 'package:uni_ui/cards/timeline_card.dart';

class ScheduleHomeCard extends GenericHomecard {
  const ScheduleHomeCard({
    super.key,
    required super.title,
  });

  @override
  Widget buildCardContent(BuildContext context) {
    return LazyConsumer<LectureProvider, List<Lecture>>(
      builder: (context, lectures) => CardTimeline(
        items: buildTimelineItems(getMockLectures()).sublist(0, 2),
      ),
      hasContent: (_) => true,
      onNullContent: Text(
        'Sem aulas',
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
      mapper: (lectures) => lectures
          .where((lecture) => lecture.endTime.isAfter(DateTime.now()))
          .toList(),
    );
  }

  List<Lecture> getMockLectures() {
    return [
      Lecture(
        'Mathematics',
        'Lecture',
        DateTime.now().subtract(Duration(hours: 1)),
        DateTime.now().add(Duration(hours: 1)),
        '101',
        'Dr. Smith',
        'Class 1',
        1,
      ),
      Lecture(
        'Physics',
        'Lecture',
        DateTime.now().add(Duration(hours: 2)),
        DateTime.now().add(Duration(hours: 3)),
        '102',
        'Dr. Johnson',
        'Class 2',
        2,
      ),
      Lecture(
        'Chemistry',
        'Lab',
        DateTime.now().add(Duration(days: 1, hours: 1)),
        DateTime.now().add(Duration(days: 1, hours: 2)),
        'Lab 201',
        'Dr. Brown',
        'Class 3',
        3,
      ),
      Lecture(
        'Biology',
        'Lecture',
        DateTime.now().add(Duration(days: 2, hours: 3)),
        DateTime.now().add(Duration(days: 2, hours: 4)),
        '103',
        'Dr. Taylor',
        'Class 4',
        4,
      ),
    ];
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
            isActive: true,
            title: DateFormat('HH:mm').format(element.startTime),
            subtitle: DateFormat('HH:mm').format(element.endTime),
            card: ScheduleCard(
              isActive: true,
              name: element.subject,
              acronym: 'LCOM',
              room: element.room,
              type: element.typeClass,
            ),
          ),
        )
        .toList();

    return items;
  }
}
