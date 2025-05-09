import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uni/generated/l10n.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/lazy/lecture_provider.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni/model/utils/time/week.dart';
import 'package:uni/view/academic_path/academic_path.dart';
import 'package:uni/view/home/widgets/generic_home_card.dart';
import 'package:uni/view/home/widgets/schedule/timeline_shimmer.dart';
import 'package:uni/view/lazy_consumer.dart';
import 'package:uni/view/widgets/icon_label.dart';
import 'package:uni_ui/cards/schedule_card.dart';
import 'package:uni_ui/cards/timeline_card.dart';
import 'package:uni_ui/icons.dart';

class ScheduleHomeCard extends GenericHomecard {
  const ScheduleHomeCard({
    super.key,
  });

  @override
  String getTitle(BuildContext context) {
    return S.of(context).schedule;
  }

  @override
  Widget buildCardContent(BuildContext context) {
    return LazyConsumer<LectureProvider, List<Lecture>>(
      builder: (context, lectures) => CardTimeline(
        items: buildTimelineItems(lectures, context).take(2).toList(),
      ),
      hasContent: (lectures) => lectures.isNotEmpty,
      onNullContent: Center(
        child: IconLabel(
          icon: const UniIcon(
            size: 45,
            UniIcons.beer,
          ),
          label: S.of(context).no_class,
          labelTextStyle: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      mapper: (lectures) => lectures
          .where((lecture) => lecture.endTime.isAfter(DateTime.now()))
          .toList(),
      contentLoadingWidget: const ShimmerCardTimeline(),
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
    List<Lecture> lectures,
    BuildContext context,
  ) {
    final now = DateTime.now();
    final week = Week(start: now);
    final session = Provider.of<SessionProvider>(context, listen: false).state!;

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
            card: FutureBuilder<File?>(
              future: ProfileProvider.fetchOrGetCachedProfilePicture(
                session,
                studentNumber: element.teacherId,
              ),
              builder: (context, snapshot) {
                return ScheduleCard(
                  isActive: now.isAfter(element.startTime) &&
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

    return items;
  }
}
