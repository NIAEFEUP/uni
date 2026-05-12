import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/riverpod/profile_provider.dart';
import 'package:uni/model/providers/riverpod/session_provider.dart';
import 'package:uni_ui/cards/schedule_card.dart';
import 'package:uni_ui/cards/timeline_card.dart';

class ScheduleDayTimeline extends ConsumerWidget {
  const ScheduleDayTimeline({
    super.key,
    required this.now,
    required this.day,
    required this.lectures,
    this.showClassNumber = false,
    this.onLectureTap,
  });

  final DateTime now;
  final DateTime day;
  final List<Lecture> lectures;
  final void Function(Lecture lecture)? onLectureTap;
  final bool showClassNumber;

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
    final groups = _groupOverlappingLectures(lectures);

    return groups.map((group) {
      final isActive = group.any(_isLectureActive);
      final groupStart = group.first.startTime;
      final groupEnd = group.first.endTime;

      return TimelineItem(
        isActive: isActive,
        title: DateFormat('HH:mm').format(groupStart),
        subtitle: DateFormat('HH:mm').format(groupEnd),
        card: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: group.map((lecture) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: FutureBuilder<File?>(
                future: ProfileNotifier.fetchOrGetCachedProfilePicture(
                  session!,
                  studentNumber: lecture.teacherId,
                ),
                builder: (context, snapshot) {
                  return ScheduleCard(
                    isActive: _isLectureActive(lecture),
                    name: lecture.subject,
                    acronym: lecture.acronym,
                    room: lecture.room,
                    type: lecture.typeClass,
                    classNumber: showClassNumber ? lecture.classNumber : null,
                    teacherName: lecture.teacherName,
                    teacherPhoto: snapshot.hasData && snapshot.data != null
                        ? Image(image: FileImage(snapshot.data!))
                        : Image.asset('assets/images/profile_placeholder.png'),
                    onTap: onLectureTap != null
                        ? () => onLectureTap!(lecture)
                        : null,
                  );
                },
              ),
            );
          }).toList(),
        ),
      );
    }).toList();
  }

  List<List<Lecture>> _groupOverlappingLectures(List<Lecture> lectures) {
    final sorted = [...lectures]
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    final groups = <List<Lecture>>[];
    var currentGroup = [sorted.first];
    var groupStart = sorted.first.startTime;
    var groupEnd = sorted.first.endTime;

    for (final lecture in sorted.skip(1)) {
      if (lecture.startTime.isAtSameMomentAs(groupStart) &&
          lecture.endTime.isAtSameMomentAs(groupEnd)) {
        currentGroup.add(lecture);
      } else {
        groups.add(currentGroup);
        currentGroup = [lecture];
        groupStart = lecture.startTime;
        groupEnd = lecture.endTime;
      }
    }
    groups.add(currentGroup);

    return groups;
  }

  bool _isLectureActive(Lecture lecture) {
    return now.isAfter(lecture.startTime) && now.isBefore(lecture.endTime);
  }
}
