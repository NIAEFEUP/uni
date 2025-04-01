import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni/model/providers/startup/profile_provider.dart';
import 'package:uni/model/providers/startup/session_provider.dart';
import 'package:uni_ui/cards/schedule_card.dart';
import 'package:uni_ui/cards/timeline_card.dart';

class ScheduleDayTimeline extends StatelessWidget {
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
  Widget build(BuildContext context) {
    if (lectures.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('EEEE, d MMMM').format(day),
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 14),
          CardTimeline(items: _buildTimelineItems(lectures, context)),
        ],
      ),
    );
  }

  List<TimelineItem> _buildTimelineItems(
    List<Lecture> lectures,
    BuildContext context,
  ) {
    final session = Provider.of<SessionProvider>(context, listen: false).state!;

    return lectures.map((lecture) {
      final isActive = _isLectureActive(lecture);
      return TimelineItem(
        isActive: isActive,
        title: DateFormat('HH:mm').format(lecture.startTime),
        subtitle: DateFormat('HH:mm').format(lecture.endTime),
        card: isActive
            ? FutureBuilder<File?>(
                future: ProfileProvider.fetchOrGetCachedProfilePicture(
                  session,
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
                  );
                },
              )
            : ScheduleCard(
                isActive: isActive,
                name: lecture.subject,
                acronym: lecture.acronym,
                room: lecture.room,
                type: lecture.typeClass,
              ),
      );
    }).toList();
  }

  bool _isLectureActive(Lecture lecture) {
    return now.isAfter(lecture.startTime) && now.isBefore(lecture.endTime);
  }
}
