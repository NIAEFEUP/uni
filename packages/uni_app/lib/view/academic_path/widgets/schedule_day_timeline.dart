import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';
import 'package:uni/view/course_unit_info/course_unit_info.dart';
import 'package:uni_ui/cards/schedule_card.dart';
import 'package:uni_ui/cards/timeline_card.dart';

class ScheduleDayTimeline extends ConsumerWidget {
  const ScheduleDayTimeline({
    super.key,
    required this.now,
    required this.day,
    required this.lectures,
  });

  final DateTime now;
  final DateTime day;
  final List<Lecture> lectures;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (lectures.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('EEEE, d MMMM').format(day),
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 14),
          CardTimeline(items: _buildTimelineItems(lectures, context, ref)),
        ],
      ),
    );
  }

  List<TimelineItem> _buildTimelineItems(
    List<Lecture> lectures,
    BuildContext context,
    WidgetRef ref,
  ) {
    final session = ref.read(sessionProvider.select((value) => value.value));

    return lectures.map((lecture) {
      final isActive = _isLectureActive(lecture);
      return TimelineItem(
        isActive: isActive,
        title: DateFormat('HH:mm').format(lecture.startTime),
        subtitle: DateFormat('HH:mm').format(lecture.endTime),
        card: FutureBuilder<File?>(
          future: ProfileNotifier.fetchOrGetCachedProfilePicture(
            session!,
            studentNumber: lecture.teacherId,
          ),
          builder: (context, snapshot) {
            return ScheduleCard(
              isActive: isActive,
              name: lecture.subject,
              acronym: lecture.acronym,
              room: lecture.room,
              type: lecture.typeClass,
              teacherName: lecture.teacherName,
              teacherPhoto: snapshot.hasData && snapshot.data != null
                  ? Image(image: FileImage(snapshot.data!))
                  : Image.asset('assets/images/profile_placeholder.png'),
              onTap: () {
                final profile = ref.watch(
                  profileProvider.select((value) => value.value),
                );

                if (profile != null) {
                  final courseUnit = profile.courseUnits.firstWhereOrNull(
                    (unit) => unit.abbreviation == lecture.acronym,
                  );
                  if (courseUnit != null && courseUnit.occurrId != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute<CourseUnitDetailPageView>(
                        builder: (context) =>
                            CourseUnitDetailPageView(courseUnit),
                      ),
                    );
                  }
                }
              },
            );
          },
        ),
      );
    }).toList();
  }

  bool _isLectureActive(Lecture lecture) {
    return now.isAfter(lecture.startTime) && now.isBefore(lecture.endTime);
  }
}
