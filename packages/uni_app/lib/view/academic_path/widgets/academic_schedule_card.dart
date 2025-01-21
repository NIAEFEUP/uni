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
      return Center(
        child: Text(
          DateFormat('EEEE, d MMMM').format(day),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('EEEE, d MMMM').format(day),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          ..._buildTimelineItems(lectures),
        ],
      ),
    );
  }

  List<Widget> _buildTimelineItems(List<Lecture> lectures) {
    return lectures
        .map(
          (lecture) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: TimelineItem(
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
          ),
        )
        .toList();
  }

  String _getAcronym(String subject) {
    return subject.split(' ').map((word) => word[0]).join().toUpperCase();
  }

  bool _isLectureActive(Lecture lecture) {
    final now = DateTime.now();
    return now.isAfter(lecture.startTime) && now.isBefore(lecture.endTime);
  }
}
