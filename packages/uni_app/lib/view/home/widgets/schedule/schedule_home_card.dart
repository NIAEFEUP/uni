import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/riverpod/default_consumer.dart';
import 'package:uni/model/providers/riverpod/lecture_provider.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';
import 'package:uni/model/utils/time/week.dart';
import 'package:uni/view/academic_path/academic_path.dart';
import 'package:uni/view/home/widgets/generic_home_card.dart';
import 'package:uni/view/home/widgets/schedule/timeline_shimmer.dart';
import 'package:uni/view/widgets/icon_label.dart';
import 'package:uni_ui/cards/schedule_card.dart';
import 'package:uni_ui/cards/timeline_card.dart';
import 'package:uni_ui/icons.dart';

class TimePeriod {
  const TimePeriod({required this.start, required this.end});

  final DateTime start;
  final DateTime end;

  Duration get duration => end.difference(start);

  bool contains(DateTime date) => date.isAfter(start) && date.isBefore(end);
}

List<Lecture> getMockLectures() {
  final now = DateTime.now();
  return [
    Lecture(
      'ESOF',
      'ESOF',
      'T',
      now.add(const Duration(days: 1)),
      now.add(const Duration(hours: 2)),
      'Room B123',
      'ademaraguiar',
      'ademaraguiar',
      101,
      '1',
      1001,
    ),
    Lecture(
      'LTW',
      'LTW',
      'TP',
      now.add(const Duration(days: 1, hours: 1)),
      now.add(const Duration(days: 4, hours: 2)),
      'Room B234',
      'arestivo',
      'arestivo',
      102,
      '2',
      1002,
    ),
  ];
}

class ScheduleHomeCard extends GenericHomecard {
  const ScheduleHomeCard({super.key});

  @override
  String getTitle(BuildContext context) {
    return S.of(context).schedule;
  }

  @override
  Widget buildCardContent(BuildContext context) {
    final mockLectures = getMockLectures();
    final now = DateTime.now();

    final todayStart = DateTime(now.year, now.month, now.day);
    final todayEnd = todayStart.add(const Duration(days: 1));
    final tomorrowStart = todayStart.add(const Duration(days: 1));
    final tomorrowEnd = tomorrowStart.add(const Duration(days: 1));

    // Upcoming lectures (from now)
    final upcomingLectures =
        mockLectures.where((lecture) => lecture.endTime.isAfter(now)).toList();

    if (upcomingLectures.isEmpty) {
      return Center(
        child: IconLabel(
          icon: const UniIcon(size: 45, UniIcons.beer),
          label: S.of(context).no_classes,
          labelTextStyle: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      );
    }

    final nextLecture = upcomingLectures.first;

    // Determine display text for date
    String dateText;
    if (nextLecture.startTime.isAfter(todayStart) &&
        nextLecture.startTime.isBefore(todayEnd)) {
      dateText = S.of(context).today;
    } else if (nextLecture.startTime.isAfter(tomorrowStart) &&
        nextLecture.startTime.isBefore(tomorrowEnd)) {
      dateText = S.of(context).tommorow;
    } else {
      dateText = DateFormat('EEEE, dd MMM').format(nextLecture.startTime);
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconLabel(
          icon: const UniIcon(size: 45, UniIcons.sun),
          label: S.of(context).no_classes_today + dateText,
          labelTextStyle: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        CardTimeline(
          items: buildTimelineItems(upcomingLectures, context).take(2).toList(),
        ),
      ],
    );
  }

  @override
  void onCardClick(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => const AcademicPathPageView(initialTabIndex: 1),
      ),
    );
  }

  List<TimelineItem> buildTimelineItems(
      List<Lecture> lectures, BuildContext context) {
    final now = DateTime.now();
    final period = TimePeriod(start: now, end: now.add(const Duration(hours: 72)));
    final week = Week(start: now);
    final session = ProviderScope.containerOf(context, listen: false)
        .read(sessionProvider);

    final sortedLectures = lectures
        .where((lecture) => period.contains(lecture.startTime))
        .toList()
        .sortedBy((lecture) => week.getWeekday(lecture.startTime.weekday));

    return sortedLectures
        .map(
          (element) => TimelineItem(
            isActive: now.isAfter(element.startTime) &&
                now.isBefore(element.endTime),
            title: DateFormat('HH:mm').format(element.startTime),
            subtitle: DateFormat('HH:mm').format(element.endTime),
            card: FutureBuilder<File?>(
              future: session.value != null
                  ? ProfileNotifier.fetchOrGetCachedProfilePicture(
                      session.value!,
                      studentNumber: element.teacherId,
                    )
                  : Future.value(),
              builder: (context, snapshot) {
                return ScheduleCard(
                  isActive:
                      now.isAfter(element.startTime) &&
                      now.isBefore(element.endTime),
                  name: element.subject,
                  acronym: element.acronym,
                  room: element.room,
                  type: element.typeClass,
                  teacherName: element.teacherName,
                  teacherPhoto: snapshot.hasData && snapshot.data != null
                      ? Image(image: FileImage(snapshot.data!))
                      : Image.asset(
                          'assets/images/profile_placeholder.png',
                        ),
                );
              },
            ),
          ),
        )
        .toList();
  }
}