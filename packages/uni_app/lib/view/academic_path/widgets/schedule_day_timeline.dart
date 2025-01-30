import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uni/model/entities/lecture.dart';
import 'package:uni_ui/cards/schedule_card.dart';
import 'package:uni_ui/cards/timeline_card.dart';

class ScheduleDayTimeline extends StatelessWidget {
  const ScheduleDayTimeline({
    super.key,
    required this.day,
    required this.lectures,
  });

  final List<Lecture> lectures;
  final DateTime day;

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
              name: lecture.subject,
              acronym: _getAcronym(lecture.subject),
              room: lecture.room,
              type: lecture.typeClass,
              teacherName: lecture.teacher,
            ),
          ),
        )
        .toList();
  }

  String _getAcronym(String subject) {
    return subject
        .split(' ')
        .where((word) => word.length >= 3)
        .map((word) => word[0])
        .join()
        .toUpperCase();
  }

  bool _isLectureActive(Lecture lecture) {
    final now = DateTime.now();
    return now.isAfter(lecture.startTime) && now.isBefore(lecture.endTime);
  }
}
