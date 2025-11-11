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

        // Debug: Print current time and all lectures
        print('=== SCHEDULE DEBUG - START ===');
        print('Current time: $now');
        print('Total lectures from provider: ${lectures.length}');
        
        for (var i = 0; i < lectures.length; i++) {
          final lecture = lectures[i];
          print('Lecture $i: ${lecture.subject}');
          print('  Start: ${lecture.startTime}');
          print('  End: ${lecture.endTime}');
          print('  Is current: ${_isLectureCurrent(lecture, now)}');
          print('  Start is after now: ${lecture.startTime.isAfter(now)}');
          print('  End is after now: ${lecture.endTime.isAfter(now)}');
        }

        // Get upcoming lectures (end time is after now)
        final upcomingLectures = lectures
            .where((lecture) => lecture.endTime.isAfter(now))
            .toList()
          ..sort((a, b) => a.startTime.compareTo(b.startTime));

        print('=== UPCOMING LECTURES FILTERED ===');
        print('Upcoming lectures count: ${upcomingLectures.length}');
        for (var i = 0; i < upcomingLectures.length; i++) {
          final lecture = upcomingLectures[i];
          print('Upcoming $i: ${lecture.subject} | ${lecture.startTime} -> ${lecture.endTime}');
        }

        if (upcomingLectures.isEmpty) {
          print('No upcoming lectures - showing no_classes message');
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
        final hasCurrentLecture = upcomingLectures.any((lecture) => _isLectureCurrent(lecture, now));
        print('Has current lecture: $hasCurrentLecture');

        // If there's a current lecture, just show the timeline without any message
        if (hasCurrentLecture) {
          print('Showing current lecture timeline');
          return CardTimeline(
            items: buildTimelineItems(upcomingLectures, ref),
          );
        }

        // Otherwise, determine what message to show
        final nextLecture = upcomingLectures.first;
        final today = DateTime(now.year, now.month, now.day);
        final tomorrow = today.add(const Duration(days: 1));
        final weekEnd = today.add(const Duration(days: 7));

        // Check if next lecture is within this week
        final isWithinThisWeek = nextLecture.startTime.isBefore(weekEnd);
        print('Next lecture: ${nextLecture.subject} at ${nextLecture.startTime}');
        print('Is within this week: $isWithinThisWeek');
        print('Today: $today');
        print('Tomorrow: $tomorrow');
        print('Week end: $weekEnd');

        if (!isWithinThisWeek) {
          // Next class is beyond this week - show "no classes this week" message
          print('Next lecture is beyond this week - showing no_classes_this_week message');
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
            nextLecture.startTime.isBefore(today.add(const Duration(days: 1)))) {
          // Next lecture is today - just show the timeline without "Today" message
          print('Next lecture is today - showing timeline without message');
          return CardTimeline(
            items: buildTimelineItems(upcomingLectures, ref),
          );
        } else if (nextLecture.startTime.isAfter(tomorrow) && 
                  nextLecture.startTime.isBefore(tomorrow.add(const Duration(days: 1)))) {
          // Next lecture is tomorrow
          print('Next lecture is tomorrow - showing tomorrow message with timeline');
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
              CardTimeline(
                items: buildTimelineItems(upcomingLectures, ref),
              ),
            ],
          );
        } else {
          // Next lecture is later this week (but within this week)
          final dateText = DateFormat(
            'EEEE',
            Localizations.localeOf(context).toString(),
          ).format(nextLecture.startTime);
          print('Next lecture is later this week ($dateText) - showing weekday message with timeline');
          
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
              CardTimeline(
                items: buildTimelineItems(upcomingLectures, ref),
              ),
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
    final isCurrent = (now.isAfter(lecture.startTime) || now.isAtSameMomentAs(lecture.startTime)) && 
           now.isBefore(lecture.endTime);
    print('  _isLectureCurrent check for ${lecture.subject}: $isCurrent (now: $now, start: ${lecture.startTime}, end: ${lecture.endTime})');
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
    final week = Week(start: now);
    final session = ref.read(sessionProvider);

    print('=== BUILD TIMELINE ITEMS DEBUG ===');
    print('Input lectures count: ${lectures.length}');
    print('Period: ${period.start} to ${period.end}');
    
    // Print all input lectures to timeline
    for (var i = 0; i < lectures.length; i++) {
      final lecture = lectures[i];
      print('Input lecture $i to timeline: ${lecture.subject} | ${lecture.startTime} -> ${lecture.endTime}');
    }

    // Filter lectures to only show those within the next 7 days
    final lecturesThisWeek = lectures
        .where((lecture) => period.contains(lecture.startTime))
        .toList();

    print('Lectures this week count: ${lecturesThisWeek.length}');
    for (var i = 0; i < lecturesThisWeek.length; i++) {
      final lecture = lecturesThisWeek[i];
      print('Lecture this week $i: ${lecture.subject} | ${lecture.startTime} -> ${lecture.endTime}');
    }

    // FIX: Sort by actual date and time, not just weekday
    final sortedLectures = lecturesThisWeek
        .sortedBy((lecture) => lecture.startTime);

    print('Sorted lectures:');
    for (var i = 0; i < sortedLectures.length; i++) {
      final lecture = sortedLectures[i];
      print('Sorted $i: ${lecture.subject} | ${lecture.startTime}');
    }

    // Take only the first 2 lectures for the home card
    final timelineItems = sortedLectures.take(2).map((element) {
      final isActive = _isLectureCurrent(element, now);
      print('Creating timeline item: ${element.subject} - Active: $isActive');
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
                  : Future<File?>.value(null),
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

    print('Final timeline items count: ${timelineItems.length}');
    for (var i = 0; i < timelineItems.length; i++) {
      final item = timelineItems[i];
      print('Final timeline item $i: ${item.title} - ${item.subtitle}');
    }
    print('=== SCHEDULE DEBUG - END ===');
    return timelineItems;
  }
}