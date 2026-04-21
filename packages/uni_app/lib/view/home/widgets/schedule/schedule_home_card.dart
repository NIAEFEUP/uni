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
import 'package:uni/utils/navigation_items.dart';
import 'package:uni/view/home/widgets/generic_home_card.dart';
import 'package:uni/view/home/widgets/schedule/timeline_shimmer.dart';
import 'package:uni/view/widgets/icon_label.dart';
import 'package:uni_ui/cards/schedule_card.dart';
import 'package:uni_ui/cards/timeline_card.dart';
import 'package:uni_ui/icons.dart';

/*List<Lecture> getMockLectures() {
  final now = DateTime.now();
  
  return [
    Lecture(
      'ESOF',
      
      'ESOF',
      
      'T',
      
      now.subtract(const Duration(hours: 2)),
      
      now.subtract(const Duration(hours: 1)),
      
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
      
      now.add(const Duration(hours: 0)),
      
      now.add(const Duration(hours: 1)),
      
      'Room B234',
      
      'arestivo',
      
      'arestivo',
      
      102,
      
      '2',
      
      1002,
     ),
  ];

}*/


class ScheduleHomeCard extends GenericHomecard {
  const ScheduleHomeCard({super.key})
    : super(
        titlePadding: const EdgeInsets.symmetric(horizontal: 20),
        bodyPadding: const EdgeInsets.symmetric(horizontal: 20),
      );

  @override
  String getTitle(BuildContext context) {
    return S.of(context).schedule;
  }

  @override
  Widget buildCardContent(BuildContext context) {
    return DefaultConsumer<List<Lecture>>(
      provider: lectureProvider,
      builder: (context, ref, lectures) {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final startOfNextWeek = today.add(Duration(days: 8 - now.weekday));
        final upcomingLectures =
            lectures.toList()..sort((a, b) => a.startTime.compareTo(b.startTime));

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

        final lecturesThisWeek = upcomingLectures
            .where((lecture) => lecture.startTime.isBefore(startOfNextWeek))
            .toList();

        if (lecturesThisWeek.isEmpty) {
          return Center(
            child: IconLabel(
              icon: const UniIcon(size: 45, UniIcons.beer),
              label: S.of(context).no_classes_this_week,
              labelTextStyle: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
        }

        final lecturesToday = _lecturesForDay(lecturesThisWeek, today);
        if (lecturesToday.isNotEmpty) {
          return CardTimeline(items: buildTimelineItems(lecturesToday, ref));
        }

        final tomorrow = today.add(const Duration(days: 1));
        final lecturesTomorrow = _lecturesForDay(lecturesThisWeek, tomorrow);
        if (lecturesTomorrow.isNotEmpty) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const UniIcon(size: 45, UniIcons.beer),
                  const SizedBox(height: 8),
                  Text(
                    '${S.of(context).no_classes_today}\n${S.of(context).nextclasses}${S.of(context).tomorrow}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              CardTimeline(items: buildTimelineItems(lecturesTomorrow, ref)),
            ],
          );
        }

        final nextLecture = lecturesThisWeek.first;
        final nextLectureDay = DateTime(
          nextLecture.startTime.year,
          nextLecture.startTime.month,
          nextLecture.startTime.day,
        );
        final nextLectureDayLectures = _lecturesForDay(
          lecturesThisWeek,
          nextLectureDay,
        );
        final dateText = DateFormat(
          'EEEE',
          Localizations.localeOf(context).toString(),
        ).format(nextLecture.startTime);

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const UniIcon(size: 45, UniIcons.beer),
                const SizedBox(height: 8),
                Text(
                  '${S.of(context).no_classes_today}\n${S.of(context).nextclasses}$dateText:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            CardTimeline(items: buildTimelineItems(nextLectureDayLectures, ref)),
          ],
        );
      },
      hasContent: (lectures) => lectures.isNotEmpty,
      nullContentWidget: Center(
        child: IconLabel(
          icon: UniIcon(
            size: 45,
            UniIcons.beer,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
          label: S.of(context).no_classes,
          labelTextStyle: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      mapper: (lectures) => lectures
          .where((lecture) => lecture.endTime.isAfter(DateTime.now()))
          .toList(),
      loadingWidget: const ShimmerCardTimeline(),
    );
  }

  bool _isLectureCurrent(Lecture lecture, DateTime now) {
    return
        (now.isAfter(lecture.startTime) ||
            now.isAtSameMomentAs(lecture.startTime)) &&
        now.isBefore(lecture.endTime);
  }

  @override
  void onCardClick(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/${NavigationItem.navAcademicPath.route}',
      arguments: 1,
    );
  }

  List<TimelineItem> buildTimelineItems(List<Lecture> lectures, WidgetRef ref) {
    final now = DateTime.now();
    final session = ref.read(sessionProvider);

    final sortedLectures = lectures
        .toList()
        .sortedBy((lecture) => lecture.startTime);

    final items = sortedLectures
        .take(2)
        .map(
          (element) => TimelineItem(
            isActive: _isLectureCurrent(element, now),
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
                  isActive: _isLectureCurrent(element, now),
                  name: element.subject,
                  acronym: element.acronym,
                  room: element.room,
                  type: element.typeClass,
                  teacherName: element.teacherName,
                  teacherPhoto: snapshot.hasData && snapshot.data != null
                      ? Image(image: FileImage(snapshot.data!))
                      : Image.asset('assets/images/profile_placeholder.png'),
                );
              },
            ),
          ),
        )
        .toList();

    return items;
  }

  List<Lecture> _lecturesForDay(List<Lecture> lectures, DateTime day) {
    final dayStart = DateTime(day.year, day.month, day.day);
    final nextDayStart = dayStart.add(const Duration(days: 1));

    return lectures
        .where(
          (lecture) =>
              !lecture.startTime.isBefore(dayStart) &&
              lecture.startTime.isBefore(nextDayStart),
        )
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
  }
}
