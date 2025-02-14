import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uni/model/entities/lecture.dart';
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
          CardTimeline(items: _buildTimelineItems(lectures)),
        ],
      ),
    );
  }

  List<TimelineItem> _buildTimelineItems(List<Lecture> lectures) {
    return lectures
        .map(
          (lecture) => TimelineItem(
            isActive: _isLectureActive(lecture),
            title: DateFormat('HH:mm').format(lecture.startTime),
            subtitle: DateFormat('HH:mm').format(lecture.endTime),
            card: ScheduleCard(
              isActive: _isLectureActive(lecture),
              name: _filterSubjectName(lecture.subject),
              acronym: lecture.acronym,
              room: lecture.room,
              type: lecture.typeClass,
              teacherName: lecture.teacher,
            ),
          ),
        )
        .toList();
  }

  // maybe should be changed to the backend, just extract the filtered name directly
  String _filterSubjectName(String subject) {
    return RegExp(r' - ([^()]*)(?: \(|$)').firstMatch(subject)?.group(1) ??
        subject;
  }

  bool _isLectureActive(Lecture lecture) {
    return now.isAfter(lecture.startTime) && now.isBefore(lecture.endTime);
  }
}
