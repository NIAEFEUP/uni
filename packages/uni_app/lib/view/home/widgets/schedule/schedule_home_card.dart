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
import 'package:uni/utils/navigation_items.dart';
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

  bool contains(DateTime date) =>
      (date.isAfter(start) || date.isAtSameMomentAs(start)) &&
      date.isBefore(end);
}

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
        //final mockLectures = getMockLectures();

        // For the sake of testing uncomment what's below
        /*
            final upcomingLectures = mockLectures
        .where((lecture) => lecture.endTime.isAfter(now))
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));
        
         */

        // For the sake of testing comment what's below
        // Get upcoming lectures (end time is after now)
        final upcomingLectures =
            lectures.where((lecture) => lecture.endTime.isAfter(now)).toList()
              ..sort((a, b) => a.startTime.compareTo(b.startTime));

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

        // Check if any lecture is currently happening
        final hasCurrentLecture = upcomingLectures.any(
          (lecture) => _isLectureCurrent(lecture, now),
        );

        // If there's a current lecture, just show the timeline without any message
        if (hasCurrentLecture) {
          return CardTimeline(items: buildTimelineItems(upcomingLectures, ref));
        }

        // Otherwise, determine what message to show
        final nextLecture = upcomingLectures.first;
        final today = DateTime(now.year, now.month, now.day);
        final tomorrow = today.add(const Duration(days: 1));
        final weekEnd = today.add(const Duration(days: 7));

        // Check if next lecture is within this week
        final isWithinThisWeek = nextLecture.startTime.isBefore(weekEnd);

        if (!isWithinThisWeek) {
          // Next class is beyond this week - show "no classes this week" message
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

        if (nextLecture.startTime.isAfter(today) &&
            nextLecture.startTime.isBefore(
              today.add(const Duration(days: 1)),
            )) {
          // Next lecture is today - just show the timeline without "Today" message
          return CardTimeline(items: buildTimelineItems(upcomingLectures, ref));
        } else if (nextLecture.startTime.isAfter(tomorrow) &&
            nextLecture.startTime.isBefore(
              tomorrow.add(const Duration(days: 1)),
            )) {
          // Next lecture is tomorrow
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
              CardTimeline(items: buildTimelineItems(upcomingLectures, ref)),
            ],
          );
        } else {
          // Next lecture is later this week (but within this week)
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
              CardTimeline(items: buildTimelineItems(upcomingLectures, ref)),
            ],
          );
        }
      },
      hasContent: (lectures) => lectures.isNotEmpty,
      nullContentWidget: Center(
        child: IconLabel(
          icon: const UniIcon(size: 45, UniIcons.beer),
          label: S.of(context).no_classes,
          labelTextStyle: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      mapper: (lectures) => lectures,
      loadingWidget: const ShimmerCardTimeline(),
    );
  }

  bool _isLectureCurrent(Lecture lecture, DateTime now) {
    final isCurrent =
        (now.isAfter(lecture.startTime) ||
            now.isAtSameMomentAs(lecture.startTime)) &&
        now.isBefore(lecture.endTime);
    return isCurrent;
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
    final period = TimePeriod(
      start: now,
      end: now.add(const Duration(days: 7)),
    );
    //final week = Week(start: now);
    final session = ref.read(sessionProvider);

    // Filter lectures to only show those within the next 7 days
    final lecturesThisWeek =
        lectures
            .where((lecture) => period.contains(lecture.startTime))
            .toList();

    //Sort by actual date and time
    final sortedLectures = lecturesThisWeek.sortedBy(
      (lecture) => lecture.startTime,
    );

    // Take only the first 2 lectures for the home card
    final timelineItems =
        sortedLectures.take(2).map((element) {
          final isActive = _isLectureCurrent(element, now);
          return TimelineItem(
            isActive: isActive,
            title: DateFormat('HH:mm').format(element.startTime),
            subtitle: DateFormat('HH:mm').format(element.endTime),
            card: FutureBuilder<File?>(
              future:
                  session.value != null
                      ? ProfileNotifier.fetchOrGetCachedProfilePicture(
                        session.value!,
                        studentNumber: element.teacherId,
                      )
                      : Future<File?>.value(),
              builder: (context, snapshot) {
                final teacherPhoto =
                    (snapshot.hasData && snapshot.data != null)
                        ? Image.file(snapshot.data!)
                        : Image.asset('assets/images/profile_placeholder.png');

                return ScheduleCard(
                  isActive: isActive,
                  name: element.subject,
                  acronym: element.acronym,
                  room: element.room,
                  type: element.typeClass,
                  teacherName: element.teacherName,
                  teacherPhoto: teacherPhoto,
                );
              },
            ),
          );
        }).toList();

    return timelineItems;
  }
}
